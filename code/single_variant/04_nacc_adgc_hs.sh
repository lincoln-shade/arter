#!/bin/bash

#========================================
# check association of top snps with HS
#========================================

cat output/nacc_adgc/nacc_adgc_unrelated.clumped | awk 'NR>1{print$3}' > output/nacc_adgc/top_snps.txt

plink \
  --bfile data/nacc_adgc/nacc_adgc_unrelated \
  --pheno data/nacc_adgc/nacc_adgc_hs_pheno.txt \
  --covar data/nacc_adgc/nacc_adgc_hs_covar.txt \
  --extract output/nacc_adgc/top_snps.txt \
  --logistic hide-covar \
  --ci 0.95 \
  --allow-no-sex \
  --out output/nacc_adgc/nacc_adgc_hs_top
  