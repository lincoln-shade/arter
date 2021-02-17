#!/bin/bash

# $1 is the pathway to the coloc folder in a project
# $2 is the gene or phenotype folder name
# $3 is the tissue
# $4 is the subdirectory of tabs.figs/colocuszoom
mkdir tabs.figs/colocuszoom/$4

#chr=$(tail -n 1 $1/$2/$3/gwas.qtl.tsv | awk -F '\t' '{print $4}')
snp=$(head -n 2  $1/$2/$3/gwas.qtl.tsv | awk -F '\t' 'NR == 2{print $2}')
#end=$(tail -n 1 $1/$2/$3/gwas.qtl.tsv | awk -F '\t' '{print $5}')

# enter an argument after the bash file command that is the gene you want to investigate
cat $1/$2/$3/gwas.qtl.tsv | awk -F '\t' '{print $2,$15}' | \
locuszoom \
  --metal - \
  --refsnp $snp \
  --flank 200kb \
  --source 1000G_March2012 \
  --build hg19 \
  --pop EUR \
  --markercol SNP \
  --pvalcol P_qtl \
  --delim space \
  --prefix tabs.figs/colocuszoom/$4/$2_$3_