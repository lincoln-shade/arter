#!/bin/bash

# prune variants
plink \
  --bfile data/ADNI_NPC/nacc.rosmap.ADNI_NPC_N60 \
  --geno 0.01 \
  --indep-pairwise 15000 1500 0.2 \
  --out data/ADNI_NPC/pruned

# create fileset
plink \
  --bfile data/ADNI_NPC/nacc.rosmap.ADNI_NPC_N60 \
  --extract data/ADNI_NPC/pruned.prune.in \
  --make-bed \
  --geno 0.01 \
  --out data/ADNI_NPC/nacc.rosmap.ADNI_NPC_N60.pruned