#!/bin/bash

#=======================
# NACC/ADGC unrelated
# logistic regression
#=======================

plink \
  --bfile data/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated \
  --logistic hide-covar \
  --ci 0.95 \
  --pheno data/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated.pheno.txt \
  --covar data/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated.covar.txt \
  --allow-no-sex \
  --out output/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated