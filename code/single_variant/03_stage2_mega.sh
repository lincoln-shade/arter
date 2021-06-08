#!/bin/bash

#=======================
# NACC/ADGC unrelated
# logistic regression
#=======================

plink \
  --bfile data/nacc_rosmap/nacc_rosmap \
  --logistic hide-covar \
  --ci 0.95 \
  --pheno data/nacc_rosmap/nacc_rosmap_pheno.txt \
  --covar data/nacc_rosmap/nacc_rosmap_covar.txt \
  --allow-no-sex \
  --out output/nacc_rosmap/nacc_rosmap