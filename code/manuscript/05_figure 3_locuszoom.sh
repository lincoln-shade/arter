#!/bin/bash

#=============================
# locuszoom plots of top SNPs
#=============================

# elovl4 snp
locuszoom \
  --metal output/act/act_mega.assoc.logistic \
  --refsnp rs2603462 \
  --flank 1000kb \
  --source 1000G_March2012 \ 
  --build hg19 \
  --pop EUR \
  --markercol SNP \
  --pvalcol P \
  --delim space \
  --prefix doc/act_mega_lz_elovl4 

# sorcs3 snp
locuszoom \
  --metal output/act/act_mega.assoc.logistic \
  --refsnp rs7902929 \
  --flank 1000kb \
  --source 1000G_March2012 \ 
  --build hg19 \
  --pop EUR \
  --markercol SNP \
  --pvalcol P \
  --delim space \
  --prefix doc/act_mega_lz_elovl4 
