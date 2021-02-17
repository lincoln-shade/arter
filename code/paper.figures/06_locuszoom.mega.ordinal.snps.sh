#!/bin/bash

Rscript 06a_make.metal.R \
  ../NACC.ROSMAP.meta/02_analysis/mega.ordinal/ordinal.assoc.logistic \
  ../NACC.ROSMAP.meta/02_analysis/mega.ordinal/plink.clumped;

# grab SNPs from plink .clumped file
snps=$( cat ../NACC.ROSMAP.meta/02_analysis/mega.ordinal/plink.clumped | awk 'NR>1{print $3}')

# make locuszoom plot for each SNP
echo $snps | xargs -n 1 bash -c '
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
    --prefix tabs.figs/locuszoom/mega.ordinal/$0
  ';

rm metal.tmp
