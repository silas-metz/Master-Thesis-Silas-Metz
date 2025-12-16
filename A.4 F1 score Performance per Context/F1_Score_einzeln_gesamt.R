suppressPackageStartupMessages({
  library(optparse)
  library(readr)
  library(dplyr)
  library(tidyr)
  library(stringr)
  library(tools)
  library(purrr)
})

#   - Outputs pro Barcode:
#       Einzel-Ergebnis (--output)
#       <barcode>_F1_summary.csv
#       <barcode>_F1_positions.csv

option_list <- list(
  make_option("--input",       type="character", help="Pfad zur CSV (bedMethyl-ähnlich; 18 Spalten)"),
  make_option("--output",      type="character", help="Pfad zur Ergebnis-CSV (eine Zeile)"),
  make_option("--gt",          type="double",    help="Ground Truth (%)"),
  make_option("--fth",         type="character", default=NA, help="Filter-threshold C (nur zur Doku)"),
  make_option("--mth",         type="character", default=NA, help="Mod-threshold m/h (nur zur Doku)"),
  make_option("--results_dir", type="character", default=NULL, help="Basis-Output-Ordner für Sammeldateien")
)
opt <- parse_args(OptionParser(option_list = option_list))
if (is.null(opt$input) || is.null(opt$output) || is.null(opt$gt))
  stop("Bitte --input, --output und --gt angeben.", call. = FALSE)

input_file  <- opt$input
output_file <- opt$output
gt_percent  <- as.numeric(opt$gt)

parse_num_opt <- function(x){
  if (is.null(x) || is.na(x)) return(NA_real_)
  x <- trimws(tolower(as.character(x)))
  if (x=="" || x=="na") return(NA_real_)
  as.numeric(x)
}
fth <- parse_num_opt(opt$fth)
mth <- parse_num_opt(opt$mth)

results_dir <- opt$results_dir
if (is.null(results_dir) || is.na(results_dir) || nchar(results_dir)==0)
  results_dir <- dirname(dirname(input_file))
dir.create(results_dir, recursive=TRUE, showWarnings=FALSE)

barcode_name <- basename(dirname(input_file))
run_file     <- basename(input_file)  

cat("Eingabe:", input_file, "\n")
cat("Ausgabe:", output_file, "\n")
cat("Results-Ordner:", results_dir, "\n")
cat("Barcode:", barcode_name, "\n")
cat("GT (%):", gt_percent, "\n")
if (!is.na(fth)) cat("filter-threshold:", fth, "\n")
if (!is.na(mth)) cat("mod-threshold:", mth, "\n")

read_auto <- function(path){
  first <- readLines(path, n = 1)
  hdr <- grepl("chrom", first, ignore.case = TRUE) && grepl("start", first, ignore.case = TRUE)
  if (grepl("\t", first)) {
    read_tsv(path, col_names = hdr, show_col_types = FALSE, comment = "#")
  } else if (grepl(";", first)) {
    read_csv2(path, col_names = hdr, show_col_types = FALSE, comment = "#")
  } else {
    read_csv(path, col_names = hdr, show_col_types = FALSE, comment = "#",
             locale = locale(decimal_mark = ".", grouping_mark = ","))
  }
}

df <- suppressWarnings(read_auto(input_file))
if (nrow(df) == 0) stop("Eingabedatei hat keine Zeilen.", call. = FALSE)
if (ncol(df) < 18) stop("Es werden 18 Spalten erwartet, gefunden: ", ncol(df), call. = FALSE)

expected <- c("chrom","start","end","modcode","score","strand",
              "X7","X8","X9","validcov","percent_modified","nmod",
              "canonical","othermod","delete","fail","diff","nocall")
if (!all(tolower(names(df)[1:18]) == expected)) names(df)[1:18] <- expected

# Filter
df <- df %>% filter(modcode == "m")
if (nrow(df) == 0) stop("Keine m-Methylierungen vorhanden.", call. = FALSE)

to_num <- function(x) suppressWarnings(as.numeric(x))
df2 <- df %>% transmute(
  chr              = as.character(chrom),
  start            = to_num(start),
  end              = to_num(end),
  strand           = as.character(strand),
  score            = to_num(score),
  validcov         = to_num(validcov),
  percent_modified = to_num(percent_modified),
  nmod             = to_num(nmod),
  canonical        = to_num(canonical)
)

# Bedingung: validcov >= 500 ODER score >= 500
df2 <- df2 %>% filter(is.finite(start), is.finite(validcov), is.finite(score),
                      (validcov >= 500) | (score >= 500))
if (nrow(df2) == 0) stop("Nach Filter (validcov>=500 ODER score>=500) keine Zeilen übrig.", call. = FALSE)

cat("Kandidaten nach Filter:", nrow(df2), "Zeilen\n")

df2 <- df2 %>%
  group_by(chr, start, strand) %>%
  arrange(desc(validcov), desc(score), .by_group = TRUE) %>%
  slice(1) %>%
  ungroup()

cat("Nach Dedupe (chr,start,strand unique):", nrow(df2), "Zeilen\n")

pm_from_counts <- 100 * df2$nmod / df2$validcov
cat("ℹ️ Median(|percent_modified_counts - percent_modified_col|) = ",
    round(median(abs(pm_from_counts - df2$percent_modified), na.rm = TRUE), 3), "%\n", sep = "")

#F1-Berechnung
f1_from_counts <- function(nmod, ncan, nvalid, gt_percent) {
  GTf <- gt_percent / 100
  TP <- pmin(nmod,        GTf * nvalid)
  FP <- pmax(0, nmod    - GTf * nvalid)
  TN <- pmin(ncan,      (1 - GTf) * nvalid)
  FN <- pmax(0, (GTf * nvalid) - nmod)
  
  Prec_m <- ifelse((TP + FP) > 0, TP / (TP + FP), 0)
  Rec_m  <- ifelse((TP + FN) > 0, TP / (TP + FN), 0)
  F1_m   <- ifelse((Prec_m + Rec_m) > 0, 2 * Prec_m * Rec_m / (Prec_m + Rec_m), 0)
  
  TP_c <- TN; FP_c <- FN; FN_c <- FP
  Prec_c <- ifelse((TP_c + FP_c) > 0, TP_c / (TP_c + FP_c), 0)
  Rec_c  <- ifelse((TP_c + FN_c) > 0, TP_c / (TP_c + FN_c), 0)
  F1_c   <- ifelse((Prec_c + Rec_c) > 0, 2 * Prec_c * Rec_c / (Prec_c + Rec_c), 0)
  
  w_m <- GTf; w_c <- 1 - GTf
  tibble(F1_m = F1_m, F1_c = F1_c, F1_combined = w_m * F1_m + w_c * F1_c)
}

by_pos <- df2 %>%
  select(chr, start, strand, validcov, nmod, canonical, percent_modified)

pos_scores <- by_pos %>%
  bind_cols(f1_from_counts(.$nmod, .$canonical, .$validcov, gt_percent)) %>%
  mutate(
    gt_percent = gt_percent,
    filter_thresh = fth,
    mod_thresh = mth
  )

cat("Positionen:", nrow(pos_scores), "\n")

weight <- by_pos$validcov
tot_w  <- sum(weight, na.rm = TRUE)
weighted_f1   <- if (tot_w > 0) weighted.mean(pos_scores$F1_combined, w = weight, na.rm = TRUE) else NA_real_
weighted_f1_m <- if (tot_w > 0) weighted.mean(pos_scores$F1_m,        w = weight, na.rm = TRUE) else NA_real_
weighted_f1_c <- if (tot_w > 0) weighted.mean(pos_scores$F1_c,        w = weight, na.rm = TRUE) else NA_real_

res <- tibble(
  file            = run_file,
  barcode         = barcode_name,
  gt_percent      = gt_percent,
  filter_thresh   = fth,
  mod_thresh      = mth,
  weighted_f1     = weighted_f1,
  weighted_f1_m   = weighted_f1_m,
  weighted_f1_c   = weighted_f1_c,
  total_weight    = tot_w,
  note            = NA_character_
)

dir.create(dirname(output_file), recursive = TRUE, showWarnings = FALSE)
write_csv(res, output_file)
cat("Done (Einzel). Weighted F1 =", round(weighted_f1, 4), " (N=", tot_w, ")\n", sep = "")
cat("Einzel-Ergebnis geschrieben → ", output_file, "\n", sep = "")

sum_csv <- file.path(results_dir, paste0(barcode_name, "_F1_summary.csv"))

if (file.exists(sum_csv)) {
  old <- suppressWarnings(read_csv(sum_csv, show_col_types = FALSE))
  if (!"note" %in% names(old)) old$note <- NA_character_
  old_clean <- old %>%
    filter(!(file == run_file & barcode == barcode_name)) %>%
    filter(is.na(note) | note != "SUMMARY")
} else {
  old_clean <- tibble()
}

all_runs <- bind_rows(old_clean, res)
vals <- all_runs$weighted_f1; vals[is.na(vals)] <- -Inf
best <- all_runs[which.max(vals),]

summary_row <- tibble(
  file            = "SUMMARY",
  barcode         = barcode_name,
  gt_percent      = best$gt_percent,
  filter_thresh   = best$filter_thresh,
  mod_thresh      = best$mod_thresh,
  weighted_f1     = best$weighted_f1,
  weighted_f1_m   = best$weighted_f1_m,
  weighted_f1_c   = best$weighted_f1_c,
  total_weight    = NA_real_,
  note            = "SUMMARY"
)
final_tbl <- bind_rows(all_runs, summary_row)
write_csv(final_tbl, sum_csv)
cat(basename(sum_csv), " aktualisiert (best Setup → F1 = ", round(best$weighted_f1, 4), ")\n", sep = "")

pos_csv <- file.path(results_dir, paste0(barcode_name, "_F1_positions.csv"))

current_pos <- pos_scores %>%
  mutate(file = run_file, barcode = barcode_name) %>%
  select(chr, start, strand, validcov, nmod, canonical, percent_modified,
         F1_m, F1_c, F1_combined, gt_percent, filter_thresh, mod_thresh,
         file, barcode) %>%
  arrange(chr, start, strand)

write_csv(current_pos, pos_csv)
cat("📍 Positions-Tabelle geschrieben →", basename(pos_csv), "\n")
