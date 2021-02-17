#!/bin/bash 

#==========================================
# make .raw file for rs2603462 & rs7902929
# and remove duplicate IDs
#==========================================

plink \
  --bfile raw_data/ADNI_NPC/N60/ADNI_NPC_N60 \
  --remove data/ADNI_NPC/ADNI_duplicate_IDs.txt \
  --extract data/ADNI_NPC/snps_test_replication.txt \
  --recode A \
  --out data/ADNI_NPC/ADNI_NPC_N47_top 