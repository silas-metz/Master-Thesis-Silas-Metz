#!/bin/bash
echo "Warte 6 Stunden, bevor das Skript startet..."
sleep 6h
echo "Starte jetzt..."

pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode01_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode01_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/C/Hac/gesamthac_barcode01.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode02_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode02_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/C/Hac/gesamthac_barcode02.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode03_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode03_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/C/Hac/gesamthac_barcode03.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode04_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode04_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/C/Hac/gesamthac_barcode04.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode05_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode05_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/C/Hac/gesamthac_barcode05.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode06_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode06_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/C/Hac/gesamthac_barcode06.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode07_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode07_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/C/Hac/gesamthac_barcode07.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode08_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode08_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/C/Hac/gesamthac_barcode08.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode09_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode09_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/C/Hac/gesamthac_barcode09.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode10_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode10_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/C/Hac/gesamthac_barcode10.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode11_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode11_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/C/Hac/gesamthac_barcode11.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode12_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode12_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/C/Hac/gesamthac_barcode12.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode13_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode13_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/C/Hac/gesamthac_barcode13.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode14_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode14_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/C/Hac/gesamthac_barcode14.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode15_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode15_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/C/Hac/gesamthac_barcode15.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode16_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode16_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/C/Hac/gesamthac_barcode16.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode17_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode17_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/C/Hac/gesamthac_barcode17.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode18_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode18_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/C/Hac/gesamthac_barcode18.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode19_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode19_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/C/Hac/gesamthac_barcode19.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode20_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode20_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/C/Hac/gesamthac_barcode20.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode21_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode21_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/C/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/C/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/C/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/C/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/C/Hac/gesamthac_barcode21.bed














pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode01_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode01_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/C/Sup/gesamtsup_barcode01.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode02_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode02_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/C/Sup/gesamtsup_barcode02.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode03_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode03_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/C/Sup/gesamtsup_barcode03.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode04_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode04_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/C/Sup/gesamtsup_barcode04.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode05_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode05_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/C/Sup/gesamtsup_barcode05.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode06_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode06_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/C/Sup/gesamtsup_barcode06.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode07_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode07_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/C/Sup/gesamtsup_barcode07.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode08_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode08_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/C/Sup/gesamtsup_barcode08.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode09_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode09_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/C/Sup/gesamtsup_barcode09.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode10_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode10_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/C/Sup/gesamtsup_barcode10.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode11_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode11_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/C/Sup/gesamtsup_barcode11.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode12_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode12_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/C/Sup/gesamtsup_barcode12.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode13_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode13_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/C/Sup/gesamtsup_barcode13.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode14_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode14_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/C/Sup/gesamtsup_barcode14.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode15_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode15_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/C/Sup/gesamtsup_barcode15.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode16_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode16_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/C/Sup/gesamtsup_barcode16.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode17_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode17_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/C/Sup/gesamtsup_barcode17.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode18_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode18_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/C/Sup/gesamtsup_barcode18.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode19_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode19_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/C/Sup/gesamtsup_barcode19.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode20_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode20_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/C/Sup/gesamtsup_barcode20.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode21_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mC_5hmC --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode21_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/C/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/C/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/C/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/C/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/C/Sup/gesamtsup_barcode21.bed
















































pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode01_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode01_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/CG/Hac/gesamthac_barcode01.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode02_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode02_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/CG/Hac/gesamthac_barcode02.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode03_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode03_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/CG/Hac/gesamthac_barcode03.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode04_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode04_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/CG/Hac/gesamthac_barcode04.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode05_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode05_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/CG/Hac/gesamthac_barcode05.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode06_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode06_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/CG/Hac/gesamthac_barcode06.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode07_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode07_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/CG/Hac/gesamthac_barcode07.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode08_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode08_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/CG/Hac/gesamthac_barcode08.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode09_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode09_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/CG/Hac/gesamthac_barcode09.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode10_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode10_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/CG/Hac/gesamthac_barcode10.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode11_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode11_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/CG/Hac/gesamthac_barcode11.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode12_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode12_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/CG/Hac/gesamthac_barcode12.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode13_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode13_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/CG/Hac/gesamthac_barcode13.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode14_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode14_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/CG/Hac/gesamthac_barcode14.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode15_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode15_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/CG/Hac/gesamthac_barcode15.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode16_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode16_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/CG/Hac/gesamthac_barcode16.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode17_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode17_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/CG/Hac/gesamthac_barcode17.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode18_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode18_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/CG/Hac/gesamthac_barcode18.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode19_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode19_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/CG/Hac/gesamthac_barcode19.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode20_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode20_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/CG/Hac/gesamthac_barcode20.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode21_ed80ce94_acc03873_0.pod5
dorado basecaller hac --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode21_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/CG/Hac/gesamthac.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/CG/Hac/gesamtshac.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/CG/Hac/gesamthac.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/CG/Hac/gesamtshac.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/CG/Hac/gesamthac_barcode21.bed














pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode01_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode01_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode01/dorado1.0.2/CG/Sup/gesamtsup_barcode01.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode02_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode02_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode02/dorado1.0.2/CG/Sup/gesamtsup_barcode02.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode03_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode03_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode03/dorado1.0.2/CG/Sup/gesamtsup_barcode03.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode04_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode04_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode04/dorado1.0.2/CG/Sup/gesamtsup_barcode04.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode05_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode05_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode05/dorado1.0.2/CG/Sup/gesamtsup_barcode05.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode06_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode06_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode06/dorado1.0.2/CG/Sup/gesamtsup_barcode06.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode07_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode07_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode07/dorado1.0.2/CG/Sup/gesamtsup_barcode07.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode08_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode08_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode08/dorado1.0.2/CG/Sup/gesamtsup_barcode08.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode09_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode09_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode09/dorado1.0.2/CG/Sup/gesamtsup_barcode09.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode10_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode10_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode10/dorado1.0.2/CG/Sup/gesamtsup_barcode10.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode11_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode11_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode11/dorado1.0.2/CG/Sup/gesamtsup_barcode11.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode12_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode12_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode12/dorado1.0.2/CG/Sup/gesamtsup_barcode12.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode13_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode13_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode13/dorado1.0.2/CG/Sup/gesamtsup_barcode13.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode14_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode14_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode14/dorado1.0.2/CG/Sup/gesamtsup_barcode14.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode15_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode15_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode15/dorado1.0.2/CG/Sup/gesamtsup_barcode15.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode16_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode16_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode16/dorado1.0.2/CG/Sup/gesamtsup_barcode16.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode17_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode17_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode17/dorado1.0.2/CG/Sup/gesamtsup_barcode17.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode18_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode18_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode18/dorado1.0.2/CG/Sup/gesamtsup_barcode18.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode19_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode19_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode19/dorado1.0.2/CG/Sup/gesamtsup_barcode19.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode20_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode20_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode20/dorado1.0.2/CG/Sup/gesamtsup_barcode20.bed


pod5 inspect summary /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode21_ed80ce94_acc03873_0.pod5
dorado basecaller sup --modified-bases 5mCG_5hmCG --reference /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa /home/diablo/Desktop/Age_PT_new_basecalling/neues_PCR/Age_20250813_TitrMethylPCRD3_ONT_MR/pod5/PBE20325_pass_barcode21_ed80ce94_acc03873_0.pod5 > /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/CG/Sup/gesamtsup.bam
samtools faidx /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa
samtools sort --write-index -o /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/CG/Sup/gesamtssup.bam /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/CG/Sup/gesamtsup.bam
modkit pileup /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/CG/Sup/gesamtssup.bam --ref /home/diablo/Desktop/Age_20250326_TitrMethylPCR_ONT_IP_onlybams/HomoSapienshg38CLCGenomeChr.fa --max-depth 2047483647 /home/diablo/Einzel_Fast5_gesamt/PCR3/PCR3_barcode21/dorado1.0.2/CG/Sup/gesamtsup_barcode21.bed
