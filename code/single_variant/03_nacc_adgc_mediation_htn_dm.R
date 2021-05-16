#===========================================
# mediation analysis of top nacc/adgc snps
# for dm and htn
#===========================================

source("code/00_load_options_packages_functions.R")

# data
pheno_dm <- fread("data/nacc_adgc/nacc_adgc_unrelated_dm.txt")
pheno_htn <- fread("data/nacc_adgc/nacc_adgc_unrelated_htn.txt")
snps <- fread("data/nacc_adgc/nacc_adgc_unrelated_top.raw")
colnames(snps) <- strip_alleles(colnames(snps))
snps[, `:=`(FID = NULL, PAT = NULL, MAT = NULL, SEX = NULL, PHENOTYPE = NULL)]

pheno_dm <- merge(pheno_dm, snps, "IID")
pheno_htn <- merge(pheno_htn, snps, "IID")

# numbers needed
snp_m <- ncol(snps) - 1
max_covar_coln <- ncol(pheno_dm) - snp_m - 1
#-----------
# diabetes
#-----------

# step 1: snp and outcome
dm_s1_est <- rep(NA, snp_m)
dm_s1_se <- rep(NA, snp_m)
dm_s1_p <- rep(NA, snp_m)

for (i in 1:snp_m) {
  dm_s1 <- lm(paste0("NACCARTE ~ ", colnames(pheno_dm)[max_covar_coln + 1 + i], " + ", paste(colnames(pheno_dm)[4:max_covar_coln], collapse = " + ")),
              data = pheno_dm)
  dm_s1_smry <- summary(dm_s1)[["coefficients"]]
  dm_s1_est[i] <-  dm_s1_smry[2, 1]
  dm_s1_se[i] <- dm_s1_smry[2, 2]
  dm_s1_p[i] <- dm_s1_smry[2, 4]
  
}

dm_s1 <- data.table(SNP = colnames(snps)[2:ncol(snps)], 
                    est = dm_s1_est,
                    se = dm_s1_se,
                    p_val = dm_s1_p)

# step 2: snp and mediator
dm_s2_est <- rep(NA, snp_m)
dm_s2_se <- rep(NA, snp_m)
dm_s2_p <- rep(NA, snp_m)

# step 4: snp + mediator and outcome
dm_s4_est <- rep(NA, snp_m)
dm_s4_se <- rep(NA, snp_m)
dm_s4_p <- rep(NA, snp_m)

for (i in 1:snp_m) {
  dm_s2 <- lm(paste0("dm ~ ", colnames(pheno_dm)[max_covar_coln + 1 + i], " + ", paste(colnames(pheno_dm)[4:max_covar_coln], collapse = " + ")),
              data = pheno_dm)
  dm_s2_smry <- summary(dm_s2)[["coefficients"]]
  dm_s2_est[i] <-  dm_s2_smry[2, 1]
  dm_s2_se[i] <- dm_s2_smry[2, 2]
  dm_s2_p[i] <- dm_s2_smry[2, 4]
  
  dm_s4 <- lm(paste0("NACCARTE ~ ", colnames(pheno_dm)[max_covar_coln + 1 + i], " + ", paste(colnames(pheno_dm)[4:max_covar_coln + 1], collapse = " + ")),
              data = pheno_dm)
  dm_s4_smry <- summary(dm_s4)[["coefficients"]]
  dm_s4_est[i] <-  dm_s4_smry[2, 1]
  dm_s4_se[i] <- dm_s4_smry[2, 2]
  dm_s4_p[i] <- dm_s4_smry[2, 4]
  
  print(summary(mediate(dm_s2, dm_s4, treat = colnames(pheno_dm)[max_covar_coln + 1 + i], mediator = "dm")))
  
}

dm_s2 <- data.table(SNP = colnames(snps)[2:ncol(snps)], 
                    est = dm_s2_est,
                    se = dm_s2_se,
                    p_val = dm_s2_p)

# step 3: mediator and outcome
dm_s3 <- lm(paste0("NACCARTE ~ ", paste(colnames(pheno_dm)[4:(max_covar_coln + 1)], collapse = " + ")),
            data = pheno_dm)

# step 4: snp + mediator and outcome
dm_s4_est <- rep(NA, snp_m)
dm_s4_se <- rep(NA, snp_m)
dm_s4_p <- rep(NA, snp_m)

for (i in 1:snp_m) {
  
  
}

dm_s4 <- data.table(SNP = colnames(snps)[2:ncol(snps)], 
                    est = dm_s4_est,
                    se = dm_s4_se,
                    p_val = dm_s4_p)
#-----------------
# hypertension
#-----------------

# step 1: snp and outcome

# step 1: snp and outcome
htn_s1_est <- rep(NA, snp_m)
htn_s1_se <- rep(NA, snp_m)
htn_s1_p <- rep(NA, snp_m)

for (i in 1:snp_m) {
  htn_s1 <- lm(paste0("NACCARTE ~ ", colnames(pheno_htn)[max_covar_coln + 1 + i], " + ", paste(colnames(pheno_htn)[4:max_covar_coln], collapse = " + ")),
              data = pheno_htn)
  htn_s1_smry <- summary(htn_s1)[["coefficients"]]
  htn_s1_est[i] <-  htn_s1_smry[2, 1]
  htn_s1_se[i] <- htn_s1_smry[2, 2]
  htn_s1_p[i] <- htn_s1_smry[2, 4]
  
}

htn_s1 <- data.table(SNP = colnames(snps)[2:ncol(snps)], 
                    est = htn_s1_est,
                    se = htn_s1_se,
                    p_val = htn_s1_p)

# step 2: snp and mediator
htn_s2_est <- rep(NA, snp_m)
htn_s2_se <- rep(NA, snp_m)
htn_s2_p <- rep(NA, snp_m)

for (i in 1:snp_m) {
  htn_s2 <- lm(paste0("htn ~ ", colnames(pheno_htn)[max_covar_coln + 1 + i], " + ", paste(colnames(pheno_htn)[4:max_covar_coln], collapse = " + ")),
              data = pheno_htn)
  htn_s2_smry <- summary(htn_s2)[["coefficients"]]
  htn_s2_est[i] <-  htn_s2_smry[2, 1]
  htn_s2_se[i] <- htn_s2_smry[2, 2]
  htn_s2_p[i] <- htn_s2_smry[2, 4]
  
}

htn_s2 <- data.table(SNP = colnames(snps)[2:ncol(snps)], 
                    est = htn_s2_est,
                    se = htn_s2_se,
                    p_val = htn_s2_p)


# step 3: mediator and outcome
htn_s3 <- lm(paste0("NACCARTE ~ ", paste(colnames(pheno_htn)[4:(max_covar_coln + 1)], collapse = " + ")),
            data = pheno_htn)

# step 4: snp + mediator and outcome
htn_s4_est <- rep(NA, snp_m)
htn_s4_se <- rep(NA, snp_m)
htn_s4_p <- rep(NA, snp_m)

for (i in 1:snp_m) {
  htn_s4 <- lm(paste0("NACCARTE ~ ", colnames(pheno_htn)[max_covar_coln + 1 + i], " + ", paste(colnames(pheno_htn)[4:max_covar_coln + 1], collapse = " + ")),
              data = pheno_htn)
  htn_s4_smry <- summary(htn_s4)[["coefficients"]]
  htn_s4_est[i] <-  htn_s4_smry[2, 1]
  htn_s4_se[i] <- htn_s4_smry[2, 2]
  htn_s4_p[i] <- htn_s4_smry[2, 4]
  
}

htn_s4 <- data.table(SNP = colnames(snps)[2:ncol(snps)], 
                    est = htn_s4_est,
                    se = htn_s4_se,
                    p_val = htn_s4_p)
