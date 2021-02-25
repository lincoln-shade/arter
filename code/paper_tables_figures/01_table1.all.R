##--------------------------------
## Make table 1 for manuscript
##--------------------------------

library(pacman)
p_load(data.table, magrittr, devtools, knitr, kableExtra, VGAM)
source_url("https://github.com/lincoln-shade/r.functions/raw/master/table.one.R")

#------------
# Load nacc.rosmapa
#------------

load("/home/commons/arter/NACC.ROSMAP.meta/01_data/data/nacc.rosmap.RData")
nacc.rosmap[, cohort := as.character(cohort)]
nacc.rosmap[cohort == "0", cohort := "NACC"]
nacc.rosmap[cohort == "1", cohort := "ROSMAP"]
nacc.rosmap[, cohort := factor(cohort)]
nacc.rosmap[, table(cohort, useNA = "a")]
nacc.rosmap[, arteriol_scler := ordered(arteriol_scler, labels = c("None", "Mild", "Moderate", "Severe"))]
nacc.rosmap[, msex := factor(msex, labels = c("Female", "Male"))]

#------------------------------------------
# Statistical tests for cohort differences
#------------------------------------------

# rank correlation Chi Square for B-ASC
TestBASC <- function() {
        # Kendall's tau rank correlation
        tau <- kendall.tau(nacc.rosmap$cohort, nacc.rosmap$arteriol_scler)
        # using Agresti's method found from
        # https://www.uvm.edu/~statdhtx/StatPages/More_Stuff/OrdinalChisq/OrdinalChiSq.html
        M2 <- nacc.rosmap[, .N - 1] * tau^2
        Xsq <- pchisq(M2, 1, lower.tail = F)
        pval <- ifelse(Xsq >= 0.001, paste(round(Xsq, 3)), "<0.001")
        pval
}

TestSex <- function() {
        Xsq <- chisq.test(nacc.rosmap[, table(cohort, msex)])[["p.value"]]
        pval <- ifelse(Xsq >= 0.001, paste(round(Xsq, 3)), "<0.001")
        pval
}

TestDeathAge <- function() {
        ttest <- t.test(nacc.rosmap[cohort == "NACC", age_death], 
                       nacc.rosmap[cohort == "ROSMAP", age_death])
        pval <- ifelse(ttest$p.value >= 0.001, paste(round(ttest$p.value, 3)), "<0.001")
        pval
}

`P-value` <- c(rep(TestBASC(), 4), 
               rep(TestSex(), 2), 
               rep(TestDeathAge(), 2)
               )
#------------
# Make table
#------------

table1 <- TableOne(nacc.rosmap[, .(arteriol_scler, msex, age_death, cohort)], "cohort")
Rep2 <- function(string) {rep(string, 2)}
table1[, Variable := c(rep("Brain Arteriolosclerosis", 4), Rep2("Sex"), Rep2("Age of death"))]
table1[, `N Missing` := NULL]
table1[, `P-value` := `P-value`]
setnames(table1, c("Overall", "NACC", "ROSMAP", "Labels"), c(paste0("N = ", nacc.rosmap[, .N]), 
                                                   paste0("N = ", nacc.rosmap[cohort == "NACC", .N]), 
                                                   paste0("N = ", nacc.rosmap[cohort == "ROSMAP", .N]),
                                                   "Participant Characteristics")
)
table1[, Variable := NULL]
print(
  table1 %>% 
    kable(format = "html") %>% 
    kable_styling(bootstrap_options = c("responsive", "condensed", "striped")) %>% 
    collapse_rows(columns = 1) %>% 
    add_header_above(c(" " = 1, "Overall" = 1, "NACC" = 1, "ROSMAP" = 1, " " = 1), align = "l") %>% 
    add_header_above(c("Table 1: NACC and ROSMAP cohort summary" = 5)) %>% 
    group_rows("Brain Arteriolosclerosis", 1, 4) %>% 
    group_rows("Sex", 5, 6) %>% 
    group_rows("Age of Death", 7, 8)
)

rm(list = ls())
p_unload(all)
