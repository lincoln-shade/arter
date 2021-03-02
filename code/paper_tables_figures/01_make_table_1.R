##===========================================
## Make Table 1: Participant Demographics
# for manuscript
# written to be sourced from within .Rmd
##===========================================

source("code/00_load_options_packages_functions.R")

load("data/adni_npc/nacc_adgc_rosmap_adni_unrelated.RData")
table_1_data <- copy(nacc_adgc_rosmap_adni_unrelated)

#----------------------------------------
# Format B-ASC and covariates for table
#----------------------------------------

# Make Cohort group variable
table_1_data[rosmap == 0 & adni == 0, Cohort := "NACC/ADGC"]
table_1_data[rosmap == 1, Cohort := "ROSMAP"]
table_1_data[adni == 1, Cohort := "ADNI"]
table_1_data[, Cohort := factor(Cohort)]

table_1_data[, `B-ASC` := ordered(arteriol_scler, labels = c("None", "Mild", "Moderate", "Severe"))]
table_1_data[, Sex := factor(msex, labels = c("Female", "Male"))]
table_1_data[, `Age of Death` := age_death]

# should make chisquare test for proportion of cases in each dataset
# https://stats.stackexchange.com/questions/332528/whats-the-best-way-to-use-the-chi-squared-test-on-more-than-2-groups-in-r

# #------------------------------------------
# # Statistical tests for cohort differences
# #------------------------------------------
# 
# # rank correlation Chi Square for B-ASC
# TestBASC <- function() {
#   # Kendall's tau rank correlation
#   tau <- kendall.tau(nacc.rosmap$cohort, nacc.rosmap$arteriol_scler)
#   # using Agresti's method found from
#   # https://www.uvm.edu/~statdhtx/StatPages/More_Stuff/OrdinalChisq/OrdinalChiSq.html
#   M2 <- nacc.rosmap[, .N - 1] * tau^2
#   Xsq <- pchisq(M2, 1, lower.tail = F)
#   pval <- ifelse(Xsq >= 0.001, paste(round(Xsq, 3)), "<0.001")
#   pval
# }
# 
# TestSex <- function() {
#   Xsq <- chisq.test(nacc.rosmap[, table(cohort, msex)])[["p.value"]]
#   pval <- ifelse(Xsq >= 0.001, paste(round(Xsq, 3)), "<0.001")
#   pval
# }
# 
# TestDeathAge <- function() {
#   ttest <- t.test(nacc.rosmap[cohort == "NACC", age_death], 
#                   nacc.rosmap[cohort == "ROSMAP", age_death])
#   pval <- ifelse(ttest$p.value >= 0.001, paste(round(ttest$p.value, 3)), "<0.001")
#   pval
# }
# 
# `P-value` <- c(rep(TestBASC(), 4), 
#                rep(TestSex(), 2), 
#                rep(TestDeathAge(), 2)
# )

table_1_data <- make_table_one(table_1_data[, .(Cohort, `B-ASC`, Sex, `Age of Death`)], "Cohort") 

table_1 <- table_1_data %>% 
  .[, -c("N Missing")] %>% 
  as_grouped_data(groups = c("Variable")) %>% 
  flextable()
  
