#!/bin/bash

bash code/coloc/01_qtls.sh output/adni_npc/nacc_adgc_rosmap_adni_unrelated.assoc.logistic
bash code/coloc/02_coloc.sh data/adni_npc/nacc_adgc_rosmap_adni_unrelated data/adni_npc/nacc_adgc_rosmap_adni_unrelated.pheno output/adni_npc/nacc_adgc_rosmap_adni_unrelated.assoc.logistic output/adni_npc/