#!/bin/bash

# enter an argument after the bash file command that is the gene you want to investigate
cat ../ADGC.HRC/80+/02_analysis/coloc.hla/Brain_Cortex/basc.qtl.tsv | awk -F '\t' '{print $2,$6}' | \
locuszoom \
  --metal - \
  --refsnp rs9260090 \
  --flank 200kb \
  --source 1000G_March2012 \
  --build hg19 \
  --pop EUR \
  --markercol SNP \
  --pvalcol P_basc \
  --delim space \
  --prefix tabs.figs/coloc.hlaa/basc