#!/bin/bash

#----------------------------------------
# keep european participants and
# run PCA on them
#----------------------------------------

# 1 create final plink fileset to use for analyses

# keep only european subjects
plink \
  --bfile data/tmp/nacc_adgc_unrelated_qc3.tmp \
  --keep data/nacc_adgc/nacc_adgc_unrelated_80_qced.txt \
  --make-bed \
  --out data/tmp/nacc_adgc_unrelated_qc4.tmp

# one final pass at variant QC
plink \
  --bfile data/tmp/nacc_adgc_unrelated_qc4.tmp \
  --maf 0.05 \
  --geno 0.05 \
  --hwe 1e-6 midp include-nonctrl \
  --make-bed \
  --out data/nacc_adgc/nacc_adgc_unrelated_80

# 2 perform pca

# create list of pruned.in snps
plink \
  --bfile data/nacc_adgc/nacc_adgc_unrelated_80 \
  --no-pheno \
  --indep-pairwise 15000 1500 0.2 \
  --out data/tmp/nacc_adgc_unrelated.tmp
  

plink \
  --bfile data/nacc_adgc/nacc_adgc_unrelated_80 \
  --allow-no-sex \
  --no-pheno \
  --pca 5 \
  --extract data/tmp/nacc_adgc_unrelated.tmp.prune.in \
  --out data/nacc_adgc/nacc_adgc_unrelated_pca_80

# # remove all of the tmp nacc_adgc tmp files in data/tmp
# rm data/tmp/nacc_adgc*.tmp*
# rm data/tmp/nacc_adgc*merged*
# rm data/tmp/1000g*.tmp*


