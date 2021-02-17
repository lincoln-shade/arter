#!/bin/bash

# create missnp file
plink \
  --bed /data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced.bed \
  --bim ADGC_HRC_strip_alleles.bim \
  --fam /data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced.fam \
  --bmerge /data_global/ADNI_NPC/N60/ADNI_NPC_N60 \
  --make-bed \
  --out plink2

# exclude missnp snps from nacc.rosmap fileset
plink \
  --bed /data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced.bed \
  --bim ADGC_HRC_strip_alleles.bim \
  --fam /data_global/ADGC_HRC/converted/full/adgc_hrc_merged_qced.fam \
  --exclude plink2-merge.missnp \
  --make-bed \
  --out adgc_hrc.tmp

# exclude missnp snps from ADNI fileset
plink \
  --bfile /data_global/ADNI_NPC/N60/ADNI_NPC_N60 \
  --exclude plink2-merge.missnp \
  --make-bed \
  --out  ADNI_NPC_N60.tmp2

# merge
plink \
  --bfile adgc_hrc.tmp \
  --bmerge ADNI_NPC_N60.tmp2 \
  --make-bed \
  --out adgc_hrc.ADNI_NPC_N60