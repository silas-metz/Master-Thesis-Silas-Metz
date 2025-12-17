#!/bin/bash

echo "Warte 6 Stunden, bevor das Skript startet..."
sleep 6h
echo "Starte jetzt..."


REF_FA="/path/to/reference/genome.fa"
POD5_DIR="/path/to/input/pod5_dir"
OUT_ROOT="/path/to/output/PCR3"
DORADO_VER="dorado1.0.2"
MAX_DEPTH="2047483647"

POD5_PREFIX="PBE20325_pass_barcode"
POD5_SUFFIX="_ed80ce94_acc03873_0.pod5"

samtools faidx "$REF_FA"

for bc in $(seq -w 1 21); do
  POD5_FILE="${POD5_PREFIX}${bc}${POD5_SUFFIX}"
  POD5_PATH="${POD5_DIR}/${POD5_FILE}"
  BARCODE_DIR="${OUT_ROOT}/PCR3_barcode${bc}/${DORADO_VER}"

  
  for CALLER in hac sup; do
    if [ "$CALLER" = "hac" ]; then
      OUT_SUB="C/Hac"
      OUT_BAM_IN="gesamthac.bam"
      OUT_BAM_SORT="gesamtshac.bam"
      OUT_BED="gesamthac_barcode${bc}.bed"
      MODBASES="5mC_5hmC"
    else
      OUT_SUB="C/Sup"
      OUT_BAM_IN="gesamtsup.bam"
      OUT_BAM_SORT="gesamtssup.bam"
      OUT_BED="gesamtsup_barcode${bc}.bed"
      MODBASES="5mC_5hmC"
    fi

    pod5 inspect summary "$POD5_PATH"
    dorado basecaller "$CALLER" --modified-bases "$MODBASES" --reference "$REF_FA" "$POD5_PATH" \
      > "${BARCODE_DIR}/${OUT_SUB}/${OUT_BAM_IN}"
    samtools sort --write-index -o "${BARCODE_DIR}/${OUT_SUB}/${OUT_BAM_SORT}" "${BARCODE_DIR}/${OUT_SUB}/${OUT_BAM_IN}"
    modkit pileup "${BARCODE_DIR}/${OUT_SUB}/${OUT_BAM_SORT}" --ref "$REF_FA" --max-depth "$MAX_DEPTH" \
      "${BARCODE_DIR}/${OUT_SUB}/${OUT_BED}"
  done

 
  for CALLER in hac sup; do
    if [ "$CALLER" = "hac" ]; then
      OUT_SUB="CG/Hac"
      OUT_BAM_IN="gesamthac.bam"
      OUT_BAM_SORT="gesamtshac.bam"
      OUT_BED="gesamthac_barcode${bc}.bed"
      MODBASES="5mCG_5hmCG"
    else
      OUT_SUB="CG/Sup"
      OUT_BAM_IN="gesamtsup.bam"
      OUT_BAM_SORT="gesamtssup.bam"
      OUT_BED="gesamtsup_barcode${bc}.bed"
      MODBASES="5mCG_5hmCG"
    fi

    pod5 inspect summary "$POD5_PATH"
    dorado basecaller "$CALLER" --modified-bases "$MODBASES" --reference "$REF_FA" "$POD5_PATH" \
      > "${BARCODE_DIR}/${OUT_SUB}/${OUT_BAM_IN}"
    samtools sort --write-index -o "${BARCODE_DIR}/${OUT_SUB}/${OUT_BAM_SORT}" "${BARCODE_DIR}/${OUT_SUB}/${OUT_BAM_IN}"
    modkit pileup "${BARCODE_DIR}/${OUT_SUB}/${OUT_BAM_SORT}" --ref "$REF_FA" --max-depth "$MAX_DEPTH" \
      "${BARCODE_DIR}/${OUT_SUB}/${OUT_BED}"
  done

done
