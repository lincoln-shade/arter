#!/bin/bash

#===========================================
# keep european participants and
# run PCA on them
# for both rosmap and nacc/adgc_rosmap mega
#===========================================

#------------------
# rosmap unrelated
#------------------

# 1 create final plink fileset to use for analyses

# one final pass at variant QC
plink \
  --bfile data/tmp/rosmap_5.tmp \
  --maf 0.05 \
  --geno 0.05 \
  --hwe 1e-6 midp include-nonctrl \
  --make-bed \
  --out data/rosmap/rosmap

# 2 perform pca

# create list of pruned.in snps
plink \
  --bfile data/rosmap/rosmap \
  --no-pheno \
  --indep-pairwise 15000 1500 0.2 \
  --out data/tmp/rosmap_prune.tmp
  

plink \
  --bfile data/rosmap/rosmap \
  --allow-no-sex \
  --no-pheno \
  --pca 5 \
  --extract data/tmp/rosmap_prune.tmp.prune.in \
  --out data/rosmap/rosmap_pca

#----------------------------------
# nacc/adgc rosmap unrelated mega
#----------------------------------

# one final pass at variant QC
plink \
  --bfile data/tmp/nacc_rosmap.tmp \
  --maf 0.05 \
  --geno 0.05 \
  --hwe 1e-6 midp include-nonctrl \
  --make-bed \
  --out data/nacc_rosmap/nacc_rosmap

# 2 perform pca

# create list of pruned.in snps
plink \
  --bfile data/nacc_rosmap/nacc_rosmap \
  --no-pheno \
  --indep-pairwise 15000 1500 0.2 \
  --out data/tmp/nacc_rosmap_prune.tmp
  

plink \
  --bfile data/nacc_rosmap/nacc_rosmap \
  --allow-no-sex \
  --no-pheno \
  --pca 5 \
  --extract data/tmp/nacc_rosmap_prune.tmp.prune.in \
  --out data/nacc_rosmap/nacc_rosmap_pca

# # remove all of the tmp nacc tmp files in data/tmp
# rm data/tmp/rosmap*.tmp*
# rm data/tmp/rosmap*merged*
# rm data/tmp/1000g*.tmp*


