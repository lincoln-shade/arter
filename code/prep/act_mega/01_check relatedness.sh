#!/bin/bash

#=============================================================
# check relatedness between act and nacc+rosmap+adni
# and merge the datasets
#=============================================================

# harmonize variants
awk '{print$2}' data/adni_npc/act_mega_unrelated.bim > data/tmp/nacc_rosmap_adni_vars.tmp

plink \
  --bfile data/act/act \
  --extract data/tmp/nacc_rosmap_adni_vars.tmp \
  --make-bed \
  --out data/tmp/act_mega_1.tmp

awk '{print$2}' data/tmp/act_mega_1.tmp.bim > data/tmp/act_mega_1_vars.tmp
cat data/tmp/act_mega_1_vars.tmp | cut -f 2 | sort | uniq -d > data/tmp/act_mega_1_dup_vars.tmp

plink \
  --bfile data/tmp/act_mega_1.tmp \
  --exclude data/tmp/act_mega_1_dup_vars.tmp \
  --make-bed \
  --out data/tmp/act_mega_2.tmp

awk '{print$2}' data/tmp/act_mega_2.tmp.bim > data/tmp/act_mega_2_vars.tmp

plink \
  --bfile data/adni_npc/act_mega_unrelated \
  --extract data/tmp/act_mega_2_vars.tmp \
  --make-bed \
  --out data/tmp/adni_mega_1.tmp

# align A1 alleles
plink \
  --bfile data/tmp/act_mega_2.tmp \
  --a1-allele data/tmp/adni_mega_1.tmp.bim 5 2 \
  --make-bed \
  --out data/tmp/act_mega_3.tmp

# try flipping variants that don't align
sort data/tmp/act_mega_3.tmp.bim data/tmp/adni_mega_1.tmp.bim | uniq -c | awk '$1==1{print$3}' | uniq -d > data/tmp/act_mega_flip_vars.tmp

plink \
  --bfile data/tmp/act_mega_3.tmp \
  --flip data/tmp/act_mega_flip_vars.tmp \
  --a1-allele data/tmp/adni_mega_1.tmp.bim 5 2 \
  --make-bed \
  --out data/tmp/act_mega_4.tmp

# most variants fixed by flipping, 9 were not
# remove variants that have different A1 alleles between two sets
sort data/tmp/act_mega_4.tmp.bim data/tmp/adni_mega_1.tmp.bim | uniq -c | awk '$1==1{print$3}' | uniq -d > data/tmp/act_mega_exclude_vars.tmp
wc -l data/tmp/act_mega_4.tmp.bim

plink \
  --bfile data/tmp/act_mega_4.tmp \
  --exclude data/tmp/act_mega_exclude_vars.tmp \
  --a1-allele data/tmp/adni_mega_1.tmp.bim 5 2 \
  --make-bed \
  --out data/tmp/act_mega_5.tmp

plink \
  --bfile data/tmp/adni_mega_1.tmp \
  --exclude data/tmp/act_mega_exclude_vars.tmp \
  --make-bed \
  --out data/tmp/adni_mega_2.tmp

sort data/tmp/act_mega_5.tmp.bim data/tmp/adni_mega_2.tmp.bim | uniq -d | wc -l
wc -l data/tmp/act_mega_5.tmp.bim
# all strand issues fixed

# merge
plink \
  --bfile data/tmp/adni_mega_2.tmp \
  --bmerge data/tmp/act_mega_5.tmp \
  --make-bed \
  --out data/tmp/act_mega_merged.tmp

# king -b data/tmp/act_mega_merged.tmp.bed --kinship --degree 2

plink \
  --bfile data/tmp/act_mega_merged.tmp \
  --genome \
  --min 0.18 \
  --out data/tmp/act_mega_merge_related.tmp

# all ACT fids and iids are in cols 1 and 2
# 4 duplicates, 2 1st-degree relatives
awk '(NR>1)' data/tmp/act_mega_merge_related.tmp.genome | awk '{print$1,$2}' > data/tmp/act_mega_dup_ids.txt

plink \
  --bfile data/tmp/act_mega_merged.tmp \
  --remove data/tmp/act_mega_dup_ids.txt \
  --make-bed \
  --out data/act/act_mega

# prune
plink \
  --bfile data/act/act_mega \
  --indep-pairwise 15000 1500 0.2 \
  --out data/tmp/act_mega_prune.tmp

plink \
  --bfile data/act/act_mega \
  --extract data/tmp/act_mega_prune.tmp.prune.in \
  --pca 5 \
  --out data/act/act_mega_pca
  
