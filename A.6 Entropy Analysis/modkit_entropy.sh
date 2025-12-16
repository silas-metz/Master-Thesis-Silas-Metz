set -euo pipefail

IN_ROOT="/home/drk/Masterarbeit/PCR_Daten_dorado1.1.1/PCR3/CG/Hac/03_chimeric"
OUT_ROOT="/home/drk/Masterarbeit/PCR_Daten_dorado1.1.1/PCR3/CG/Hac/08_Entropy"

regions_bed_file="/home/drk/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/IL2RG_hg38_chrX_71111301_71111745.bed"
ref="/home/drk/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa"

BAM_SUFFIX="_non_chimeric.sorted.bam"
THREADS=32
RESUME=false
DRY_RUN=false


err(){ echo "ERROR: $*" >&2; exit 1; }
command -v modkit >/dev/null 2>&1 || err "'modkit' nicht im PATH gefunden."
command -v samtools >/dev/null 2>&1 || err "'samtools' nicht im PATH gefunden."
[[ -d "$IN_ROOT"          ]] || err "IN_ROOT existiert nicht: $IN_ROOT"
[[ -f "$regions_bed_file" ]] || err "regions_bed_file nicht gefunden: $regions_bed_file"
[[ -f "$ref"              ]] || err "ref (FASTA) nicht gefunden: $ref"

mkdir -p "$OUT_ROOT"
shopt -s nullglob
mapfile -d '' BARCODES < <(find "$IN_ROOT" -maxdepth 1 -mindepth 1 -type d -name "barcode*" -print0 | sort -z)
[[ ${#BARCODES[@]} -gt 0 ]] || err "Keine barcode*-Unterordner unter: $IN_ROOT"


echo "Input root:   $IN_ROOT"
echo "Output root:  $OUT_ROOT"
echo "Regions BED:  $regions_bed_file"
echo "Reference:    $ref"
echo "Threads:      $THREADS"
echo "BAM suffix:   $BAM_SUFFIX"


for bc_dir in "${BARCODES[@]}"; do
  bc_name="$(basename "$bc_dir")"
  mod_bam="${bc_dir}/${bc_name}${BAM_SUFFIX}"
  outdir="${OUT_ROOT}/${bc_name}"

  echo "BARCODE: $bc_name"
  echo "BAM:     $mod_bam"
  echo "OUTDIR:  $outdir"

  [[ -f "$mod_bam" ]] || { echo "WARN: BAM fehlt – skip $bc_name"; continue; }
  [[ -f "${mod_bam}.bai" ]] || samtools index "$mod_bam"

  if $RESUME && [[ -s "${outdir}/windows.bedgraph" ]]; then
    echo "INFO: windows.bedgraph existiert – Resume aktiv, skip $bc_name"
    continue
  fi

  mkdir -p "$outdir"

  cmd=( modkit entropy
        --in-bam "${mod_bam}"
        -o "${outdir}"
        --regions "${regions_bed_file}"    # BED3/4
        --cpg                              # combine strands
        --ref "${ref}"
        --threads "${THREADS}"
        --log-filepath "modkit_entropy.log"
        -n 3
        -w 250
        --min-coverage 10
        --max-filtered-positions 0
      )


  echo "CMD: ${cmd[*]}"
  if $DRY_RUN; then
    echo "[Dry-run] ${cmd[*]}"
  else
    ( cd "${outdir}" && "${cmd[@]}" )
  fi
done

echo "Fertig."

