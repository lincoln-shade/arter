#!/bin/bash

#==========================================
# check relatedness in ROSMAP dataset
# and perform other QC measures
#==========================================

# copy original fileset to tmp fileset for alteration
cp /data_global/ROSMAP/rare_imputed_resilience/ROSMAP_rare_imputed_final.bed data/tmp/rosmap.tmp.bed
cp /data_global/ROSMAP/rare_imputed_resilience/ROSMAP_rare_imputed_final.bim data/tmp/rosmap.tmp.bim
cp /data_global/ROSMAP/rare_imputed_resilience/ROSMAP_rare_imputed_final.fam data/tmp/rosmap.tmp.fam

# script to fix iids to match neuropath file
Rscript code/prep/rosmap/02a_fix_iids.R

# create PLINK fileset of participants with B-ASC phenotyping
plink \
  --bfile data/tmp/rosmap.tmp \
  --fam data/tmp/rosmap_fixed_iids.tmp.fam \
  --keep data/tmp/rosmap_ids.tmp.txt \
  --make-bed \
  --out data/tmp/rosmap_1.tmp

#-------------------------------------------------------------
# Step 1: basic variant and individual quality filters
# remove participants with missing genotyping rate of > 0.05
# remove variants with MAF < 0.05
# remove variants that fail HWE test
# remove variants that have missing genotype rate > 0.05
#--------------------------------------------------------------

# 20% variant missingness threshold
plink \
  --bfile data/tmp/rosmap_1.tmp \
  --geno 0.2 \
  --make-bed \
  --out data/tmp/rosmap_1a.tmp

# 20% IID missingness threshold
plink \
  --bfile data/tmp/rosmap_1a.tmp \
  --mind 0.2 \
  --make-bed \
  --out data/tmp/rosmap_1b.tmp

# 5% variant missingness threshold
plink \
  --bfile data/tmp/rosmap_1b.tmp \
  --geno 0.05 \
  --make-bed \
  --out data/tmp/rosmap_1c.tmp

# 5% IID missingness threshold
plink \
  --bfile data/tmp/rosmap_1c.tmp \
  --mind 0.05 \
  --make-bed \
  --out data/tmp/rosmap_1d.tmp

# filter variants by HWE test
# include non-controls because plink phenotypes aren't accurate
plink \
  --bfile data/tmp/rosmap_1d.tmp \
  --hwe 1e-6 midp include-nonctrl \
  --make-bed \
  --out data/tmp/rosmap_1e.tmp

# create pruned SNP subset
# exclude regions of known high heterozygosity
plink \
  --bfile data/tmp/rosmap_1e.tmp \
  --exclude data/inversion.regions.txt \
  --indep-pairwise 15000 1500 0.2 \
  --out data/tmp/rosmap_1e_pruned.tmp

# create list of participants with unusually high heterozygosity
plink \
  --bfile data/tmp/rosmap_1e.tmp \
  --extract data/tmp/rosmap_1e_pruned.tmp.prune.in \
  --het \
  --out data/tmp/rosmap_1f.tmp

# check heterozygosity and create list of participants who fail QC
# (absolute heterozygosity rate > 3 sd from mean)
Rscript code/prep/rosmap/02b_check_heterozygosity.R

# create PLINK fileset that keeps only those who pass heterozygosity QC
plink \
  --bfile data/tmp/rosmap_1e.tmp \
  --remove ./data/tmp/rosmap_1f_fail_het.tmp.txt \
  --make-bed \
  --out data/tmp/rosmap_2.tmp

