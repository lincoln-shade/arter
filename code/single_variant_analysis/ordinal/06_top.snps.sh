#!/bin/bash

##-------------------------------
## get r^2 matrix of top SNPs
##-------------------------------

# note that default for --r2 is to remove all variant pairs that have r2 < 0.2 from the report

plink \
  --bfile /data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced \
  --keep 01_data/data/pheno.txt \
  --clump 02_analysis/ordinal/ordinal.assoc.logistic \
  --clump-p1 0.00001 \
  --clump-r2 0.05 \
  --out 02_analysis/ordinal/plink