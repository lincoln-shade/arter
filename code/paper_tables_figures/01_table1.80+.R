##--------------------------------
## Make table 1 for manuscript
##--------------------------------

library(pacman)
p_load(data.table, magrittr, devtools, knitr, kableExtra, VGAM)
source_url("https://github.com/lincoln-shade/r.functions/raw/master/table.one.R")

#------------
# Load data
#------------

# ROSMAP
load("../ROSMAP/01_data/data/rosmap.RData")
rosmap <- rosmap[, c(1:5)]
rosmap[, Cohort := "ROSMAP"]

# NACC
load("../ADGC.HRC/80+/01_data/data/nacc.ordinal.RData")
nacc.ordinal <- nacc.ordinal[, c(1:5)]

# change sex variable labels to match those in ROSMAP
nacc.ordinal[, NPSEX := ifelse(NPSEX == 1, 1, 0)]
setnames(nacc.ordinal, 
         c("NACCARTE", "NACCDAGE", "NPSEX"),
         c("arteriol_scler", "age_death", "msex"))
nacc.ordinal[, Cohort := "NACC"]

#----------------
# Merge datasets
#----------------

dat <- rbind(nacc.ordinal, rosmap)
dat[, msex := factor(msex, labels = c("Female", "Male"))]
dat[, arteriol_scler := factor(arteriol_scler, labels = c("None", "Mild", "Moderate", "Severe"))]
dat[, Cohort := factor(Cohort)]

#------------------------------------------
# Statistical tests for cohort differences
#------------------------------------------

# rank correlation Chi Square for B-ASC
TestBASC <- function() {
        # Kendall's tau rank correlation
        tau <- kendall.tau(dat$Cohort, dat$arteriol_scler)
        # using Agresti's method found from
        # https://www.uvm.edu/~statdhtx/StatPages/More_Stuff/OrdinalChisq/OrdinalChiSq.html
        M2 <- dat[, .N - 1] * tau^2
        Xsq <- pchisq(M2, 1, lower.tail = F)
        pval <- ifelse(Xsq >= 0.001, paste(Xsq), "<0.001")
        pval
}

TestSex <- function() {
        Xsq <- chisq.test(dat[, table(Cohort, msex)])[["p.value"]]
        pval <- ifelse(Xsq >= 0.001, paste(Xsq), "<0.001")
        pval
}

TestDeathAge <- function() {
        ttest <- t.test(dat[Cohort == "NACC", age_death], 
                       dat[Cohort == "ROSMAP", age_death])
        pval <- ifelse(ttest$p.value >= 0.001, paste(ttest$p.value), "<0.001")
        pval
}

`P-value` <- c(rep(TestBASC(), 4), 
               rep(TestSex(), 2), 
               rep(TestDeathAge(), 2)
               )
#------------
# Make table
#------------

table1 <- TableOne(dat[, .(arteriol_scler, msex, age_death, Cohort)], "Cohort")
Rep2 <- function(string) {rep(string, 2)}
table1[, Variable := c(rep("Brain Arteriolosclerosis", 4), Rep2("Sex"), Rep2("Age of death"))]
table1[, `N Missing` := NULL]
table1[, `P-value` := `P-value`]
setnames(table1, c("Overall", "NACC", "ROSMAP"), c(paste0("N = ", dat[, .N]), 
                                                   paste0("N = ", dat[Cohort == "NACC", .N]), 
                                                   paste0("N = ", dat[Cohort == "ROSMAP", .N]))
)

print(table1 %>% 
        kable(format = "html") %>% 
        kable_styling(bootstrap_options = c("responsive", "condensed", "striped")) %>% 
        collapse_rows(columns = 1) %>% 
        add_header_above(c(" " = 2, "Overall" = 1, "NACC" = 1, "ROSMAP" = 1, " " = 1), align = "l") %>% 
        add_header_above(c("Table 1: NACC and ROSMAP cohort summary" = ncol(table1)))
)

rm(list = ls())
p_unload(all)
