#!/bin/bash

path=/home/commons/arter/NACC.ROSMAP.meta/02_analysis/coloc
analysis=mega.all
script=08a_locuszoom.coloc.qtl.sh

bash $script $path cd83 Whole_Blood $analysis
bash $script $path elovl4 Brain_Cerebellar_Hemisphere $analysis
bash $script $path or9n1p Brain_Nucleus_accumbens_basal_ganglia $analysis
bash $script $path rp11-408a13.3 Brain_Cerebellum $analysis
bash $script $path spred2 Cells_Cultured_fibroblasts $analysis
bash $script $path tas2r5 Brain_Hypothalamus $analysis