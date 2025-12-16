suppressPackageStartupMessages({
  lib <- function(pkgs){
    for(p in pkgs){
      if(!requireNamespace(p, quietly = TRUE)){
        install.packages(p, repos="https://cloud.r-project.org")
      }
      suppressPackageStartupMessages(library(p, character.only=TRUE))
    }
  }
  lib(c("optparse","fs","glue","stringr","data.table","dplyr","tidyr",
        "readr","purrr","ggplot2","scales","tibble"))
})

option_list <- list(
  make_option(c("--sup_dir"), type="character", help="Pfad bis /Sup/ (ohne /05_extract_calls).", metavar="PATH"),
  make_option(c("--bed"), type="character", help="BED/CSV mit Spalten (chrom,start,end).", metavar="FILE"),
  make_option(c("--file_pattern"), type="character", default="\\.tsv(\\.gz)?$",
              help="Regex/Teilstring zur Auswahl der extract-calls-Dateien in jedem barcodeXX-Ordner. Default: %default"),
  make_option(c("--position_offset"), type="integer", default=0,
              help="MUSS 0 sein (strikter Start/End-Match). Andere Werte -> Abbruch."),
  make_option(c("--which_positions"), type="character", default="both",
              help="Welche Positionen matchen: 'start', 'end' oder 'both'. Default: %default"),
  make_option(c("--start_position_delta"), type="integer", default=0,
              help="Bewusster Integer-Shift auf BED-START. Default: %default"),
  make_option(c("--end_position_delta"), type="integer", default=0,
              help="Bewusster Integer-Shift auf BED-END (bei CpG meist -1). Default: %default"),
  make_option(c("--normalize_probs"), type="character", default="auto",
              help="Wahrscheinlichkeiten: 'auto' (0–1 lassen, 0–255 -> /255), '0-1', '0-255'."),
  make_option(c("--drop_h"), type="logical", default=TRUE,
              help="h-Calls (z. B. 5hmC) entfernen? Default: %default"),
  make_option(c("--save_pdf"), type="logical", default=TRUE,
              help="Zusätzlich zu PNG ein Multi-Seiten-PDF erzeugen? Default: %default"),
  make_option(c("--png_width"), type="double", default=11,
              help="PNG Breite in Zoll. Default: %default"),
  make_option(c("--png_height"), type="double", default=6.5,
              help="PNG Höhe in Zoll. Default: %default"),
  make_option(c("--dpi"), type="integer", default=200,
              help="PNG DPI. Default: %default"),
  make_option(c("--jitter_alpha"), type="double", default=0.25,
              help="Transparenz für Jitter-Punkte. Default: %default"),
  make_option(c("--jitter_width"), type="double", default=0.15,
              help="Breite des Jitters. Default: %default")
)
opt <- parse_args(OptionParser(option_list = option_list))

if (is.null(opt$sup_dir) || is.null(opt$bed)) stop("Bitte --sup_dir und --bed angeben.", call. = FALSE)
if (opt$position_offset != 0) stop("--position_offset muss 0 sein (strikter Start/End-Match).", call. = FALSE)

which_positions <- tolower(trimws(opt$which_positions))
if (!which_positions %in% c("start","end","both")) {
  stop("--which_positions muss 'start', 'end' oder 'both' sein.", call. = FALSE)
}

sup_dir  <- fs::path_abs(opt$sup_dir)
bed_file <- fs::path_abs(opt$bed)
if (!fs::dir_exists(sup_dir))  stop(glue("sup_dir nicht gefunden: {sup_dir}"))
if (!fs::file_exists(bed_file)) stop(glue("BED/CSV nicht gefunden: {bed_file}"))

trim_ws <- function(x) gsub("[[:space:]]+$","", gsub("^[[:space:]]+","", as.character(x)))

std_chr <- function(x){
  x <- trim_ws(x)
  x <- ifelse(grepl("^chr", x, ignore.case=TRUE), x, paste0("chr", x))
  x <- gsub("^chrmt$","chrM", x, ignore.case=TRUE)
  x <- gsub("^chrmt\\b","chrM", x, ignore.case=TRUE)
  x <- gsub("^chrm?$","chrM", x, ignore.case=TRUE)
  x
}

to_int_safe <- function(v){
  v <- trim_ws(v)
  suppressWarnings(as.integer(as.numeric(v)))
}

read_bed_flexible <- function(path){
  df <- suppressWarnings(readr::read_delim(
    file = path, delim = NULL, comment = "#", col_types = readr::cols(.default = "c")
  ))
  if (ncol(df) < 3) stop("BED/CSV hat weniger als 3 Spalten (erwartet mind. chrom,start,end).")
  cn <- tolower(trim_ws(names(df)))
  
  if (!any(c("chrom","chr","contig","seqname") %in% cn)) stop("Konnte 'chrom/chr/contig/seqname' nicht finden.")
  if (!any(c("start","chromstart","chrom_start","pos","position","begin") %in% cn)) stop("Konnte 'start/pos/position' nicht finden.")
  if (!any(c("end","chromend","chrom_end","stop") %in% cn)) stop("Konnte 'end/stop' nicht finden.")
  
  map_name <- function(x){
    x <- tolower(x)
    if (x %in% c("chrom","chr","contig","seqname")) return("chrom")
    if (x %in% c("start","chromstart","chrom_start","pos","position","begin")) return("start")
    if (x %in% c("end","chromend","chrom_end","stop")) return("end")
    x
  }
  names(df) <- vapply(cn, map_name, FUN.VALUE = character(1))
  
  df <- df %>% select(chrom, start, end) %>%
    mutate(chrom = std_chr(chrom),
           start = to_int_safe(start),
           end   = to_int_safe(end)) %>%
    filter(!is.na(chrom), !is.na(start), !is.na(end)) %>%
    distinct(chrom, start, end, .keep_all = TRUE) %>%
    arrange(chrom, start, end)
  df
}

find_barcode_files <- function(root_sup, pattern){
  base <- fs::path(root_sup, "05_extract_calls")
  if(!fs::dir_exists(base)) stop(glue("Ordner fehlt: {base} (erwartet unter {root_sup})"))
  dirs <- fs::dir_ls(base, type = "directory", recurse = FALSE)
  dirs <- dirs[grepl("barcode\\d{2}$", basename(dirs))]
  dirs <- dirs[order(basename(dirs))]
  if (length(dirs) == 0) stop("Keine barcodeXX-Ordner unter 05_extract_calls gefunden.")
  tibble::tibble(
    barcode = basename(dirs),
    dir = dirs
  ) %>%
    mutate(file = purrr::map_chr(dir, ~{
      cand <- fs::dir_ls(.x, type = "file", recurse = FALSE, glob = "*")
      cand <- cand[grepl(pattern, basename(cand))]
      if (length(cand) == 0) NA_character_ else cand[1]
    }))
}

read_calls_flexible <- function(path){
  if (is.na(path) || !fs::file_exists(path)) return(NULL)
  suppressWarnings({
    df <- tryCatch(
      readr::read_tsv(
        file = path,
        col_types = readr::cols(.default = readr::col_character()),
        progress = FALSE
      ),
      error = function(e) NULL
    )
  })
  if (is.null(df) || nrow(df) == 0) return(NULL)
  
  cn_raw <- names(df)
  cn <- tolower(gsub("[[:space:]]+", "", cn_raw))
  name_of <- function(cands){
    idx <- which(cn %in% cands)
    if (length(idx)) cn_raw[idx[1]] else NA_character_
  }
  
  col_chrom <- name_of(c("chrom","chr","contig","rname","seqname"))
  col_pos   <- name_of(c("ref_position","position","pos","start","refpos","offset"))
  col_prob  <- name_of(c("call_prob","prob","probability","mod_prob","modprob",
                         "prob_mod","mod_probability","prob_5mc","mod_prob_5mc"))
  col_code  <- name_of(c("call_code","code","mod_code","modcode","label"))
  
  if (is.na(col_chrom) || is.na(col_pos) || is.na(col_prob)) {
    warning(glue("Spalten nicht eindeutig in {basename(path)}. Vorhanden: {paste(cn_raw, collapse=', ')}"))
    return(NULL)
  }
  
  chrom_v <- std_chr(df[[col_chrom]])
  pos_v   <- to_int_safe(df[[col_pos]])
  prob_v  <- suppressWarnings(as.numeric(df[[col_prob]]))
  
  out <- data.table::data.table(
    chrom    = chrom_v,
    position = pos_v,
    prob_raw = prob_v
  )
  
  if (!is.na(col_code)) {
    code_raw <- df[[col_code]]
    code_l   <- tolower(trim_ws(code_raw))
    out[, call_code := code_raw]
    out[, code_lower := code_l]
    # NUR 'm' (und Alias '5mc') als methylated; Rest unmethylated
    meth_class <- ifelse(code_l %in% c("m","5mc"), "methylated", "unmethylated")
    out[, meth_class := factor(meth_class, levels = c("unmethylated","methylated"))]
  }
  
  if ("strand" %in% cn)        out[, strand := as.character(df[["strand"]])]
  if ("ref_strand" %in% cn && !"strand" %in% names(out)) out[, strand := as.character(df[["ref_strand"]])]
  
  out <- out[!is.na(chrom) & !is.na(position)]
  if (nrow(out) == 0) return(NULL)
  out
}

normalize_probs <- function(x, mode = c("auto","0-1","0-255")){
  mode <- match.arg(mode)
  if (mode == "0-1") return(pmax(pmin(x, 1), 0))
  if (mode == "0-255") return(pmax(pmin(x/255, 1), 0))
  mx <- suppressWarnings(max(x, na.rm = TRUE))
  if (is.finite(mx) && mx > 1.001 && mx <= 255) return(pmax(pmin(x/255, 1), 0))
  pmax(pmin(x, 1), 0)
}

bed <- read_bed_flexible(bed_file)
message(glue("BED geladen: {nrow(bed)} Position(en)."))

bed_pos_start <- bed %>%
  transmute(chrom, pos = start + as.integer(opt$start_position_delta)) %>%
  mutate(chrom = std_chr(chrom), pos = as.integer(pos))
bed_pos_end <- bed %>%
  transmute(chrom, pos = end + as.integer(opt$end_position_delta)) %>%
  mutate(chrom = std_chr(chrom), pos = as.integer(pos))

use_start <- which_positions %in% c("start","both")
use_end   <- which_positions %in% c("end","both")

barcode_tbl <- find_barcode_files(sup_dir, opt$file_pattern)
miss <- sum(is.na(barcode_tbl$file))
if (miss > 0) warning(glue("{miss} barcode-Ordner ohne passende TSV-Datei (Pattern: {opt$file_pattern})."))
barcode_tbl <- barcode_tbl %>% filter(!is.na(file))
if (nrow(barcode_tbl) == 0) stop("Keine passenden TSV-Dateien gefunden.")
message(glue("Gefundene Barcodes: {paste(barcode_tbl$barcode, collapse=', ')}"))

normalize_mode <- opt$normalize_probs
calls_list <- vector("list", nrow(barcode_tbl) * (use_start + use_end))
idx <- 1L
hit_counter <- tibble::tibble(barcode = character(), type = character(), hits = integer())

dbg_dir <- fs::path(sup_dir, "06_boxplots_extract_calls_debug")
fs::dir_create(dbg_dir)

for (i in seq_len(nrow(barcode_tbl))) {
  bc <- barcode_tbl$barcode[i]
  fpath <- barcode_tbl$file[i]
  message(glue("[{i}/{nrow(barcode_tbl)}] Lese {bc}: {basename(fpath)}"))
  dt <- read_calls_flexible(fpath)
  if (is.null(dt) || nrow(dt) == 0) { warning(glue("Leere/ungültige Datei: {fpath}")); next }
  
  setDT(dt); setkey(dt, chrom, position)
  
  drop_h_if_needed <- function(D){
    if (!isTRUE(opt$drop_h)) return(D)
    if (!("code_lower" %in% names(D))) return(D)
    n_before <- nrow(D)
    D <- D[!(code_lower %in% c("h","5hmc"))]
    n_after  <- nrow(D)
    n_drop   <- n_before - n_after
    if (n_drop > 0) message(glue("      entfernt (h): {n_drop} Reads"))
    D
  }
  
  if (use_start) {
    bp <- as.data.table(bed_pos_start)
    sel_s <- dt[bp, on = .(chrom, position = pos), nomatch = 0L]
    hit_counter <- add_row(hit_counter, barcode = bc, type = "start", hits = nrow(sel_s))
    message(glue("   Hits(start): {nrow(sel_s)}/{nrow(bp)}  (delta={opt$start_position_delta})"))
    if (nrow(sel_s) > 0) {
      sel_s <- drop_h_if_needed(sel_s)
      if (nrow(sel_s) > 0) {
        sel_s[, prob := normalize_probs(prob_raw, normalize_mode)]
        sel_s[, barcode := bc]
        sel_s[, bed_pos := position]
        sel_s[, pos_type := "start"]
        sel_s[, c("position") := NULL]
        calls_list[[idx]] <- sel_s[]; idx <- idx + 1L
      }
    } else {
      try({
        data.table::fwrite(head(dt[, .(chrom, position)], 1000),
                           fs::path(dbg_dir, glue("nohits_preview_{bc}_start.tsv")), sep="\t")
        data.table::fwrite(as.data.table(bed_pos_start),
                           fs::path(dbg_dir, glue("bed_positions_used_start.tsv")), sep="\t")
      }, silent = TRUE)
    }
  }
  
  if (use_end) {
    bp <- as.data.table(bed_pos_end)
    sel_e <- dt[bp, on = .(chrom, position = pos), nomatch = 0L]
    hit_counter <- add_row(hit_counter, barcode = bc, type = "end", hits = nrow(sel_e))
    message(glue("   Hits( end ): {nrow(sel_e)}/{nrow(bp)}  (delta={opt$end_position_delta})"))
    if (nrow(sel_e) > 0) {
      sel_e <- drop_h_if_needed(sel_e)
      if (nrow(sel_e) > 0) {
        sel_e[, prob := normalize_probs(prob_raw, normalize_mode)]
        sel_e[, barcode := bc]
        sel_e[, bed_pos := position]
        sel_e[, pos_type := "end"]
        sel_e[, c("position") := NULL]
        calls_list[[idx]] <- sel_e[]; idx <- idx + 1L
      }
    } else {
      try({
        data.table::fwrite(head(dt[, .(chrom, position)], 1000),
                           fs::path(dbg_dir, glue("nohits_preview_{bc}_end.tsv")), sep="\t")
        data.table::fwrite(as.data.table(bed_pos_end),
                           fs::path(dbg_dir, glue("bed_positions_used_end.tsv")), sep="\t")
      }, silent = TRUE)
    }
  }
}

calls <- data.table::rbindlist(calls_list, use.names = TRUE, fill = TRUE)
if (nrow(calls) == 0) {
  stop("Nach striktem Match (und ggf. h-Filter) keine Daten vorhanden. Siehe Debug-Dateien unter: ", dbg_dir, call. = FALSE)
}

# Ausgabe
out_dir <- fs::path(sup_dir, "06_boxplots_extract_calls")
fs::dir_create(out_dir)

summary_dt <- calls[
  , .(
    n_reads = .N,
    q05 = quantile(prob, 0.05, na.rm=TRUE),
    q25 = quantile(prob, 0.25, na.rm=TRUE),
    median = median(prob, na.rm=TRUE),
    q75 = quantile(prob, 0.75, na.rm=TRUE),
    q95 = quantile(prob, 0.95, na.rm=TRUE),
    mean = mean(prob, na.rm=TRUE),
    sd   = sd(prob, na.rm=TRUE)
  ),
  by = .(chrom, bed_pos, barcode, pos_type)
][order(chrom, pos_type, bed_pos, barcode)]

readr::write_csv(summary_dt, fs::path(out_dir, "summary_quantiles_by_barcode_position_start_end.csv"))
message(glue("Summary geschrieben: {fs::path(out_dir, 'summary_quantiles_by_barcode_position_start_end.csv')}"))

# Plot
plot_one_position <- function(chrom, pos, typ, df_pos, jitter_alpha=0.25, jitter_width=0.15){
  df_pos <- df_pos %>% mutate(barcode = factor(barcode, levels = sort(unique(barcode))))
  has_mclass <- "meth_class" %in% colnames(df_pos)
  
  p <- ggplot(df_pos, aes(x = barcode, y = prob)) +
    geom_boxplot(outlier.shape = NA)
  
  if (has_mclass) {
    p <- p +
      geom_jitter(aes(color = meth_class), width = jitter_width, alpha = jitter_alpha, size = 0.000000000000001) +
      scale_color_manual(
        name = "Status",
        values = c("unmethylated" = "blue", "methylated" = "red"),
        limits = c("unmethylated","methylated"),
        drop = FALSE
      )
  } else {
    p <- p + geom_jitter(width = jitter_width, alpha = jitter_alpha, size = 0.9)
  }
  
  p +
    scale_y_continuous(limits = c(0,1), breaks = seq(0,1,0.1), labels = percent_format(accuracy = 1)) +
    labs(title = glue("{chrom}:{pos} ({typ}) – Mod probabilities over barcodes"),
         x = "Barcode", y = "Mod probability (0–1)") +
    theme_minimal(base_size = 12) +
    theme(
      plot.title = element_text(face="bold", hjust=0),
      axis.text.x = element_text(angle=45, hjust=1),
      panel.background = element_rect(fill = "white", colour = NA),
      plot.background  = element_rect(fill = "white", colour = NA),
      panel.grid.minor = element_blank()
    )
}

positions <- calls[, .(chrom, bed_pos, pos_type)] %>% distinct() %>% arrange(chrom, pos_type, bed_pos)
message(glue("Erzeuge Boxplots für {nrow(positions)} Position(en) (inkl. Start/End)."))

plots <- vector("list", nrow(positions))
for (i in seq_len(nrow(positions))) {
  ch <- positions$chrom[i]
  ps <- positions$bed_pos[i]
  tp <- positions$pos_type[i]
  dfp <- calls[chrom == ch & bed_pos == ps & pos_type == tp]
  if (nrow(dfp) == 0) next
  p <- plot_one_position(ch, ps, tp, as_tibble(dfp), opt$jitter_alpha, opt$jitter_width)
  plots[[i]] <- p
  png_path <- fs::path(out_dir, glue("boxplot_{ch}_{ps}_{tp}.png"))
  ggsave(png_path, p, width = opt$png_width, height = opt$png_height, dpi = opt$dpi, bg = "white")
}

if (isTRUE(opt$save_pdf) && length(Filter(Negate(is.null), plots)) > 0) {
  pdf_path <- fs::path(out_dir, "boxplots_all_positions_start_end.pdf")
  grDevices::pdf(pdf_path, width = opt$png_width, height = opt$png_height, bg = "white")
  for (p in plots) if (!is.null(p)) print(p)
  grDevices::dev.off()
  message(glue("PDF geschrieben: {pdf_path}"))
}

# Report
if (nrow(hit_counter)) {
  hit_wide <- hit_counter %>% tidyr::pivot_wider(names_from = type, values_from = hits, values_fill = 0)
  readr::write_csv(hit_wide, fs::path(out_dir, "hit_counts_by_barcode_start_end.csv"))
  message(glue("Hit-Tabelle geschrieben: {fs::path(out_dir, 'hit_counts_by_barcode_start_end.csv')}"))
}

message("Fertig. PNGs/CSV (und ggf. PDF) unter: ", out_dir)
message("Hinweis: Für CpG ist --end_position_delta -1 meist korrekt (zweite Base = end-1).")
