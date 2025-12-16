#  DNAmAge aus Nanopore-Betas:
#   - HorvathS2013  (353 CpGs)
#   - HannumG2013   (71 CpGs)

suppressPackageStartupMessages({
  if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  
  BiocManager::install("methylclockData", ask = FALSE, update = FALSE)
  
  library(methylclockData)
  library(dplyr)
  library(readr)
  library(tidyr)
  library(tools)
})


horvath_with_cpgid_dir <- "/home/drk/Masterarbeit/CASIN/Output_CG_Kontext/Hac/20250721/00_Results/Filtered_by_Horvath/noH/combined_strands/with_cpgid"
hannum_with_cpgid_dir  <- "/home/drk/Masterarbeit/CASIN/Output_CG_Kontext/Hac/20250721/00_Results/Filtered_by_Hannum/noH/combined_strands/with_cpgid"

out_csv <- "/home/drk/Masterarbeit/CASIN/DNAmAge_Horvath_Hannum_from_ONT.csv"

read_clock_long <- function(dir_path) {
  if (!dir.exists(dir_path)) {
    stop("Ordner existiert nicht: ", dir_path)
  }
  
  files <- list.files(dir_path, pattern = "\\.csv$", full.names = TRUE)
  if (length(files) == 0) {
    stop("Keine .csv-Dateien in: ", dir_path)
  }
  
  cat("Lese ", length(files), " Dateien aus: ", dir_path, "\n")
  
  all_long <- lapply(files, function(f) {
    df <- tryCatch(
      read_csv(f, show_col_types = FALSE),
      error = function(e) read_csv2(f, show_col_types = FALSE)
    )
    
    if (!"sample_id" %in% names(df)) {
      df$sample_id <- file_path_sans_ext(basename(f))
    }
    
    need <- c("sample_id", "cpg_id", "combined_beta")
    if (!all(need %in% names(df))) {
      stop("In Datei ", f, " fehlen Spalten: ",
           paste(setdiff(need, names(df)), collapse = ", "))
    }
    
    df %>%
      select(sample_id, cpg_id, combined_beta)
  }) %>%
    bind_rows()
  
  return(all_long)
}

##  Horvath
cat("\n=== Horvath (linearer Score) ===\n")
hor_long <- read_clock_long(horvath_with_cpgid_dir)

coefHorvath <- get_coefHorvath()
hor_intercept <- coefHorvath$CoefficientTraining[coefHorvath$CpGmarker == "(Intercept)"]

hor_coef <- coefHorvath %>%
  filter(CpGmarker != "(Intercept)") %>%
  transmute(
    cpg_id     = CpGmarker,
    coef_train = CoefficientTraining
  )

hor_long2 <- hor_long %>%
  inner_join(hor_coef, by = "cpg_id")

n_required <- nrow(hor_coef)
n_used     <- length(unique(hor_long2$cpg_id))
cat("  Erwartete Horvath-CpGs: ", n_required, "\n")
cat("  In deinen Daten vorhandene Horvath-CpGs: ", n_used, "\n")

hor_age_raw <- hor_long2 %>%
  mutate(beta = as.numeric(combined_beta)) %>%
  group_by(sample_id) %>%
  summarise(
    n_cpg_used               = n_distinct(cpg_id),
    DNAmAge_HorvathS2013_raw = hor_intercept + sum(beta * coef_train, na.rm = TRUE),
    .groups = "drop"
  )

##  Hannum
cat("\n=== Hannum ===\n")
han_long <- read_clock_long(hannum_with_cpgid_dir)

coefHannum <- get_coefHannum()

if ("Intercept" %in% colnames(coefHannum)) {
  han_intercept <- unique(coefHannum$Intercept)[1]
} else {
  han_intercept <- 0
}

han_coef <- coefHannum %>%
  transmute(
    cpg_id     = CpGmarker,
    coef_train = CoefficientTraining
  )

han_long2 <- han_long %>%
  inner_join(han_coef, by = "cpg_id")

n_required_han <- nrow(han_coef)
n_used_han     <- length(unique(han_long2$cpg_id))
cat("  Erwartete Hannum-CpGs: ", n_required_han, "\n")
cat("  In deinen Daten vorhandene Hannum-CpGs: ", n_used_han, "\n")

han_age <- han_long2 %>%
  mutate(beta = as.numeric(combined_beta)) %>%
  group_by(sample_id) %>%
  summarise(
    n_cpg_used               = n_distinct(cpg_id),
    DNAmAge_HannumG2013_raw  = han_intercept + sum(beta * coef_train, na.rm = TRUE),
    .groups = "drop"
  )

hor_age <- hor_age_raw %>%
  select(
    sample_id,
    n_cpg_horvath            = n_cpg_used,
    DNAmAge_HorvathS2013_raw = DNAmAge_HorvathS2013_raw
  )

han_age <- han_age %>%
  select(
    sample_id,
    n_cpg_hannum             = n_cpg_used,
    DNAmAge_HannumG2013_raw  = DNAmAge_HannumG2013_raw
  )

age_df <- full_join(hor_age, han_age, by = "sample_id")

# Horvath-antiTrafo (Originalformel, adult.age = 20)
adult_age <- 20

age_df <- age_df %>%
  mutate(
    DNAmAge_HorvathS2013_antiTrafo = ifelse(
      DNAmAge_HorvathS2013_raw < 0,
      (1 + adult_age) * exp(DNAmAge_HorvathS2013_raw) - 1,
      (1 + adult_age) * DNAmAge_HorvathS2013_raw + adult_age
    )
  )

write_csv(age_df, out_csv)
cat("\n Fertig. Ergebnisse in:\n  ", out_csv, "\n")
