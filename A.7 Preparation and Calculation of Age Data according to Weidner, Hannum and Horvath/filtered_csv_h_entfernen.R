suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(stringr)
  library(tools)
})

#Input
input_dir  <- "/path/to/input/CASIN/Output_CG_Kontext/Hac/20250721/00_Results/Filtered_by_Horvath"

file_pattern <- "_filtered\\.csv$"

output_dir <- file.path(input_dir, "noH")
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)
 

if (!dir.exists(input_dir)) {
  stop("input_dir existiert nicht: ", input_dir)
}

csv_files <- list.files(input_dir, pattern = file_pattern, full.names = TRUE)
if (length(csv_files) == 0) {
  stop("Keine passenden CSV-Dateien im Ordner gefunden: ", input_dir)
}

cat("Gefundene gefilterte CSV-Dateien:", length(csv_files), "\n\n")

for (csv in csv_files) {
  base <- basename(csv)
  out_file <- file.path(
    output_dir,
    paste0(file_path_sans_ext(base), "_noH.csv")
  )
  
  cat("Verarbeite:", base, "... ")
  
  df <- read_csv(csv, show_col_types = FALSE)
  
  if (!"modcode" %in% names(df)) {
    cat("Spalte 'modcode' fehlt, übersprungen.\n")
    next
  }
  
  n_before <- nrow(df)
  
  df_noH <- df %>%
    filter(!(modcode %in% c("h", "H")))
  
  n_after <- nrow(df_noH)
  n_removed <- n_before - n_after
  
  write_csv(df_noH, out_file)
  
  cat("OK →", out_file, " (", n_removed, " Zeilen mit modcode 'h' entfernt)\n", sep = "")
}

cat("\n Fertig. Alle Dateien ohne h-Methylierungen in:\n  ", output_dir, "\n")
