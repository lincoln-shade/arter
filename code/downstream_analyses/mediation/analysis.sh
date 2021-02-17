#!/bin/bash

bfile=/data_global/ADGC_HRC/converted/unrelated/adgc_hrc_merged_unrelated
pheno=01_data/pheno.txt
covar=01_data/covar.txt

plink19b610 \
  --bfile $bfile \
  --pheno $pheno \
  --covar $covar \
  --logistic \
  --geno 0.1 --hwe 0.000001 --maf 0.05 \
  --allow-no-sex \
  --out 02_analysis/analysis