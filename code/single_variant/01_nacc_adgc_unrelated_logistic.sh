#!/bin/bash

#=======================
# NACC/ADGC unrelated
# logistic regression
#=======================

plink \
  --bfile data/nacc_adgc/nacc_adgc_unrelated \
  --logistic hide-covar \
  --ci 0.95 \
  --pheno data/nacc_adgc/nacc_adgc_unrelated_pheno.txt \
  --covar data/nacc_adgc/nacc_adgc_unrelated_covar.txt \
  --allow-no-sex \
  --out output/nacc_adgc/nacc_adgc_unrelated