#!/bin/bash

#----------------------------------------
# keep european participants and
# run PCA on them
#----------------------------------------

# 1 create final plink fileset to use for analyses

# keep only european subjects
plink \
  --bfile data/tmp/act_qc4.tmp \
  --keep data/act/act_qced.txt \
  --make-bed \
  --out data/tmp/act_qc4.tmp

# one final pass at variant QC
plink \
  --bfile data/tmp/act_qc4.tmp \
  --maf 0.05 \
  --geno 0.05 \
  --hwe 1e-6 midp include-nonctrl \
  --make-bed \
  --out data/act/act

# 2 perform pca

# create list of pruned.in snps
plink \
  --bfile data/act/act \
  --no-pheno \
  --indep-pairwise 15000 1500 0.2 \
  --out data/tmp/act.tmp
  

plink \
  --bfile data/act/act \
  --allow-no-sex \
  --no-pheno \
  --pca 5 \
  --extract data/tmp/act.tmp.prune.in \
  --out data/act/act_pca

# remove all of the tmp act tmp files in data/tmp
rm data/tmp/act*.tmp*
rm data/tmp/act*merged*
rm data/tmp/1000g*.tmp*


