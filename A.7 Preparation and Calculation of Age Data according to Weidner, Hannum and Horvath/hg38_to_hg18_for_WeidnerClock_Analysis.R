#  Weidner-Clock (3 CpGs) annotieren:


suppressPackageStartupMessages({
  if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  
  if (!requireNamespace("minfi", quietly = TRUE))
    BiocManager::install("minfi", ask = FALSE, update = FALSE)
  if (!requireNamespace("IlluminaHumanMethylation27kanno.ilmn12.hg19", quietly = TRUE))
    BiocManager::install("IlluminaHumanMethylation27kanno.ilmn12.hg19", ask = FALSE, update = FALSE)
  if (!requireNamespace("rtracklayer", quietly = TRUE))
    BiocManager::install("rtracklayer", ask = FALSE, update = FALSE)
  
  library(minfi)
  library(IlluminaHumanMethylation27kanno.ilmn12.hg19)
  library(rtracklayer)
  library(GenomicRanges)
  library(dplyr)
  library(readr)
  library(stringr)
  library(tools)
})

input_dir    <- "/home/drk/Masterarbeit/CASIN/Output_CG_Kontext/Hac/20250729/00_Results/Filtered_by_Weidner/noH/combined_strands"

file_pattern <- "\\.csv$"

# Chainfile für LiftOver hg38 -> hg19
chain_file   <- "/home/drk/Masterarbeit/R_Scripte/hg38_to_hg19_Ref/hg38ToHg19.over.chain"

output_dir   <- file.path(input_dir, "with_hg19_cpgid")
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)


weidner_ids <- c("cg02228185", "cg25809905", "cg17861230")

ann27 <- getAnnotation(IlluminaHumanMethylation27kanno.ilmn12.hg19)

weidner_ann <- ann27[weidner_ids, ] %>%
  as.data.frame() %>%
  transmute(
    cpg_id   = rownames(.),
    chrom    = as.character(chr),
    pos_hg19 = as.integer(pos)
  )

print(weidner_ann)

if (!file.exists(chain_file)) {
  stop("Chainfile nicht gefunden: ", chain_file,
       "\nBitte Pfad oben in 'chain_file' anpassen.")
}
ch <- import.chain(chain_file)


if (!dir.exists(input_dir)) {
  stop("Input_dir existiert nicht: ", input_dir)
}

in_files <- list.files(input_dir, pattern = file_pattern, full.names = TRUE)
if (length(in_files) == 0) {
  stop("Keine passenden Dateien in input_dir gefunden: ", input_dir)
}

cat("Gefundene Dateien:", length(in_files), "\n\n")

annotate_one_file <- function(f) {
  base <- basename(f)
  sample_id <- file_path_sans_ext(base)
  cat("▶️  Verarbeite:", base, "... ")
  
  df <- tryCatch(
    read_csv(f, show_col_types = FALSE),
    error = function(e) read_csv2(f, show_col_types = FALSE)
  )
  
  if (!all(c("chrom","start","end") %in% names(df))) {
    cat("Spalten 'chrom','start','end' fehlen, übersprungen.\n")
    return(NULL)
  }
  
  gr38 <- GRanges(
    seqnames = df$chrom,
    ranges   = IRanges(start = as.integer(df$start),
                       end   = as.integer(df$end))
  )
  
  # LiftOver
  lifted <- liftOver(gr38, ch)
  
  chrom_hg19_lift <- character(length(gr38))
  start_hg19_lift <- integer(length(gr38))
  end_hg19_lift   <- integer(length(gr38))
  
  chrom_hg19_lift[] <- NA_character_
  start_hg19_lift[] <- NA_integer_
  end_hg19_lift[]   <- NA_integer_
  
  for (i in seq_along(gr38)) {
    hits <- lifted[[i]]
    if (length(hits) == 0) next
    chrom_hg19_lift[i] <- as.character(seqnames(hits)[1])
    start_hg19_lift[i] <- start(hits)[1]
    end_hg19_lift[i]   <- end(hits)[1]
  }
  
  df$chrom_hg19_lift <- chrom_hg19_lift
  df$start_hg19_lift <- start_hg19_lift
  df$end_hg19_lift   <- end_hg19_lift
  
  df$cpg_id    <- NA_character_
  df$chrom_hg19 <- NA_character_
  df$pos_hg19   <- NA_integer_
  df$start_hg19 <- NA_integer_
  df$end_hg19   <- NA_integer_
  
  for (i in seq_len(nrow(df))) {
    chr_lift <- df$chrom_hg19_lift[i]
    pos_lift <- df$start_hg19_lift[i]
    
    if (is.na(chr_lift) || is.na(pos_lift)) next
    
    cand <- weidner_ann[weidner_ann$chrom == chr_lift, ]
    if (nrow(cand) == 0) next
    
    j <- which.min(abs(cand$pos_hg19 - pos_lift))
    
    df$cpg_id[i]     <- cand$cpg_id[j]
    df$chrom_hg19[i] <- cand$chrom[j]
    df$pos_hg19[i]   <- cand$pos_hg19[j]
    df$start_hg19[i] <- cand$pos_hg19[j] - 1L
    df$end_hg19[i]   <- cand$pos_hg19[j] + 1L
  }
  
  out_file <- file.path(output_dir, paste0(sample_id, "_with_hg19_cpgid.csv"))
  write_csv(df, out_file)
  
  cat("OK →", out_file, "\n")
  return(df)
}

res_list <- lapply(in_files, annotate_one_file)

cat("\n Fertig. Annotierte Dateien (hg38 + hg19 + cpg_id) liegen in:\n  ",
    output_dir, "\n")
