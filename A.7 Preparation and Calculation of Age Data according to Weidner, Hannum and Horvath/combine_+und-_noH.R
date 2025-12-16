suppressPackageStartupMessages({
  library(readr)
  library(dplyr)
  library(stringr)
  library(tools)
})

# Input
input_dir    <- "/home/drk/Masterarbeit/CASIN/Output_CG_Kontext/Hac/20250729/00_Results/Filtered_by_Weidner/noH"
file_pattern <- "_filtered_noH\\.csv$"
output_dir   <- file.path(input_dir, "combined_strands")
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

max_distance <- 2

if (!dir.exists(input_dir)) {
  stop("Input_dir existiert nicht: ", input_dir)
}

csv_files <- list.files(input_dir, pattern = file_pattern, full.names = TRUE)
if (length(csv_files) == 0) {
  stop("Keine passenden CSV-Dateien im Ordner gefunden: ", input_dir)
}

cat("Gefundene CSV-Dateien:", length(csv_files), "\n\n")

combine_strands_one_file <- function(file, max_distance = 20) {
  base_name <- basename(file)
  sample_id <- file_path_sans_ext(base_name)
  
  cat("Verarbeite:", base_name, "... ")
  
  df <- read_csv(file, show_col_types = FALSE)
  
  needed <- c(
    "chrom","start","end","modcode","score","strand",
    "X7","X8","X9","validcov","percent_modified",
    "nmod","canonical","othermod","delete","fail","diff","nocall"
  )
  if (!all(needed %in% names(df))) {
    cat("Nicht alle erwarteten bedMethyl-Spalten vorhanden, übersprungen.\n")
    return(NULL)
  }
  
  if ("modcode" %in% names(df)) {
    df <- df %>% filter(!(modcode %in% c("h","H")))
  }
  
  df <- df %>%
    mutate(
      chrom            = as.character(chrom),
      start            = as.integer(start),
      end              = as.integer(end),
      strand           = as.character(strand),
      validcov         = as.numeric(validcov),
      percent_modified = as.numeric(percent_modified),
      nmod             = as.numeric(nmod),
      canonical        = as.numeric(canonical),
      othermod         = as.numeric(othermod),
      delete           = as.numeric(delete),
      fail             = as.numeric(fail),
      diff             = as.numeric(diff),
      nocall           = as.numeric(nocall)
    )
  
  plus  <- df %>% filter(strand == "+") %>% mutate(id_plus  = row_number())
  minus <- df %>% filter(strand == "-") %>% mutate(id_minus = row_number())
  
  if (nrow(plus) == 0 | nrow(minus) == 0) {
    cat("Nur ein Strang vorhanden, keine Kombination.\n")
    
    out_df <- df %>%
      mutate(
        sample_id         = sample_id,
        combined_validcov = validcov,
        combined_beta     = nmod / validcov,
        score             = validcov        # <<< score = validcov
      ) %>%
      select(
        sample_id,
        chrom,start,end,modcode,score,strand,
        X7,X8,X9,validcov,percent_modified,
        nmod,canonical,othermod,delete,fail,diff,nocall,
        combined_validcov,combined_beta
      )
    
    out_file <- file.path(output_dir,
                          paste0(sample_id, "_combinedStrands.csv"))
    write_csv(out_df, out_file)
    cat("OK →", out_file, "\n")
    return(out_df)
  }
  
  cand <- plus %>%
    inner_join(minus, by = "chrom", suffix = c("_plus","_minus")) %>%
    mutate(delta = abs(start_plus - start_minus)) %>%
    filter(delta <= max_distance)
  
  if (nrow(cand) == 0) {
    cat("Keine passenden +/−-Paare gefunden, schreibe Originalwerte.\n")
    
    out_df <- df %>%
      mutate(
        sample_id         = sample_id,
        combined_validcov = validcov,
        combined_beta     = nmod / validcov,
        score             = validcov        # <<< score = validcov
      ) %>%
      select(
        sample_id,
        chrom,start,end,modcode,score,strand,
        X7,X8,X9,validcov,percent_modified,
        nmod,canonical,othermod,delete,fail,diff,nocall,
        combined_validcov,combined_beta
      )
    
    out_file <- file.path(output_dir,
                          paste0(sample_id, "_combinedStrands.csv"))
    write_csv(out_df, out_file)
    cat("OK →", out_file, "\n")
    return(out_df)
  }
  
  cand <- cand %>%
    group_by(id_plus) %>%
    slice_min(delta, n = 1, with_ties = FALSE) %>%
    ungroup() %>%
    group_by(id_minus) %>%
    slice_min(delta, n = 1, with_ties = FALSE) %>%
    ungroup()
  
  paired_plus_ids  <- cand$id_plus
  paired_minus_ids <- cand$id_minus
  
  combined_pairs <- cand %>%
    mutate(
      start_comb   = pmin(start_plus, start_minus),
      end_comb     = pmax(end_plus,   end_minus),
      
      cov_comb        = validcov_plus + validcov_minus,
      nmod_comb       = nmod_plus     + nmod_minus,
      canonical_comb  = canonical_plus  + canonical_minus,
      othermod_comb   = othermod_plus   + othermod_minus,
      delete_comb     = delete_plus     + delete_minus,
      fail_comb       = fail_plus       + fail_minus,
      diff_comb       = diff_plus       + diff_minus,
      nocall_comb     = nocall_plus     + nocall_minus,
      
      beta_comb    = nmod_comb / cov_comb,
      perc_comb    = beta_comb * 100
    ) %>%
    transmute(
      sample_id    = sample_id,
      chrom        = chrom,
      start        = start_comb,
      end          = end_comb,
      modcode      = modcode_plus,
      score        = cov_comb,          
      strand       = "both",
      X7           = X7_plus,
      X8           = X8_plus,
      X9           = X9_plus,
      validcov     = cov_comb,
      percent_modified = perc_comb,
      nmod         = nmod_comb,
      canonical    = canonical_comb,
      othermod     = othermod_comb,
      delete       = delete_comb,
      fail         = fail_comb,
      diff         = diff_comb,
      nocall       = nocall_comb,
      combined_validcov = cov_comb,
      combined_beta     = beta_comb
    )
  
  # ungepaarte + / - übernehmen, score = validcov
  unpaired_plus <- plus %>%
    filter(!(id_plus %in% paired_plus_ids)) %>%
    mutate(
      sample_id         = sample_id,
      combined_validcov = validcov,
      combined_beta     = nmod / validcov,
      score             = validcov
    ) %>%
    select(
      sample_id,
      chrom,start,end,modcode,score,strand,
      X7,X8,X9,validcov,percent_modified,
      nmod,canonical,othermod,delete,fail,diff,nocall,
      combined_validcov,combined_beta
    )
  
  unpaired_minus <- minus %>%
    filter(!(id_minus %in% paired_minus_ids)) %>%
    mutate(
      sample_id         = sample_id,
      combined_validcov = validcov,
      combined_beta     = nmod / validcov,
      score             = validcov
    ) %>%
    select(
      sample_id,
      chrom,start,end,modcode,score,strand,
      X7,X8,X9,validcov,percent_modified,
      nmod,canonical,othermod,delete,fail,diff,nocall,
      combined_validcov,combined_beta
    )
  
  out_df <- bind_rows(combined_pairs, unpaired_plus, unpaired_minus) %>%
    arrange(chrom, start, end)
  
  out_file <- file.path(output_dir,
                        paste0(sample_id, "_combinedStrands.csv"))
  write_csv(out_df, out_file)
  
  cat("OK →", out_file, "\n")
  return(out_df)
}

all_results <- lapply(csv_files, combine_strands_one_file,
                      max_distance = max_distance)

cat("\n Fertig. Kombinierte Dateien in:\n  ", output_dir, "\n")
