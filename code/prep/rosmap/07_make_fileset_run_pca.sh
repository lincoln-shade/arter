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
  --bfile data/tmp/rosmap_unrelated_3.tmp \
  --maf 0.05 \
  --geno 0.05 \
  --hwe 1e-6 midp include-nonctrl \
  --make-bed \
  --out data/rosmap/rosmap_unrelated

# 2 perform pca

# create list of pruned.in snps
plink \
  --bfile data/rosmap/rosmap_unrelated \
  --no-pheno \
  --indep-pairwise 15000 1500 0.2 \
  --out data/tmp/rosmap_unrelated_prune.tmp
  

plink \
  --bfile data/rosmap/rosmap_unrelated \
  --allow-no-sex \
  --no-pheno \
  --pca 5 \
  --extract data/tmp/rosmap_unrelated_prune.tmp.prune.in \
  --out data/rosmap/rosmap_unrelated_pca

#----------------------------------
# nacc/adgc rosmap unrelated mega
#----------------------------------

# one final pass at variant QC
plink \
  --bfile data/tmp/nacc_adgc_rosmap_unrelated.tmp \
  --maf 0.05 \
  --geno 0.05 \
  --hwe 1e-6 midp include-nonctrl \
  --make-bed \
  --out data/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated

# 2 perform pca

# create list of pruned.in snps
plink \
  --bfile data/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated \
  --no-pheno \
  --indep-pairwise 15000 1500 0.2 \
  --out data/tmp/nacc_adgc_rosmap_unrelated_prune.tmp
  

plink \
  --bfile data/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated \
  --allow-no-sex \
  --no-pheno \
  --pca 5 \
  --extract data/tmp/nacc_adgc_rosmap_unrelated_prune.tmp.prune.in \
  --out data/nacc_adgc_rosmap/nacc_adgc_rosmap_unrelated_pca

# remove all of the tmp nacc_adgc tmp files in data/tmp
rm data/tmp/rosmap*.tmp*
rm data/tmp/rosmap*merged*
rm data/tmp/1000g*.tmp*


