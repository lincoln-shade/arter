#!/bin/bash

#----------------------------------------
# keep european participants and
# run PCA on them
#----------------------------------------

# 1 create final plink fileset to use for analyses

# keep only european subjects
plink \
  --bfile data/tmp/nacc_adgc_qc3.tmp \
  --keep data/nacc_adgc/nacc_adgc_related_qced.txt \
  --make-bed \
  --out data/tmp/nacc_adgc_qc4.tmp

# one final pass at variant QC
plink \
  --bfile data/tmp/nacc_adgc_qc4.tmp \
  --maf 0.05 \
  --geno 0.05 \
  --hwe 1e-6 midp include-nonctrl \
  --make-bed \
  --out data/nacc_adgc/nacc_adgc_related

# create pruned dataset for PC-AiR
# prune
plink \
  --bfile data/nacc_adgc/nacc_adgc_related \
  --indep-pairwise 15000 1500 0.2 \
  --out data/nacc_adgc/nacc_adgc_related_pruned

plink \
  --bfile data/nacc_adgc/nacc_adgc_related \
  --extract data/nacc_adgc/nacc_adgc_related_pruned.prune.in \
  --make-bed \
  --out data/nacc_adgc/nacc_adgc_related_pruned

# create fileset with only top snps from unrelated regression
cat output/nacc_adgc/nacc_adgc_unrelated.clumped | awk 'NR>1{print$3}' > data/nacc_adgc/nacc_adgc_unrelated_top.txt

plink \
  --bfile data/nacc_adgc/nacc_adgc_related \
  --extract data/nacc_adgc/nacc_adgc_unrelated_top.txt \
  --make-bed \
  --out data/nacc_adgc/nacc_adgc_related_top
