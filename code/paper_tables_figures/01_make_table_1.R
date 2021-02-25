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

table_1 <- make_table_one(table_1_data[, .(Cohort, `B-ASC`, Sex, `Age of Death`)], "Cohort") %>% 
  .[, -c("N Missing")] %>% 
  as_grouped_data(groups = c("Variable")) %>% 
  flextable()
  
