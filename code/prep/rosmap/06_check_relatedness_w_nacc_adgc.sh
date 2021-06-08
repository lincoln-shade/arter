#!/bin/bash

#===============================================================
# Step 4: merge rosmap with nacc and check for relatedness
#===============================================================

# create rosmap fileset with only european ids (which is all of them...)
plink \
  --bfile data/tmp/rosmap_3_1c.tmp \
  --keep data/tmp/rosmap.tmp.txt \
  --make-bed \
  --out data/tmp/rosmap_4.tmp

# print rosmap variants
awk '{print$2}' data/tmp/rosmap_3_1c.tmp.bim > data/tmp/rosmap_var.tmp.txt

# need to remove :A1:A2 from nacc variant IDs
cat data/nacc/nacc.bim | awk 'gsub(/:[ACTG]*:[ACTG]*/, "", $2)' > data/tmp/nacc_varID_noA1A2.tmp.bim

# nacc w rosmap vars
plink \
  --bfile data/nacc/nacc \
  --bim data/tmp/nacc_varID_noA1A2.tmp.bim \
  --extract data/tmp/rosmap_var.tmp.txt \
  --make-bed \
  --out data/tmp/nacc_1.tmp


# rosmap with filtered nacc vars
awk '{print$2}' data/tmp/nacc_1.tmp.bim > data/tmp/nacc_var.tmp.txt

plink \
  --bfile data/tmp/rosmap_4.tmp \
  --extract data/tmp/nacc_var.tmp.txt \
  --make-bed \
  --out data/tmp/rosmap_4a.tmp

#------------------------------------------
# Ensure both filesets have same build
#------------------------------------------
# sync BPs between filesets
plink \
  --bfile data/tmp/nacc_1.tmp \
  --update-map data/tmp/rosmap_4a.tmp.bim 4 2 \
  --make-bed \
  --out data/tmp/nacc_1a.tmp

#---------------------------------------------
# ensure all variants have same A1/A2 alleles
#---------------------------------------------

# 1 set reference genome to rosmap alleles
plink \
  --bfile data/tmp/nacc_1a.tmp \
  --a1-allele data/tmp/rosmap_4a.tmp.bim 5 2 \
  --make-bed \
  --out data/tmp/nacc_1b.tmp

# no strand issues, so can proceed straight to merging

#---------------------------
# merge rosmap and 1000g
#---------------------------

# merge
plink \
  --bfile data/tmp/rosmap_4a.tmp \
  --bmerge data/tmp/nacc_1a.tmp \
  --allow-no-sex \
  --make-bed \
  --out data/tmp/rosmap_nacc_merged

# this dataset should also serve as basis for mega-analysis, after removing related ids.
# need to not delete

#-----------------------------------------
# identify and remove related rosmap ids
#-----------------------------------------

plink \
  --bfile data/tmp/rosmap_nacc_merged \
  --indep-pairwise 15000 1500 0.2 \
  --out data/tmp/rosmap_nacc_merged_prune

plink \
  --bfile data/tmp/rosmap_nacc_merged \
  --extract data/tmp/rosmap_nacc_merged_prune.prune.in \
  --genome \
  --min 0.18 \
  --out data/tmp/rosmap_nacc_merged_related.tmp

Rscript code/prep/rosmap/06a_check_relatedness.R

plink \
  --bfile data/tmp/rosmap_4.tmp \
  --remove data/tmp/rosmap_nacc_related_remove.tmp.txt \
  --make-bed \
  --out data/tmp/rosmap_5.tmp

#-----------------------------------------------------------------
# remove related ids for merged dataset to prep for mega-analysis
#-----------------------------------------------------------------

plink \
  --bfile data/tmp/rosmap_nacc_merged \
  --remove data/tmp/rosmap_nacc_related_remove.tmp.txt \
  --make-bed \
  --out data/tmp/nacc_rosmap.tmp

  