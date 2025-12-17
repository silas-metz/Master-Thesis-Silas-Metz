suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
  library(stringr)
  library(tibble)
})


weidner_age_file <- "/path/to/input/CASIN/Output_CG_Kontext/Hac/20250729/00_Results/Filtered_by_Weidner/noH/combined_strands/with_hg19_cpgid/weidner_age_results.csv"

hor_han_file     <- "/path/to/input/CASIN/20250729/DNAmAge_Horvath_Hannum_from_ONT.csv"

out_merged       <- "/path/to/output/CASIN/20250729/Age_all_clocks_merged.csv"


age_tbl <- tribble(
  ~id_short, ~real_age,
  "Age01", 23.669,
  "Age02", 27.244,
  "Age03", 27.540,
  "Age04", 28.567,
  "Age05", 30.932,
  "Age06", 21.265,
  "Age07", 27.814,
  "Age08", 18.598,
  "PT06", 72.544,
  "PT09", 71.926,
  "PT10", 78.003,
  "PT17", 74.402,
  "PT18", 72.298,
  "PT21", 72.022,
  "PT30", 79.658,
  "PT36", 69.615,
  "d0", 34.500,
  "d7_CASIN", 34.500,
  "d7_DMSO", 34.500
)


cat("Alters-Tabelle (hardcoded):\n")
print(age_tbl)


if (!file.exists(weidner_age_file)) {
  stop("Weidner-Datei nicht gefunden: ", weidner_age_file)
}

weidner_raw <- tryCatch(
  read_csv(weidner_age_file, show_col_types = FALSE),
  error = function(e) read_csv2(weidner_age_file, show_col_types = FALSE)
)

if (!"DNAmAge_Weidner" %in% names(weidner_raw)) {
  stop("Spalte 'DNAmAge_Weidner' fehlt in ", weidner_age_file)
}

weidner <- weidner_raw %>%
  select(-any_of(c("real_age", "age_chr"))) %>%  # <--- alte Altersfelder weg
  mutate(
    id_short = sub("_filtered_noH$", "", sample_id),
    id_short = str_trim(id_short),
    group    = ifelse(startsWith(id_short, "Age"), "young", "old")
  ) %>%
  left_join(age_tbl, by = "id_short")

if (any(is.na(weidner$real_age))) {
  warning("Samples ohne real_age:\n",
          paste(weidner$id_short[is.na(weidner$real_age)], collapse = ", "))
}

cat("\nKopf Weidner + real_age (sollte ~18–80 sein, NICHT 23000):\n")
print(
  weidner %>%
    select(sample_id, id_short, group, real_age, DNAmAge_Weidner) %>%
    arrange(id_short)
)


if (!file.exists(hor_han_file)) {
  stop("Horvath/Hannum-Datei nicht gefunden: ", hor_han_file)
}

horhan_raw <- tryCatch(
  read_csv(hor_han_file, show_col_types = FALSE),
  error = function(e) read_csv2(hor_han_file, show_col_types = FALSE)
)

needed <- c("sample_id",
            "DNAmAge_HorvathS2013_raw",
            "DNAmAge_HorvathS2013_antiTrafo",
            "DNAmAge_HannumG2013_raw")

if (!all(needed %in% names(horhan_raw))) {
  stop("In Horvath/Hannum-Datei fehlen Spalten: ",
       paste(setdiff(needed, names(horhan_raw)), collapse = ", "))
}

horhan <- horhan_raw %>%
  select(all_of(needed))

cat("\nKopf Horvath/Hannum:\n")
print(horhan %>% head())


merged <- weidner %>%
  left_join(horhan, by = "sample_id") %>%
  mutate(
    AA_Weidner = DNAmAge_Weidner               - real_age,
    AA_Horvath = DNAmAge_HorvathS2013_antiTrafo - real_age,
    AA_Hannum  = DNAmAge_HannumG2013_raw       - real_age
  ) %>%
  arrange(id_short)

cat("\nKopf der finalen Tabelle:\n")
print(
  merged %>%
    select(sample_id, id_short, group,
           real_age,
           DNAmAge_Weidner,
           DNAmAge_HorvathS2013_antiTrafo,
           DNAmAge_HannumG2013_raw,
           AA_Weidner, AA_Horvath, AA_Hannum)
)

write_csv(merged, out_merged)
cat("\n Geschrieben: ", out_merged, "\n")
