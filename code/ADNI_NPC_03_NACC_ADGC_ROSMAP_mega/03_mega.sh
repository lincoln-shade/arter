#!/bin/bash

#=================================================
# perform logistic regression for mega-analysis
# for top SNPs rs2603462 and rs7902929
#=================================================

# top snps

plink \
  --bfile data/ADNI_NPC/nacc.rosmap.ADNI_NPC_N60 \
  --logistic hide-covar \
  --pheno data/ADNI_NPC/adni.nacc.rosmap.pheno.txt \
  --covar data/ADNI_NPC/adni.nacc.rosmap.covar.txt \
  --extract data/ADNI_NPC/snps_test_replication.txt \
  --allow-no-sex \
  --ci 0.95 \
  --out output/ADNI_NPC/nacc.rosmap.ADNI_NPC_N60.mega.top

# use only 3 PCs
# P-values even larger

plink \
  --bfile data/ADNI_NPC/nacc.rosmap.ADNI_NPC_N60 \
  --logistic hide-covar \
  --pheno data/ADNI_NPC/adni.nacc.rosmap.pheno.txt \
  --covar data/ADNI_NPC/adni.nacc.rosmap.covar.txt \
  --covar-number 1-13 \
  --extract data/ADNI_NPC/snps_test_replication.txt \
  --allow-no-sex \
  --ci 0.95 \
  --out output/ADNI_NPC/nacc.rosmap.ADNI_NPC_N60.mega.top.3pcs
  
plink \
  --bfile data/ADNI_NPC/nacc.rosmap.ADNI_NPC_N60 \
  --logistic hide-covar \
  --pheno data/ADNI_NPC/adni.nacc.rosmap.pheno.txt \
  --covar data/ADNI_NPC/adni.nacc.rosmap.covar.txt \
  --geno 0.05 \
  --hwe 1e-6 \
  --maf 0.05 \
  --allow-no-sex \
  --ci 0.95 \
  --out output/ADNI_NPC/nacc.rosmap.ADNI_NPC_N60.mega