#!/bin/bash 
#Vorgehen um die PCR-Produkte richtig zu basecallen und demuxen für PCR-5er-Reihe (Hier mit 21 barcodes)


# die 5 pod5 dateien zu einer großen pod5 zusammenfügen

 # pod5 merge -o /path/to/input/pod5/Converted.pod5 /path/to/input/pod5_parts/*.pod5


# Basecallen ohne trimmen, ohne demultiplexen und ohne alignen
#Sup

dorado basecaller \
  sup@v5.0.0 \
  /path/to/input/pod5/Converted.pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_5er/base_out_c/Sup/gesamt.bam
  
dorado demux --kit-name SQK-NBD114-24 --output-dir /path/to/output/PCR_5er/base_out_c/demux/Sup /path/to/output/PCR_5er/base_out_c/Sup/gesamt.bam
# Hac

dorado basecaller \
  hac@v5.0.0 \
  /path/to/input/pod5/Converted.pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_5er/base_out_c/Hac/gesamt.bam
  
dorado demux --kit-name SQK-NBD114-24 --output-dir /path/to/output/PCR_5er/base_out_c/demux/Hac /path/to/output/PCR_5er/base_out_c/Hac/gesamt.bam


# ab hier für PCR-10er-Reihe

dorado basecaller \
  sup@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode01/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Sup/barcode01.bam

dorado basecaller \
  hac@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode01/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Hac/barcode01.bam
  
  
  
  dorado basecaller \
  sup@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode02/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Sup/barcode02.bam

dorado basecaller \
  hac@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode02/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Hac/barcode02.bam
  
  
  
  dorado basecaller \
  sup@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode03/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Sup/barcode03.bam

dorado basecaller \
  hac@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode03/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Hac/barcode03.bam
  
  
  
  dorado basecaller \
  sup@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode04/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Sup/barcode04.bam

dorado basecaller \
  hac@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode04/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Hac/barcode04.bam
  
  
  
  dorado basecaller \
  sup@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode05/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Sup/barcode05.bam

dorado basecaller \
  hac@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode05/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Hac/barcode05.bam
  
  
  
  dorado basecaller \
  sup@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode06/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Sup/barcode06.bam

dorado basecaller \
  hac@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode06/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Hac/barcode06.bam
  
  
  
  dorado basecaller \
  sup@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode07/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Sup/barcode07.bam

dorado basecaller \
  hac@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode07/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Hac/barcode07.bam
  
  
  
  dorado basecaller \
  sup@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode08/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Sup/barcode08.bam

dorado basecaller \
  hac@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode08/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Hac/barcode08.bam
  
  
  
  dorado basecaller \
  sup@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode09/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Sup/barcode09.bam

dorado basecaller \
  hac@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode09/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Hac/barcode09.bam
  
  
  
  dorado basecaller \
  sup@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode10/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Sup/barcode10.bam

dorado basecaller \
  hac@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode10/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Hac/barcode10.bam
  
  
  
  dorado basecaller \
  sup@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode11/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Sup/barcode11.bam

dorado basecaller \
  hac@v5.0.0 \
  /path/to/input/PCR_10er/pod5/barcode11/*"_Converted".pod5 \
  --kit-name SQK-NBD114-24 \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/PCR_10er/base_out_c/Hac/barcode11.bam
