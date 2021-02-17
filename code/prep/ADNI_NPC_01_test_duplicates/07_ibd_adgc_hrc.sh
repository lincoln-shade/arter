#!/bin/bash

plink \
  --bfile adgc_hrc.ADNI_NPC_N60.pruned \
  --genome \
  --min 0.18 \
  --out adgc_hrc.ADNI_NPC_N60.pruned