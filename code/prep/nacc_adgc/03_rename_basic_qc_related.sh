#!/bin/bash

#======================================
# rename nacc_adgc_qc2.tmp fileset to 
# skip the remove related pairs step
# to merge related dataset with 1000g
#======================================

mv data/tmp/nacc_adgc_qc2.tmp.bed data/tmp/nacc_adgc_qc3.tmp.bed
mv data/tmp/nacc_adgc_qc2.tmp.bim data/tmp/nacc_adgc_qc3.tmp.bim
mv data/tmp/nacc_adgc_qc2.tmp.fam data/tmp/nacc_adgc_qc3.tmp.fam