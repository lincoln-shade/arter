#!/bin/bash

bash code/coloc/01_qtls.sh output/nacc_adgc/nacc_adgc_unrelated.assoc.logistic
bash code/coloc/02_coloc.sh data/nacc_adgc/nacc_adgc_unrelated data/nacc_adgc/nacc_adgc_unrelated_pheno.txt output/nacc_adgc/nacc_adgc_unrelated.assoc.logistic output/nacc_adgc/