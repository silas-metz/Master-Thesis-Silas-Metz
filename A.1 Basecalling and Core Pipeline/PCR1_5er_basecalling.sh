#!/bin/bash
echo "Warte 2 Stunden, bevor das Skript startet..."
sleep 2h
echo "Starte jetzt..."

dorado basecaller \
  sup \
  /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/merged.pod5 \
  --reference /home/diablo/Desktop/HomoSapienshg38CLCGenomeChr.fa \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/Sup/C/gesamtsup.bam
  
dorado demux --kit-name SQK-NBD114-24 --no-trim --output-dir /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/Sup/C/demux /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/Sup/C/gesamtsup.bam


dorado basecaller \
  sup \
  /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/merged.pod5 \
  --reference /home/diablo/Desktop/HomoSapienshg38CLCGenomeChr.fa \
  --no-trim \
  --modified-bases 5mCG_5hmCG \
  --recursive \
  > /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/Sup/CG/gesamtsup.bam
  
dorado demux --kit-name SQK-NBD114-24 --no-trim --output-dir /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/Sup/CG/demux /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/Sup/CG/gesamtsup.bam



dorado basecaller \
  hac \
  /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/merged.pod5 \
  --reference /home/diablo/Desktop/HomoSapienshg38CLCGenomeChr.fa \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/Hac/C/gesamtsup.bam
  
dorado demux --kit-name SQK-NBD114-24 --no-trim --output-dir /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/Hac/C/demux /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/Hac/C/gesamtsup.bam


dorado basecaller \
  hac \
  /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/merged.pod5 \
  --reference /home/diablo/Desktop/HomoSapienshg38CLCGenomeChr.fa \
  --no-trim \
  --modified-bases 5mCG_5hmCG \
  --recursive \
  > /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/Hac/CG/gesamtsup.bam
  
dorado demux --kit-name SQK-NBD114-24 --no-trim --output-dir /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/Hac/CG/demux /home/diablo/Einzel_Fast5_gesamt/PCR1_5er/pod5/Hac/CG/gesamtsup.bam

