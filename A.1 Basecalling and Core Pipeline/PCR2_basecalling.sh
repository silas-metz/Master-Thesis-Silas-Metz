dorado basecaller \
  sup \
  /path/to/input/pcr_run02/Converted.pod5 \
  --reference /path/to/reference/genome.fa \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/pcr_run02/basecalling/sup/C/gesamtsup.bam
  
dorado demux --kit-name SQK-NBD114-24 --no-trim --output-dir /path/to/output/pcr_run02/basecalling/sup/C/demux /path/to/output/pcr_run02/basecalling/sup/C/gesamtsup.bam


dorado basecaller \
  sup \
  /path/to/input/pcr_run02/Converted.pod5 \
  --reference /path/to/reference/genome.fa \
  --no-trim \
  --modified-bases 5mCG_5hmCG \
  --recursive \
  > /path/to/output/pcr_run02/basecalling/sup/CG/gesamtsup.bam
  
dorado demux --kit-name SQK-NBD114-24 --no-trim --output-dir /path/to/output/pcr_run02/basecalling/sup/CG/demux /path/to/output/pcr_run02/basecalling/sup/CG/gesamtsup.bam



dorado basecaller \
  hac \
  /path/to/input/pcr_run02/Converted.pod5 \
  --reference /path/to/reference/genome.fa \
  --no-trim \
  --modified-bases 5mC_5hmC \
  --recursive \
  > /path/to/output/pcr_run02/basecalling/hac/C/gesamtsup.bam
  
dorado demux --kit-name SQK-NBD114-24 --no-trim --output-dir /path/to/output/pcr_run02/basecalling/hac/C/demux /path/to/output/pcr_run02/basecalling/hac/C/gesamtsup.bam


dorado basecaller \
  hac \
  /path/to/input/pcr_run02/Converted.pod5 \
  --reference /path/to/reference/genome.fa \
  --no-trim \
  --modified-bases 5mCG_5hmCG \
  --recursive \
  > /path/to/output/pcr_run02/basecalling/hac/CG/gesamtsup.bam
  
dorado demux --kit-name SQK-NBD114-24 --no-trim --output-dir /path/to/output/pcr_run02/basecalling/hac/CG/demux /path/to/output/pcr_run02/basecalling/hac/CG/gesamtsup.bam
