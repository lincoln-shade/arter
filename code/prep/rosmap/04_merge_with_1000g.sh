#!/bin/bash

#=================================
# Step 3: Merge with 1000 genomes
#=================================

#---------------------------------------
# Sync variant IDs between filesets
#---------------------------------------

# create plink fileset with only biallelic variants
plink \
  --bfile data/tmp/rosmap_3.tmp \
  --biallelic-only strict \
  --make-bed \
  --out data/tmp/rosmap_3_1.tmp

# write duplicate variant ids to file
cat data/tmp/rosmap_3_1.tmp.bim | cut -f 2 | sort | uniq -d > data/tmp/rosmap_3_1_dups.tmp.txt

# create plink fileset with only biallelic variants
plink \
  --bfile data/tmp/rosmap_3_1.tmp \
  --biallelic-only strict \
  --exclude data/tmp/rosmap_3_1_dups.tmp.txt \
  --make-bed \
  --out data/tmp/rosmap_3_1a.tmp

# create list of SNPs from QCed rosmap
awk '{print$2}' data/tmp/rosmap_3_1a.tmp.bim > data/tmp/rosmap_3_1a_vars.tmp.txt

# create 1000g fileset with rosmap snps
plink \
  --bfile data/1000g/1000g \
  --extract data/tmp/rosmap_3_1a_vars.tmp.txt \
  --make-bed \
  --biallelic-only strict \
  --out data/tmp/1000g1.tmp

# create list of filtered 1000g snps
awk '{print$2}' data/tmp/1000g1.tmp.bim > data/tmp/1000g1_vars.tmp.txt

# create rosmap fileset with filtered 1000g snps
plink \
  --bfile data/tmp/rosmap_3_1a.tmp \
  --biallelic-only strict \
  --extract data/tmp/1000g1_vars.tmp.txt \
  --make-bed \
  --out data/tmp/rosmap_3_1b.tmp

# now both filesets have the exact same variant ids

#------------------------------------------
# Ensure both filesets have same build
#------------------------------------------
# sync BPs between filesets
plink \
  --bfile data/tmp/1000g1.tmp \
  --update-map data/tmp/rosmap_3_1b.tmp.bim 4 2 \
  --make-bed \
  --out data/tmp/1000g2.tmp

#---------------------------------------------
# ensure all variants have same A1/A2 alleles
#---------------------------------------------

# 1 set reference genome to rosmap alleles
plink \
  --bfile data/tmp/1000g2.tmp \
  --a1-allele data/tmp/rosmap_3_1b.tmp.bim 5 2 \
  --make-bed \
  --out data/tmp/1000g3.tmp

# 2 try to resolve strand issues
awk '{print$2,$5,$6}' data/tmp/rosmap_3_1b.tmp.bim > data/tmp/rosmap_3_1b_var.tmp.txt
awk '{print$2,$5,$6}' data/tmp/1000g3.tmp.bim > data/tmp/1000g3_var.tmp.txt
sort data/tmp/rosmap_3_1b_var.tmp.txt data/tmp/1000g3_var.tmp.txt |uniq -u > data/tmp/rosmap_3_1b_1000g3_var_diff.tmp.txt

awk '{print$1}' data/tmp/rosmap_3_1b_1000g3_var_diff.tmp.txt | sort -u > data/tmp/rosmap_1000g_flip_list.tmp.txt

plink \
  --bfile data/tmp/1000g3.tmp \
  --flip data/tmp/rosmap_1000g_flip_list.tmp.txt \
  --a1-allele data/tmp/rosmap_3_1b.tmp.bim 5 2 \
  --make-bed \
  --out data/tmp/1000g4.tmp

awk '{print$2,$5,$6}' data/tmp/1000g4.tmp.bim > data/tmp/1000g4_var.tmp.txt
sort data/tmp/rosmap_3_1b_var.tmp.txt data/tmp/1000g4_var.tmp.txt |uniq -u  > data/tmp/rosmap_1000g_uncorrected_var.tmp.txt

# none of the variants were fixed by flipping.

# 3 remove uncorrected variants
awk '{print$1}' data/tmp/rosmap_1000g_uncorrected_var.tmp.txt | sort -u > data/tmp/rosmap_1000g_exclude_var.tmp.txt

plink \
  --bfile data/tmp/rosmap_3_1b.tmp \
  --exclude data/tmp/rosmap_1000g_exclude_var.tmp.txt \
  --make-bed \
  --out data/tmp/rosmap_3_1c.tmp

plink \
  --bfile data/tmp/1000g4.tmp \
  --exclude data/tmp/rosmap_1000g_exclude_var.tmp.txt \
  --make-bed \
  --out data/tmp/1000g5.tmp

#---------------------------
# merge rosmap and 1000g
#---------------------------

# merge
plink \
  --bfile data/tmp/rosmap_3_1c.tmp \
  --bmerge data/tmp/1000g5.tmp \
  --allow-no-sex \
  --make-bed \
  --out data/tmp/rosmap_1000g_merged

# prune
plink \
  --bfile data/tmp/rosmap_1000g_merged \
  --indep-pairwise 15000 1500 0.2 \
  --out data/tmp/rosmap_1000g_merged_prune

# pca
plink \
  --bfile data/tmp/rosmap_1000g_merged \
  --no-pheno \
  --extract data/tmp/rosmap_1000g_merged_prune.prune.in \
  --pca 2 \
  --out data/tmp/rosmap_1000g_merged_pca
  