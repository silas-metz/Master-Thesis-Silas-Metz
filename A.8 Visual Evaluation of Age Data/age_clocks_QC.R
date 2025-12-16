suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(ggplot2)
})

# -----------------------------
# <<< USER-INPUT >>>
# -----------------------------

in_file <- "/home/drk/Masterarbeit/CASIN/20250729/Age_all_clocks_merged.csv"

out_dir <- "/home/drk/Masterarbeit/CASIN/20250729/Clock_QC"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

age <- read_delim(
  in_file,
  delim = ",",
  locale = locale(decimal_mark = "."),
  show_col_types = FALSE
)

cat("Kopf der eingelesenen Tabelle:\n")
print(head(age))

cat("\nSpaltennamen:\n")
print(names(age))

cat("\nZusammenfassung real_age:\n")
print(summary(age$real_age))


# Age Acceleration
age <- age %>%
  mutate(
    AA_Weidner = DNAmAge_Weidner               - real_age,
    AA_Horvath = DNAmAge_HorvathS2013_antiTrafo - real_age,
    AA_Hannum  = DNAmAge_HannumG2013_raw       - real_age
  )

# Scatterplots: real_age vs. Clock
plot_scatter_clock <- function(df, clock_col, clock_label, file_suffix) {
  form <- as.formula(paste(clock_col, "~ real_age"))
  lm_fit <- lm(form, data = df)
  r2     <- summary(lm_fit)$r.squared
  
  p <- ggplot(df, aes(x = real_age, y = .data[[clock_col]], colour = group, label = id_short)) +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
    geom_point(size = 3) +
    geom_smooth(method = "lm", se = FALSE) +
    ggrepel::geom_text_repel(size = 3, show.legend = FALSE) +
    labs(
      x = "Chronological age [years]",
      y = paste0(clock_label, " [years]"),
      colour = "Group",
      title = paste("Chronological age vs.", clock_label),
      subtitle = paste0("Linear fit R² = ", round(r2, 3))
    ) +
    theme_bw()
  
  outfile <- file.path(out_dir, paste0("Age_scatter_", file_suffix, ".pdf"))
  ggsave(outfile, p, width = 6, height = 5)
  cat("Scatterplot geschrieben:", outfile, "\n")
}

suppressPackageStartupMessages(library(ggrepel))

plot_scatter_clock(age, "DNAmAge_Weidner",               "DNAmAge (Weidner)", "Weidner")
plot_scatter_clock(age, "DNAmAge_HorvathS2013_antiTrafo","DNAmAge (Horvath)", "Horvath")
plot_scatter_clock(age, "DNAmAge_HannumG2013_raw",       "DNAmAge (Hannum)",  "Hannum")

# Boxplots: Age Acceleration

plot_box_AA <- function(df, aa_col, aa_label, file_suffix) {
  p <- ggplot(df, aes(x = group, y = .data[[aa_col]], fill = group)) +
    geom_boxplot(outlier.shape = NA, alpha = 0.5) +
    geom_jitter(width = 0.1, size = 2) +
    labs(
      x = "",
      y = paste0(aa_label, " [years]"),
      title = paste(aa_label, "by group")
    ) +
    theme_bw()
  
  outfile <- file.path(out_dir, paste0("Age_boxplot_", file_suffix, ".pdf"))
  ggsave(outfile, p, width = 4, height = 5)
  cat("Boxplot geschrieben:", outfile, "\n")
}

plot_box_AA(age, "AA_Weidner", "Age Acceleration (Weidner)", "AA_Weidner")
plot_box_AA(age, "AA_Horvath", "Age Acceleration (Horvath)", "AA_Horvath")
plot_box_AA(age, "AA_Hannum",  "Age Acceleration (Hannum)",  "AA_Hannum")

# Statistiken
stats_group <- age %>%
  group_by(group) %>%
  summarise(
    n              = n(),
    mean_real_age  = mean(real_age),
    sd_real_age    = sd(real_age),
    mean_Weidner   = mean(DNAmAge_Weidner),
    sd_Weidner     = sd(DNAmAge_Weidner),
    mean_Horvath   = mean(DNAmAge_HorvathS2013_antiTrafo),
    sd_Horvath     = sd(DNAmAge_HorvathS2013_antiTrafo),
    mean_Hannum    = mean(DNAmAge_HannumG2013_raw),
    sd_Hannum      = sd(DNAmAge_HannumG2013_raw),
    mean_AA_Weidner= mean(AA_Weidner),
    sd_AA_Weidner  = sd(AA_Weidner),
    mean_AA_Horvath= mean(AA_Horvath),
    sd_AA_Horvath  = sd(AA_Horvath),
    mean_AA_Hannum = mean(AA_Hannum),
    sd_AA_Hannum   = sd(AA_Hannum),
    .groups = "drop"
  )

tt_weidner <- t.test(AA_Weidner ~ group, data = age)
tt_horvath <- t.test(AA_Horvath ~ group, data = age)
tt_hannum  <- t.test(AA_Hannum  ~ group, data = age)

stats_file_csv <- file.path(out_dir, "Age_clock_stats.csv")
write_csv2(stats_group, stats_file_csv)
cat("Statistiken geschrieben:", stats_file_csv, "\n")

stats_file_txt <- file.path(out_dir, "Age_clock_stats.txt")
sink(stats_file_txt)
cat("=== Group-wise summary ===\n\n")
print(stats_group)

cat("\n\n=== t-tests (AA young vs old) ===\n\n")
cat("Weidner AA:\n"); print(tt_weidner)
cat("\nHorvath AA:\n"); print(tt_horvath)
cat("\nHannum AA:\n");  print(tt_hannum)
sink()
cat("Detail-Statistiken geschrieben:", stats_file_txt, "\n")

cat("\nFertig. Nutze die PDFs + Stats für deine Masterarbeit (Scatterplots, Boxplots, Mittelwerte, p-Werte).\n")
