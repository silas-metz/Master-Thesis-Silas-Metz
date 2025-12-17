suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(tidyr)
  library(tools)
})


clock_name <- "Horvath"

if (clock_name == "Horvath") {
  clock_mapping_csv <- "/path/to/clocks/HorvathClock_hg19_hg38.csv"
  combined_dir      <- "/path/to/input/CASIN/Output_CG_Kontext/Hac/20250729/00_Results/Filtered_by_Horvath/noH/combined_strands"
} else if (clock_name == "Hannum") {
  clock_mapping_csv <- "/path/to/clocks/HannumClock_hg19_hg38.csv"
  combined_dir      <- "/path/to/input/CASIN/Output_CG_Kontext/Hac/20250729/00_Results/Filtered_by_Hannum/noH/combined_strands"
} else {
  stop("clock_name muss 'Horvath' oder 'Hannum' sein.")
}


# Output-Ordner
output_dir <- file.path(combined_dir, "with_cpgid")
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)


if (!file.exists(clock_mapping_csv)) {
  stop("Clock-Mapping-Datei nicht gefunden: ", clock_mapping_csv)
}

map_df <- read_csv(clock_mapping_csv, show_col_types = FALSE)

needed_cols <- c("cpg_id","chrom_hg19","pos_hg19",
                 "chrom_hg38","pos_hg38","start_hg38","end_hg38")
if (!all(needed_cols %in% names(map_df))) {
  stop("In ", clock_mapping_csv, " fehlen benötigte Spalten: ",
       paste(setdiff(needed_cols, names(map_df)), collapse = ", "))
}

map_df <- map_df %>%
  filter(!is.na(chrom_hg38), !is.na(pos_hg38))

map_long <- map_df %>%
  mutate(pos_minus1 = pos_hg38 - 1L,
         pos_exact  = pos_hg38,
         pos_plus1  = pos_hg38 + 1L) %>%
  pivot_longer(cols = c(pos_minus1, pos_exact, pos_plus1),
               names_to = "which_pos",
               values_to = "start") %>%
  select(cpg_id,
         chrom_hg19, pos_hg19,
         chrom_hg38 = chrom_hg38,
         pos_hg38,
         start_hg38, end_hg38,
         start) %>%
  distinct()

cat("Clock:", clock_name, "– Mapping-Tabellenzeilen:", nrow(map_long), "\n")


if (!dir.exists(combined_dir)) {
  stop("combined_dir existiert nicht: ", combined_dir)
}

in_files <- list.files(combined_dir, pattern = "\\.csv$", full.names = TRUE)
if (length(in_files) == 0) {
  stop("Keine .csv-Dateien in combined_dir gefunden: ", combined_dir)
}

annotate_one_file <- function(f) {
  base <- basename(f)
  sample_id <- file_path_sans_ext(base)
  cat("▶️  Verarbeite:", base, "... ")
  
  df <- tryCatch(
    read_csv(f, show_col_types = FALSE),
    error = function(e) read_csv2(f, show_col_types = FALSE)
  )
  
  if (!all(c("chrom","start") %in% names(df))) {
    cat("Spalten 'chrom' oder 'start' fehlen, übersprungen.\n")
    return(NULL)
  }
  
  df2 <- df %>%
    left_join(map_long,
              by = c("chrom" = "chrom_hg38",
                     "start" = "start"))
  
  n_total <- nrow(df2)
  n_annot <- sum(!is.na(df2$cpg_id))
  cat("OK (annotiert:", n_annot, "von", n_total, "Zeilen)\n")
  
  out_file <- file.path(output_dir, paste0(sample_id, "_with_cpgid.csv"))
  write_csv(df2, out_file)
  
  return(invisible(df2))
}

res_list <- lapply(in_files, annotate_one_file)

cat("\n✅ Fertig. Annotierte Dateien (mit cpg_id) liegen in:\n  ",
    output_dir, "\n")
