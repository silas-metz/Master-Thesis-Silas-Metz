suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(stringr)
  library(ggplot2)
  library(tibble)
  library(purrr)
})

#INPUT
base_dirs <- c(
  "/path/to/input/PCR1_5er/CG/Hac/08_Entropy",
  "/path/to/input/PCR2/CG/Hac/08_Entropy",
  "/path/to/input/PCR3/CG/Hac/08_Entropy"
)

entropy_col    <- "median_entropy"
normalize_by_k <- FALSE
k              <- 3

select_barcodes_for_table <- NULL
round_digits <- 3


stopifnot(length(base_dirs) == 3)
stopifnot(all(dir.exists(base_dirs)))

out_dir_base   <- file.path(base_dirs[1], "plots_entropy_aggregate")
dir.create(out_dir_base, showWarnings = FALSE, recursive = TRUE)

out_points_per_pcr_csv <- file.path(out_dir_base, "entropy_points_per_pcr.csv")
out_points_agg_csv     <- file.path(out_dir_base, "entropy_points_aggregated.csv")
out_fitinfo_csv        <- file.path(out_dir_base, "entropy_vs_H2_fitinfo.csv")
out_png                <- file.path(out_dir_base, "entropy_vs_H2.png")
out_pdf                <- file.path(out_dir_base, "entropy_vs_H2.pdf")
out_table_csv          <- file.path(out_dir_base, "entropy_compare_table.csv")

H2_fun <- function(p) {
  res <- -p*log(p, 2) - (1-p)*log(1-p, 2)
  res[!is.finite(res)] <- 0  # H(0)=H(1)=0
  res
}

barcode_to_percent <- function(bc) {
  idx <- suppressWarnings(as.integer(stringr::str_extract(bc, "\\d+")))
  ifelse(is.na(idx), NA_real_, (idx - 1) * 5)
}

read_regions_one <- function(path_regions) {
  coln <- c("chrom","start","end","region","mean_entropy","strand",
            "median_entropy","min_entropy","max_entropy",
            "mean_num_reads","min_num_reads","max_num_reads",
            "n_windows_ok","n_windows_fail")
  readr::read_tsv(
    path_regions,
    col_names = coln,
    col_types = cols(
      chrom = col_character(),
      start = col_double(),
      end = col_double(),
      region = col_character(),
      mean_entropy = col_double(),
      strand = col_character(),
      median_entropy = col_double(),
      min_entropy = col_double(),
      max_entropy = col_double(),
      mean_num_reads = col_double(),
      min_num_reads = col_double(),
      max_num_reads = col_double(),
      n_windows_ok = col_double(),
      n_windows_fail = col_double()
    )
  )
}

find_regions_file <- function(bd) {
  cand <- file.path(bd, "regions.bed")
  if (file.exists(cand)) return(cand)
  hits <- list.files(bd, pattern = "^regions\\.bed$", full.names = TRUE, recursive = TRUE)
  if (length(hits) > 0) return(hits[1])
  NA_character_
}

collect_one_basedir <- function(base_dir, run_label) {
  barcode_dirs <- list.dirs(base_dir, full.names = TRUE, recursive = FALSE)
  barcode_dirs <- barcode_dirs[grepl("(?i)barcode\\d+$", basename(barcode_dirs))]
  if (length(barcode_dirs) == 0) {
    warning(sprintf("Keine barcodeXX-Ordner in %s gefunden.", base_dir))
    return(tibble())
  }
  
  rows <- list()
  for (bd in sort(barcode_dirs)) {
    bc <- basename(bd)
    rfile <- find_regions_file(bd)
    if (is.na(rfile)) { warning(sprintf("[%s|%s] regions.bed nicht gefunden.", run_label, bc)); next }
    tbl <- tryCatch(read_regions_one(rfile),
                    error = function(e) { warning(sprintf("[%s|%s] regions.bed Lesefehler: %s", run_label, bc, e$message)); NULL })
    if (is.null(tbl) || nrow(tbl) == 0) { warning(sprintf("[%s|%s] regions.bed leer/ungültig.", run_label, bc)); next }
    
    rec <- tbl[1, ]
    Hraw <- rec[[entropy_col]]
    Hobs <- if (normalize_by_k) Hraw / k else Hraw
    gt_percent <- barcode_to_percent(bc)
    
    rows[[bc]] <- tibble(
      run              = run_label,
      base_dir         = base_dir,
      barcode          = bc,
      gt_percent       = gt_percent,
      p                = gt_percent / 100,
      Hobs             = Hobs,
      entropy_raw      = Hraw,
      mean_num_reads   = rec$mean_num_reads,
      n_windows_ok     = rec$n_windows_ok,
      n_windows_fail   = rec$n_windows_fail,
      regions_file     = rfile
    )
  }
  bind_rows(rows)
}

runs <- c("PCR1", "PCR2", "PCR3")
all_long <- map2_dfr(base_dirs, runs, collect_one_basedir)

if (nrow(all_long) == 0) stop("Keine gültigen Punkte erzeugt – bitte Verzeichnisstruktur prüfen.")

all_long <- all_long %>% arrange(run, p)
write_csv(all_long, out_points_per_pcr_csv)
message("Einzelpunkte (alle PCRs) gespeichert: ", out_points_per_pcr_csv)

agg <- all_long %>%
  group_by(barcode, gt_percent, p) %>%
  summarize(
    H_mean = mean(Hobs, na.rm = TRUE),
    H_sd   = sd(Hobs, na.rm = TRUE),
    n      = sum(is.finite(Hobs)),
    .groups = "drop"
  ) %>%
  arrange(p)

write_csv(agg, out_points_agg_csv)
message("Aggregierte Punkte gespeichert: ", out_points_agg_csv)

pgrid <- tibble(p = seq(0, 1, length.out = 501)) %>% mutate(H2 = H2_fun(p))

a_max <- max(agg$H_mean, na.rm = TRUE)
pgrid <- pgrid %>% mutate(H2_scaled_max = H2 * a_max)

H2_at_obs <- H2_fun(agg$p)
num <- sum(H2_at_obs * agg$H_mean, na.rm = TRUE)
den <- sum(H2_at_obs^2, na.rm = TRUE)
a_fit <- ifelse(den > 0, num / den, NA_real_)
pgrid <- pgrid %>% mutate(H2_scaled_fit = H2 * a_fit)

rmse <- function(x, y) {
  ok <- is.finite(x) & is.finite(y)
  x <- x[ok]; y <- y[ok]
  if (!length(x)) return(NA_real_)
  sqrt(mean((x - y)^2))
}
rmse_max <- rmse(agg$H_mean, H2_at_obs * a_max)
rmse_fit <- rmse(agg$H_mean, H2_at_obs * a_fit)

fit_info <- tibble(
  entropy_col = entropy_col,
  normalize_by_k = normalize_by_k,
  k = k,
  a_max = a_max,
  rmse_max = rmse_max,
  a_fit = a_fit,
  rmse_fit = rmse_fit,
  n_barcodes = nrow(agg),
  n_total_points = nrow(all_long)
)
write_csv(fit_info, out_fitinfo_csv)
message("Fit-Infos gespeichert: ", out_fitinfo_csv)

x_annot <- 50
y_annot <- 0.25

plt <- ggplot() +
  geom_point(
    data = agg,
    aes(x = gt_percent, y = H_mean, shape = "Points: observed mean"),
    size = 2.6
  ) +
  geom_line(
    data = pgrid,
    aes(x = p * 100, y = H2_scaled_fit, linetype = "Solid line: fitted H2(p)"),
    linewidth = 1.0
  ) +
  scale_x_continuous(
    breaks = seq(0, 100, 10),
    minor_breaks = seq(0, 100, 5),
    labels = function(x) paste0(x, "%")
  ) +
  scale_shape_manual(name = " ", values = c("Points: observed mean" = 16)) +
  scale_linetype_manual(
    name = " ",
    values = c("Solid line: fitted H2(p)" = "solid")
  ) +
  labs(
    title = "Aggregated regional entropy (Mean) vs Shannon-Entropy H2 (p)",
    subtitle = sprintf("Points: H_mean (PCR1–3) | Solid line: a_fit = %.3f (RMSE = %.3f)", a_fit, rmse_fit),
    x = "Methylation rate p (Ground Truth, %)",
    y = "mean Entropy"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    panel.background = element_rect(fill = "white", colour = NA),
    plot.background  = element_rect(fill = "white", colour = NA),
    panel.grid.major = element_line(linewidth = 0.3),
    panel.grid.minor = element_line(linewidth = 0.2),
    plot.title       = element_text(face = "bold"),
    axis.title.x     = element_text(margin = margin(t = 8)),
    axis.title.y     = element_text(margin = margin(r = 8)),
    legend.position  = "bottom",
    legend.direction = "horizontal",
    legend.title     = element_blank(),
    legend.text      = element_text(size = 9),
    legend.key.width = unit(10, "pt"),
    legend.key.height= unit(10, "pt"),
    legend.box.margin= margin(t = 4, r = 0, b = 0, l = 0)
  ) +
  guides(
    shape    = guide_legend(order = 1, override.aes = list(size = 3), nrow = 1),
    linetype = guide_legend(order = 2, nrow = 1)
  ) +
  annotate(
    "label",
    x = x_annot, y = y_annot,
    label = sprintf("a_fit = %.3f\nRMSE = %.3f", a_fit, rmse_fit),
    hjust = 0.5, vjust = 0.5,
    label.size = 0.2
  )

ggsave(out_png, plt, width = 8, height = 5.2, dpi = 300)
ggsave(out_pdf, plt, width = 8, height = 5.2)
message("✔ Plot gespeichert:")
message("  - ", out_png)
message("  - ", out_pdf)



# Vergleichstabelle

df_tab <- agg
if (!is.null(select_barcodes_for_table)) {
  pat <- paste0("^barcode(", paste0(select_barcodes_for_table, collapse = "|"), ")$")
  df_tab <- df_tab %>% filter(str_detect(barcode, pat))
  if (nrow(df_tab) == 0) warning("Hinweis: Kein Barcode aus 'select_barcodes_for_table' gefunden; Tabelle bleibt leer.")
}

H2_at_tab <- H2_fun(df_tab$p)

table_out <- df_tab %>%
  transmute(
    Barcode                   = barcode,
    `GT %`                    = gt_percent,
    `Beob. H (Mean über 3 PCR)` = H_mean,
    `Theorie H2 (unskaliert)` = H2_at_tab,
    `Abweichung (unskaliert)` = H_mean - H2_at_tab,
    `Theorie H2·a_fit`        = H2_at_tab * a_fit,
    `Abweichung (skaliert)`   = H_mean - (H2_at_tab * a_fit),
    n                         = n,
    sd                        = H_sd
  ) %>%
  arrange(`GT %`) %>%
  mutate(across(-Barcode, ~round(.x, round_digits)))

write_csv(table_out, out_table_csv)
message("Vergleichstabelle gespeichert: ", out_table_csv)

print(table_out, n = nrow(table_out))
cat("\nHinweis:\n",
    "- 'Beob. H (Mean über 3 PCR)': Durchschnitt der median_entropy je Barcode aus den drei Eingabepfaden.\n",
    "- 'Theorie H2 (unskaliert)': reine Shannon-Form (Max.=1 Bit bei p=0.5).\n",
    "- 'Theorie H2·a_fit': an die Mittelwerte skaliert (Least Squares, a_fit).\n",
    "- Abweichungen = Beob. H_mean - Theorie (negativ => Beobachtung unter Theorie).\n",
    sep = "")
