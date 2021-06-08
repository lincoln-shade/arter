#!/bin/bash

#=======================
# NACC/ADGC unrelated
# logistic regression
#=======================

plink \
  --bfile data/nacc/nacc \
  --logistic hide-covar \
  --ci 0.95 \
  --pheno data/nacc/nacc_pheno.txt \
  --covar data/nacc/nacc_covar.txt \
  --allow-no-sex \
  --out output/nacc/nacc

bash code/single_variant/clump_top_snps.sh data/nacc/nacc output/nacc/nacc.assoc.logistic output/nacc/nacc