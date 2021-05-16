#!/bin/bash

#=======================
# rosmap unrelated
# logistic regression
#=======================

plink \
  --bfile data/rosmap/rosmap_unrelated \
  --logistic hide-covar \
  --ci 0.95 \
  --pheno data/rosmap/rosmap_unrelated_pheno.txt \
  --covar data/rosmap/rosmap_unrelated_covar.txt \
  --allow-no-sex \
  --out output/rosmap/rosmap_unrelated