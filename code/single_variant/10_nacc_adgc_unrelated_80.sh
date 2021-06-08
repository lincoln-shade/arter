#!/bin/bash

#=======================
# NACC/ADGC unrelated
# logistic regression
#=======================

plink \
  --bfile data/nacc_adgc/nacc_adgc_unrelated_80 \
  --logistic hide-covar \
  --ci 0.95 \
  --pheno data/nacc_adgc/nacc_adgc_unrelated_80_pheno.txt \
  --covar data/nacc_adgc/nacc_adgc_unrelated_80_covar.txt \
  --allow-no-sex \
  --out output/nacc_adgc/nacc_adgc_unrelated_80