#!/bin/bash

##------------------------------------------------------------------------
## Analyze top SNPs from Chou et al in NACC subjects
##------------------------------------------------------------------------

fileset=/data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced
pheno=01_data/data/pheno.txt
covar=01_data/data/covar.txt

plink \
  --bfile $fileset \
  --snps rs864745:T:C, rs7193343:T:C, rs7961581:C:T, rs5215:C:T, rs11206510:T:C, rs7395662:A:G \
  --pheno $pheno \
  --covar $covar \
  --allow-no-sex \
  --logistic hide-covar \
  --geno 0.1 --hwe 0.000001 --maf 0.05 \
  --out 02_analysis/chou.snps/chou.snps