#!/bin/bash

# enter an argument after the bash file command that is the gene you want to investigate
cat ../ADGC.HRC/80+/02_analysis/coloc.nmral2p/Artery_Aorta/basc.qtl.tsv | awk -F '\t' '{print $2,$6}' | \
locuszoom \
  --metal - \
  --refsnp rs11718099 \
  --flank 200kb \
  --source 1000G_March2012 \
  --build hg19 \
  --pop EUR \
  --markercol SNP \
  --pvalcol P_basc \
  --delim space \
  --prefix tabs.figs/coloc.nmral2p/basc