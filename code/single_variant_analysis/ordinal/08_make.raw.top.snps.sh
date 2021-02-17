#!/bin/bash

##--------------------------------------------
## make .raw file for top snps for brant test
##--------------------------------------------

# note that default for --r2 is to remove all variant pairs that have r2 < 0.2 from the report

plink \
  --bfile /data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced \
  --keep 01_data/data/pheno.txt \
  --extract 02_analysis/ordinal/indep.top.snps.txt \
  --recode A \
  --out 02_analysis/ordinal/top.snps