#====================================================
# load options, packages, and functions for project
#====================================================

#--------------
# base options
#--------------
options(digits = 15)

#------------------------
# install/load packages
#------------------------
date <- "2021-04-01"
cran_packages <- c("data.table", "magrittr", "ggplot2", "stringi", "readxl", "flextable", "devtools", "ggrepel", "knitr", "rentrez",
                   "miceadds", "MASS", "dplyr", "GMMAT", "pacman", "remotes", "mediation")
ignore_deps <- c("SeqArray", "tinytex")
github_packages <- c("coloc")
bioc_packages <- c("rtracklayer", "GEOquery", "GENESIS", "GWASTools", "qusage", "SeqArray") #"SNPRelate"

# load arrow
# if you're on linux and want to open parquet files from GTEx, you'll need to run the following when installing arrow
if (!(require("arrow"))) {
  Sys.setenv(ARROW_S3="ON")
  Sys.setenv(NOT_CRAN="true")	
  install.packages("arrow", repos = "https://arrow-r-nightly.s3.amazonaws.com")
}

# cran packages loaded with groundhog for improved reproducibility
if (!require("groundhog")) {
  install.packages("groundhog")
}

# bioconductor packages
groundhog.library("BiocManager", date)

for(p in bioc_packages) {
  if(p %in% rownames(installed.packages()) == FALSE) {
    BiocManager::install(p)
  }
  library(p, character.only = TRUE)
}

# cran packages
groundhog.library(cran_packages, date, ignore.deps = ignore_deps)

# github packages
if (!require("coloc")) {
  remotes::install_github("chr1swallace/coloc",build_vignettes=TRUE)
}

rm(bioc_packages, cran_packages, github_packages, date, ignore_deps, p)
#------------------------
# load custom functions
#------------------------

strip_alleles <- function(x) {
  x <- stri_replace_last_regex(x, ":[ACTG]*:[ACTG]*", "")
}

source_url("https://raw.githubusercontent.com/lincoln-shade/r.functions/master/make_table_one.R", 
           sha1 = "618b76ddf7b93f365d7cd45fdf00910011dabb0c")

make_output_file <- function(x, out) {
  if (nchar(x) == 0) {
    return(out)
  } else {
    return(paste0(x, out))
  }
}

make_or_95_ci <- function(or, l95, u95, round_digits=2, flip_less_than_1=TRUE) {
  if (flip_less_than_1) {
    output <- ifelse(or >= 1,
                     paste0(round(or, round_digits), " [", round(l95, round_digits), "-", round(u95, round_digits), "]"),
                     ifelse((or < 1) & (or > 0),
                            paste0(round(1 / or, round_digits), " [", round(1 / u95, round_digits), "-", round(1 / l95, round_digits), "]"),
                            paste0("-"))
    )
  }
  
  output <- ifelse(or > 0,
                   paste0(round(or, round_digits), " [", round(l95, round_digits), "-", round(u95, round_digits), "]"),
                   paste0("-"))
  output
}

# takes as input a data.table object read from .assoc.logistic file
# with same column names
plot_manhattan <- function(results, signif_only=TRUE, annotate=FALSE) {
  results <- copy(results)
  results[, BP := as.numeric(BP)]
  if (signif_only) {
    results <- results[P < 0.05]
  }
  
  if (length(annotate) > 0) {
    results[SNP %in% annotate, annotate := TRUE]
  }
  
  # cumulative bp length for each chromosome
  chr_bp <- results[, max(BP), CHR] %>% 
    setnames("V1", "chr_length") %>% 
    # add 20mil buffer to help with spacing of axis labels
    .[, cum_length := cumsum(chr_length) - chr_length + 20000000*(CHR - 1)]
  
  results <- merge(results, chr_bp[, -c("chr_length")], "CHR") %>% 
    setorder(CHR, BP) %>% 
    .[, bp_cum := BP + cum_length]
  
  x_axis <- results[, (max(bp_cum) + min(bp_cum)) / 2, CHR]

  manplot <- results[, ggplot(.SD, aes(bp_cum, -log10(P)))] +
    geom_point(aes(color=as.factor(CHR)), alpha=0.8, size=1.3) +
    scale_color_manual(values = rep(c("#606060", "#000066"), 22)) +
    geom_hline(yintercept = 7.3, color = "black") + #genome-wide significance threshold
    geom_hline(yintercept = 5, color = "black") + #suggestibility threshold
    
    scale_x_continuous(label = x_axis$CHR, breaks= x_axis$V1) +
    # remove space between y-axis and baseline
    scale_y_continuous(expand = c(0.05, 0)) +

    xlab("Chromosome") +
    ylab("-log(P)") +
    # Add highlighted points
    #geom_point(data=subset(snp_mod, is_highlight=="yes"), color="orange", size=2) +

    # Add label using ggrepel to avoid overlapping
    geom_label_repel(data=results[annotate == TRUE], aes(label=SNP), size=5) +

    # Custom theme:
    theme_bw() +
    theme(
      # text = element_text(family = "Calibri", size = 20),
      axis.text = element_text(size = 12),
      legend.position="none",
      panel.border = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.x = element_blank()
    )
  
  manplot
}
