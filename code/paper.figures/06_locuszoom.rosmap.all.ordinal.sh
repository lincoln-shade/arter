#!/bin/bash

Rscript 06a_make.metal.R \
  ../ROSMAP/all/02_analysis/ordinal/ordinal.assoc.logistic \
  ../ROSMAP/all/02_analysis/ordinal/plink.clumped;

# grab SNPs from plink .clumped file
snps=$( cat clumped.tmp | awk 'NR>1{print $3}')

# make locuszoom plot for each SNP
echo $snps | xargs -n 1 -P 4 bash -c '
  locuszoom \
    --metal metal.tmp \
    --refsnp $0 \
    --flank 200kb \
    --source 1000G_March2012 \
    --build hg19 \
    --pop EUR \
    --markercol SNP \
    --pvalcol P \
    --delim space \
    --prefix tabs.figs/locuszoom/rosmap.all.ordinal/$0
  ';

rm metal.tmp clumped.tmp
