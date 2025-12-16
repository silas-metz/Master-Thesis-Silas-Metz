#!/usr/bin/env Rscript
# ======================================================================
# Median(median - sd) aus summary_quantiles_by_barcode_position_start_end.csv
#
# Eingabe:
#   CSV/TSV mit Header und Spalten:
#     chrom, bed_pos, barcode, pos_type, n_reads, q05, q25, median, q75, q95, mean, sd
#   (Trennzeichen wird automatisch erkannt)
#
# Ausgabe:
#   <output_dir>/median_minus_sd_details.csv   (Original + Spalte med_minus_sd)
#   <output_dir>/median_minus_sd_summary.csv   (eine Zeile mit Gesamtmedian)
#
# Aufrufbeispiel:
#   Rscript median_probabilities_punktesystem.R \
#     --input "/pfad/zur/summary_quantiles_by_barcode_position_start_end.csv" \
#     --output_dir "/pfad/zum/output"
#
# 
# ======================================================================

suppressWarnings(suppressMessages({
  if (!requireNamespace("data.table", quietly = TRUE)) {
    stop("Bitte installiere zuerst 'data.table' (install.packages('data.table')).")
  }
}))

# ---------- einfache Argument-Parsing (ohne Zusatzpakete) -------------
args <- commandArgs(trailingOnly = TRUE)
kv <- list()
i <- 1
while (i <= length(args)) {
  a <- args[i]
  if (grepl("^--", a)) {
    if (grepl("=", a)) {
      sp <- strsplit(sub("^--", "", a), "=", fixed = TRUE)[[1]]
      kv[[sp[1]]] <- sp[2]
      i <- i + 1
    } else {
      key <- sub("^--", "", a)
      if (i + 1 <= length(args) && !grepl("^--", args[i + 1])) {
        kv[[key]] <- args[i + 1]
        i <- i + 2
      } else {
        kv[[key]] <- "TRUE"
        i <- i + 1
      }
    }
  } else {
    i <- i + 1
  }
}

get_arg <- function(key, default = NULL, required = FALSE) {
  if (!is.null(kv[[key]])) return(kv[[key]])
  if (required) stop(sprintf("Fehlendes Argument --%s", key))
  default
}

input_file <- get_arg("input", required = TRUE)
output_dir <- get_arg("output_dir", required = TRUE)

# ---------- Checks -----------------------------------------------------
if (!file.exists(input_file)) stop("input existiert nicht: ", input_file)
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  if (!dir.exists(output_dir)) stop("Konnte output_dir nicht anlegen: ", output_dir)
}

# ---------- Einlesen (auto-Delimiter) ---------------------------------
fread <- data.table::fread
df <- tryCatch(
  fread(input_file, sep = "auto", data.table = FALSE, showProgress = FALSE),
  error = function(e) {
    stop("Konnte Datei nicht lesen: ", conditionMessage(e))
  }
)

if (nrow(df) == 0) stop("Datei ist leer: ", input_file)

# Spaltennamen vereinheitlichen
colnames(df) <- tolower(colnames(df))

# Pflichtspalten prüfen
need <- c("median", "sd")
if (!all(need %in% colnames(df))) {
  stop("Pflichtspalten fehlen. Erwartet: ", paste(need, collapse = ", "),
       "\nGefunden: ", paste(colnames(df), collapse = ", "))
}

# Numerik erzwingen (robust ggü. Text/Factor)
to_num <- function(x) suppressWarnings(as.numeric(x))
df$median <- to_num(df$median)
df$sd     <- to_num(df$sd)

# ---------- Berechnung: med_minus_sd pro Zeile ------------------------
df$med_minus_sd <- df$median - df$sd

# Nur gültige Zeilen für die Gesamtkennzahl
ok <- is.finite(df$med_minus_sd)

if (!any(ok)) stop("Keine gültigen 'median - sd' Werte vorhanden (alles NA/Inf).")

global_median <- stats::median(df$med_minus_sd[ok], na.rm = TRUE)

# ---------- Ausgaben ---------------------------------------------------
out_details <- file.path(output_dir, "median_minus_sd_details.csv")
out_summary <- file.path(output_dir, "median_minus_sd_summary.csv")

data.table::fwrite(df, out_details)

summary_df <- data.frame(
  n_rows_total      = nrow(df),
  n_rows_used       = sum(ok),
  median_of_median_minus_sd = global_median,
  stringsAsFactors = FALSE
)
data.table::fwrite(summary_df, out_summary)

message("Fertig.\nDetails:  ", out_details,
        "\nSummary:  ", out_summary,
        "\nMedian(median - sd) = ", sprintf("%.6f", global_median))
