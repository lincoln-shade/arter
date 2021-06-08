#!/bin/bash

#=======================
# rosmap unrelated
# logistic regression
#=======================

cat output/nacc/nacc.clumped | awk 'NR>1{print$3}' | sed -E 's/:[[:alpha:]]*:[[:alpha:]]*//' > data/tmp/nacc_top_snps.tmp

plink \
  --bfile data/rosmap/rosmap \
  --logistic hide-covar \
  --ci 0.95 \
  --pheno data/rosmap/rosmap_pheno.txt \
  --covar data/rosmap/rosmap_covar.txt \
  --allow-no-sex \
  --extract data/tmp/nacc_top_snps.tmp \
  --out output/rosmap/rosmap