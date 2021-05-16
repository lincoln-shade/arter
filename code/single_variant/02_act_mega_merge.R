

source("code/00_load_options_packages_functions.R")

chr_list <- vector(mode = "list", length = 22)
for (i in 1:22) {
  chr_list[[i]] <- fread(paste0("output/act/act_mega_chr", i, ".assoc.logistic"))
}

results <- rbindlist(chr_list)
setorder(results, P)
head(results)
results[P < 1e-5]

fwrite(results, file = "output/act/act_mega.assoc.logisic", sep = " ", quote = FALSE)
