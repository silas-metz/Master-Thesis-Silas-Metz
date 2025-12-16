set -euo pipefail

# Usage:
#   ./extract_calls_dual.sh /path/to/Hac --bed regions.bed|regions.csv


if [[ $# -lt 2 ]]; then
  echo "Usage: $0 PARENT_DIR (--region chr:start-end | --bed regions.bed|regions.csv) [--threads N]"
  exit 1
fi

PARENT_DIR="$1"; shift
REGION=""
BED_FILE=""
THREADS="4"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --region) REGION="$2"; shift 2 ;;
    --bed)    BED_FILE="$2"; shift 2 ;;
    --threads) THREADS="$2"; shift 2 ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

if [[ -n "${BED_FILE:-}" ]]; then
  if [[ ! -f "$BED_FILE" ]]; then
    echo "Error: BED/CSV file not found: $BED_FILE"
    exit 1
  fi
  if [[ "$BED_FILE" == *.csv ]]; then
    echo "[INFO] Converting CSV to temporary BED format..."
    TMPBED=$(mktemp)
    tail -n +2 "$BED_FILE" | sed 's/[;,]/\t/g' | cut -f1-3 > "$TMPBED"
    BED_FILE="$TMPBED"
    echo "[INFO] Temporary BED written to $BED_FILE"
  fi
fi

MAIN_OUTDIR="${PARENT_DIR}/05_extract_calls"
mkdir -p "$MAIN_OUTDIR"

# Schleife
find "${PARENT_DIR}/03_chimeric" -type f -name "barcode*_non_chimeric.sorted.bam" | while read -r BAM; do
  BARCODE="$(basename "$(dirname "$BAM")")"    # barcode01, barcode02, ...
  STEM="$(basename "${BAM%.bam}")"

  OUTDIR="${MAIN_OUTDIR}/${BARCODE}"
  mkdir -p "$OUTDIR"

  OUTFILE="${OUTDIR}/${STEM}_calls_all_from_bed.tsv.gz"

  if [[ -n "$REGION" ]]; then
    SAFE_REGION="$(echo "$REGION" | sed 's/[:\-]/_/g')"
    OUTFILE="${OUTDIR}/${STEM}_calls_all_${SAFE_REGION}.tsv.gz"

    modkit extract calls "$BAM" - \
      --threads "$THREADS" \
      --region "$REGION" \
      | gzip > "$OUTFILE"

  elif [[ -n "$BED_FILE" ]]; then
    modkit extract calls "$BAM" - \
      --threads "$THREADS" \
      --include-bed "$BED_FILE" \
      | gzip > "$OUTFILE"
  else
    echo "Error: Provide --region or --bed"
    exit 1
  fi

  echo "[DONE] Saved: $OUTFILE"
done
echo "Outputs gespeichert unter: $MAIN_OUTDIR"

