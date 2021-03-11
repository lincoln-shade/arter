#!/bin/bash

bash code/coloc/01_qtls.sh output/rosmap/rosmap_unrelated.assoc.logistic
bash code/coloc/02_coloc.sh data/rosmap/rosmap_unrelated data/rosmap/rosmap_unrelated_pheno.txt output/rosmap/rosmap_unrelated.assoc.logistic output/rosmap/