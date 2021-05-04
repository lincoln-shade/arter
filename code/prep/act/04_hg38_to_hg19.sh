#!/bin/bash

#==========================================
# 1. convert ACT fileset from hg38 to hg19
# 2. keep only variants in the mega-analysis
# 3. convert to rsID format
#==========================================
in_bed=data/tmp/act_var_hg38.bed
cat data/tmp/act_qc3.tmp.bim | awk 'NR>1{print "chr"$1,$4-1,$4,$2}' > $in_bed

# liftOver tutorial available at https://genome.sph.umich.edu/wiki/LiftOver
out_bed=data/tmp/act_hg19.bed
unlifted_bed=data/tmp/act_unlifted.bed
liftOver $in_bed raw_data/hg38ToHg19.over.chain $out_bed $unlifted_bed

hg19_var=data/tmp/act_hg19_vars.txt
cat $out_bed | awk '{print$4}' > $hg19_var

# inlude only variants successfully lifted over to hg19
plink \
  -bfile data/tmp/act_qc3.tmp \
  -extract $hg19_var \
  -make-bed \
  -out data/tmp/act_qc3_hg19_var.tmp

Rscript --vanilla code/prep/act/04a_var_id_proc.R

plink \
  -bfile data/tmp/act_qc3_hg19_var.tmp \
  -extract data/tmp/act_mega_var_ids.txt \
  -make-bed \
  -out data/tmp/act_qc3_mega_vars.tmp

plink \
  -bfile data/tmp/act_qc3_mega_vars.tmp \
  -bim data/tmp/act_qc3_mega_vars_rsid.tmp.bim \
  -make-bed \
  -out data/tmp/act_qc4.tmp
