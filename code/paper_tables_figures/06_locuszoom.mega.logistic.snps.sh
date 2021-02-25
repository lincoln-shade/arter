#!/bin/bash

Rscript 06a_make.metal.R;

# grab SNPs from plink .clumped file
snps=$( cat ../NACC.ROSMAP.meta/02_analysis/logistic/plink.clumped | awk 'NR>1{print $3}')

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
    --prefix tabs.figs/locuszoom/mega.logistic/$0
  ';

rm metal.tmp
