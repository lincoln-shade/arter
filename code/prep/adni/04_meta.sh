#!/bin/bash

#================================================
# ADNI NPC and NACC/ADGC and ROSMAP meta-analysis
#================================================

# create plink output for ADNI_NPC
plink \
  --bfile raw_data/ADNI_NPC/N60/ADNI_NPC_N60 \
  --pheno data/ADNI_NPC/adni.nacc.rosmap.pheno.txt \
  --covar data/ADNI_NPC/adni.nacc.rosmap.covar.txt \
  --covar-number 1,4,11-15 \
  --extract data/ADNI_NPC/snps_test_replication.txt \
  --logistic hide-covar \
  --ci 0.95 \
  --out output/ADNI_NPC/top_replication

plink \
  --meta-analysis output/ADNI_NPC/top_replication.assoc.logistic \
      NACC.ROSMAP.meta/02_analysis/logistic/mega.assoc.logistic \
  --out output/ADNI_NPC/meta.top