suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(ggplot2)
  library(tidyr)
  library(stringr)
})

in_file <- "/path/to/input/CASIN/20250729/Age_all_clocks_merged.csv"
out_dir <- "/path/to/output/CASIN/20250729/Clock_QC/Weidner_CpGs"

dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

read_age_robust <- function(path) {
  if (!file.exists(path)) {
    stop("Input-Datei nicht gefunden: ", path)
  }
  
  age1 <- tryCatch(
    read_delim(
      path,
      delim  = ";",
      locale = locale(decimal_mark = ","),
      show_col_types = FALSE
    ),
    error = function(e) NULL
  )
  if (!is.null(age1) && ncol(age1) > 1) {
    message("Eingelesen als ';'-getrennte Datei mit Dezimal-Komma.")
    return(age1)
  }
  
  age2 <- tryCatch(
    read_delim(
      path,
      delim  = ",",
      locale = locale(decimal_mark = "."),
      show_col_types = FALSE
    ),
    error = function(e) NULL
  )
  if (!is.null(age2) && ncol(age2) > 1) {
    message("Eingelesen als ','-getrennte Datei mit Dezimal-Punkt.")
    return(age2)
  }
  
  stop("Konnte Datei nicht sinnvoll parsen – bitte Trennzeichen/Format prüfen.")
}

age_raw <- read_age_robust(in_file)

needed_cols <- c(
  "sample_id", "id_short",
  "beta_ASPA", "beta_ITGA2B", "beta_PDE4C"
)

missing <- setdiff(needed_cols, names(age_raw))
if (length(missing) > 0) {
  stop("In Age_all_clocks_merged fehlen Spalten: ",
       paste(missing, collapse = ", "))
}

age <- age_raw %>%
  select(all_of(needed_cols)) %>%
  mutate(
    beta_ASPA   = as.numeric(beta_ASPA),
    beta_ITGA2B = as.numeric(beta_ITGA2B),
    beta_PDE4C  = as.numeric(beta_PDE4C),
    id_short    = factor(id_short, levels = c("d0", "d7_CASIN", "d7_DMSO"))
  )

cat("Kopf 'age':\n")
print(head(age))

beta_long <- age %>%
  pivot_longer(
    cols      = c(beta_ASPA, beta_ITGA2B, beta_PDE4C),
    names_to  = "cpg",
    values_to = "beta"
  ) %>%
  mutate(
    cpg = recode(
      cpg,
      "beta_ASPA"   = "CpG1 (ASPA)",
      "beta_ITGA2B" = "CpG2 (ITGA2B)",
      "beta_PDE4C"  = "CpG3 (PDE4C)"
    ),
    cpg = factor(
      cpg,
      levels = c("CpG1 (ASPA)",
                 "CpG2 (ITGA2B)",
                 "CpG3 (PDE4C)")
    )
  )

cat("\nbeta_long (wird für Plot UND CSV benutzt):\n")
print(beta_long)

cpg_stats_final <- beta_long %>%
  arrange(cpg, id_short, sample_id) %>%
  select(cpg, id_short, sample_id, beta)

stats_out <- file.path(out_dir, "Age_Weidner_CpG_group_stats.csv")
write_csv(cpg_stats_final, stats_out)
cat("\n CpG-Punktdaten geschrieben nach:\n", stats_out, "\n")

# Plot
plot_cpg_scatter <- function(df_cpg, cpg_label, out_pdf) {
  p <- ggplot(df_cpg,
              aes(x = id_short,
                  y = beta * 100,
                  color = id_short,
                  shape = id_short)) +
    geom_point(size = 3, alpha = 0.9) +
    scale_x_discrete(name = "Sample / condition") +
    scale_y_continuous(
      name         = "Methylation level [%]",
      limits       = c(0, 100),
      breaks       = seq(0, 100, by = 20),
      minor_breaks = seq(0, 100, by = 10),
      labels       = function(x) paste0(x, " %"),
      expand       = expansion(mult = 0.02)
    ) +
    labs(
      title = paste0("Weidner ", cpg_label, " - methylation by condition")
    ) +
    theme_bw(base_size = 12) +
    theme(
      panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
      panel.grid.minor = element_line(color = "grey92", linewidth = 0.2),
      plot.title       = element_text(hjust = 0.5, face = "bold"),
      legend.position  = "bottom",
      legend.title     = element_blank()
    )
  
  ggsave(out_pdf, p, width = 5, height = 4)
  cat("CpG-Plot gespeichert:", out_pdf, "\n")
}

for (cp in levels(beta_long$cpg)) {
  df_sub    <- beta_long %>% filter(cpg == cp)
  lab_clean <- str_replace(cp, "CpG", "CpG ")
  file_safe <- str_replace_all(cp, "[ ()]", "_")
  out_pdf   <- file.path(
    out_dir,
    paste0("Age_Weidner_", file_safe, "_age_vs_beta.pdf")
  )
  plot_cpg_scatter(df_sub, lab_clean, out_pdf)
}

p_all <- ggplot(beta_long,
                aes(x = id_short,
                    y = beta * 100,
                    color = id_short,
                    shape = id_short)) +
  geom_point(size = 3, alpha = 0.9) +
  scale_x_discrete(name = "Sample / condition") +
  scale_y_continuous(
    name         = "Methylation level [%]",
    limits       = c(0, 100),
    breaks       = seq(0, 100, by = 20),
    minor_breaks = seq(0, 100, by = 10),
    labels       = function(x) paste0(x, " %"),
    expand       = expansion(mult = 0.02)
  ) +
  facet_wrap(~ cpg, nrow = 1) +
  labs(title = "Weidner CpG methylation across CASIN conditions") +
  theme_bw(base_size = 12) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.3),
    panel.grid.minor = element_line(color = "grey92", linewidth = 0.2),
    plot.title       = element_text(hjust = 0.5, face = "bold"),
    legend.position  = "bottom",
    legend.title     = element_blank(),
    strip.text       = element_text(face = "bold")
  )

out_pdf_all <- file.path(
  out_dir,
  "Age_Weidner_CpGs_all_three_facets_age_vs_beta.pdf"
)
ggsave(out_pdf_all, p_all, width = 9, height = 4)
cat("Kombinierter CpG-Scatter gespeichert:", out_pdf_all, "\n")

cat("\n Fertig: jetzt mit y-Achse in Prozent.\n")
