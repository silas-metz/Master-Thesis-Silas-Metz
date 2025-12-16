library(readr)
library(dplyr)

# INPUT
bedmethyl_dir <- "Q:/Main/Mol_Diag/Projekte/2024-2025_Aging/Auswertung/Age_Methylreihe_PCR_IP_SiMa_20250429/Hac_bedmethyl_als_csv_mit_krit"
position_csv <- "Q:/Main/Mol_Diag/Personen/Zz_Studierende/Mayr_S/SilasBackup/SilasRStudio/SkriptTestDateien_csv/TestClock.csv"
# OUTPUT
output_dir <- "Q:/Main/Mol_Diag/Projekte/2024-2025_Aging/Auswertung/Age_Methylreihe_PCR_IP_SiMa_20250429/hac_filtered_by_PCR_Clock_mit_krit"

pos_df <- read_csv2(position_csv, show_col_types = FALSE)

required_cols <- c("chrom", "start", "end")
if (!all(required_cols %in% colnames(pos_df))) {
  stop("Positionsdatei muss Spalten: chrom, start, end enthalten.")
}

dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

csv_files <- list.files(bedmethyl_dir, pattern = "\\.csv$", full.names = TRUE)

for (bedmethyl_file in csv_files) {
  cat("Verarbeite:", bedmethyl_file, "\n")
  
  bed_df <- read_csv(bedmethyl_file, show_col_types = FALSE)
  
  if (!all(required_cols %in% colnames(bed_df))) {
    warning("⚠️ Datei übersprungen wegen fehlender Spalten:", bedmethyl_file)
    next
  }
  
  filtered_df <- bed_df %>%
    filter(
      mapply(function(chr, pos) {
        any(pos_df$chrom == chr & pos_df$start <= pos & pos_df$end >= pos)
      }, chrom, start)
    )
  
  base_name <- basename(bedmethyl_file)
  output_file <- file.path(output_dir, base_name)
  
  write_csv(filtered_df, output_file)
  cat("✅ Gespeichert:", output_file, "\n\n")
}

cat("Alle Dateien wurden verarbeitet!\n")
