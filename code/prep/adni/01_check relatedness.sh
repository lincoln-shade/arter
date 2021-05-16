#!/bin/bash

#=============================================================
# check relatedness between adni npc, nacc, and rosmap
# and merge the data sets
#=============================================================

# harmonize variants
awk '{print$2}' data/nacc_rosmap/nacc_rosmap.bim > data/tmp/nacc_rosmap_vars.tmp

plink \
  --bfile raw_data/ADNI_NPC/N60/ADNI_NPC_N60 \
  --extract data/tmp/nacc_rosmap_vars.tmp \
  --make-bed \
  --biallelic-only strict \
  --out data/tmp/adni_1.tmp

awk '{print$2}' data/tmp/adni_1.tmp.bim > data/tmp/adni_1_vars.tmp
cat data/tmp/adni_1_vars.tmp | cut -f 2 | sort | uniq -d > data/tmp/adni_1_dup_vars.tmp

plink \
  --bfile data/tmp/adni_1.tmp \
  --exclude data/tmp/adni_1_dup_vars.tmp \
  --make-bed \
  --biallelic-only strict \
  --out data/tmp/adni_2.tmp

awk '{print$2}' data/tmp/adni_2.tmp.bim > data/tmp/adni_2_vars.tmp

plink \
  --bfile data/nacc_rosmap/nacc_rosmap \
  --extract data/tmp/adni_2_vars.tmp \
  --make-bed \
  --out data/tmp/nacc_rosmap_1.tmp

plink \
  --bfile data/tmp/adni_2.tmp \
  --a1-allele data/tmp/nacc_rosmap_1.tmp.bim 5 2 \
  --make-bed \
  --out data/tmp/adni_3.tmp

# two bim files are identical, so map is already synced
sort data/tmp/adni_3.tmp.bim data/tmp/nacc_rosmap_1.tmp.bim | uniq -d | wc -l
wc -l data/tmp/adni_3.tmp.bim

# merge
plink \
  --bfile data/tmp/nacc_rosmap_1.tmp \
  --bmerge data/tmp/adni_3.tmp \
  --make-bed \
  --out data/tmp/nacc_rosmap_adni_merged.tmp

# prune
plink \
  --bfile data/tmp/nacc_rosmap_adni_merged.tmp \
  --indep-pairwise 15000 1500 0.2 \
  --out data/tmp/nacc_rosmap_adni_merged_prune.tmp

plink \
  --bfile data/tmp/nacc_rosmap_adni_merged.tmp \
  --genome \
  --extract data/tmp/nacc_rosmap_adni_merged_prune.tmp.prune.in \
  --min 0.18 \
  --out data/tmp/nacc_rosmap_adni_related.tmp

# all adni fids and iids are in cols 1 and 2
awk '(NR>1)' data/tmp/nacc_rosmap_adni_related.tmp.genome | awk '{print$1,$2}' > data/adni_npc/adni_nacc_dup_ids.txt

plink \
  --bfile data/tmp/nacc_rosmap_adni_merged.tmp \
  --remove data/adni_npc/adni_nacc_dup_ids.txt \
  --make-bed \
  --out data/adni_npc/nacc_rosmap_adni_unrelated

#only 13 people removed, no need to redo ld pruning
plink \
  --bfile data/adni_npc/nacc_rosmap_adni_unrelated \
  --extract data/tmp/nacc_rosmap_adni_merged_prune.tmp.prune.in \
  --pca 5 \
  --out data/adni_npc/nacc_rosmap_adni_unrelated_pca
  
