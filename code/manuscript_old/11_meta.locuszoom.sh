#!/bin/bash

# enter an argument after the bash file command that is the gene you want to investigate
cat $1 |awk '{print $3,$7}' | \
locuszoom \
  --metal - \
  --refsnp $3 \
  --flank 200kb \
  --source 1000G_March2012 \
  --build hg19 \
  --pop EUR \
  --markercol $2 \
  --pvalcol $4 \
  --delim space \
  --prefix tabs.figs/$3