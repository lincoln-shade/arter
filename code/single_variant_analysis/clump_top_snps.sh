#!/bin/bash

##--------------------------------------------
## generate list of independent top variants
##--------------------------------------------

# note that default for --r2 is to remove all variant pairs that have r2 < 0.2 from the report

bfile=$1
sumstats=$2
out=$3

plink \
  --bfile $1 \
  --clump $2 \
  --clump-p1 0.00001 \
  --clump-r2 0.05 \
  --out $3
