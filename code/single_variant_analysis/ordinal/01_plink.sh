#!/bin/bash

bfile=/data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced
keep=01_data/data/pheno.txt
plink \
      --bfile $bfile \
      --keep $keep \
      --allow-no-sex \
      --maf 0.05 --geno 0.05 --hwe 0.000001 \
      --mind 0.05 \
      --make-bed \
      --out 02_analysis/ordinal/plink/plink