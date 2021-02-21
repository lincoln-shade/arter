#!/bin/bash

#=========================
# meta-analysis with act
#=========================

plink \
  --meta-analysis output/adni_npc/nacc_adgc_rosmap_adni_unrelated.assoc.logistic \
    raw_data/brainartbin.assoc.logistic.txt \
  --out output/act/act__nacc_adgc_rosmap_adni_unrelated