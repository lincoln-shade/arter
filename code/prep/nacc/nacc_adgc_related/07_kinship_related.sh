#!/bin/bash

#==============================
# king kinship estimation
#==============================

/software/king -b data/nacc_adgc/nacc_adgc_related.bed --kinship --prefix data/nacc_adgc/nacc_adgc_related

# remove MZ groups because they are duplicates
