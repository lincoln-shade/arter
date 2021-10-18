#!/bin/bash

##--------------------------------------------
## make .raw file for top snps for brant test
##--------------------------------------------

# clump top snps
cat output/nacc/ordinal_results.txt | awk '{print$2,$7}' | awk '{if (NR == 1) print "SNP P"; else print $0}' > data/tmp/ordinal_results.tmp

plink \
  --bfile data/nacc/nacc \
  --clump data/tmp/ordinal_results.tmp \
  --clump-r2 0.05 \
  --clump-p1 1e-5 \
  --out output/nacc/ordinal

cat output/nacc/ordinal.clumped | awk 'NR>1{print $3}' > output/nacc/ordinal_top_snps.txt

plink \
  --bfile data/nacc/nacc \
  --recode A \
  --extract output/nacc/ordinal_top_snps.txt \
  --out data/nacc/ordinal_top_snps

