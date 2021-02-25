#!/bin/bash

path=/home/commons/arter/ADGC.HRC/65+/02_analysis/coloc
analysis=nacc.all
bash 08a_locuszoom.coloc.qtl.sh $path elovl4 Brain_Cerebellar_Hemisphere $analysis
bash 08a_locuszoom.coloc.qtl.sh $path dalrd3 Brain_Anterior_cingulate_cortex_BA24 $analysis
bash 08a_locuszoom.coloc.qtl.sh $path fam212a Brain_Nucleus_accumbens_basal_ganglia $analysis
bash 08a_locuszoom.coloc.qtl.sh $path lnpk Brain_Cerebellum $analysis
bash 08a_locuszoom.coloc.qtl.sh $path mst1r Brain_Cortex $analysis
bash 08a_locuszoom.coloc.qtl.sh $path rnf123.clu_30038 Cells_EBV-transformed_lymphocytes $analysis
bash 08a_locuszoom.coloc.qtl.sh $path rnf123.clu_34534 Whole_Blood $analysis
bash 08a_locuszoom.coloc.qtl.sh $path rnf123.clu_35367 Cells_Cultured_fibroblasts $analysis
bash 08a_locuszoom.coloc.qtl.sh $path rnf123.clu_40490 Artery_Tibial $analysis
bash 08a_locuszoom.coloc.qtl.sh $path spred2 Cells_Cultured_fibroblasts $analysis
bash 08a_locuszoom.coloc.qtl.sh $path tcta Whole_Blood $analysis
