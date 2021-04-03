#!/bin/bash

#---------------------------------
# create .raw file for top snps
#---------------------------------

cat output/nacc_adgc/nacc_adgc_unrelated.clumped | awk 'NR>1{print$3}' > data/nacc_adgc/nacc_adgc_unrelated_top.txt

plink \
  --bfile data/nacc_adgc/nacc_adgc_unrelated \
  --extract data/nacc_adgc/nacc_adgc_unrelated_top.txt \
  --recode A \
  --out data/nacc_adgc/nacc_adgc_unrelated_top