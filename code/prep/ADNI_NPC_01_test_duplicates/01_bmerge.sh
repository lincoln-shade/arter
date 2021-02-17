#!/bin/bash

# create missnp file
plink \
  --bfile ../../NACC.ROSMAP.meta/01_data/merged/plink \
  --bmerge /data_global/ADNI_NPC/N60/ADNI_NPC_N60 \
  --make-bed

# exclude missnp snps from nacc.rosmap fileset
plink \
  --bfile ../../NACC.ROSMAP.meta/01_data/merged/plink \
  --exclude plink-merge.missnp \
  --make-bed \
  --out  nacc.rosmap.tmp

# exclude missnp snps from ADNI fileset
plink \
  --bfile /data_global/ADNI_NPC/N60/ADNI_NPC_N60 \
  --exclude plink-merge.missnp \
  --make-bed \
  --out  ADNI_NPC_N60.tmp

# merge
plink \
  --bfile nacc.rosmap.tmp \
  --bmerge ADNI_NPC_N60.tmp \
  --make-bed \
  --out nacc.rosmap.ADNI_NPC_N60