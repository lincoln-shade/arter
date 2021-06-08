#!/bin/bash

#-----------------
# prep nacc data
#-----------------
path=code/prep/nacc/
Rscript --vanilla "$path"01_nacc_ids.R

bash "$path"02_basic_qc.sh
bash "$path"03_create_unrelated.sh
bash "$path"04_merge_with_1000g.sh
Rscript --vanilla "$path"05_remove_ethnic_outliers.R
bash "$path"06_make_fileset_run_pca.sh
Rscript --vanilla "$path"07_make_pheno.R