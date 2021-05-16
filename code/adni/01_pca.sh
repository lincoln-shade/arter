#!/bin/bash

#=================================================
# perform PCA for mega-analysis on pruned dataset
#=================================================

# already have pruned dataset from checking for duplicates, so just run
# PCA on that dataset

plink \
  --bfile data/ADNI_NPC/nacc.rosmap.ADNI_NPC_N60.pruned \
  --remove data/ADNI_NPC/ADNI_duplicate_IDs.txt \
  --pca 5 \
  --out data/ADNI_NPC/nacc.rosmap.ADNI_NPC_N60.pca