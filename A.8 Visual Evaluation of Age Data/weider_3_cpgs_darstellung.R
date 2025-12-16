suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(ggplot2)
  library(tidyr)
  library(stringr)
})

in_file <- "/home/drk/Masterarbeit/CASIN/20250721/Age_all_clocks_merged.csv"
out_dir <- "/home/drk/Masterarbeit/CASIN/20250721/Clock_QC/Weidner_CpGs"
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

cat("Kopf der eingelesenen Tabelle (relevante Spalten):\n")
print(
  age_raw %>%
    select(sample_id, id_short, group,
           real_age,
           beta_ASPA, beta_ITGA2B, beta_PDE4C) %>%
    head()
)

needed_cols <- c(
  "sample_id", "id_short", "group", "real_age",
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
    real_age    = as.numeric(real_age),
    beta_ASPA   = as.numeric(beta_ASPA),
    beta_ITGA2B = as.numeric(beta_ITGA2B),
    beta_PDE4C  = as.numeric(beta_PDE4C),
    group       = factor(group,
                         levels = c("young", "old"),
                         labels = c("Young", "Old"))
  )

cat("\nZusammenfassung real_age:\n")
print(summary(age$real_age))

age_min <- floor(min(age$real_age, na.rm = TRUE))
age_max <- ceiling(max(age$real_age, na.rm = TRUE))


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

cat("\nKopf beta_long:\n")
print(head(beta_long))

# Gruppen-Statistik

cpg_group_stats <- beta_long %>%
  group_by(cpg, group) %>%
  summarise(
    n         = sum(!is.na(beta)),
    mean_beta = mean(beta, na.rm = TRUE),
    sd_beta   = sd(beta,   na.rm = TRUE),
    .groups   = "drop"
  )

cpg_summary <- cpg_group_stats %>%
  select(cpg, group, mean_beta, sd_beta) %>%
  pivot_wider(
    names_from  = group,
    values_from = c(mean_beta, sd_beta),
    names_glue  = "{.value}_{group}"
  )

cpg_ttests <- beta_long %>%
  group_by(cpg) %>%
  summarise(
    diff_old_minus_young =
      mean(beta[group == "Old"],   na.rm = TRUE) -
      mean(beta[group == "Young"], na.rm = TRUE),
    p_value = tryCatch(
      t.test(beta ~ group)$p.value,
      error = function(e) NA_real_
    ),
    .groups = "drop"
  )

cpg_stats_final <- cpg_summary %>%
  left_join(cpg_ttests, by = "cpg")

stats_out <- file.path(out_dir, "Age_Weidner_CpG_group_stats.csv")
write_csv(cpg_stats_final, stats_out)
cat("\n CpG-Gruppenstatistik geschrieben:", stats_out, "\n")

# Scatter (Alter vs Beta)
plot_cpg_scatter <- function(df_cpg, cpg_label, out_pdf,
                             age_min, age_max) {
  lm_fit <- lm(beta ~ real_age, data = df_cpg)
  R2     <- summary(lm_fit)$r.squared
  
  y_pos <- max(df_cpg$beta, na.rm = TRUE) -
    0.05 * diff(range(df_cpg$beta, na.rm = TRUE))
  
  p <- ggplot(df_cpg,
              aes(x = real_age, y = beta,
                  color = group, shape = group)) +
    geom_point(size = 3, alpha = 0.9) +
    geom_smooth(
      data = df_cpg,
      aes(x = real_age, y = beta),
      method = "lm",
      se = FALSE,
      color = "black",
      linewidth = 0.8,
      inherit.aes = FALSE
    ) +
    annotate(
      "text",
      x = 45,
      y = y_pos,
      label = paste0("R² = ", sprintf("%.2f", R2)),
      hjust = 0.5,
      vjust = 1,
      size  = 3.5
    ) +
    scale_color_manual(
      values = c("Young" = "#1f77b4", "Old" = "#d62728")
    ) +
    scale_shape_manual(
      values = c("Young" = 16, "Old" = 17)
    ) +
    scale_x_continuous(
      name         = "Chronological age [years]",
      limits       = c(10, 90),
      breaks       = seq(10, 90, by = 10),  # 10er-Hauptticks
      minor_breaks = seq(10, 90, by = 5),   # 5er-Minorticks
      expand       = expansion(mult = 0.01)
    ) +
    scale_y_continuous(
      name   = "Methylation level (beta)",
      limits = c(0, 1),
      breaks = seq(0, 1, by = 0.2),
      minor_breaks = seq(0, 1, by = 0.05),
      expand = expansion(mult = 0.02)
    ) +
    labs(
      title = paste0("Weidner ", cpg_label, " – age vs methylation")
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
  cat("CpG-Scatter gespeichert:", out_pdf, "\n")
}


#Plots
for (cp in levels(beta_long$cpg)) {
  df_sub    <- beta_long %>% filter(cpg == cp)
  lab_clean <- str_replace(cp, "CpG", "CpG ")
  file_safe <- str_replace_all(cp, "[ ()]", "_")
  out_pdf   <- file.path(
    out_dir,
    paste0("Age_Weidner_", file_safe, "_age_vs_beta.pdf")
  )
  plot_cpg_scatter(df_sub, lab_clean, out_pdf, age_min, age_max)
}

p_all <- ggplot(beta_long,
                aes(x = real_age, y = beta,
                    color = group, shape = group)) +
  geom_point(size = 3, alpha = 0.9) +
  geom_smooth(
    aes(group = 1),
    method = "lm",
    se = FALSE,
    color = "black",
    linewidth = 0.8
  ) +
  scale_color_manual(
    values = c("Young" = "#1f77b4", "Old" = "#d62728")
  ) +
  scale_shape_manual(
    values = c("Young" = 16, "Old" = 17)
  ) +
  scale_x_continuous(
    name         = "Chronological age [years]",
    limits       = c(10, 90),
    breaks       = seq(10, 90, by = 10),  # 10er-Hauptticks
    minor_breaks = seq(10, 90, by = 5),   # 5er-Minorticks
    expand       = expansion(mult = 0.01)
  ) +
  scale_y_continuous(
    name   = "Methylation level (beta)",
    limits = c(0, 1),
    breaks = seq(0, 1, by = 0.2),
    minor_breaks = seq(0, 1, by = 0.05),
    expand = expansion(mult = 0.02)
  ) +
  facet_wrap(~ cpg, nrow = 1) +
  labs(
    title = "Weidner CpG methylation vs chronological age"
  ) +
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

cat("\n Fertig: Weidner-CpG Scatterplots (Alter vs Beta) mit Gitternetz erstellt.\n")
