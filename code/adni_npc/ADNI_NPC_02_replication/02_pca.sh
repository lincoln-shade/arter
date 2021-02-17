#!/bin/bash

#===================================
# prune and perform pca on ADNI_NPC
#===================================

plink \
  --bfile raw_data/ADNI_NPC/N60/ADNI_NPC_N60 \
  --remove data/ADNI_NPC/ADNI_duplicate_IDs.txt \
  --indep-pairwise 15000 1500 0.2 \
  --make-bed \
  --out data/ADNI_NPC/ADNI_NPC_pruned

plink \
  --bfile raw_data/ADNI_NPC/N60/ADNI_NPC_N60 \
  --remove data/ADNI_NPC/ADNI_duplicate_IDs.txt \
  --extract data/ADNI_NPC/ADNI_NPC_pruned.prune.in \
  --pca 5 \
  --out data/ADNI_NPC/ADNI_NPC_pca