suppressPackageStartupMessages({
  library(readr); library(data.table); library(dplyr); library(stringr)
  library(tidyr); library(purrr); library(glue); library(pheatmap); library(tibble)
})

inputs <- tribble(
  ~PCR,   ~Version, ~dir,
  "PCR1", "1.0.2",  "/path/to/input/PCR_Daten/PCR1_5er/CG/Sup/04_F1_Scores/00_Results",
  "PCR1", "1.1.1",  "/path/to/input/PCR_Daten_dorado1.1.1/PCR1_5er/CG/Sup/04_F1_Scores/00_Results",
  "PCR2", "1.0.2",  "/path/to/input/PCR_Daten/PCR2/CG/Sup/04_F1_Scores/00_Results",
  "PCR2", "1.1.1",  "/path/to/input/PCR_Daten_dorado1.1.1/PCR2/CG/Sup/04_F1_Scores/00_Results",
  "PCR3", "1.0.2",  "/path/to/input/PCR_Daten/PCR3/CG/Sup/04_F1_Scores/00_Results",
  "PCR3", "1.1.1",  "/path/to/input/PCR_Daten_dorado1.1.1/PCR3/CG/Sup/04_F1_Scores/00_Results"
)

output_dir      <- "/path/to/output/Heatmaps/CG/Sup"
metrics_to_plot <- c("F1_combined", "F1_m", "F1_c")

do_cluster_rows <- TRUE
do_cluster_cols <- TRUE

# Farbskala
base_break_step <- 0.05
palette_func <- colorRampPalette(c("#440154FF", "#31688EFF", "#35B779FF", "#FDE725FF"))

csv_name <- "filtered_all_F1_positions.csv"

na_fill_for_clustering <- "col_median"    # oder "zero"

cap_mode   <- "min_to_one"
cap_low    <- 0.80
cap_high   <- 0.92
cap_q      <- c(0.05, 0.95)
cap_clip   <- TRUE


read_any_table <- function(path) {
  first <- readLines(path, n = 2, warn = FALSE)
  if (length(first) == 0) stop(glue("Datei ist leer: {path}"))
  header <- first[1]
  counts <- c(tab = str_count(header, "\t"),
              semi = str_count(header, ";"),
              comma = str_count(header, ","))
  delim <- names(which.max(counts))
  df <- switch(delim,
               tab   = suppressWarnings(readr::read_tsv(path, show_col_types = FALSE)),
               semi  = suppressWarnings(readr::read_delim(path, delim = ";", show_col_types = FALSE)),
               comma = suppressWarnings(readr::read_csv(path, show_col_types = FALSE)))
  df <- as.data.frame(df, stringsAsFactors = FALSE)
  colnames(df) <- trimws(colnames(df))
  df
}

to_num <- function(x) {
  y <- trimws(as.character(x))
  y[y == ""] <- NA
  suppressWarnings(as.numeric(gsub(",", ".", y, fixed = FALSE)))
}

standardize_and_annotate <- function(df, file_path, PCR, Version, Barcode) {
  required_cols <- c("chr","start","strand",
                     "validcov","nmod","canonical","percent_modified",
                     "F1_m","F1_c","F1_combined","file","barcode")
  missing <- setdiff(required_cols, names(df))
  if (length(missing) > 0) stop(glue("Pflichtspalten fehlen in {file_path}: {paste(missing, collapse=', ')}"))
  
  df <- df %>%
    mutate(
      chr = as.character(chr),
      start = as.integer(start),
      strand = as.character(strand),
      validcov = to_num(validcov),
      F1_m = to_num(F1_m),
      F1_c = to_num(F1_c),
      F1_combined = to_num(F1_combined),
      PositionID = glue("{chr}:{start}({strand})"),
      PCR = PCR,
      Version = Version,
      Barcode = sprintf("%02d", as.integer(Barcode)),
      SampleID = glue("{PCR}|{Version}|BC{sprintf('%02d', as.integer(Barcode))}")
    ) %>%
    arrange(start, desc(strand == "+"))
  
  for (nm in c("F1_m","F1_c","F1_combined")) {
    if (!is.numeric(df[[nm]])) stop(glue("Spalte {nm} ist nicht numerisch in {file_path}"))
  }
  df
}

list_barcode_dirs_one_level <- function(root_dir) {
  subs <- list.dirs(root_dir, full.names = TRUE, recursive = FALSE)
  bas  <- basename(subs)
  keep_idx <- grepl("(?i)^barcode\\s*0?\\d+$", bas)
  keep <- subs[keep_idx]
  if (length(keep) == 0) return(keep)
  m <- stringr::str_match(basename(keep), "(?i)^barcode\\s*0?(\\d+)$")
  nums <- suppressWarnings(as.integer(m[, 2]))
  keep[order(nums)]
}

impute_for_clustering <- function(mat, how = "col_median") {
  if (!is.numeric(mat)) mode(mat) <- "numeric"
  mat[!is.finite(mat)] <- NA_real_
  if (how == "zero") { mat[is.na(mat)] <- 0; return(mat) }
  col_meds <- apply(mat, 2, function(x) if (all(is.na(x))) NA_real_ else stats::median(x, na.rm = TRUE))
  for (j in seq_len(ncol(mat))) {
    idx <- which(is.na(mat[, j])); if (length(idx) == 0) next
    fill_val <- col_meds[j]; if (is.na(fill_val) || !is.finite(fill_val)) fill_val <- 0
    mat[idx, j] <- fill_val
  }
  mat[is.na(mat)] <- 0
  mat
}

cap_matrix_and_breaks <- function(mat, mode = "none",
                                  abs_low = 0.0, abs_high = 1.0,
                                  q = c(0.05, 0.95),
                                  clip = TRUE,
                                  base_step = 0.05) {
  x <- as.numeric(mat)
  x <- x[is.finite(x)]
  low <- 0; high <- 1
  
  if (length(x) > 0) {
    m <- match.arg(tolower(mode), c("none","absolute","quantile","min_to_one"))
    if (m == "absolute") {
      low <- as.numeric(abs_low); high <- as.numeric(abs_high)
    } else if (m == "quantile") {
      qs <- stats::quantile(x, probs = q, na.rm = TRUE, names = FALSE, type = 7)
      low <- qs[1]; high <- qs[2]
    } else if (m == "min_to_one") {
      low <- min(x, na.rm = TRUE)
      high <- 1.0
      if (!is.finite(low) || low >= 1) low <- 1 - base_step
    } else {
      low <- 0; high <- 1
    }
  }
  if (!is.finite(low) || !is.finite(high) || low >= high) { low <- 0; high <- 1 }
  
  mat_out <- mat
  if (isTRUE(clip)) {
    mat_out[mat_out < low]  <- low
    mat_out[mat_out > high] <- high
  }
  nstep  <- max(2L, ceiling((high - low) / base_step) + 1L)
  breaks <- seq(from = low, to = high, length.out = nstep)
  list(mat = mat_out, breaks = breaks, low = low, high = high)
}


stopifnot(nrow(inputs) == 6)
if (any(!dir.exists(inputs$dir))) {
  missing_dirs <- inputs$dir[!dir.exists(inputs$dir)]
  stop(glue("Diese Eingabe-Ordner existieren nicht:\n{paste(missing_dirs, collapse='\n')}"))
}

dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
missing_log_file <- file.path(output_dir, "missing_csv_log.txt")
if (file.exists(missing_log_file)) file.remove(missing_log_file)

collect_one_dir <- function(PCR, Version, dir) {
  bc_dirs <- list_barcode_dirs_one_level(dir)
  if (length(bc_dirs) == 0) { warning(glue("Keine barcodeXX-Ordner in: {dir}")); return(list()) }
  purrr::map(bc_dirs, function(bd) {
    bc <- stringr::str_match(basename(bd), "(?i)^barcode\\s*0?(\\d+)$")[,2]
    f  <- file.path(bd, csv_name)
    if (!file.exists(f)) {
      write(glue("{Sys.time()}  MISSING CSV: {f}"), file = missing_log_file, append = TRUE)
      return(NULL)
    }
    safe <- purrr::safely(function() {
      df <- read_any_table(f)
      df <- standardize_and_annotate(df, f, PCR = PCR, Version = Version, Barcode = bc)
      df$.__source__ <- f
      df
    })
    res <- safe()
    if (!is.null(res$error)) {
      write(glue("{Sys.time()}  READ ERROR: {f}\n{res$error}"), file = missing_log_file, append = TRUE)
      return(NULL)
    }
    res$result
  }) |> purrr::compact()
}

message("Sammle Daten …")
all_parts <- pmap(inputs, collect_one_dir) |> unlist(recursive = FALSE)
if (length(all_parts) == 0) stop("Keine Daten gefunden.")
all_df <- bind_rows(all_parts)

# Coverage
coverage_tbl <- all_df %>%
  count(PCR, Version, Barcode, name = "n_rows") %>%
  mutate(expected = 14L, ok = n_rows == expected) %>%
  arrange(PCR, Version, as.integer(Barcode))
write.csv(coverage_tbl, file.path(output_dir, "barcode_coverage.csv"), row.names = FALSE)

all_df_clean <- all_df %>%
  select(chr, start, strand, PositionID,
         F1_m, F1_c, F1_combined,
         PCR, Version, Barcode, SampleID) %>%
  distinct()

pos_order <- all_df_clean %>%
  distinct(PositionID, start, strand) %>%
  arrange(start, desc(strand == "+")) %>% pull(PositionID)

expected_samples <- inputs %>%
  tidyr::crossing(Barcode = sprintf("%02d", 1:21)) %>%
  transmute(SampleID = glue("{PCR}|{Version}|BC{Barcode}")) %>% pull(SampleID)

# Heatmap
.diag_acc <- NULL

plot_heatmap_for_metric <- function(metric_name, df, outdir) {
  stopifnot(metric_name %in% c("F1_combined","F1_m","F1_c"))
  
  wide <- df %>%
    select(PositionID, SampleID, all_of(metric_name)) %>%
    distinct() %>%
    pivot_wider(
      names_from  = SampleID,
      values_from = all_of(metric_name),
      values_fill = NA_real_
    ) %>%
    slice(match(pos_order, PositionID))
  
  mat_orig <- wide %>% column_to_rownames("PositionID") %>% as.matrix()
  
  miss <- setdiff(expected_samples, colnames(mat_orig))
  if (length(miss) > 0) {
    add <- matrix(NA_real_, nrow = nrow(mat_orig), ncol = length(miss),
                  dimnames = list(rownames(mat_orig), miss))
    mat_orig <- cbind(mat_orig, add)
  }
  split_info <- tstrsplit(colnames(mat_orig), "\\|")
  ord_base <- order(factor(split_info[[1]], levels = unique(inputs$PCR)),
                    factor(split_info[[2]], levels = unique(inputs$Version)),
                    suppressWarnings(as.integer(sub("^BC", "", split_info[[3]]))))
  mat_orig <- mat_orig[, ord_base, drop = FALSE]
  
  if (!all(vapply(as.data.frame(mat_orig), is.numeric, logical(1)))) {
    stop(glue("Nicht-numerische Werte in Matrix für {metric_name}. Prüfe CSV/Preview."))
  }
  storage.mode(mat_orig) <- "double"
  
  diag <- data.frame(SampleID = colnames(mat_orig),
                     n = colSums(!is.na(mat_orig)),
                     n_na = colSums(is.na(mat_orig)),
                     min = apply(mat_orig, 2, function(x) if (all(is.na(x))) NA_real_ else min(x, na.rm = TRUE)),
                     max = apply(mat_orig, 2, function(x) if (all(is.na(x))) NA_real_ else max(x, na.rm = TRUE)),
                     metric = metric_name, stringsAsFactors = FALSE)
  .diag_acc <<- rbind(.diag_acc, diag)
  
  mat_plot <- mat_orig
  
  samples <- colnames(mat_plot)
  annot <- tibble(SampleID = samples) %>%
    tidyr::separate(SampleID, into = c("PCR","Version","BC"), sep = "\\|",
                    remove = FALSE, extra = "merge", fill = "right") %>%
    mutate(
      Barcode = sub("^BC", "", BC),
      PCR     = factor(PCR,     levels = unique(inputs$PCR)),
      Version = factor(Version, levels = unique(inputs$Version)),
      Barcode = factor(Barcode, levels = sprintf("%02d", 1:21))
    ) %>% select(-BC) %>% as.data.frame()
  rownames(annot) <- annot$SampleID
  annot <- annot[, c("PCR","Version","Barcode"), drop = FALSE]
  
# Clustering
  mat_imp   <- impute_for_clustering(mat_plot, how = na_fill_for_clustering)
  row_order <- if (do_cluster_rows && nrow(mat_imp) >= 2) stats::hclust(stats::dist(mat_imp))$order else seq_len(nrow(mat_imp))
  col_order <- if (do_cluster_cols && ncol(mat_imp) >= 2) stats::hclust(stats::dist(t(mat_imp)))$order else seq_len(ncol(mat_imp))
  
  mat_show  <- mat_plot[row_order, col_order, drop = FALSE]
  annot_use <- annot[colnames(mat_show), , drop = FALSE]
  
  cap <- cap_matrix_and_breaks(
    mat_show,
    mode      = cap_mode,
    abs_low   = cap_low,
    abs_high  = cap_high,
    q         = cap_q,
    clip      = cap_clip,
    base_step = base_break_step
  )
  mat_color   <- cap$mat
  storage.mode(mat_color) <- "double"
  breaks_used <- cap$breaks
  cols        <- palette_func(length(breaks_used) - 1L)
  
  dir.create(outdir, showWarnings = FALSE, recursive = TRUE)
  base     <- glue("{metric_name}_F1_heatmap_all_6dirs")
  pngfile  <- file.path(outdir, glue("{base}.png"))
  pdffile  <- file.path(outdir, glue("{base}.pdf"))
  csv_full <- file.path(outdir, glue("{base}_matrix_FULL.csv"))
  csv_show <- file.path(outdir, glue("{base}_matrix_capped.csv"))
  meta     <- file.path(outdir, glue("{base}_color_meta.txt"))
  
  write.csv(mat_orig,  csv_full, row.names = TRUE)
  write.csv(mat_color, csv_show, row.names = TRUE)
  writeLines(c(
    paste0("metric: ", metric_name),
    paste0("cap_mode: ", cap_mode),
    paste0("cap_low_used: ", sprintf("%.6f", cap$low)),
    paste0("cap_high_used: ", sprintf("%.6f", cap$high)),
    paste0("cap_clip: ", cap_clip),
    paste0("breaks_n: ", length(breaks_used)),
    paste0("break_step: ~", round(diff(range(breaks_used)) / (length(breaks_used)-1), 5))
  ), con = meta)
  
# Plot
  make_title <- function(metric, low, high) {
    glue("Heatmap {metric} - Skala [{sprintf('%.3f', low)}, {sprintf('%.3f', high)}] (PCR x Version)")
  }
  
  png(pngfile, width = 2400, height = 1400, res = 180)
  pheatmap(mat_color,
           color = cols, breaks = breaks_used,
           cluster_rows = FALSE, cluster_cols = FALSE,
           fontsize_row = 10, fontsize_col = 7,
           show_rownames = TRUE, show_colnames = FALSE,
           border_color = NA, na_col = "grey90",
           main = make_title(metric_name, cap$low, cap$high),
           annotation_col = annot_use)
  dev.off()
  
  pdf(pdffile, width = 22, height = 12)
  pheatmap(mat_color,
           color = cols, breaks = breaks_used,
           cluster_rows = FALSE, cluster_cols = FALSE,
           fontsize_row = 10, fontsize_col = 6,
           show_rownames = TRUE, show_colnames = FALSE,
           border_color = NA, na_col = "grey90",
           main = make_title(metric_name, cap$low, cap$high),
           annotation_col = annot_use)
  dev.off()
  
  message(glue("OK: {metric_name} -> {pngfile} / {pdffile}"))
}

message("Baue Heatmaps …")
walk(metrics_to_plot, ~plot_heatmap_for_metric(.x, all_df_clean, output_dir))

if (!is.null(.diag_acc)) {
  write.csv(.diag_acc, file.path(output_dir, "per_sample_diagnostics.csv"), row.names = FALSE)
}
message(glue("Fertig. Heatmaps & Logs unter: {output_dir}"))
