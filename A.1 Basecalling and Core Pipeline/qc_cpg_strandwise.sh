#!/usr/bin/env bash
set -euo pipefail

usage(){ echo "Usage: $0 -b BAM -f REF.fa -p POSITIONS.csv -m BEDMETHYL -o OUT.tsv" >&2; exit 1; }

BAM=""; REF=""; POS=""; BEDM=""; OUT=""
while getopts "b:f:p:m:o:" opt; do
  case "$opt" in
    b) BAM="$OPTARG" ;;
    f) REF="$OPTARG" ;;
    p) POS="$OPTARG" ;;
    m) BEDM="$OPTARG" ;;
    o) OUT="$OPTARG" ;;
    *) usage ;;
  esac
done
[ -z "$BAM" ] || [ -z "$REF" ] || [ -z "$POS" ] || [ -z "$BEDM" ] || [ -z "$OUT" ] && usage

command -v samtools >/dev/null 2>&1 || { echo "[ERR] samtools not found" >&2; exit 1; }
[ -f "$BAM"  ] || { echo "[ERR] BAM not found: $BAM" >&2; exit 1; }
[ -f "$REF"  ] || { echo "[ERR] REF not found: $REF" >&2; exit 1; }
[ -f "$POS"  ] || { echo "[ERR] Positions CSV not found: $POS" >&2; exit 1; }
[ -f "$BEDM" ] || { echo "[ERR] bedMethyl not found: $BEDM" >&2; exit 1; }

[ -f "${BAM}.bai" ] || [ -f "${BAM%.bam}.bai" ] || samtools index "$BAM" >/dev/null
[ -f "${REF}.fai" ] || samtools faidx "$REF" >/dev/null

printf "chr\tcpos\tstrand\tn_reads\tfrac_with_softclip\tmedian_ref_dist_to_end\twin3_mismatch_rate\twin3_indel_rate\tvalidcov\tfail\tfail_pct\n" > "$OUT"

VCOL=10   # Nvalid_cov
FCOL=16   # Nfail
STRCOL=6  # strand
MODCOL=4  # 'm'/'h'

HDR=$(mktemp)
samtools view -H "$BAM" | awk '/^@SQ\tSN:/{for(i=1;i<=NF;i++){if($i ~ /^SN:/){gsub(/^SN:/,"",$i); print $i}}}' > "$HDR"
choose_contig() {
  raw="$1"; bare="${raw#chr}"; bare="${bare#Chr}"; [ "$bare" = "M" ] && bare="MT"
  for c in "$raw" "chr${bare}" "$bare" "Chr${bare}" "chrM" "MT"; do
    [ -n "$c" ] && grep -qx "$c" "$HDR" && { echo "$c"; return; }
  done
  echo ""
}

POS_NORM=$(mktemp)
DELIM=$(awk 'NR==1{ if(index($0,"\t")) print "TAB"; else if(index($0,";")) print "SC"; else print "CSV"; exit }' "$POS")
if [ "$DELIM" = "TAB" ]; then FSARG=$'\t'; elif [ "$DELIM" = "SC" ]; then FSARG=';'; else FSARG=','; fi
awk -v FS="$FSARG" -v OFS="\t" '
  { gsub(/^\xEF\xBB\xBF/,"",$0); sub(/\r$/,"",$0);
    if(NF<3) next; chr=$1; s=$2; e=$3;
    gsub(/^ +| +$/,"",chr); gsub(/^ +| +$/,"",s); gsub(/^ +| +$/,"",e);
    if(s !~ /^[0-9]+$/ || e !~ /^[0-9]+$/) next;
    print chr, s, e }' "$POS" > "$POS_NORM"
N_POS=$(wc -l < "$POS_NORM"); echo "[INFO] Positions erkannt: $N_POS; Delimiter=$DELIM" >&2

median_from_first_col() {
  f="$1"; n=$(wc -l < "$f" || echo 0)
  if [ "$n" -eq 0 ]; then echo "NA NA"; return; fi
  sc=$(awk '{s+=$2} END{ if(NR==0) print "NA"; else printf "%.6f\n", s/NR }' "$f")
  if [ $((n%2)) -eq 1 ]; then
    mid=$(cut -f1 "$f" | sort -n | sed -n "$(( (n+1)/2 ))p")
  else
    a=$(cut -f1 "$f" | sort -n | sed -n "$(( n/2 ))p")
    b=$(cut -f1 "$f" | sort -n | sed -n "$(( n/2 + 1 ))p")
    mid=$(awk -v a="$a" -v b="$b" 'BEGIN{ if(a==""||b=="") print "NA"; else printf "%.6f\n", (a+b)/2 }')
  fi
  echo "$mid $sc"
}

lookup_bedmethyl_m_only() {
  local chr_raw="$1" str="$2" cpos="$3"
  local cpos_end=$((cpos+1))
  awk -v FS="\t" -v chr="$chr_raw" -v c="$cpos" -v ce="$cpos_end" -v want="$str" \
      -v vcol="$VCOL" -v fcol="$FCOL" -v scol="$STRCOL" -v mcol="$MODCOL" '
    BEGIN{vsum=0; fsum=0}
    NR==1{next}
    ($1==chr && $2==c && $3==ce && $scol==want && $mcol=="m"){ vsum += ($vcol+0); fsum += ($fcol+0) }
    END{ print vsum, fsum }' "$BEDM"
}

# Hauptschleife
while IFS=$'\t' read -r CHR_RAW S E; do
  [ -z "${CHR_RAW:-}" ] && continue
  BAMCHR="$(choose_contig "$CHR_RAW")"
  [ -z "$BAMCHR" ] && echo "[WARN] Kein Contig im BAM für '$CHR_RAW' gefunden." >&2

  E1=$((E-1))  # für '-' Strang C-Pos

  for STR in "+" "-"; do
    if [ "$STR" = "+" ]; then CPOS="$S"; else CPOS="$E1"; fi

    NREADS=0; SC_FRAC="NA"; MEDIAN="NA"
    if [ -n "$BAMCHR" ]; then
      REG="${BAMCHR}:${CPOS}-${CPOS}"
      TMP=$(mktemp)
      set +e
      samtools view -F 4 "$BAM" "$REG" 2>/dev/null \
      | awk -v pos="$CPOS" -v want_str="$STR" '
          BEGIN{OFS="\t"}
          function is_revflag(f){ return (int(f/16)%2)==1 ? 1 : 0 }
          function ref_len(cig,    i,len,ch,num,n,refc){
            refc=0; num=""; len=length(cig);
            for(i=1;i<=len;i++){
              ch=substr(cig,i,1);
              if(ch>="0" && ch<="9"){ num=num ch; continue }
              n=(num==""?0:+num); num="";
              if(ch=="M"||ch=="D"||ch=="N"||ch=="="||ch=="X") refc+=n;
            }
            return refc
          }
          function has_softclip(cig){ return (cig ~ /^[0-9]+S/ || cig ~ /S$/) ? 1 : 0 }
          {
            flag=$2; rstart=$4; cig=$6
            strand=(is_revflag(flag)?"-":"+"); if(strand!=want_str) next
            rl=ref_len(cig); rend=rstart+rl-1
            if(pos<rstart || pos>rend) next
            d1=pos-rstart; if(d1<0)d1=-d1
            d2=rend-pos;   if(d2<0)d2=-d2
            md=(d1<d2?d1:d2)
            print md, has_softclip(cig)
          }' > "$TMP"
      RET=$?
      set -e
      if [ $RET -eq 0 ] && [ -s "$TMP" ]; then
        read -r MEDIAN SC_FRAC <<<"$(median_from_first_col "$TMP")"
        NREADS=$(wc -l < "$TMP")
      fi
      rm -f "$TMP"
    fi

    read -r VALID FAIL <<<"$(lookup_bedmethyl_m_only "$CHR_RAW" "$STR" "$CPOS")"

    RATE=$(awk -v f="$FAIL" -v n="$NREADS" 'BEGIN{ if(n>0) printf "%.4f", 100.0*f/n; else print "NA" }')

    # Debug
    echo "[DBG] ${CHR_RAW} C=${CPOS} STR=${STR} | reads=${NREADS} valid_m=${VALID} fail_m=${FAIL} (${RATE}%%)" >&2

    printf "%s\t%s\t%s\t%s\t%s\t%s\tNA\tNA\t%s\t%s\t%s\n" \
      "$CHR_RAW" "$CPOS" "$STR" "$NREADS" "$SC_FRAC" "$MEDIAN" "$VALID" "$FAIL" "$RATE" >> "$OUT"
  done
done < "$POS_NORM"

rm -f "$HDR" "$POS_NORM"
echo "[OK] geschrieben: $OUT" >&2

