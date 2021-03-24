#!/bin/bash

#=====================================================
# magma analysis for nacc/adgc, rosmap, and adni mega
#=====================================================

# annotate snps to gene locations
magma \
  --annotate window=1000 \
  --snp-loc data/adni_npc/nacc_adgc_rosmap_adni_unrelated.bim \
  --gene-loc raw_data/magma/NCBI37.3.gene.loc \
  --out output/magma/nacc_adgc_rosmap_adni_unrelated
# gene-based analysis
## create file with 22 batches
touch data/tmp/magma_batches.tmp
bach_num=22
for i in {1..$batch_num}
  do
  echo -e "$i" >> data/tmp/magma_batches.tmp
  done
## this script wouldn't work when I created line breaks
cat data/tmp/magma_batches.tmp | xargs -n 1 -P $batch_num -I % magma --batch % $batch_num --bfile data/adni_npc/nacc_adgc_rosmap_adni_unrelated --pval output/adni_npc/nacc_adgc_rosmap_adni_unrelated.assoc.logistic ncol=NMISS --gene-annot output/magma/nacc_adgc_rosmap_adni_unrelated.genes.annot --genes-only --out output/magma/nacc_adgc_rosmap_adni_unrelated

rm data/tmp/magma_batches.tmp
# magma --gene-results output/magma/nacc_adgc_rosmap_adni_unrelated.genes.raw --set-annot data/magma/gene_sets.txt set-col=1 gene-col=2 --out output/magma/nacc_adgc_rosmap_adni_unrelated
