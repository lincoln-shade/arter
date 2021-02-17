#!/bin/bash
# arg1 = summary stats file
Rscript 10a_sumstats.strip.alleles.R $1 $2

file=sumstats.tmp
# enter an argument after the bash file command that is the gene you want to investigate
cat $file | awk -F',' '{print $2,$6}' | \
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