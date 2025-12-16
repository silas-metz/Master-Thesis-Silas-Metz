# Weidner-DNAmAge für alle Samples berechnen

suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(stringr)
  library(tidyr)
})

input_dir <- "/home/drk/Masterarbeit/CASIN/Output_CG_Kontext/Hac/20250729/00_Results/Filtered_by_Weidner/noH/combined_strands/with_hg19_cpgid"

file_pattern <- "_with_hg19_cpgid\\.csv$"

out_csv <- file.path(input_dir, "weidner_age_results.csv")

weidner_map <- tibble::tibble(
  cpg_id = c("cg02228185", "cg25809905", "cg17861230"),
  gene   = c("ASPA",       "ITGA2B",     "PDE4C")
)

# Weidner-Formel
weidner_age_fun <- function(beta_ASPA, beta_ITGA2B, beta_PDE4C) {
  38.0 - 26.4 * beta_ASPA - 23.7 * beta_ITGA2B + 164.7 * beta_PDE4C
}


if (!dir.exists(input_dir)) {
  stop("Input_dir existiert nicht: ", input_dir)
}

files <- list.files(input_dir, pattern = file_pattern, full.names = TRUE)
if (length(files) == 0) {
  stop("Keine passenden Dateien in: ", input_dir)
}

cat("Gefundene Weidner-Dateien:", length(files), "\n\n")


res_list <- list()

for (f in files) {
  base <- basename(f)
  cat("Verarbeite:", base, "... ")
  
  df <- tryCatch(
    read_csv(f, show_col_types = FALSE),
    error = function(e) read_csv2(f, show_col_types = FALSE)
  )
  
  if ("sample_id" %in% names(df)) {
    sample_id <- unique(df$sample_id)[1]
  } else {
    sample_id <- tools::file_path_sans_ext(base)
  }
  
  if (!all(c("cpg_id") %in% names(df))) {
    cat("'cpg_id' fehlt, übersprungen.\n")
    next
  }
  
  if ("combined_beta" %in% names(df)) {
    df$beta <- as.numeric(df$combined_beta)
  } else if ("percent_modified" %in% names(df)) {
    df$beta <- as.numeric(df$percent_modified) / 100
  } else {
    cat("Weder 'combined_beta' noch 'percent_modified' gefunden.\n")
    next
  }
  
  df_beta <- df %>%
    inner_join(weidner_map, by = "cpg_id") %>%
    select(gene, beta)
  
  if (nrow(df_beta) == 0) {
    cat("Keine Weidner-CpGs gefunden.\n")
    next
  }
  
  df_beta_wide <- df_beta %>%
    group_by(gene) %>%
    summarise(beta = mean(beta, na.rm = TRUE), .groups = "drop") %>%
    tidyr::pivot_wider(names_from = gene, values_from = beta)
  
  for (g in c("ASPA","ITGA2B","PDE4C")) {
    if (!(g %in% names(df_beta_wide))) df_beta_wide[[g]] <- NA_real_
  }
  
  beta_ASPA   <- df_beta_wide$ASPA
  beta_ITGA2B <- df_beta_wide$ITGA2B
  beta_PDE4C  <- df_beta_wide$PDE4C
  
  age_weidner <- weidner_age_fun(beta_ASPA, beta_ITGA2B, beta_PDE4C)
  
  res_list[[sample_id]] <- tibble::tibble(
    sample_id       = sample_id,
    beta_ASPA       = as.numeric(beta_ASPA),
    beta_ITGA2B     = as.numeric(beta_ITGA2B),
    beta_PDE4C      = as.numeric(beta_PDE4C),
    DNAmAge_Weidner = as.numeric(age_weidner)
  )
  
  cat("OK\n")
}

if (length(res_list) == 0) {
  stop("Keine verwertbaren Weidner-Daten gefunden.")
}

weidner_results <- dplyr::bind_rows(res_list)

write_csv(weidner_results, out_csv)

cat("\n Fertig. Weidner-DNAmAge für alle Samples in:\n  ", out_csv, "\n")
