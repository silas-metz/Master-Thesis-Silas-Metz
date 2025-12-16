# Output:
#   <output_dir>/combined_f1_details.csv   (eine Zeile pro Barcode-Datei)
#   <output_dir>/combined_f1_summary.csv   (eine Zeile Gesamtzusammenfassung)
#
# Aufrufbeispiel:
#   Rscript combine_weighted_f1.R \
#     --input_root "/pfad/zu/parent" \
#     --pattern "_filtered_F1.csv" \
#     --output_dir "/pfad/zum/output"


suppressWarnings(suppressMessages({
  if (!requireNamespace("data.table", quietly = TRUE)) {
    stop("Bitte installiere zuerst 'data.table' (install.packages('data.table')).")
  }
}))

args <- commandArgs(trailingOnly = TRUE)
kv <- if (length(args) > 0) {
  res <- list()
  i <- 1
  while (i <= length(args)) {
    a <- args[i]
    if (grepl("^--", a)) {
      if (grepl("=", a)) {
        sp <- strsplit(sub("^--", "", a), "=", fixed = TRUE)[[1]]
        res[[sp[1]]] <- sp[2]
        i <- i + 1
      } else {
        key <- sub("^--", "", a)
        if (i + 1 <= length(args) && !grepl("^--", args[i + 1])) {
          res[[key]] <- args[i + 1]
          i <- i + 2
        } else {
          res[[key]] <- "TRUE"
          i <- i + 1
        }
      }
    } else {
      i <- i + 1
    }
  }
  res
} else list()

get_arg <- function(key, default = NULL, required = FALSE) {
  if (!is.null(kv[[key]])) return(kv[[key]])
  if (required) stop(sprintf("Fehlendes Argument --%s", key))
  default
}

input_root <- get_arg("input_root", required = TRUE)
output_dir <- get_arg("output_dir", required = TRUE)
pattern    <- get_arg("pattern", "_filtered_F1.csv")  # Dateinamen-Teil, nach dem gesucht wird
barcode_regex <- get_arg("barcode_regex", "^barcode\\d{2}$") # Ordnernamen-Muster

if (!dir.exists(input_root)) stop("input_root existiert nicht: ", input_root)
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  if (!dir.exists(output_dir)) stop("Konnte output_dir nicht anlegen: ", output_dir)
}

dtfread <- function(path) {
  data.table::fread(path, sep = "auto", data.table = FALSE, showProgress = FALSE)
}

safe_num <- function(x) {
  suppressWarnings(as.numeric(x))
}

all_subdirs <- list.dirs(input_root, full.names = TRUE, recursive = FALSE)
barcode_dirs <- all_subdirs[grepl(barcode_regex, basename(all_subdirs), ignore.case = TRUE)]

if (length(barcode_dirs) == 0) {
  stop("Keine barcode-Unterordner gefunden in: ", input_root,
       "\nErwartet wurden Ordner wie 'barcode01', 'barcode02', ...")
}

collect <- list()
for (bdir in barcode_dirs) {
  cand <- list.files(bdir, pattern = pattern, full.names = TRUE, recursive = FALSE)
  if (length(cand) == 0) next
  
  if (length(cand) > 1) {
    mt <- file.info(cand)$mtime
    cand <- cand[order(mt, decreasing = TRUE)][1]
  }
  
  df <- tryCatch(dtfread(cand), error = function(e) NULL)
  if (is.null(df) || nrow(df) == 0) next
  
  cn <- tolower(colnames(df))
  colnames(df) <- cn
  
  need <- c("weighted_f1", "total_weight")
  if (!all(need %in% cn)) {
    warning("Pflichtspalten fehlen in: ", cand, "  (gefunden: ",
            paste(cn, collapse = ","), ")")
    next
  }
  
  df$weighted_f1  <- safe_num(df$weighted_f1)
  df$total_weight <- safe_num(df$total_weight)
  
  bc <- basename(bdir)
  
  w <- df$total_weight
  f1 <- df$weighted_f1
  
  ok <- is.finite(w) & is.finite(f1) & w >= 0
  if (!any(ok)) next
  
  f1_barcode <- sum(f1[ok] * w[ok], na.rm = TRUE) / sum(w[ok], na.rm = TRUE)
  W_barcode  <- sum(w[ok], na.rm = TRUE)
  
  pick <- function(nm) if (nm %in% cn) df[[nm]][which(ok)][1] else NA
  gt_percent       <- pick("gt_percent")
  weighted_f1_m    <- pick("weighted_f1_m")
  weighted_f1_c    <- pick("weighted_f1_c")
  filter_thresh    <- pick("filter_thresh")
  mod_thresh       <- pick("mod_thresh")
  note             <- pick("note")
  file_in          <- basename(cand)
  
  collect[[length(collect) + 1]] <- data.frame(
    barcode         = bc,
    file            = file_in,
    weighted_f1     = f1_barcode,
    total_weight    = W_barcode,
    gt_percent      = gt_percent,
    weighted_f1_m   = weighted_f1_m,
    weighted_f1_c   = weighted_f1_c,
    filter_thresh   = filter_thresh,
    mod_thresh      = mod_thresh,
    note            = note,
    stringsAsFactors = FALSE
  )
}

if (length(collect) == 0) {
  stop("Keine gültigen *_filtered_F1.csv Dateien gefunden, die 'weighted_f1' UND 'total_weight' enthalten.")
}

details <- do.call(rbind, collect)

# Globalen, gewichteten F1_combined
ok <- is.finite(details$weighted_f1) & is.finite(details$total_weight) & details$total_weight >= 0
if (!any(ok)) stop("Keine gültigen Werte für die globale Gewichtung gefunden.")

global_weighted_f1 <- sum(details$weighted_f1[ok] * details$total_weight[ok]) /
  sum(details$total_weight[ok])

summary_df <- data.frame(
  n_barcodes_included   = sum(ok),
  total_weight_sum      = sum(details$total_weight[ok]),
  weighted_f1_combined  = global_weighted_f1,
  stringsAsFactors = FALSE
)

# Output 
out_details <- file.path(output_dir, "combined_f1_details.csv")
out_summary <- file.path(output_dir, "combined_f1_summary.csv")

data.table::fwrite(details[ok, ], out_details)
data.table::fwrite(summary_df, out_summary)

message("Fertig.\nDetails: ", out_details, "\nSummary: ", out_summary)
