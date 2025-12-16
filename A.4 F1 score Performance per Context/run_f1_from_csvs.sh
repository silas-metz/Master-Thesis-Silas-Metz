set -euo pipefail


# Verwendung:
#   ./run_f1_from_csvs.sh /pfad/zu/csv_root \
#                         /pfad/zum/00_Results \
#                         /pfad/zum/04_F1_Scores

CSV_ROOT="${1:-}"
if [[ -z "${CSV_ROOT}" || ! -d "${CSV_ROOT}" ]]; then
  echo "❌ Bitte gültigen Eingabeordner angeben. Beispiel:"
  echo "   ./run_f1_from_csvs.sh /data/all_csvs"
  exit 1
fi

RESULTS_DIR="${2:-$(realpath "${CSV_ROOT}/../00_Results")}"
F1_DIR="${3:-$(realpath "${CSV_ROOT}/../04_F1_Scores")}"

F1_SCRIPT="/home/drk/Masterarbeit/R_Scripte/PCR_Skripte/F1_Score_einzeln_gesamt.R"

mkdir -p "${RESULTS_DIR}" "${F1_DIR}"

echo "CSV_ROOT   : ${CSV_ROOT}"
echo "RESULTS_DIR: ${RESULTS_DIR}   (pro Barcode eigener Unterordner)"
echo "F1_DIR     : ${F1_DIR}        (pro Barcode eigener Unterordner)"
echo "F1_SCRIPT  : ${F1_SCRIPT}"

# ------------------------------------------------------------
# 1) Alle CSVs finden
# ------------------------------------------------------------
mapfile -t CSV_FILES < <(find "${CSV_ROOT}" -type f -name "*.csv" | sort)
if [[ ${#CSV_FILES[@]} -eq 0 ]]; then
  echo "❌ Keine CSV-Dateien unter ${CSV_ROOT} gefunden."
  exit 1
fi
echo "🔎 Gefundene CSVs: ${#CSV_FILES[@]}"


# Barcodes extrahieren
declare -A FILE_TO_BARCODE=()
declare -A BARCODE_SET=()

for f in "${CSV_FILES[@]}"; do
  base="$(basename "$f")"
  dirn="$(basename "$(dirname "$f")")"

  # 1) aus Dateiname
  if [[ "$base" =~ (barcode[0-9]+) ]]; then
    bc="${BASH_REMATCH[1]}"
  # 2) sonst Elternordner
  elif [[ "$dirn" =~ (barcode[0-9]+) ]]; then
    bc="${BASH_REMATCH[1]}"
  else
    echo "Konnte Barcode nicht aus Name ableiten, verwende Elternordner als Fallback: ${dirn}"
    bc="${dirn}"
  fi

  FILE_TO_BARCODE["$f"]="$bc"
  BARCODE_SET["$bc"]=1
done

# Sortieren
mapfile -t BARCODES < <(printf "%s\n" "${!BARCODE_SET[@]}" | sort)
N=${#BARCODES[@]}
if [[ $N -eq 0 ]]; then
  echo "❌ Keine Barcodes erkannt."
  exit 1
fi

echo "Barcodes erkannt (${N}): ${BARCODES[*]}"


# GT-Mapping
declare -A GT_BY_BARCODE=()
if [[ $N -le 1 ]]; then
  # Nur ein Barcode -> GT = 0
  GT_BY_BARCODE["${BARCODES[0]}"]=0
else
  for i in "${!BARCODES[@]}"; do
    bc="${BARCODES[$i]}"
    GT=$(awk -v i="$i" -v n="$N" 'BEGIN{ printf "%.0f", (i*100.0)/(n-1) }')
    GT_BY_BARCODE["$bc"]="$GT"
  done
fi

echo "🎯 GT-Zuordnung:"
for bc in "${BARCODES[@]}"; do
  echo "   - ${bc} -> GT=${GT_BY_BARCODE[$bc]}%"
done

parse_fth() {
  local name="$1"
  if [[ "$name" =~ _f([0-9]+\.[0-9]+) ]]; then
    printf "%s" "${BASH_REMATCH[1]}"
  else
    printf "NA"
  fi
}
parse_mth() {
  local name="$1"
  if [[ "$name" =~ _m([0-9]+\.[0-9]+) ]]; then
    printf "%s" "${BASH_REMATCH[1]}"
  else
    printf "NA"
  fi
}


# Lauf pro CSV
export LC_NUMERIC=C  

for f in "${CSV_FILES[@]}"; do
  bc="${FILE_TO_BARCODE[$f]}"
  gt="${GT_BY_BARCODE[$bc]}"

  base="$(basename "$f")"
  fth="$(parse_fth "$base")"
  mth="$(parse_mth "$base")"

  bc_results="${RESULTS_DIR}/${bc}"
  bc_f1="${F1_DIR}/${bc}"
  mkdir -p "${bc_results}" "${bc_f1}"

  out_csv="${bc_f1}/${base%.csv}_F1.csv"

  echo "────────────────────────────────────────────────────────"
  echo "Datei: $base"
  echo "   Barcode : $bc"
  echo "   GT      : ${gt}%"
  echo "   fth/mth : $fth / $mth"
  echo "   Results : $bc_results"
  echo "   F1 out  : $out_csv"

  Rscript "${F1_SCRIPT}" \
    --input "${f}" \
    --output "${out_csv}" \
    --gt "${gt}" \
    --fth "${fth}" \
    --mth "${mth}" \
    --results_dir "${bc_results}"
done

echo "Fertig: Alle CSVs analysiert."
echo "Pro-Barcode-Summaries:   ${RESULTS_DIR}/<barcode>/*_F1_summary.csv"
echo "Pro-Positions-Tabellen:  ${RESULTS_DIR}/<barcode>/*_F1_positions.csv"
echo "Einzel-Run-Resultate:    ${F1_DIR}/<barcode>/*_F1.csv"

