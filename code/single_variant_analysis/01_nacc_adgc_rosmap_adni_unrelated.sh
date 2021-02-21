#!/bin/bash

plink \
  --bfile data/adni_npc/nacc_adgc_rosmap_adni_unrelated \
  --logistic hide-covar \
  --ci 0.95 \
  --pheno data/adni_npc/nacc_adgc_rosmap_adni_unrelated.pheno \
  --covar data/adni_npc/nacc_adgc_rosmap_adni_unrelated.covar \
  --allow-no-sex \
  --out output/adni_npc/nacc_adgc_rosmap_adni_unrelated