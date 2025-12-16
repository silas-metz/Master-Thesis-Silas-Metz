# ============================================================
# CpG Punktplots (modkit extract calls) für ALLE Barcodes
# ------------------------------------------------------------
# - Input:  <parent_dir>/05_extract_calls/barcodeXX/*.tsv.gz
# - Output: <parent_dir>/06_DensityPlots/barcodeXX/
# - Rot = methyliert (call_code != "-"), Blau = unmethyliert (call_code == "-")
# - Transparente Punkte mit vertikaler Trennung (+ oben / - unten)
# ============================================================

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(ggplot2)
  library(glue)
  library(stringr)
  library(tools)
})

# -----------------------------
# <<< USER-INPUT >>>
# -----------------------------
parent_dir <- "/home/drk/Masterarbeit/PCR_Daten_dorado1.1.1/PCR2/CG/Hac"
pos_path   <- "/home/drk/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/TestClock.csv"

# -----------------------------
# Hilfsfunktionen
# -----------------------------
read_positions <- function(path) {
  message(glue("Lese Positionsdatei: {path}"))
  if (grepl("\\.csv$", path, ignore.case = TRUE)) {
    first_line <- readLines(path, n = 1)
    delim <- if (grepl(";", first_line)) ";" else ","
    read_delim(
      path, delim = delim,
      col_names = c("chrom","start","end"),
      col_types = cols(
        chrom = col_character(),
        start = col_integer(),
        end   = col_integer()
      ),
      show_col_types = FALSE
    )
  } else if (grepl("\\.bed$", path, ignore.case = TRUE)) {
    read_tsv(
      path,
      col_names = c("chrom","start","end"),
      col_types = cols(
        chrom = col_character(),
        start = col_integer(),
        end   = col_integer()
      ),
      comment = "#",
      show_col_types = FALSE
    )
  } else {
    stop("Positionsdatei muss .csv oder .bed sein: ", path)
  }
}

read_calls <- function(tsv_path) {
  message(glue("  └─ TSV: {tsv_path}"))
  tsv <- read_tsv(tsv_path, show_col_types = FALSE)
  need_cols <- c("ref_position","chrom","ref_strand","call_prob","call_code")
  missing <- setdiff(need_cols, names(tsv))
  if (length(missing) > 0) stop("Fehlende Spalten in TSV: ", paste(missing, collapse = ", "))
  tsv
}

map_status <- function(x) {
  x <- as.character(x)
  ifelse(is.na(x) | x == "" | x == "-", "Unmethylated", "Methylated")
}

empty_plot <- function(title_txt, subtitle_txt = "Keine Reads für diese Auswahl") {
  ggplot() +
    annotate("text", x = 0.5, y = 0.5, label = subtitle_txt, size = 5, hjust = 0.5) +
    coord_cartesian(xlim = c(0, 1), ylim = c(0, 1)) +
    labs(title = title_txt, x = "Call Probability", y = NULL) +
    theme_minimal(base_size = 12) +
    theme(
      plot.background  = element_rect(fill = "white", colour = NA),
      panel.background = element_rect(fill = "white", colour = NA),
      axis.text = element_text(colour = "black"),
      axis.title = element_text(colour = "black"),
      axis.ticks.y = element_blank(),
      axis.text.y  = element_blank()
    )
}

# >>> Punktplot mit vertikaler Trennung zwischen Meth/Unmeth
make_pointplot <- function(df, title_txt, subtitle_txt) {
  df <- df %>% filter(!is.na(call_prob))
  if (nrow(df) == 0) return(empty_plot(title_txt, subtitle_txt))
  
  df <- df %>%
    mutate(
      methylation = factor(map_status(call_code),
                           levels = c("Methylated", "Unmethylated")),
      # vertikale Trennung: Meth oben (0.65), Unmeth unten (0.35)
      y_center = ifelse(methylation == "Methylated", 0.65, 0.35),
      y_jitter = jitter(y_center, amount = 0.10)
    )
  
  ggplot(df, aes(x = call_prob, y = y_jitter, color = methylation)) +
    geom_point(alpha = 0.12, size = 2, shape = 16, stroke = 0) +
    scale_color_manual(values = c("Methylated" = "red", "Unmethylated" = "blue")) +
    coord_cartesian(xlim = c(0, 1), ylim = c(0, 1)) +
    labs(
      title = title_txt,
      subtitle = subtitle_txt,
      x = "Call Probability",
      y = NULL,
      color = NULL
    ) +
    theme_minimal(base_size = 12) +
    theme(
      plot.background  = element_rect(fill = "white", colour = NA),
      panel.background = element_rect(fill = "white", colour = NA),
      axis.text.y = element_blank(),
      axis.ticks.y = element_blank(),
      axis.text = element_text(colour = "black"),
      axis.title = element_text(colour = "black"),
      legend.position = "bottom"
    )
}

find_tsv_for_barcode <- function(barcode_dir) {
  cand1 <- Sys.glob(file.path(barcode_dir, "*_calls_all_from_bed.tsv.gz"))
  if (length(cand1) >= 1) return(cand1[1])
  cand2 <- Sys.glob(file.path(barcode_dir, "*.tsv.gz"))
  if (length(cand2) >= 1) return(cand2[1])
  stop("Keine .tsv.gz in: ", barcode_dir)
}

# -----------------------------
# MAIN
# -----------------------------
calls_root   <- file.path(parent_dir, "05_extract_calls")
output_root  <- file.path(parent_dir, "06_DensityPlots")
dir.create(output_root, showWarnings = FALSE, recursive = TRUE)

bed <- read_positions(pos_path)

barcode_dirs <- list.dirs(calls_root, full.names = TRUE, recursive = FALSE)
barcode_dirs <- barcode_dirs[grepl("barcode", basename(barcode_dirs), ignore.case = TRUE)]
if (length(barcode_dirs) == 0) stop("Keine barcodeXX-Ordner unter: ", calls_root)

message(glue("Gefundene Barcodes unter {calls_root}: {paste(basename(barcode_dirs), collapse=', ')}"))

for (bdir in barcode_dirs) {
  barcode_name <- basename(bdir)
  message(glue("\n===== Verarbeite {barcode_name} ====="))
  
  tsv_path <- find_tsv_for_barcode(bdir)
  tsv <- read_calls(tsv_path)
  
  out_dir <- file.path(output_root, barcode_name)
  dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
  pdf_path <- file.path(out_dir, glue("{barcode_name}_CallProb_PointPlots_All.pdf"))
  
  plots_to_pdf <- list()
  
  tmp_summary <- tsv %>% mutate(methylation = map_status(call_code)) %>%
    count(methylation)
  message(glue("  Klassen in TSV: {paste(paste0(tmp_summary$methylation, '=', tmp_summary$n), collapse=' | ')}"))
  
  for (i in seq_len(nrow(bed))) {
    chrom     <- bed$chrom[i]
    start_pos <- bed$start[i]
    end_pos   <- bed$end[i] - 1
    
    message(glue("→ CpG {i}: {chrom}:{start_pos}-{bed$end[i]} | + = {start_pos}, - = {end_pos}"))
    
    plus_df  <- tsv %>% filter(chrom == !!chrom, ref_position == !!start_pos, ref_strand == "+")
    minus_df <- tsv %>% filter(chrom == !!chrom, ref_position == !!end_pos,   ref_strand == "-")
    
    title_plus  <- glue("{chrom}:{start_pos}  (+ Strand)")
    title_minus <- glue("{chrom}:{end_pos}  (- Strand)")
    sub_plus    <- glue("n = {nrow(plus_df)} Reads  |  Regel: start & ref_strand = '+'")
    sub_minus   <- glue("n = {nrow(minus_df)} Reads  |  Regel: (end-1) & ref_strand = '-'")
    
    p_plus  <- make_pointplot(plus_df,  title_plus,  sub_plus)
    p_minus <- make_pointplot(minus_df, title_minus, sub_minus)
    
    ggsave(file.path(out_dir, glue("{barcode_name}_CpG_{chrom}_{start_pos}_plus_points.png")),
           plot = p_plus, width = 7, height = 4, dpi = 300, bg = "white")
    ggsave(file.path(out_dir, glue("{barcode_name}_CpG_{chrom}_{end_pos}_minus_points.png")),
           plot = p_minus, width = 7, height = 4, dpi = 300, bg = "white")
    
    plots_to_pdf <- append(plots_to_pdf, list(p_plus, p_minus))
  }
  
  pdf(pdf_path, width = 7, height = 4, onefile = TRUE, bg = "white")
  for (p in plots_to_pdf) print(p)
  dev.off()
  
  message(glue("✅ Fertig für {barcode_name}. Ausgabe: {out_dir}"))
}

message(glue("\n🎯 Alle Barcodes fertig. Gesamtausgabe unter: {output_root}\n"))
