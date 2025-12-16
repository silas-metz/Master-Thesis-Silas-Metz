suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(tidyr)
  library(ggplot2)
})

in_file <- "/home/drk/Masterarbeit/CASIN/20250721/Age_all_clocks_merged.csv"

out_dir <- "/home/drk/Masterarbeit/CASIN/20250721/Clock_QC/AA"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

out_pdf <- file.path(out_dir, "Age_AA_heatmap_zscore.pdf")

age <- tryCatch(
  {
    read_csv(in_file, show_col_types = FALSE)
  },
  error = function(e) {
    read_delim(
      in_file,
      delim  = ";",
      locale = locale(decimal_mark = ","),
      show_col_types = FALSE
    )
  }
)

cat("Kopf der eingelesenen Tabelle:\n")
print(head(age))

age <- age %>%
  mutate(
    real_age = dplyr::case_when(
      is.numeric(real_age) ~ real_age,
      is.character(real_age) ~ suppressWarnings(
        as.numeric(gsub(",", ".", real_age, fixed = TRUE))
      ),
      TRUE ~ NA_real_
    ),
    AA_Weidner = DNAmAge_Weidner               - real_age,
    AA_Horvath = DNAmAge_HorvathS2013_antiTrafo - real_age,
    AA_Hannum  = DNAmAge_HannumG2013_raw       - real_age
  )

cat("\nZusammenfassung real_age (Jahre):\n")
print(summary(age$real_age))

cat("\nZusammenfassung AA_Weidner:\n")
print(summary(age$AA_Weidner))

cat("\nZusammenfassung AA_Horvath:\n")
print(summary(age$AA_Horvath))

cat("\nZusammenfassung AA_Hannum:\n")
print(summary(age$AA_Hannum))

# Matrix für Heatmap
aa_mat <- age %>%
  select(id_short, group, AA_Weidner, AA_Horvath, AA_Hannum)

aa_long <- aa_mat %>%
  pivot_longer(
    cols      = starts_with("AA_"),
    names_to  = "clock",
    values_to = "AA"
  ) %>%
  group_by(clock) %>%
  mutate(
    AA_z = (AA - mean(AA, na.rm = TRUE)) / sd(AA, na.rm = TRUE)
  ) %>%
  ungroup()

sample_order <- aa_long %>%
  distinct(id_short, group) %>%
  arrange(group, id_short) %>%
  pull(id_short)

aa_long <- aa_long %>%
  mutate(
    id_short = factor(id_short, levels = sample_order),
    clock    = factor(clock,
                      levels = c("AA_Weidner", "AA_Horvath", "AA_Hannum"),
                      labels = c("Weidner", "Horvath", "Hannum"))
  )

# Heatmap

p_heat <- ggplot(aa_long, aes(x = clock, y = id_short, fill = AA_z)) +
  geom_tile(color = "grey40") +
  scale_fill_gradient2(
    name = "z-AA",
    low = "#2166ac",
    mid = "white",
    high = "#b2182b",
    midpoint = 0
  ) +
  labs(
    x = "Clock",
    y = "Sample",
    title = "Age Acceleration (z-score) – Weidner / Horvath / Hannum"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x  = element_text(angle = 45, hjust = 1),
    panel.grid   = element_blank()
  )

ggsave(out_pdf, p_heat, width = 5, height = 5)
cat("\n Heatmap geschrieben nach:\n", out_pdf, "\n")

# ============================================================
# ENDE – dieses Skript erzeugt NUR die AA-Heatmap, keine Boxplots
# ============================================================
