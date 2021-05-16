#!/bin/bash

for adc in {1..7}
  do
  plink19b3x \
    --bfile /data_global/ADGC_HRC/converted/unrelated/adgc_hrc_merged_unrelated \
    --pheno phe/ADC${adc}.phe --covar phe/ADC${adc}.covar --logistic hide-covar \
    --out log/ADC.${adc} --geno 0.1 --hwe 0.000001 --maf 0.05 --allow-no-sex  \
    --ci 0.95
  done