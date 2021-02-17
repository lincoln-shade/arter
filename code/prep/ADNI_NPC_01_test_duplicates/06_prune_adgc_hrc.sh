#!/bin/bash

# prune variants
plink \
  --bfile adgc_hrc.ADNI_NPC_N60 \
  --geno 0.01 \
  --indep-pairwise 15000 1500 0.2 \
  --out pruned2

# create fileset
plink \
  --bfile adgc_hrc.ADNI_NPC_N60 \
  --extract pruned2.prune.in \
  --make-bed \
  --geno 0.01 \
  --out adgc_hrc.ADNI_NPC_N60.pruned