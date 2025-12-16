suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(tidyr)
  library(ggplot2)
  library(stringr)
})

in_file <- "/home/drk/Masterarbeit/CASIN/20250721/Age_all_clocks_merged.csv"

out_dir <- "/home/drk/Masterarbeit/CASIN/20250721/Clock_QC/Age_VS_Age"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

age <- read_csv(in_file, show_col_types = FALSE)

cat("Kopf der eingelesenen Tabelle:\n")
print(head(age))

needed <- c("sample_id",
            "id_short",
            "group",
            "real_age",
            "DNAmAge_Weidner",
            "DNAmAge_HorvathS2013_antiTrafo",
            "DNAmAge_HannumG2013_raw",
            "AA_Weidner",
            "AA_Horvath",
            "AA_Hannum")

if (!all(needed %in% names(age))) {
  stop("Fehlende Spalten in Age_all_clocks_merged.csv:\n",
       paste(setdiff(needed, names(age)), collapse = ", "))
}

age <- age %>%
  mutate(
    group = factor(group, levels = c("young", "old"))
  )

cat("\nZusammenfassung real_age:\n")
print(summary(age$real_age))

# Scatter: Chronologisches Alter vs DNAmAge
# Long-Format: eine Zeile = Sample + Clock
age_long <- age %>%
  transmute(
    id_short,
    group,
    real_age,
    Weidner = DNAmAge_Weidner,
    Horvath = DNAmAge_HorvathS2013_antiTrafo,
    Hannum  = DNAmAge_HannumG2013_raw
  ) %>%
  pivot_longer(
    cols      = c(Weidner, Horvath, Hannum),
    names_to  = "clock",
    values_to = "DNAmAge"
  )

p_scatter <- ggplot(age_long,
                    aes(x = real_age,
                        y = DNAmAge,
                        color = group,
                        label = id_short)) +
  geom_abline(slope = 1, intercept = 0,
              linetype = "dashed", alpha = 0.5) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 0.8) +
  # Labels als kleine Textchen neben den Punkten
  ggrepel::geom_text_repel(size = 3, show.legend = FALSE) +
  facet_wrap(~ clock, nrow = 1, scales = "fixed") +
  scale_color_manual(values = c("young" = "#1f77b4",
                                "old"   = "#d62728")) +
  labs(
    x = "Chronological age (years)",
    y = "DNAm age (years)",
    color = "Group",
    title = "Chronological age vs. DNAm age (Weidner, Horvath, Hannum)"
  ) +
  theme_bw(base_size = 11) +
  theme(
    strip.background = element_rect(fill = "grey90"),
    strip.text       = element_text(face = "bold"),
    legend.position  = "bottom"
  )

scatter_file <- file.path(out_dir, "Age_scatter_all_clocks.pdf")
ggsave(scatter_file, p_scatter, width = 9, height = 3.5)
cat("\n Gespeichert: ", scatter_file, "\n")

# AA-Vergleich
make_pair_df <- function(df, xcol, ycol, xlab, ylab) {
  df %>%
    transmute(
      id_short,
      group,
      x    = .data[[xcol]],
      y    = .data[[ycol]],
      pair = paste0(xlab, " vs ", ylab)
    )
}

aa_pairs <- bind_rows(
  make_pair_df(age, "AA_Weidner", "AA_Horvath", "Weidner", "Horvath"),
  make_pair_df(age, "AA_Weidner", "AA_Hannum",  "Weidner", "Hannum"),
  make_pair_df(age, "AA_Horvath", "AA_Hannum",  "Horvath", "Hannum")
)

pair_stats <- aa_pairs %>%
  group_by(pair) %>%
  summarise(
    cor = cor(x, y, use = "pairwise.complete.obs"),
    .groups = "drop"
  )

cat("\nPairwise AA-Korrelationen:\n")
print(pair_stats)

# Scatter-Plot
p_pairs <- ggplot(aa_pairs,
                  aes(x = x, y = y,
                      color = group,
                      label = id_short)) +
  geom_hline(yintercept = 0, linetype = "dotted", alpha = 0.5) +
  geom_vline(xintercept = 0, linetype = "dotted", alpha = 0.5) +
  geom_point(size = 3) +
  ggrepel::geom_text_repel(size = 3, show.legend = FALSE) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 0.8) +
  facet_wrap(~ pair, nrow = 1, scales = "free") +
  scale_color_manual(values = c("young" = "#1f77b4",
                                "old"   = "#d62728")) +
  labs(
    x = "Age acceleration (Clock 1) [years]",
    y = "Age acceleration (Clock 2) [years]",
    color = "Group",
    title = "Pairwise comparison of age acceleration between clocks"
  ) +
  theme_bw(base_size = 11) +
  theme(
    strip.background = element_rect(fill = "grey90"),
    strip.text       = element_text(face = "bold"),
    legend.position  = "bottom"
  )

pairs_file <- file.path(out_dir, "Age_AA_pairwise_scatter.pdf")
ggsave(pairs_file, p_pairs, width = 9, height = 3.5)
cat("Gespeichert: ", pairs_file, "\n")

cat("\nFertig. Dieses Skript erzeugt:\n",
    "- Age_scatter_all_clocks.pdf (real_age vs DNAmAge für alle 3 Clocks)\n",
    "- Age_AA_pairwise_scatter.pdf (AA-Vergleich Clock vs Clock)\n")
