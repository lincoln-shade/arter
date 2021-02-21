#!/bin/bash

#=====================================================
# magma analysis for nacc/adgc, rosmap, and adni mega
#=====================================================

# annotate snps to gene locations
magma \
  --annotate \
  --snp-loc data/adni_npc/nacc_adgc_rosmap_adni_unrelated.bim \
  --gene-loc raw_data/magma/NCBI37.3.gene.loc \
  --out output/magma/nacc_adgc_rosmap_adni_unrelated

# this script wouldn't work when I created line breaks
magma --bfile data/adni_npc/nacc_adgc_rosmap_adni_unrelated --pval output/adni_npc/nacc_adgc_rosmap_adni_unrelated.assoc.logistic ncol=NMISS --gene-annot output/magma/nacc_adgc_rosmap_adni_unrelated.genes.annot --out output/magma/nacc_adgc_rosmap_adni_unrelated

magma --gene-results output/magma/nacc_adgc_rosmap_adni_unrelated.genes.raw --set-annot data/magma/gene_sets.txt set-col=1 gene-col=2 --out output/magma/nacc_adgc_rosmap_adni_unrelated
