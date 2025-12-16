#  Horvath- & Hannum-Clock: CpG-Positionen (hg19 & hg38)


suppressPackageStartupMessages({
  if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  
  # 450k-Annotation (hg19) + Liftover
  BiocManager::install("IlluminaHumanMethylation450kanno.ilmn12.hg19",
                       ask = FALSE, update = FALSE)
  BiocManager::install("methylclockData",
                       ask = FALSE, update = FALSE)
  
  library(IlluminaHumanMethylation450kanno.ilmn12.hg19)
  library(methylclockData)
  library(rtracklayer)
  library(GenomicRanges)
  library(dplyr)
  library(readr)
})


horvath_cpgs_csv <- "/home/drk/Masterarbeit/R_Scripte/Clocks/Horvath_CpGs.csv"
hannum_cpgs_csv  <- "/home/drk/Masterarbeit/R_Scripte/Clocks/Hannum_CpGs.csv"

# Chainfile hg19 -> hg38
chain_file <- "/home/drk/Masterarbeit/R_Scripte/hg38_to_hg19_Ref/hg19ToHg38.over.chain"

out_horvath <- "/home/drk/Masterarbeit/R_Scripte/Clocks/HorvathClock_hg19_hg38.csv"
out_hannum  <- "/home/drk/Masterarbeit/R_Scripte/Clocks/HannumClock_hg19_hg38.csv"

window_bp <- 1L

ann450k <- getAnnotation(IlluminaHumanMethylation450kanno.ilmn12.hg19)

build_mapping <- function(cpg_csv, out_csv, clock_name) {
  cat("=== ", clock_name, " ===\n", sep = "")
  
  if (!file.exists(cpg_csv)) stop("CpG-Datei fehlt: ", cpg_csv)
  cpg_df <- read_csv(cpg_csv, show_col_types = FALSE)
  if (!"cpg_id" %in% names(cpg_df))
    stop("In ", cpg_csv, " fehlt Spalte 'cpg_id'.")
  
  cpg_ids <- unique(cpg_df$cpg_id)
  
  in_annot <- intersect(cpg_ids, rownames(ann450k))
  missing  <- setdiff(cpg_ids, rownames(ann450k))
  
  cat("  Gefundene CpGs in 450k-Annotation: ", length(in_annot), "\n")
  if (length(missing) > 0) {
    print(missing)
  }
  
  sub_ann <- as.data.frame(ann450k[in_annot, ]) %>%
    transmute(
      cpg_id     = rownames(.),
      chrom_hg19 = as.character(chr),
      pos_hg19   = as.integer(pos)
    )
  
  if (length(missing) > 0) {
    sub_missing <- tibble::tibble(
      cpg_id     = missing,
      chrom_hg19 = NA_character_,
      pos_hg19   = NA_integer_
    )
    sub_ann <- bind_rows(sub_ann, sub_missing)
  }
  

  # LiftOver hg19 -> hg38
  if (!file.exists(chain_file))
    stop("Chainfile nicht gefunden: ", chain_file)
  
  ch <- import.chain(chain_file)
  
  ok_idx <- which(!is.na(sub_ann$chrom_hg19) & !is.na(sub_ann$pos_hg19))
  
  gr19 <- GRanges(
    seqnames = sub_ann$chrom_hg19[ok_idx],
    ranges   = IRanges(start = sub_ann$pos_hg19[ok_idx],
                       end   = sub_ann$pos_hg19[ok_idx]),
    cpg_id   = sub_ann$cpg_id[ok_idx]
  )
  
  lifted <- liftOver(gr19, ch)
  
  chrom_hg38 <- rep(NA_character_, nrow(sub_ann))
  pos_hg38   <- rep(NA_integer_,   nrow(sub_ann))
  
  for (i in seq_along(lifted)) {
    hits <- lifted[[i]]
    if (length(hits) == 0) next
    row_idx <- which(sub_ann$cpg_id == mcols(gr19)$cpg_id[i])
    chrom_hg38[row_idx] <- as.character(seqnames(hits)[1])
    pos_hg38[row_idx]   <- start(hits)[1]
  }
  
  sub_ann$chrom_hg38 <- chrom_hg38
  sub_ann$pos_hg38   <- pos_hg38
  sub_ann$start_hg38 <- ifelse(is.na(pos_hg38), NA_integer_,
                               pos_hg38 - window_bp)
  sub_ann$end_hg38   <- ifelse(is.na(pos_hg38), NA_integer_,
                               pos_hg38 + window_bp)
  
  sub_ann <- sub_ann %>% arrange(cpg_id)
  
  write_csv(sub_ann, out_csv)
  cat("Mapping geschrieben nach: ", out_csv, "\n\n")
  
  invisible(sub_ann)
}

map_horvath <- build_mapping(horvath_cpgs_csv, out_horvath, "Horvath")
map_hannum  <- build_mapping(hannum_cpgs_csv,  out_hannum,  "Hannum")

cat("Fertig.\n")
