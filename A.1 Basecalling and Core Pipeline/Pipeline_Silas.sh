# 
# Pipeline Silas - Evaluierung von Methylierungsinformationen
# 

# Example Pipeline to call methylation from Nanopore data using modkit pileup via Epi2me

####################################################################################################################################################
# 1. Step: FastQ und uBAM-files will be aligned via the Epi2me workflow "Alignment" which uses minimap2 to align the reads along a reference genome.
####################################################################################################################################################

# ============================== NUTZUNG ===============================
# Starte das Skript mit dem Namen der gewünschten Probe (Ordnername):
# Zuerst: conda activate nanophase-v0.2.2 (SilasEnv)
# Anschließend: ./run_alignment_workflow.sh ProbennameXYZ

# ============================== BENUTZEREINGABE ===============================
SAMPLE_NAME=$1

if [ -z "$SAMPLE_NAME" ]; then
  echo "Bitte gib den Namen einer Probe (Ordner) an,  z. B.: ./run_alignment_workflow.sh Probenname123"
  exit 1
fi

# ============================== PFADSETUP ===============================
BASE_DIR=/path/to/input/folder
SAMPLE_DIR=$BASE_DIR/$SAMPLE_NAME
ALIGNMENT_DIR=$BASE_DIR/"01_Alignment"
MERGED_DIR_BAM=$BASE_DIR/"02_BAM_merged"

REF=/path/to/HomoSapienshg38CLCGenomeChr.fa
OUT_DIR=$ALIGNMENT_DIR/$SAMPLE_NAME

mkdir -p $OUT_DIR
mkdir -p $MERGED_DIR_BAM/$SAMPLE_NAME

# ============================ Datenverschiebung ==============================
# Rekursive Suche nach Dateien mit *_barcodeXX.bam
find "$BASE_DIR" -maxdepth 1 -type f -name "*barcode*.bam" | while read -r FILE; do
    # Nur Dateinamen extrahieren
    BASENAME=$(basename "$FILE")

    # Barcode extrahieren, z. B. "barcode01"
    BARCODE=$(echo "$BASENAME" | grep -o "barcode[0-9]\+")

    # Wenn kein Barcode vorhanden, überspringen
    if [[ -z "$BARCODE" ]]; then
        echo "Kein Barcode in Datei: $FILE"
        continue
    fi

    # Zielverzeichnis: gleiches Verzeichnis wie Datei + Barcode-Ordner
    FILEDIR=$(dirname "$FILE")
    TARGET_DIR="$FILEDIR/$BARCODE"
    mkdir -p "$TARGET_DIR"

    # Datei verschieben
    mv "$FILE" "$TARGET_DIR/"

    echo "Verschoben: $FILE -> $TARGET_DIR/"
done

# ============================== NEXTFLOW SETUP ===============================
NEXTFLOW_CMD="nextflow run /home/drk/epi2melabs/workflows/epi2me-labs/wf-alignment"
THREADS=16
OUTPUT_XAM_FMT="bam"

# ============================== INPUT-TYP ERKENNUNG ===============================
# 1. uBAM
samtools merge -f $SAMPLE_DIR/*.bam -o $MERGED_DIR_BAM/$SAMPLE_NAME/$SAMPLE_NAME"_merged".bam \

# Header ändern: chrMT → chrM
samtools view -H $MERGED_DIR_BAM/$SAMPLE_NAME/$SAMPLE_NAME"_merged".bam | sed 's/SN:chrMT/SN:chrM/' > $MERGED_DIR_BAM/$SAMPLE_NAME/header_modified.sam
samtools reheader $MERGED_DIR_BAM/$SAMPLE_NAME/header_modified.sam $MERGED_DIR_BAM/$SAMPLE_NAME/$SAMPLE_NAME"_merged".bam > $MERGED_DIR_BAM/$SAMPLE_NAME/$SAMPLE_NAME"_merged_chrM".bam
mv $MERGED_DIR_BAM/$SAMPLE_NAME/$SAMPLE_NAME"_merged_chrM".bam $MERGED_DIR_BAM/$SAMPLE_NAME/$SAMPLE_NAME"_merged".bam
rm $MERGED_DIR_BAM/$SAMPLE_NAME/header_modified.sam

  
#  samtools index $MERGED_DIR_BAM/$SAMPLE_NAME/$SAMPLE_NAME"_merged".bam \
  
  samtools sort -u $MERGED_DIR_BAM/$SAMPLE_NAME/$SAMPLE_NAME"_merged".bam -o $MERGED_DIR_BAM/$SAMPLE_NAME/$SAMPLE_NAME"_sorted".bam \
  
  samtools index $MERGED_DIR_BAM/$SAMPLE_NAME/$SAMPLE_NAME"_sorted".bam \
  
UBAM_FILE=$(find "$MERGED_DIR_BAM/$SAMPLE_NAME" -type f -name $SAMPLE_NAME"_sorted".bam | paste -sd "," -)

# 2. FASTQ (falls vorhanden)
#gunzip $SAMPLE_DIR/*.fastq.gz
# cat $SAMPLE_DIR/*.fastq > $MERGED_DIR_FASTQ/$SAMPLE_NAME/$SAMPLE_NAME"_merged".fastq \
  
  #samtools index $MERGED_DIR_FASTQ/$SAMPLE_NAME/$SAMPLE_NAME"_merged".fastq \
  
  #samtools sort -u $MERGED_DIR_FASTQ/$SAMPLE_NAME/$SAMPLE_NAME"_merged".fastq -o $MERGED_DIR_FASTQ/$SAMPLE_NAME/$SAMPLE_NAME"_sorted".fastq \
  
# FASTQ_FILE=$(find "$MERGED_DIR_FASTQ/$SAMPLE_NAME" -type f -name $SAMPLE_NAME"_merged".fastq | paste -sd "," -)

# ============================== WORKFLOW AUSFÜHREN ===============================
echo "Starte Alignment für Probe: $SAMPLE_NAME"
echo "➡ Output-Verzeichnis: $OUT_DIR"

if [ -n "$UBAM_FILE" ]; then
  echo "Verwende unaligned BAM-Datei: $UBAM_FILE"
  
  $NEXTFLOW_CMD \
    --bam $UBAM_FILE \
    --sample_name $SAMPLE_NAME \
    --references $REF \
    --out_dir $OUT_DIR \
    --threads $THREADS \
    --output_xam_fmt $OUTPUT_XAM_FMT

else
  echo "Keine unterstützten Eingabedateien (uBAM) gefunden im Verzeichnis: $SAMPLE_DIR"
  exit 1
fi

echo "Schritt 1 abgeschlossen für Probe: $SAMPLE_NAME"


######################################################################################
# 2. Step: Extrahieren und getrenntes Abspeichern der chimären Reads mittels samtools.
######################################################################################

# ============================== INPUT ===============================
INPUT_BAM=$OUT_DIR/$SAMPLE_NAME*"aligned".bam

# ============================== OUTPUT ==============================
CHIMERIC_DIR=$BASE_DIR/"03_chimeric"/$SAMPLE_NAME
CHIMERIC_BAM=$CHIMERIC_DIR/$SAMPLE_NAME"_chimeric".bam
NON_CHIMERIC_BAM=$CHIMERIC_DIR/$SAMPLE_NAME"_non_chimeric".bam
CHIMERIC_SORTED=$CHIMERIC_DIR/$SAMPLE_NAME"_chimeric.sorted".bam
NON_CHIMERIC_SORTED=$CHIMERIC_DIR/$SAMPLE_NAME"_non_chimeric.sorted".bam

mkdir -p $CHIMERIC_DIR

# ============================== EXTRAKTION ===============================
# 1. Chimäre Reads (mit SA:-Tag)
samtools view -h $INPUT_BAM | grep -E '^@|SA:' | samtools view -b -o $CHIMERIC_BAM

# 2. Nicht-chimäre Reads (ohne SA:-Tag)
samtools view -h $INPUT_BAM | grep -v 'SA:' | samtools view -b -o $NON_CHIMERIC_BAM

# ============================== SORTIEREN & INDEXIEREN ===============================
samtools sort -o "$CHIMERIC_SORTED" "$CHIMERIC_BAM"
samtools index "$CHIMERIC_SORTED"

samtools sort -o "$NON_CHIMERIC_SORTED" "$NON_CHIMERIC_BAM"
samtools index "$NON_CHIMERIC_SORTED"


# ============================== INFO ===============================
echo "Chimerische Reads:     $CHIMERIC_SORTED"
echo "Nicht-chimäre Reads:   $NON_CHIMERIC_SORTED"

echo "Schritt 2 abgeschlossen für Probe: $SAMPLE_NAME"


###########################################################################################
# 3. Step: Durchlauf des Human Variation Workflows zur Methylierungsanalyse mittels modkit.
###########################################################################################

# ============================== INPUT ===============================

HUMAN_DIR=$BASE_DIR"_Human_Variation_detailed"

# mkdir -p $HUMAN_DIR/$SAMPLE_NAME


# ============================== Epi2me-Parameter ===============================
NEXTFLOW_CMD_HUMAN="nextflow run /home/drk/epi2melabs/workflows/epi2me-labs/wf-human-variation"

#Hier jeweils die Workflow Options die man benötigt auf:"true" setzen, andernfalls:"false"
SV=false
SNP=false
CNV=false #to use QDNAseq instead of Spectre, use CNV=--use_qdnaseq
STR=false
MOD=true


# Main Options
BAM=$NON_CHIMERIC_SORTED
BAM_MIN_COVERAGE=20    #Minimum benötigte read coverage festlegen; Default:20
#BED für PCR-Produkt ist nicht die selbe wie für das Adaptive Sampling
BED=/home/drk/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/IL2RG_hg38_chrX_71111301_71111745.bed #Entsprechende Target Region BED-File angeben
#Hier BED für Adaptive Sampling
#BED=/home/diablo/Desktop/Age_AdapSamp_202503/Horvath_Hannum_WeidnerClocks_IL2RGex1_MT_groglei10k_SaRa_20250327.bed
ANNOTATION=false #SnpEff annotation
PHASED=false #Perform Phasing
INCLUDE_ALL_CTGS=false #Call for variants on all sequences in the reference, Default:false
OUTPUT_GENE_SUMMARY=false #If set to true, the workflow will generate gene-level coverage summaries, Default:false
IGV=false #Visualiz eoutputs in the Epi2me IGV visualizer
OUTPUT=$HUMAN_DIR/$SAMPLE_NAME

#Copy number variant calling options
USE_QDNASEQ=false #Use QDNAseq for CNV calling
QDNASEQ_BIN_SIZE=500 #Bin size for QDNAseq in kbp, Default:500

#Modified base calling options
FORCE_STRAND=true  #Call strand-aware modifications, Default:false

#Advanced options
DEPTH_INTERVALS=false #Output a bedGraph file with entries for each genomic interval featuring homogeneous depth #Default:false
GVCF=false #Enable to output a gVCF file in addition to the VCF outputs (experimental) Default:false
DOWNSAMPLE_COVERAGE=false #Downsample the coverage to along the genome, Default:false
DOWNSAMPLE_COVERAGE_TARGET=60 #Average coverage or reads to use for the analysis #Default:60

# Multiprocessing Options
UBAM_MAP_THREADS=8 #Set max number of threads to use for aligning reads from uBam, Default:8
UBAM_SORT_THREADS=3 #Set max number of threads to use for sorting and indexing aligned reads from uBAM, Default:3
UBAM_BAM2FQ_THREADS=1 #Set max number of threads to use for uncompressing uBAM and generating FASTQ for alignment, Default:1
MODKIT_THREADS=4 #Total number of threads to use in modkit modified base calling, Default:4


# Kommando ausführen
#$NEXTFLOW_CMD_HUMAN 
modkit pileup \
--cpg \
--ref $REF \
--max-depth 2047483647 \
$BAM \
$BASE_DIR/00_Results/$SAMPLE_NAME.bed



  echo "Schritt 3 abgeschlossen für Probe: $SAMPLE_NAME"
  
  # Wenn erfolgreich, lösche den work-Ordner
if [ $? -eq 0 ]; then
    echo "Workflow erfolgreich abgeschlossen. 'work'-Ordner wird gelöscht."
    rm -rf /home/drk/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/work
    rm -rf $ALIGNMENT_DIR/$SAMPLE_NAME/combined_references.mmi
    rm -rf $ALIGNMENT_DIR/$SAMPLE_NAME/combined_refs.fasta
    rm -rf $ALIGNMENT_DIR/$SAMPLE_NAME/combined_refs.fasta.fai
else
    echo "Workflow FEHLGESCHLAGEN. 'work'-Ordner bleibt erhalten zur Analyse."
fi

