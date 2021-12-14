#=======================================================
# Create list if ACT IDs that meet includion criteria
#=======================================================

library(pacman)
pload("data.table", "magrittr", "readxl")

act_np <- as.data.table(read_xlsx("/data_global/ACT/DataForE235_20210421.xlsx", sheet = 2))
table(act_np$micro_arteriolosclerosis_id, useNA = "a")
act_np <- act_np[!(is.na(micro_arteriolosclerosis_id))]

act_geno <- fread("/data_global/ACT/qced/act_nhw_qced.fam")

act_np <- act_np[IDfromDave %in% act_geno$V2]
table(act_np$micro_arteriolosclerosis_id, useNA = "a")

act_geno <- act_geno[V2 %in% act_np$IDfromDave, .(V1, V2)]

fwrite(act_geno, file = "data/tmp/act_ids.txt", col.names = FALSE, quote = FALSE, sep = " ")
