#!/bin/bash

#=============================
# locuszoom plots of top SNPs
#=============================

cat output/nacc_rosmap/nacc_rosmap.assoc.logistic | awk '{print$2,$12}' > data/tmp/metal.tmp
# elovl4 snp
locuszoom --metal data/tmp/metal.tmp --refsnp rs2603462 --flank 1000kb --source 1000G_March2012 --build hg19 --pop EUR --markercol SNP --pvalcol P --delim space --prefix doc/stage2_lz_elovl4 

# sorcs3 snp
locuszoom --metal data/tmp/metal.tmp --refsnp rs7902929 --flank 1000kb --source 1000G_March2012 --build hg19 --pop EUR --markercol SNP --pvalcol P --delim space --prefix doc/stage2_lz_sorcs3 

rm data/tmp/metal.tmp