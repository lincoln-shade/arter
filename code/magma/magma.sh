#!/bin/bash

#=====================================================
# magma analysis for nacc/adgc, rosmap, and adni mega
#=====================================================

# annotate snps to gene locations
magma \
  --annotate window=1000 \
  --snp-loc data/act/act_mega.bim \
  --gene-loc raw_data/magma/NCBI37.3.gene.loc \
  --out output/magma/act_mega
# gene-based analysis

## this script wouldn't work when I created line breaks
seq 1 22 | xargs -n 1 -P 22 -I % magma --batch % 22 --bfile data/act/act_mega --pval output/act/act_mega.assoc.logistic ncol=NMISS --gene-annot output/magma/act_mega.genes.annot --genes-only --out output/magma/act_mega

magma --merge output/magma/act_mega --out output/magma/act_mega
# rm output/magma/act_mega.batch*
