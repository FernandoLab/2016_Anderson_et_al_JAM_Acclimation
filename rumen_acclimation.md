# Acclimation of the rumen microbiota during a finishing study
Christopher L. Anderson (canderson30@unl.edu)  
December 7, 2015  
## Introduction
This is a R Markdown file to accompany the mansucript 2016 Anderson et al. JAM manuscript. It was written in [R markdown](http://rmarkdown.rstudio.com) and converted to html using the R knitr package. This enables us to embed the results of our analyses directly into the text to allow for a reproducible data analysis pipeline. A [github repository is available](https://github.com/chrisLanderson/2016_Anderson_et_al_JAM_Acclimation). 

## **BEFORE YOU RENDER**: 
The analysis from the Anderson et al. JAM manuscript can be recreated by using the associated R Markdown file. This is setup to be ran on Mac OS X and was initially performed with 8 GB RAM (less should be fine though). No root access is needed. This should all work in a linux enviornmnet as well if you use a linux version of USEARCH and the anaconda package manager [download page](http://continuum.io/downloads).


  1. Run the bash script to create a virtual enironment and download/install programs **LOCALLY** with the anaconda package manager.
    
  2. Render the R Markdown file with knitR to recreate the workflow and outputs.

Due to licensing issues, USEARCH can not be included in the setup. To obtain a download link, go to the USEARCH [download page](http://www.drive5.com/usearch/download.html) and select version USEARCH v7.0.1090 for Mac OSX. **A link (expires after 30 days) will be sent to the provided email. Use the link as an argument for shell script below**.

Simply download the bash script from the github repository and run it (provide the link to download your licensed USEARCH version as an argument for setup.sh):

  1. wget https://raw.githubusercontent.com/chrisLanderson/2016_Anderson_et_al_JAM_Acclimation/master/setup.sh
  2. chmod 775 setup.sh 
  3. ./setup.sh usearch_link

**Anaconda is downloaded and prompts you during installataion of several packages. The prompts are as follows:**

  1. Press enter to view the license agreement
  2. Press enter to read the license and q to exit
  3. Accept the terms by entering yes
  4. Prompts you where to install anaconda.  Simply type anaconda to create a directory within the current directory. Should be:
  [/Users/user/anaconda] >>> anaconda
  5. No to prepend anaconda to your path. Choosing yes should not impact the installation though.
  6. Will be asked a few times if you wish to proceed with installing the packages...agree to it.
  7. After installation, enter 'source anaconda/bin/activate rumenEnv' on the command line to activate the virtual enviornment with all dependencies.
  

To convert the R markdown to html use the command: **render("rumen_acclimation.Rmd")**. To start a R session and run the workflow, use these commands from within the  direcotry you initiated installation:

  1. source anaconda/bin/activate rumenEnv
  2. R
  3. install.packages("rmarkdown", repos='http://cran.us.r-project.org')
  4. install.packages("knitr", repos='http://cran.us.r-project.org')
  5. source("http://bioconductor.org/biocLite.R")
  6. biocLite("Heatplus", ask=FALSE, suppressUpdates=TRUE)
  7. library(rmarkdown)
  8. library(knitr)
  9. render("rumen_acclimation.Rmd")
  

The following packages and knitR settings were used to compile this document:


```r
install.packages("ggplot2", repos='http://cran.us.r-project.org')
```

```
## also installing the dependencies 'colorspace', 'Rcpp', 'dichromat', 'munsell', 'labeling', 'plyr', 'gtable', 'reshape2', 'scales', 'proto'
## 
## Updating HTML index of packages in '.Library'
## Making 'packages.html' ... done
```

```r
install.packages("matrixStats", repos='http://cran.us.r-project.org')
```

```
## Updating HTML index of packages in '.Library'
## Making 'packages.html' ... done
```

```r
install.packages("vegan", repos='http://cran.us.r-project.org')
```

```
## also installing the dependency 'permute'
## 
## Updating HTML index of packages in '.Library'
## Making 'packages.html' ... done
```

```r
install.packages("reshape", repos='http://cran.us.r-project.org')
```

```
## Updating HTML index of packages in '.Library'
## Making 'packages.html' ... done
```

```r
install.packages("biom", repos='http://cran.us.r-project.org')
```

```
## also installing the dependency 'RJSONIO'
## 
## Updating HTML index of packages in '.Library'
## Making 'packages.html' ... done
```

```r
install.packages("gplots", repos='http://cran.us.r-project.org')
```

```
## also installing the dependencies 'gtools', 'gdata'
## 
## Updating HTML index of packages in '.Library'
## Making 'packages.html' ... done
```

```r
install.packages("formatR", repos='http://cran.us.r-project.org')
```

```
## Updating HTML index of packages in '.Library'
## Making 'packages.html' ... done
```

```r
install.packages("knitr", repos='http://cran.us.r-project.org')
```

```
## Updating HTML index of packages in '.Library'
## Making 'packages.html' ... done
```

```r
install.packages("rmarkdown", repos='http://cran.us.r-project.org')
```

```
## Updating HTML index of packages in '.Library'
## Making 'packages.html' ... done
```

```r
install.packages("RColorBrewer", repos='http://cran.us.r-project.org')
```

```
## Updating HTML index of packages in '.Library'
## Making 'packages.html' ... done
```

```r
install.packages("mvtnorm", repos='http://cran.us.r-project.org')
```

```
## Updating HTML index of packages in '.Library'
## Making 'packages.html' ... done
```

```r
install.packages("coin", repos='http://cran.us.r-project.org')
```

```
## also installing the dependencies 'zoo', 'TH.data', 'sandwich', 'modeltools', 'multcomp'
## 
## Updating HTML index of packages in '.Library'
## Making 'packages.html' ... done
```

```r
install.packages("spaa", repos='http://cran.us.r-project.org')
```

```
## Updating HTML index of packages in '.Library'
## Making 'packages.html' ... done
```

```r
perm = 1e4
```



```r
sessionInfo()
```

```
## R version 3.2.2 (2015-08-14)
## Platform: x86_64-apple-darwin11.4.2 (64-bit)
## Running under: OS X 10.10.4 (Yosemite)
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] knitr_1.11           rmarkdown_0.8.1      BiocInstaller_1.20.1
## 
## loaded via a namespace (and not attached):
## [1] magrittr_1.5    formatR_1.2.1   htmltools_0.2.6 tools_3.2.2    
## [5] yaml_2.1.13     stringi_1.0-1   stringr_1.0.0   digest_0.6.8   
## [9] evaluate_0.8
```

```r
opts_chunk$set("tidy" = TRUE)
opts_chunk$set("echo" = TRUE)
opts_chunk$set("eval" = TRUE)
opts_chunk$set("warning" = FALSE)
opts_chunk$set("cache" = TRUE)
```

## Data curation

Download the 454 data (not really raw data though because the sequencing center had done some initial quality control on them...see manuscript for details):

```bash
wget https://github.com/chrisLanderson/2016_Anderson_et_al_JAM_Acclimation/raw/master/rumen.acclimation.tar.gz
tar -zxvf rumen.acclimation.tar.gz
```

Now  get the SILVA reference alignment and trim it to the V1-V3 region (region was determined using 27F and 518R primers) of the 16S rRNA gene.

```bash
wget http://www.mothur.org/w/images/2/27/Silva.nr_v119.tgz
tar -zxvf Silva.nr_v119.tgz
rm -rf Silva.nr_v119.tgz __MACOSX silva.nr_v119.tax README.Rmd README.html README.md
```

## Demulitplex and Quality Control

The code chunk below demulitplexes the sequencing library using the provided mapping file then trims off the reverse primer.  Subseqeuntly, we use a combination of mothur and FASTX to trim the seqeunces to a fixed length of 400 basepairs to improve OTU picking in UPARSE downstream. Finally, the sequences are reverse complemented in mothur.


```bash

wget https://raw.githubusercontent.com/chrisLanderson/2016_Anderson_et_al_JAM_Acclimation/master/mapping.txt
  
wget https://raw.githubusercontent.com/chrisLanderson/2016_Anderson_et_al_JAM_Acclimation/master/qiime_parameters_working.txt
  
split_libraries.py -m mapping.txt -f rumen.adaptation.fasta -b hamming_8 -l 0 -L 1000 -M 1 -o rumen_adaptation_demultiplex
  
truncate_reverse_primer.py -f rumen_adaptation_demultiplex/seqs.fna -o rumen_adaptation_rev_primer -m mapping.txt -z truncate_only -M 2
  
mothur "#trim.seqs(fasta=rumen_adaptation_rev_primer/seqs_rev_primer_truncated.fna, minlength=400)"
  
fastx_trimmer -i rumen_adaptation_rev_primer/seqs_rev_primer_truncated.trim.fasta -l 400 -o rumen.adaptation.qc.trim.fasta
 
mothur "#reverse.seqs(fasta=rumen.adaptation.qc.trim.fasta)"
```

## Pick OTUs, assign taxonomy, and align sequences

Use a custom perl script from our lab to convert the fasta file from QIIME format to a format that works with UPARSE to generate the OTU table:


```bash
wget https://raw.githubusercontent.com/chrisLanderson/2016_Anderson_et_al_JAM_Acclimation/master/qiime_to_usearch.pl

chmod 775 qiime_to_usearch.pl

./qiime_to_usearch.pl -fasta=rumen.adaptation.qc.trim.rc.fasta -prefix=rumen

mv format.fasta rumen.adaptation.format.fasta
```

Run the sequences through the UPARSE pipeline to pick OTUs:

```bash
svn export https://github.com/chrisLanderson/2016_Anderson_et_al_JAM_Acclimation/trunk/usearch_python_scripts --non-interactive --trust-server-cert
chmod -R 775 usearch_python_scripts
wget https://github.com/chrisLanderson/2016_Anderson_et_al_JAM_Acclimation/raw/master/gold.fasta.gz
gzip -d gold.fasta.gz
chmod 775 gold.fasta
mkdir usearch_results

usearch -derep_fulllength rumen.adaptation.format.fasta -sizeout -output usearch_results/rumen.adaptation.derep.fasta

usearch -sortbysize usearch_results/rumen.adaptation.derep.fasta -minsize 2 -output usearch_results/rumen.adaptation.derep.sort.fasta

usearch -cluster_otus usearch_results/rumen.adaptation.derep.sort.fasta -otus usearch_results/rumen.adaptation.otus1.fasta

usearch -uchime_ref usearch_results/rumen.adaptation.otus1.fasta -db gold.fasta -strand plus -nonchimeras usearch_results/rumen.adaptation.otus1.nonchimera.fasta

python usearch_python_scripts/fasta_number.py usearch_results/rumen.adaptation.otus1.nonchimera.fasta > usearch_results/rumen.adaptation.otus2.fasta

usearch -usearch_global rumen.adaptation.format.fasta -db usearch_results/rumen.adaptation.otus2.fasta -strand plus -id 0.97 -uc usearch_results/rumen.adaptation.otu_map.uc

python usearch_python_scripts/uc2otutab.py usearch_results/rumen.adaptation.otu_map.uc > usearch_results/rumen.adaptation.otu_table.txt

cp usearch_results/rumen.adaptation.otu_table.txt ./
```

Assign taxonomy to the OTU representative sequences:

```bash
assign_taxonomy.py -i usearch_results/rumen.adaptation.otus2.fasta -t anaconda/envs/rumenEnv/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt -r anaconda/envs/rumenEnv/lib/python2.7/site-packages/qiime_default_reference/gg_13_8_otus/rep_set/97_otus.fasta -o assign_gg_taxa -m mothur
```

Add the taxa outputted to the OTU table with the column header "taxonomy" and output the resulting file to biom format:

```bash
awk 'NR==1; NR > 1 {print $0 | "sort"}' rumen.adaptation.otu_table.txt > rumen.adaptation.otu_table.sort.txt 
sort assign_gg_taxa/rumen.adaptation.otus2_tax_assignments.txt > assign_gg_taxa/rumen.adaptation.otus2_tax_assignments.sort.txt
{ printf '\ttaxonomy\t\t\n'; cat assign_gg_taxa/rumen.adaptation.otus2_tax_assignments.sort.txt ; }  > assign_gg_taxa/rumen.adaptation.otus2_tax_assignments.sort.label.txt

paste rumen.adaptation.otu_table.sort.txt <(cut -f 2 assign_gg_taxa/rumen.adaptation.otus2_tax_assignments.sort.label.txt) > rumen.adaptation.otu_table.tax.txt

rm rumen.adaptation.otu_table.sort.txt

biom convert --table-type "OTU table" -i rumen.adaptation.otu_table.tax.txt -o rumen.adaptation.otu_table.tax.biom --process-obs-metadata taxonomy --to-json
```

Two of the samples were collected twice and seqeunced at a time point...not quite sure why...but lets remove the duplicate with the lower depth - samples R6 and R19.

```bash
printf "R6\nR19" > remove_samples.txt

filter_samples_from_otu_table.py -i rumen.adaptation.otu_table.tax.biom -o rumen.adaptation.otu_table.tax.filter.biom --sample_id_fp remove_samples.txt --negate_sample_id_fp

biom summarize-table -i rumen.adaptation.otu_table.tax.filter.biom -o rumen.adaptation.otu_table.tax.filter.summary.txt
#1165 OTUs, 145200 sequences
```

Align the sequences using the SILVA reference within mothur and view the alignment summary:

```bash
mothur "#align.seqs(fasta=usearch_results/rumen.adaptation.otus2.fasta, reference=Silva.nr_v119.align)"

mv usearch_results/rumen.adaptation.otus2.align ./

mothur "#summary.seqs(fasta=rumen.adaptation.otus2.align)"
```

I find it easiest to use R to collect the names of OTUs that are not aligning well. We can use the summary file to find this information. I decided to remove any OTU that did not end exactly at position 13125 (remember this is the end we sequenced off of) and started before position 1726:

```r
summary <- read.table("rumen.adaptation.otus2.summary", sep = "\t", header = TRUE)

summary_sub <- subset(summary, end == 13125 & start > 1726)

write.table(summary_sub$seqname, file = "remove_otus.txt", col.names = F, row.names = F)
```

Remove those seqeunces that did not align well from the OTU table and then remove OTUs with a Cyanobacteria classification. UPARSE should have removed sinlgeton OTUs, but while we are removing OTUs we want to double check this is the case (-n 2 parameter):

```bash
filter_otus_from_otu_table.py -i rumen.adaptation.otu_table.tax.filter.biom -o rumen.adaptation.otu_table.tax.filter.filter.biom -e remove_otus.txt -n 2 --negate_ids_to_exclude

filter_taxa_from_otu_table.py -i rumen.adaptation.otu_table.tax.filter.filter.biom -o rumen.adaptation.otu_table.tax.final.biom -n p__Cyanobacteria

biom summarize-table -i rumen.adaptation.otu_table.tax.final.biom -o rumen.adaptation.otu_table.tax.final.summary.txt
```

Leaving the OTUs that we removed from the OTU table within the aligned file is fine for downstream. Now use that aligned file to generate a phylogenetic tree using clearcut in mothur. For this to work, clearcut requires ID lengths greater than ~10 characters. To account for this, we simply add 10 'A's to the front of all sequence names. We then remove the 'A's after the tree is formed.

```bash
sed -i -e 's/>/>AAAAAAAAAA/g' rumen.adaptation.otus2.align

mothur "#dist.seqs(fasta=rumen.adaptation.otus2.align, output=lt)"

mothur "#clearcut(phylip=rumen.adaptation.otus2.phylip.dist)"

sed -i -e 's/AAAAAAAAAA//g' rumen.adaptation.otus2.phylip.tre
```

## Rarefaction Curves and Alpha Diversity

We wanted to look at the sequencing depth of each sample by monitoring the number of novel OTUs encountered as depth is increased. Setup here is for a depth roughly equivalent to least sample seqeunced within a step-up diet in our study so we can visually see full depth to give us an idea if the curves were plateauing....Also, we wanted to compare alpha diversity (observed OTUs and chao1 index), but with all samples at the sample depth.

Remember, from QIIME: "If the lines for some categories do not extend all the way to the right end of the x-axis, that means that at least one of the samples in that category does not have that many sequences."


```bash
multiple_rarefactions.py -i rumen.adaptation.otu_table.tax.final.biom -o alpha_rare -m 10 -x 6600 -s 500 -n 10
 
alpha_diversity.py -i alpha_rare/ -o alpha_rare_otu_chao -m observed_otus,chao1
 
collate_alpha.py -i alpha_rare_otu_chao/ -o alpha_rare_collate
 
make_rarefaction_plots.py -i alpha_rare_collate/ -m mapping.txt -e stderr --generate_average_tables -b Treatment -w -o alpha_rare_collate_avgtable
 
multiple_rarefactions_even_depth.py -i rumen.adaptation.otu_table.tax.final.biom -n 10 -d 2160 -o mult_even
 
alpha_diversity.py -i mult_even/ -o alpha_even -m observed_otus,chao1,goods_coverage 
 
collate_alpha.py -i alpha_even -o alpha_even_collate

alpha_diversity.py -i rumen.adaptation.otu_table.tax.final.biom -o goods.txt -m goods_coverage

```

```
## /Volumes/LaCie/rumen_adaptation_test/anaconda/envs/rumenEnv/lib/python2.7/site-packages/matplotlib/collections.py:590: FutureWarning: elementwise comparison failed; returning scalar instead, but in the future will perform elementwise comparison
##   if self._edgecolors == str('face'):
```


```r
library(XML)
library(ggplot2)
```

```
## Need help? Try the ggplot2 mailing list: http://groups.google.com/group/ggplot2.
```

```r
library(matrixStats)
```

```
## matrixStats v0.15.0 (2015-10-26) successfully loaded. See ?matrixStats for help.
```

```r
library(plyr)
```

```
## 
## Attaching package: 'plyr'
## 
## The following object is masked from 'package:matrixStats':
## 
##     count
```

```r
rare_table <- readHTMLTable("alpha_rare_collate_avgtable/rarefaction_plots.html")
rare_table$rare_data[rare_table$rare_data == "nan"] <- NA
alpha_rare <- na.omit(rare_table$rare_data)
colnames(alpha_rare)[2] <- "Seqs.Sample"
colnames(alpha_rare)[3] <- "chao1.Ave."
colnames(alpha_rare)[4] <- "chao1.Err."
colnames(alpha_rare)[5] <- "observed_otus.Ave."
colnames(alpha_rare)[6] <- "observed_otus.Err."

cols = c(2, 3, 4, 5, 6)

alpha_rare[, cols] <- lapply(cols, function(x) as.numeric(as.character(alpha_rare[, 
    x])))

corn_rare <- subset(alpha_rare, Treatment %in% c("C1", "C2", "C3", "C4", "CF"))
ramp_rare <- subset(alpha_rare, Treatment %in% c("R1", "R2", "R3", "R4", "RF"))
corn_rare$Diet <- "CORN"
ramp_rare$Diet <- "RAMP"
alpha_rare <- rbind(corn_rare, ramp_rare)
pd <- position_dodge(width = 275)

rare_otu_plot <- ggplot(alpha_rare, aes(x = Seqs.Sample, y = observed_otus.Ave., 
    colour = Treatment, group = Treatment, ymin = observed_otus.Ave. - observed_otus.Err., 
    ymax = observed_otus.Ave. + observed_otus.Err.)) + geom_line(position = pd) + 
    geom_pointrange(position = pd, size = 0.3) + scale_colour_manual(values = c(C1 = "#FF0000", 
    C2 = "#BF003F", C3 = "#7F007F", C4 = "#3F00BF", CF = "#0000FF", R1 = "#FF0000", 
    R2 = "#BF003F", R3 = "#7F007F", R4 = "#3F00BF", RF = "#0000FF")) + labs(x = "Sequences per Sample", 
    y = "Mean Observed OTUs") + theme(legend.title = element_blank(), text = element_text(size = 6)) + 
    facet_grid(~Diet)

rare_chao1_plot <- ggplot(alpha_rare, aes(x = Seqs.Sample, y = chao1.Ave., colour = Treatment, 
    group = Treatment, ymin = chao1.Ave. - chao1.Err., ymax = chao1.Ave. + chao1.Err.)) + 
    geom_line(position = pd) + geom_pointrange(position = pd, size = 0.3) + 
    scale_colour_manual(values = c(C1 = "#FF0000", C2 = "#BF003F", C3 = "#7F007F", 
        C4 = "#3F00BF", CF = "#0000FF", R1 = "#FF0000", R2 = "#BF003F", R3 = "#7F007F", 
        R4 = "#3F00BF", RF = "#0000FF")) + labs(x = "Sequences per Sample", 
    y = "Mean Chao1 Index") + theme(legend.title = element_blank(), text = element_text(size = 6)) + 
    facet_grid(~Diet)


alpha_chao1 <- read.table("alpha_even_collate/chao1.txt", header = TRUE, sep = "\t")
alpha_otu <- read.table("alpha_even_collate/observed_otus.txt", header = TRUE, 
    sep = "\t")

alpha_chao1 <- alpha_chao1[-c(1:3)]
colnames(alpha_chao1) <- c("CF_332", "R3_259", "R2_343", "R4_343", "R4_259", 
    "C3_346", "C4_332", "R1_222", "CF_346", "RF_343", "RF_222", "C3_332", "R2_222", 
    "R1_343", "R3_343", "C1_346", "C2_332", "R2_259", "R3_222", "C1_332", "C2_346", 
    "R4_222", "RF_259", "R1_259", "C4_346")
alpha_chao1_matrix <- as.matrix(alpha_chao1)
alpha_chao1_means <- data.frame(Means = colMeans(alpha_chao1_matrix), SD = colSds(alpha_chao1_matrix))

alpha_otu <- alpha_otu[-c(1:3)]
colnames(alpha_otu) <- c("CF_332", "R3_259", "R2_343", "R4_343", "R4_259", "C3_346", 
    "C4_332", "R1_222", "CF_346", "RF_343", "RF_222", "C3_332", "R2_222", "R1_343", 
    "R3_343", "C1_346", "C2_332", "R2_259", "R3_222", "C1_332", "C2_346", "R4_222", 
    "RF_259", "R1_259", "C4_346")
alpha_otu_matrix <- as.matrix(alpha_otu)
alpha_otu_means <- data.frame(Means = colMeans(alpha_otu_matrix), SD = colSds(alpha_otu_matrix))

steps <- data.frame(step = c("Finisher", "Step3", "Step2", "Step4", "Step4", 
    "Step3", "Step4", "Step1", "Finisher", "Finisher", "Finisher", "Step3", 
    "Step2", "Step1", "Step3", "Step1", "Step2", "Step2", "Step3", "Step1", 
    "Step2", "Step4", "Finisher", "Step1", "Step4"))
diets <- data.frame(diet = c("CORN", "RAMP", "RAMP", "RAMP", "RAMP", "CORN", 
    "CORN", "RAMP", "CORN", "RAMP", "RAMP", "CORN", "RAMP", "RAMP", "RAMP", 
    "CORN", "CORN", "RAMP", "RAMP", "CORN", "CORN", "RAMP", "RAMP", "RAMP", 
    "CORN"))

alpha_chao1_means <- cbind(alpha_chao1_means, steps, diets)
alpha_chao1_means$step <- factor(alpha_chao1_means$step, c("Step1", "Step2", 
    "Step3", "Step4", "Finisher"))
alpha_chao1_plot <- ggplot(alpha_chao1_means, aes(x = step, y = Means)) + geom_point(size = 2) + 
    labs(x = "", y = "Mean Chao1 Index") + theme(legend.title = element_blank(), 
    text = element_text(size = 6)) + facet_wrap(~diet)

alpha_otu_means <- cbind(alpha_otu_means, steps, diets)
alpha_otu_means$step <- factor(alpha_otu_means$step, c("Step1", "Step2", "Step3", 
    "Step4", "Finisher"))
alpha_otu_plot <- ggplot(alpha_otu_means, aes(x = step, y = Means)) + geom_point(size = 2) + 
    labs(x = "", y = "Mean Observed OTUs") + theme(legend.title = element_blank(), 
    text = element_text(size = 6)) + facet_wrap(~diet)



multiplot <- function(..., plotlist = NULL, file, cols = 1, layout = NULL) {
    library(grid)
    plots <- c(list(...), plotlist)
    numPlots = length(plots)
    if (is.null(layout)) {
        layout <- matrix(seq(1, cols * ceiling(numPlots/cols)), ncol = cols, 
            nrow = ceiling(numPlots/cols))
    }
    
    if (numPlots == 1) {
        print(plots[[1]])
        
    } else {
        grid.newpage()
        pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
        for (i in 1:numPlots) {
            matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
            print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row, layout.pos.col = matchidx$col))
        }
    }
}

png("FigureS2.png", units = "in", height = 12, width = 12, res = 300)
multiplot(rare_otu_plot, rare_chao1_plot, alpha_otu_plot, alpha_chao1_plot, 
    cols = 2)
dev.off()
```

```
## quartz_off_screen 
##                 2
```

```r
pdf("FigureS2.pdf", height = 12, width = 12)
multiplot(rare_otu_plot, rare_chao1_plot, alpha_otu_plot, alpha_chao1_plot, 
    cols = 2)
dev.off()
```

```
## quartz_off_screen 
##                 2
```

<div style="text-align:center" markdown="1">
![alpha_div](FigureS2.png)
</div>

## Taxonomy


```bash
biom convert --table-type "OTU table" -i rumen.adaptation.otu_table.tax.final.biom -o rumen.adaptation.otu_table.tax.final.txt --header-key taxonomy --output-metadata-id "taxonomy" --to-tsv

head -n 2 rumen.adaptation.otu_table.tax.final.txt > rumen.adaptation.otu_table.tax.final.genus.txt

grep "g__[a-zA-Z0-9]" rumen.adaptation.otu_table.tax.final.txt >> rumen.adaptation.otu_table.tax.final.genus.txt

biom convert --table-type "OTU table" -i rumen.adaptation.otu_table.tax.final.genus.txt -o rumen.adaptation.otu_table.tax.final.genus.biom --process-obs-metadata taxonomy --to-json

biom summarize-table -i rumen.adaptation.otu_table.tax.final.genus.biom -o rumen.adaptation.otu_table.tax.final.genus.summarize.txt


head -n 2 rumen.adaptation.otu_table.tax.final.txt > rumen.adaptation.otu_table.tax.final.family.txt

grep "f__[a-zA-Z0-9]" rumen.adaptation.otu_table.tax.final.txt >> rumen.adaptation.otu_table.tax.final.family.txt 

biom convert --table-type "OTU table" -i rumen.adaptation.otu_table.tax.final.family.txt -o rumen.adaptation.otu_table.tax.final.family.biom --process-obs-metadata taxonomy --to-json

biom summarize-table -i rumen.adaptation.otu_table.tax.final.family.biom -o rumen.adaptation.otu_table.tax.final.family.summarize.txt

```

## Beta Diversity

Split the OTU table into RAMP and CORN adapted samples then generate the beta diversity outputs for each:

```bash
biom summarize-table -i rumen.adaptation.otu_table.tax.final.biom -o rumen.adaptation.otu_table.tax.final.summarize.txt

beta_diversity_through_plots.py -i rumen.adaptation.otu_table.tax.final.biom -o beta_div -t rumen.adaptation.otus2.phylip.tre -m mapping.txt -p qiime_parameters_working.txt -e 2160

split_otu_table.py -i rumen.adaptation.otu_table.tax.final.biom -o split_total -m mapping.txt -f Diet
 
biom summarize-table -i split_total/rumen.adaptation.otu_table.tax.final__Diet_Corn__.biom -o split_total/control.summarize.txt

biom summarize-table -i split_total/rumen.adaptation.otu_table.tax.final__Diet_Ramp__.biom -o split_total/ramp.summarize.txt

beta_diversity_through_plots.py -i split_total/rumen.adaptation.otu_table.tax.final__Diet_Corn__.biom -o corn_beta_div -t rumen.adaptation.otus2.phylip.tre -m mapping.txt -p qiime_parameters_working.txt -e 2160

beta_diversity_through_plots.py -i split_total/rumen.adaptation.otu_table.tax.final__Diet_Ramp__.biom -o ramp_beta_div -t rumen.adaptation.otus2.phylip.tre -m mapping.txt -p qiime_parameters_working.txt -e 2959
```


## Community Statistics
We use permanova tests (implemented in R as adonis function in the vegan package) to identify differences in microbial community structure. Here we are using the unweighted unifrac as the distance matrix of choice:

```r
library(vegan)
```

```
## Loading required package: permute
## Loading required package: lattice
## This is vegan 2.3-2
```

```r
library(reshape)
```

```
## 
## Attaching package: 'reshape'
## 
## The following objects are masked from 'package:plyr':
## 
##     rename, round_any
```

```r
corn_unweighted <- read.table("corn_beta_div/unweighted_unifrac_dm.txt", sep = "\t", 
    header = TRUE)
row.names(corn_unweighted) <- corn_unweighted$X
corn_unweighted <- corn_unweighted[, -1]
corn_unweighted <- as.dist(corn_unweighted)

ramp_unweighted <- read.table("ramp_beta_div/unweighted_unifrac_dm.txt", sep = "\t", 
    header = TRUE)
row.names(ramp_unweighted) <- ramp_unweighted$X
ramp_unweighted <- ramp_unweighted[, -1]
ramp_unweighted <- as.dist(ramp_unweighted)

corn_map <- read.table("split_total/mapping__Diet_Corn__.txt", sep = "\t", header = FALSE)
colnames(corn_map) <- c("SampleID", "BarcodeSequence", "LinkerPrimerSequence", 
    "ReversePrimer", "Treatment", "Diet", "Step", "Individual", "Description")

ramp_map <- read.table("split_total/mapping__Diet_Ramp__.txt", sep = "\t", header = FALSE)
colnames(ramp_map) <- c("SampleID", "BarcodeSequence", "LinkerPrimerSequence", 
    "ReversePrimer", "Treatment", "Diet", "Step", "Individual", "Description")


adonis(corn_unweighted ~ Treatment + Individual, permutations = 999, data = corn_map)
```

```
## 
## Call:
## adonis(formula = corn_unweighted ~ Treatment + Individual, data = corn_map,      permutations = 999) 
## 
## Permutation: free
## Number of permutations: 999
## 
## Terms added sequentially (first to last)
## 
##            Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)   
## Treatment   4   1.43823 0.35956  2.0936 0.60783  0.010 **
## Individual  1   0.24097 0.24097  1.4031 0.10184  0.187   
## Residuals   4   0.68696 0.17174         0.29033          
## Total       9   2.36616                 1.00000          
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
adonis(ramp_unweighted ~ Treatment + Individual, permutations = 999, data = ramp_map)
```

```
## 
## Call:
## adonis(formula = ramp_unweighted ~ Treatment + Individual, data = ramp_map,      permutations = 999) 
## 
## Permutation: free
## Number of permutations: 999
## 
## Terms added sequentially (first to last)
## 
##            Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)    
## Treatment   4    1.2722 0.31805  1.7673 0.38853  0.001 ***
## Individual  1    0.3825 0.38250  2.1254 0.11682  0.004 ** 
## Residuals   9    1.6197 0.17996         0.49465           
## Total      14    3.2744                 1.00000           
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```


Need to check that the data does not violate the assumptions of PERMANOVA, however, the results below for corn-adapted animals are not reliable because the is no variance within group due to low n (that is, within a group there is only one value, i.e. C1-C1, C2-C2, etc.)

```r
anova(betadisper(corn_unweighted, corn_map$Treatment))
```

```
## Analysis of Variance Table
## 
## Response: Distances
##           Df   Sum Sq   Mean Sq    F value    Pr(>F)    
## Groups     4 0.012144 0.0030361 7.1773e+29 < 2.2e-16 ***
## Residuals  5 0.000000 0.0000000                         
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
anova(betadisper(corn_unweighted, corn_map$Individual))
```

```
## Analysis of Variance Table
## 
## Response: Distances
##           Df   Sum Sq   Mean Sq F value Pr(>F)
## Groups     1 0.000128 0.0001285  0.0135 0.9103
## Residuals  8 0.076006 0.0095008
```

```r
permutest(betadisper(corn_unweighted, corn_map$Treatment))
```

```
## 
## Permutation test for homogeneity of multivariate dispersions
## Permutation: free
## Number of permutations: 999
## 
## Response: Distances
##           Df   Sum Sq   Mean Sq          F N.Perm Pr(>F)    
## Groups     4 0.012144 0.0030361 6.8757e+29    999  0.001 ***
## Residuals  5 0.000000 0.0000000                             
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
permutest(betadisper(corn_unweighted, corn_map$Individual))
```

```
## 
## Permutation test for homogeneity of multivariate dispersions
## Permutation: free
## Number of permutations: 999
## 
## Response: Distances
##           Df   Sum Sq   Mean Sq      F N.Perm Pr(>F)
## Groups     1 0.000128 0.0001285 0.0135    999  0.925
## Residuals  8 0.076006 0.0095008
```

```r
anova(betadisper(ramp_unweighted, ramp_map$Treatment))
```

```
## Analysis of Variance Table
## 
## Response: Distances
##           Df   Sum Sq   Mean Sq F value Pr(>F)
## Groups     4 0.005649 0.0014123  0.4373 0.7791
## Residuals 10 0.032296 0.0032296
```

```r
anova(betadisper(ramp_unweighted, ramp_map$Individual))
```

```
## Analysis of Variance Table
## 
## Response: Distances
##           Df   Sum Sq   Mean Sq F value Pr(>F)
## Groups     2 0.001527 0.0007634  0.1269  0.882
## Residuals 12 0.072203 0.0060169
```

```r
permutest(betadisper(ramp_unweighted, ramp_map$Treatment))
```

```
## 
## Permutation test for homogeneity of multivariate dispersions
## Permutation: free
## Number of permutations: 999
## 
## Response: Distances
##           Df   Sum Sq   Mean Sq      F N.Perm Pr(>F)
## Groups     4 0.005649 0.0014123 0.4373    999  0.788
## Residuals 10 0.032296 0.0032296
```

```r
permutest(betadisper(ramp_unweighted, ramp_map$Individual))
```

```
## 
## Permutation test for homogeneity of multivariate dispersions
## Permutation: free
## Number of permutations: 999
## 
## Response: Distances
##           Df   Sum Sq   Mean Sq      F N.Perm Pr(>F)
## Groups     2 0.001527 0.0007634 0.1269    999  0.891
## Residuals 12 0.072203 0.0060169
```

We used Mann-Whitney U Test as a post-hoc method to compare the microbial community structure of stages within an adaptation program.  To do this, we compared the pairwise distances relative to step 1.  For instance, to test for a difference in community structure between step 2 and step 3, we compared all the pairwise distances from step 1 samples to step 2 samples to the distance from step 1 samples to step 3 samples:

```r
corn_unweighted_matrix <- as.matrix(corn_unweighted)
m <- as.matrix(corn_unweighted)
m2 <- melt(m)[melt(upper.tri(m))$value, ]
names(m2) <- c("Sample1", "Sample2", "distance")
write.table(m2, "corn_unweighted_pariwise_dist.txt", sep = "\t", row.names = FALSE)

ramp_unweighted_matrix <- as.matrix(ramp_unweighted)
m <- as.matrix(ramp_unweighted)
m2 <- melt(m)[melt(upper.tri(m))$value, ]
names(m2) <- c("Sample1", "Sample2", "distance")
write.table(m2, "ramp_unweighted_pariwise_dist.txt", sep = "\t", row.names = FALSE)
```


```bash
wget https://raw.githubusercontent.com/chrisLanderson/2016_Anderson_et_al_JAM_Acclimation/master/treatment_distances.pl
 
chmod 775 treatment_distances.pl
 
./treatment_distances.pl -mapping_file=mapping.txt -distance_file=corn_unweighted_pariwise_dist.txt -category=Treatment
 
mv treatment_distances.txt corn_unweighted_treatment_distances.txt
 
./treatment_distances.pl -mapping_file=mapping.txt -distance_file=ramp_unweighted_pariwise_dist.txt -category=Treatment
 
mv treatment_distances.txt ramp_unweighted_treatment_distances.txt
```

```
## --2015-12-11 14:01:25--  https://raw.githubusercontent.com/chrisLanderson/2016_Anderson_et_al_JAM_Acclimation/master/treatment_distances.pl
## Resolving raw.githubusercontent.com... 23.235.40.133
## Connecting to raw.githubusercontent.com|23.235.40.133|:443... connected.
## HTTP request sent, awaiting response... 200 OK
## Length: 6979 (6.8K) [text/plain]
## Saving to: ‘treatment_distances.pl’
## 
##      0K ......                                                100%  555M=0s
## 
## 2015-12-11 14:01:26 (555 MB/s) - ‘treatment_distances.pl’ saved [6979/6979]
## 
## 
## Number of pairwise comparisons read in: 45
## 
## 
## Number of pairwise comparisons read in: 105
```


```r
corn_unweighted <- read.table("corn_unweighted_treatment_distances.txt", sep = "\t", 
    header = TRUE)
corn_unweighted_pairs <- split(corn_unweighted, corn_unweighted$Sample1Diet_Sample2Diet)

c1c1_c1c2_test <- wilcox.test(corn_unweighted_pairs$C1_C1$Distance, corn_unweighted_pairs$C1_C2$Distance)
c1c1_c1c2_test
```

```
## 
## 	Wilcoxon rank sum test
## 
## data:  corn_unweighted_pairs$C1_C1$Distance and corn_unweighted_pairs$C1_C2$Distance
## W = 0, p-value = 0.4
## alternative hypothesis: true location shift is not equal to 0
```

```r
lapply(c1c1_c1c2_test$p.value, write, "corn_unweighted_c1c1_c1c2_wilcox.txt", 
    append = TRUE)
```

```
## [[1]]
## NULL
```

```r
c1c2_c1c3_test <- wilcox.test(corn_unweighted_pairs$C1_C2$Distance, corn_unweighted_pairs$C1_C3$Distance)
c1c2_c1c3_test
```

```
## 
## 	Wilcoxon rank sum test
## 
## data:  corn_unweighted_pairs$C1_C2$Distance and corn_unweighted_pairs$C1_C3$Distance
## W = 6, p-value = 0.6857
## alternative hypothesis: true location shift is not equal to 0
```

```r
lapply(c1c2_c1c3_test$p.value, write, "corn_unweighted_c1c2_c1c3_wilcox.txt", 
    append = TRUE)
```

```
## [[1]]
## NULL
```

```r
c1c3_c1c4_test <- wilcox.test(corn_unweighted_pairs$C1_C3$Distance, corn_unweighted_pairs$C1_C4$Distance)
c1c3_c1c4_test
```

```
## 
## 	Wilcoxon rank sum test
## 
## data:  corn_unweighted_pairs$C1_C3$Distance and corn_unweighted_pairs$C1_C4$Distance
## W = 0, p-value = 0.02857
## alternative hypothesis: true location shift is not equal to 0
```

```r
lapply(c1c3_c1c4_test$p.value, write, "corn_unweighted_c1c3_c1c4_wilcox.txt", 
    append = TRUE)
```

```
## [[1]]
## NULL
```

```r
c1c4_c1cf_test <- wilcox.test(corn_unweighted_pairs$C1_C4$Distance, corn_unweighted_pairs$C1_CF$Distance)
c1c4_c1cf_test
```

```
## 
## 	Wilcoxon rank sum test
## 
## data:  corn_unweighted_pairs$C1_C4$Distance and corn_unweighted_pairs$C1_CF$Distance
## W = 2, p-value = 0.1143
## alternative hypothesis: true location shift is not equal to 0
```

```r
lapply(c1c4_c1cf_test$p.value, write, "corn_unweighted_c1c4_c1cf_wilcox.txt", 
    append = TRUE)
```

```
## [[1]]
## NULL
```

```r
ramp_unweighted <- read.table("ramp_unweighted_treatment_distances.txt", sep = "\t", 
    header = TRUE)
ramp_unweighted_pairs <- split(ramp_unweighted, ramp_unweighted$Sample1Diet_Sample2Diet)

r1r1_r1r2_test <- wilcox.test(ramp_unweighted_pairs$R1_R1$Distance, ramp_unweighted_pairs$R1_R2$Distance)
r1r1_r1r2_test
```

```
## 
## 	Wilcoxon rank sum test
## 
## data:  ramp_unweighted_pairs$R1_R1$Distance and ramp_unweighted_pairs$R1_R2$Distance
## W = 2, p-value = 0.03636
## alternative hypothesis: true location shift is not equal to 0
```

```r
lapply(r1r1_r1r2_test$p.value, write, "ramp_unweighted_r1r1_r1r2_wilcox.txt", 
    append = TRUE)
```

```
## [[1]]
## NULL
```

```r
r1r2_r1r3_test <- wilcox.test(ramp_unweighted_pairs$R1_R2$Distance, ramp_unweighted_pairs$R1_R3$Distance)
r1r2_r1r3_test
```

```
## 
## 	Wilcoxon rank sum test
## 
## data:  ramp_unweighted_pairs$R1_R2$Distance and ramp_unweighted_pairs$R1_R3$Distance
## W = 0, p-value = 4.114e-05
## alternative hypothesis: true location shift is not equal to 0
```

```r
lapply(r1r2_r1r3_test$p.value, write, "ramp_unweighted_r1r2_r1r3_wilcox.txt", 
    append = TRUE)
```

```
## [[1]]
## NULL
```

```r
r1r3_r1r4_test <- wilcox.test(ramp_unweighted_pairs$R1_R3$Distance, ramp_unweighted_pairs$R1_R4$Distance)
r1r3_r1r4_test
```

```
## 
## 	Wilcoxon rank sum test
## 
## data:  ramp_unweighted_pairs$R1_R3$Distance and ramp_unweighted_pairs$R1_R4$Distance
## W = 53, p-value = 0.2973
## alternative hypothesis: true location shift is not equal to 0
```

```r
lapply(r1r3_r1r4_test$p.value, write, "ramp_unweighted_r1r3_r1r4_wilcox.txt", 
    append = TRUE)
```

```
## [[1]]
## NULL
```

```r
r1r4_r1rf_test <- wilcox.test(ramp_unweighted_pairs$R1_R4$Distance, ramp_unweighted_pairs$R1_RF$Distance)
r1r4_r1rf_test
```

```
## 
## 	Wilcoxon rank sum test
## 
## data:  ramp_unweighted_pairs$R1_R4$Distance and ramp_unweighted_pairs$R1_RF$Distance
## W = 29, p-value = 0.3401
## alternative hypothesis: true location shift is not equal to 0
```

```r
lapply(r1r4_r1rf_test$p.value, write, "ramp_unweighted_r1r4_r1rf_wilcox.txt", 
    append = TRUE)
```

```
## [[1]]
## NULL
```

## Shared OTUs and Sequences

```bash
collapse_samples.py -b rumen.adaptation.otu_table.tax.final.biom -m mapping.txt --output_biom_fp rumen.adaptation.collapse_samples.biom --output_mapping_fp mapping_collapse.txt --collapse_fields Treatment --collapse_mode sum

split_otu_table.py -i rumen.adaptation.collapse_samples.biom -m mapping_collapse.txt -f Diet -o split_collapse_samples

biom convert -i split_collapse_samples/rumen.adaptation.collapse_samples__Diet_Corn__.biom -o split_collapse_samples/rumen.adaptation.collapse_samples__Diet_Corn__.json.biom --to-json --table-type="OTU table"

biom convert -i split_collapse_samples/rumen.adaptation.collapse_samples__Diet_Ramp__.biom -o split_collapse_samples/rumen.adaptation.collapse_samples__Diet_Ramp__.json.biom --to-json --table-type="OTU table"
```


```r
library(biom)
library(gplots)
```

```
## 
## Attaching package: 'gplots'
## 
## The following object is masked from 'package:stats':
## 
##     lowess
```

```r
corn_biom <- read_biom("split_collapse_samples/rumen.adaptation.collapse_samples__Diet_Corn__.json.biom")

corn_df <- as.data.frame(as(biom_data(corn_biom), "matrix"))

corn_boolean_df <- as.data.frame(corn_df > 0 + 0)

corn_boolean_df <- corn_boolean_df[c("C1", "C2", "C3", "C4", "CF")]

png("Figure4_panelA.png", units = "in", height = 6, width = 6, res = 300)
corn_venn <- venn(corn_boolean_df)
dev.off()
```

```
## quartz_off_screen 
##                 2
```

```r
pdf("Figure4_panelA.pdf", height = 6, width = 6)
corn_venn <- venn(corn_boolean_df)
dev.off()
```

```
## quartz_off_screen 
##                 2
```

<div style="text-align:center" markdown="1">
![corn_venn](Figure4_panelA.png)
</div>


```r
ramp_biom <- read_biom("split_collapse_samples/rumen.adaptation.collapse_samples__Diet_Ramp__.json.biom")

ramp_df <- as.data.frame(as(biom_data(ramp_biom), "matrix"))

ramp_boolean_df <- as.data.frame(ramp_df > 0 + 0)

ramp_boolean_df <- ramp_boolean_df[c("R1", "R2", "R3", "R4", "RF")]

png("Figure4_panelB.png", units = "in", height = 6, width = 6, res = 300)
ramp_venn <- venn(ramp_boolean_df)
dev.off()
```

```
## quartz_off_screen 
##                 2
```

```r
pdf("Figure4_panelB.pdf", height = 6, width = 6)
ramp_venn <- venn(ramp_boolean_df)
dev.off()
```

```
## quartz_off_screen 
##                 2
```

<div style="text-align:center" markdown="1">
![ramp_venn](Figure4_panelB.png)
</div>

Get shared number of OTUs and sequences per sample:

```bash
shared_phylotypes.py -i rumen.adaptation.collapse_samples.biom -o collapse_samples_shared_otus.txt
```


```r
library(spaa)
share_otu <- read.table("collapse_samples_shared_otus.txt", sep = "\t", row.names = 1, 
    header = TRUE)
share_dist <- as.dist(share_otu)
share_list <- dist2list(as.dist(t(share_dist)))
share_list_cut <- share_list[as.numeric(share_list$col) > as.numeric(share_list$row), 
    ]

for (i in 1:nrow(share_list_cut)) {
    row <- as.character(share_list_cut[i, 1])
    col <- as.character(share_list_cut[i, 2])
    value <- as.numeric(share_list_cut[i, 3])
    max_otu <- max(share_otu[row, row], share_otu[col, col])
    per <- (value/max_otu) * 100
    otu_out <- c(row, col, value, per)
    write(otu_out, file = "TableS4.txt", sep = "\t", ncolumns = 4, append = TRUE)
}

collapse_biom <- read_biom("rumen.adaptation.collapse_samples.biom")
collapse <- as.matrix(as(biom_data(collapse_biom), "matrix"))
collapse_df <- as.data.frame(collapse)


seq_shared_func <- function(x) {
    single_combo <- unlist(x)
    collapse_sub <- collapse_df[, names(collapse_df) %in% single_combo]
    collapse_sub[, 3] <- collapse_sub[, 1] + collapse_sub[, 2]
    sub_sum <- colSums(collapse_sub)
    collapse_sub[collapse_sub == 0] <- NA
    collapse_sub2 <- na.omit(collapse_sub)
    collapse_sub2[, 3] <- collapse_sub2[, 1] + collapse_sub2[, 2]
    sub_sum2 <- colSums(collapse_sub2)
    per <- (sub_sum2["V3"]/sub_sum["V3"]) * 100
    collapse_out <- c(names(collapse_sub2)[1], names(collapse_sub2)[2], toString(sub_sum2["V3"]), 
        toString(sub_sum["V3"]), toString(per))
    write(collapse_out, file = "TableS3.txt", sep = "\t", ncolumns = 5, append = TRUE)
}

combn(colnames(collapse), 2, simplify = FALSE, FUN = seq_shared_func)
```

```
## [[1]]
## NULL
## 
## [[2]]
## NULL
## 
## [[3]]
## NULL
## 
## [[4]]
## NULL
## 
## [[5]]
## NULL
## 
## [[6]]
## NULL
## 
## [[7]]
## NULL
## 
## [[8]]
## NULL
## 
## [[9]]
## NULL
## 
## [[10]]
## NULL
## 
## [[11]]
## NULL
## 
## [[12]]
## NULL
## 
## [[13]]
## NULL
## 
## [[14]]
## NULL
## 
## [[15]]
## NULL
## 
## [[16]]
## NULL
## 
## [[17]]
## NULL
## 
## [[18]]
## NULL
## 
## [[19]]
## NULL
## 
## [[20]]
## NULL
## 
## [[21]]
## NULL
## 
## [[22]]
## NULL
```

## OTU Heatmap


```r
library(Heatplus)
library(RColorBrewer)

otu_table_biom <- read_biom("rumen.adaptation.otu_table.tax.final.biom")
otu_table <- as.data.frame(as(biom_data(otu_table_biom), "matrix"))
row.names(otu_table) <- otu_table$OTU.ID
colnames(otu_table) <- c("CF_332", "R3_259", "R2_343", "R4_343", "R4_259", "C3_346", 
    "C4_332", "R1_222", "CF_346", "RF_343", "RF_222", "C3_332", "R2_222", "R1_343", 
    "R3_343", "C1_346", "C2_332", "R2_259", "R3_222", "C1_332", "C2_346", "R4_222", 
    "RF_259", "R1_259", "C4_346")
otu_table_trans <- as.data.frame(t(otu_table))
otu_table_rel <- otu_table_trans/rowSums(otu_table_trans)
scalewhiteblack <- colorRampPalette(c("white", "black"), space = "rgb")(100)
otu_dist <- vegdist(otu_table_rel, method = "bray")
row.clus <- hclust(otu_dist, "aver")
maxab <- apply(otu_table_rel, 2, max)
n1 <- names(which(maxab < 0.01))
otu_table_rel2 <- otu_table_rel[, -which(names(otu_table_rel) %in% n1)]
otu_dist_col <- vegdist(t(otu_table_rel2), method = "bray")
col.clus <- hclust(otu_dist_col, "aver")

pdf("Figure2.pdf")
heatmap.2(as.matrix(otu_table_rel2), Rowv = as.dendrogram(row.clus), Colv = as.dendrogram(col.clus), 
    col = scalewhiteblack, margins = c(2, 6), trace = "none", density.info = "none", 
    labCol = "", xlab = "OTUs", ylab = "Samples", main = "", lhei = c(2, 8))
dev.off()
```

```
## quartz_off_screen 
##                 2
```

```r
png("Figure2.png", units = "in", height = 12, width = 12, res = 300)
heatmap.2(as.matrix(otu_table_rel2), Rowv = as.dendrogram(row.clus), Colv = as.dendrogram(col.clus), 
    col = scalewhiteblack, margins = c(2, 6), trace = "none", density.info = "none", 
    labCol = "", xlab = "OTUs", ylab = "Samples", main = "", lhei = c(2, 8))
dev.off()
```

```
## quartz_off_screen 
##                 2
```

<div style="text-align:center" markdown="1">
![otu_heatmap](Figure2.png)
</div>

## Pairwise Comparisons and Principle Component Analysis


```r
ramp_unweighted <- read.table("ramp_unweighted_treatment_distances.txt", sep = "\t", 
    header = TRUE)
corn_unweighted <- read.table("corn_unweighted_treatment_distances.txt", sep = "\t", 
    header = TRUE)

corn_unweighted_pairs <- split(corn_unweighted, corn_unweighted$Sample1Diet_Sample2Diet)
corn_1_pairs <- rbind(corn_unweighted_pairs$C1_C1, corn_unweighted_pairs$C1_C2, 
    corn_unweighted_pairs$C1_C3, corn_unweighted_pairs$C1_C4, corn_unweighted_pairs$C1_CF)

ramp_unweighted_pairs <- split(ramp_unweighted, ramp_unweighted$Sample1Diet_Sample2Diet)
ramp_1_pairs <- rbind(ramp_unweighted_pairs$R1_R1, ramp_unweighted_pairs$R1_R2, 
    ramp_unweighted_pairs$R1_R3, ramp_unweighted_pairs$R1_R4, ramp_unweighted_pairs$R1_RF)

ramp_1_pairs <- as.data.frame(sapply(ramp_1_pairs, gsub, pattern = "_", replacement = "-"))
corn_1_pairs <- as.data.frame(sapply(corn_1_pairs, gsub, pattern = "_", replacement = "-"))

ramp_1_pairs[, "Distance"] <- lapply("Distance", function(x) as.numeric(as.character(ramp_1_pairs[, 
    x])))
corn_1_pairs[, "Distance"] <- lapply("Distance", function(x) as.numeric(as.character(corn_1_pairs[, 
    x])))

corn_distance <- ggplot(corn_1_pairs, aes(x = Sample1Diet_Sample2Diet, y = Distance)) + 
    geom_boxplot() + geom_point(position = position_jitter(width = 0.15)) + 
    labs(x = "", y = "Unweighted UniFrac Distance\n") + guides(fill = FALSE) + 
    theme(axis.text.x = element_text(colour = "black"), axis.title.y = element_text(size = 14), 
        axis.ticks = element_blank())

ramp_distance <- ggplot(ramp_1_pairs, aes(x = Sample1Diet_Sample2Diet, y = Distance)) + 
    geom_boxplot() + geom_point(position = position_jitter(width = 0.15)) + 
    labs(x = "", y = "Unweighted UniFrac Distance\n") + guides(fill = FALSE) + 
    theme(axis.text.x = element_text(colour = "black"), axis.title.y = element_text(size = 14), 
        axis.ticks = element_blank())


con <- file("corn_beta_div/unweighted_unifrac_pc.txt")
corn_pc <- read.table(con, skip = 9, nrow = 10, sep = "\t")
corn_pc <- corn_pc[, c("V1", "V2", "V3")]
colnames(corn_pc) <- c("SampleID", "PC1", "PC2")

con <- file("ramp_beta_div/unweighted_unifrac_pc.txt")
ramp_pc <- read.table(con, skip = 9, nrow = 15, sep = "\t")
ramp_pc <- ramp_pc[, c("V1", "V2", "V3")]
colnames(ramp_pc) <- c("SampleID", "PC1", "PC2")

mapping <- read.table("mapping.txt", header = FALSE, sep = "\t")
colnames(mapping) <- c("SampleID", "BC", "For", "Rev", "Treatment", "Diet", 
    "Step", "Indiv", "Description")

corn_pc_map <- merge(corn_pc, mapping, by = "SampleID")
ramp_pc_map <- merge(ramp_pc, mapping, by = "SampleID")

shape_corn <- c(C1 = 15, C2 = 16, C3 = 17, C4 = 18, CF = 8)
corn_pc_plot <- ggplot(corn_pc_map, aes(PC1, PC2)) + geom_point(aes(size = 4, 
    shape = factor(Treatment))) + xlab("PC1 (38.9%)") + ylab("PC2 (13.5%)") + 
    guides(size = FALSE) + scale_shape_manual(name = "", values = shape_corn) + 
    labs(fill = "")

shape_ramp <- c(R1 = 15, R2 = 16, R3 = 17, R4 = 18, RF = 8)
ramp_pc_plot <- ggplot(ramp_pc_map, aes(PC1, PC2)) + geom_point(aes(size = 4, 
    shape = factor(Treatment))) + xlab("PC1 (20.5%)") + ylab("PC2 (13.0%)") + 
    guides(size = FALSE) + scale_shape_manual(name = "", values = shape_ramp) + 
    labs(fill = "")

con <- file("beta_div/unweighted_unifrac_pc.txt")
total_pc <- read.table(con, skip = 9, nrow = 25, sep = "\t")
total_pc <- total_pc[, c("V1", "V2", "V3")]
colnames(total_pc) <- c("SampleID", "PC1", "PC2")

total_pc_map <- merge(total_pc, mapping, by = "SampleID")

shape_all <- c(R1 = 15, R2 = 16, R3 = 17, R4 = 18, RF = 8, C1 = 15, C2 = 16, 
    C3 = 17, C4 = 18, CF = 8)
color_all <- c(R1 = "red", R2 = "red", R3 = "red", R4 = "red", RF = "red", C1 = "blue", 
    C2 = "blue", C3 = "blue", C4 = "blue", CF = "blue")
total_pc_plot <- ggplot(total_pc_map, aes(PC1, PC2)) + geom_point(aes(size = 4, 
    color = factor(Treatment), shape = factor(Treatment))) + xlab("PC1 (21.1%)") + 
    ylab("PC2 (10.0%)") + guides(size = FALSE) + scale_shape_manual(name = "", 
    values = shape_all) + scale_colour_manual(name = "", values = color_all) + 
    labs(fill = "")


pdf("Figure1.pdf", height = 6, width = 16)
multiplot(total_pc_plot, corn_distance, ramp_distance, cols = 3)
dev.off()
```

```
## quartz_off_screen 
##                 2
```

```r
png("Figure1.png", height = 6, width = 16, units = "in", res = 300)
multiplot(total_pc_plot, corn_distance, ramp_distance, cols = 3)
dev.off()
```

```
## quartz_off_screen 
##                 2
```

<div style="text-align:center" markdown="1">
![unweighted_distance](Figure1.png)
</div>


## OTU-Level Statistics and Comparisons
Wanted to look at differential OTUs at break points in ramp and corn adapted animals based on pairwise t-statstics. We use LEfSe to compare samples:

```bash
filter_otus_from_otu_table.py -i split_total/rumen.adaptation.otu_table.tax.final__Diet_Corn__.biom -n 1 -o split_total/rumen.adaptation.otu_table.tax.final__Diet_Corn__.filter.biom

filter_otus_from_otu_table.py -i split_total/rumen.adaptation.otu_table.tax.final__Diet_Ramp__.biom -n 1 -o split_total/rumen.adaptation.otu_table.tax.final__Diet_Ramp__.filter.biom
```


```r
corn_biom <- read_biom("split_total/rumen.adaptation.otu_table.tax.final__Diet_Corn__.filter.biom")
corn_table <- as.data.frame(as(biom_data(corn_biom), "matrix"))
corn_rel <- sweep(corn_table, 2, colSums(corn_table), FUN = "/")
rownames(corn_rel) <- paste("OTU", rownames(corn_rel), sep = "")
corn_rel2 <- corn_rel[0, ]
corn_rel2[nrow(corn_rel2) + 1, ] <- c("break2", "break1", "break2", "break2", 
    "break1", "break1", "break1", "break1", "break1", "break2")
corn_rel2[nrow(corn_rel2) + 1, ] <- c("A332", "A346", "A332", "A346", "A332", 
    "A346", "A332", "A332", "A346", "A346")
row.names(corn_rel2) <- c("break", "animal")
corn_rel_merge <- rbind(corn_rel2, corn_rel)
write.table(corn_rel_merge, sep = "\t", file = "split_total/rumen.adaptation.otu_table.tax.final__Diet_Corn__.filter.relative.txt", 
    row.names = TRUE, col.names = FALSE, quote = FALSE)

ramp_biom <- read_biom("split_total/rumen.adaptation.otu_table.tax.final__Diet_Ramp__.filter.biom")
ramp_table <- as.data.frame(as(biom_data(ramp_biom), "matrix"))
ramp_rel <- sweep(ramp_table, 2, colSums(ramp_table), FUN = "/")
rownames(ramp_rel) <- paste("OTU", rownames(ramp_rel), sep = "")
ramp_rel2 <- ramp_rel[0, ]
ramp_rel2[nrow(ramp_rel2) + 1, ] <- c("break3", "break2", "break3", "break3", 
    "break1", "break3", "break3", "break2", "break1", "break3", "break2", "break3", 
    "break2", "break3", "break1")
ramp_rel2[nrow(ramp_rel2) + 1, ] <- c("A259", "A343", "A343", "A259", "A222", 
    "A343", "A222", "A222", "A343", "A343", "A259", "A222", "A222", "A259", 
    "A259")
row.names(ramp_rel2) <- c("break", "animal")
ramp_rel_merge <- rbind(ramp_rel2, ramp_rel)
ramp_rel_merge_1 <- subset(ramp_rel_merge, select = c(R18, R24, R8, R12, R23, 
    R5))
ramp_rel_merge_2 <- subset(ramp_rel_merge, select = c(R12, R23, R5, R11, R13, 
    R14, R20, R21, R23, R3, R4, R7))
write.table(ramp_rel_merge_1, sep = "\t", file = "split_total/rumen.adaptation.otu_table.tax.final__Diet_Ramp__.filter.b12.relative.txt", 
    row.names = TRUE, col.names = FALSE, quote = FALSE)
write.table(ramp_rel_merge_2, sep = "\t", file = "split_total/rumen.adaptation.otu_table.tax.final__Diet_Ramp__.filter.b23.relative.txt", 
    row.names = TRUE, col.names = FALSE, quote = FALSE)
```


```bash
wget https://bitbucket.org/nsegata/lefse/get/default.zip -O lefse.zip
unzip lefse.zip
mv nsegata* lefse

python lefse/format_input.py split_total/rumen.adaptation.otu_table.tax.final__Diet_Corn__.filter.relative.txt corn_lefse_format.txt -c 1 -u 2 -o 1000000 
python lefse/run_lefse.py corn_lefse_format.txt corn_lefse_result.txt

python lefse/format_input.py split_total/rumen.adaptation.otu_table.tax.final__Diet_Ramp__.filter.b12.relative.txt ramp_12_lefse_format.txt -c 1 -u 2 -o 1000000 
python lefse/run_lefse.py ramp_12_lefse_format.txt ramp_12_lefse_result.txt

python lefse/format_input.py split_total/rumen.adaptation.otu_table.tax.final__Diet_Ramp__.filter.b23.relative.txt ramp_23_lefse_format.txt -c 1 -u 2 -o 1000000 
python lefse/run_lefse.py ramp_23_lefse_format.txt ramp_23_lefse_result.txt
```

```
## --2015-12-11 14:01:47--  https://bitbucket.org/nsegata/lefse/get/default.zip
## Resolving bitbucket.org... 131.103.20.168, 131.103.20.167
## Connecting to bitbucket.org|131.103.20.168|:443... connected.
## HTTP request sent, awaiting response... 200 OK
## Length: unspecified [application/zip]
## Saving to: ‘lefse.zip’
## 
##      0K .......... .......... .......... .......... ..........  708K
##     50K ........                                                168M=0.07s
## 
## 2015-12-11 14:01:48 (822 KB/s) - ‘lefse.zip’ saved [59458]
## 
## Archive:  lefse.zip
##   inflating: nsegata-lefse-094f447691f0/.hg_archival.txt  
##   inflating: nsegata-lefse-094f447691f0/.hgtags  
##   inflating: nsegata-lefse-094f447691f0/__init__.py  
##   inflating: nsegata-lefse-094f447691f0/example/run.sh  
##   inflating: nsegata-lefse-094f447691f0/format_input.py  
##   inflating: nsegata-lefse-094f447691f0/lefse.py  
##   inflating: nsegata-lefse-094f447691f0/lefse2circlader.py  
##   inflating: nsegata-lefse-094f447691f0/lefsebiom/AbundanceTable.py  
##   inflating: nsegata-lefse-094f447691f0/lefsebiom/CClade.py  
##   inflating: nsegata-lefse-094f447691f0/lefsebiom/ConstantsBreadCrumbs.py  
##   inflating: nsegata-lefse-094f447691f0/lefsebiom/ValidateData.py  
##   inflating: nsegata-lefse-094f447691f0/lefsebiom/__init__.py  
##   inflating: nsegata-lefse-094f447691f0/plot_cladogram.py  
##   inflating: nsegata-lefse-094f447691f0/plot_features.py  
##   inflating: nsegata-lefse-094f447691f0/plot_res.py  
##   inflating: nsegata-lefse-094f447691f0/qiime2lefse.py  
##   inflating: nsegata-lefse-094f447691f0/requirements.txt  
##   inflating: nsegata-lefse-094f447691f0/run_lefse.py  
## Number of significantly discriminative features: 120 ( 120 ) before internal wilcoxon
## Number of discriminative features with abs LDA score > 2.0 : 120
## Number of significantly discriminative features: 37 ( 37 ) before internal wilcoxon
## Number of discriminative features with abs LDA score > 2.0 : 37
## Number of significantly discriminative features: 118 ( 118 ) before internal wilcoxon
## Number of discriminative features with abs LDA score > 2.0 : 118
```


```r
corn_lefse <- read.table("corn_lefse_result.txt", header = FALSE, sep = "\t")
corn_lefse <- corn_lefse[complete.cases(corn_lefse), ]
corn_lefse$V1 <- gsub("OTU", "", corn_lefse$V1)
write.table(corn_lefse$V1, file = "corn_lefse_otus.txt", row.names = FALSE, 
    col.names = FALSE, quote = FALSE)

ramp_lefse_12 <- read.table("ramp_12_lefse_result.txt", header = FALSE, sep = "\t")
ramp_lefse_12 <- ramp_lefse_12[complete.cases(ramp_lefse_12), ]
ramp_lefse_12$V1 <- gsub("OTU", "", ramp_lefse_12$V1)
write.table(ramp_lefse_12$V1, file = "ramp_12_lefse_otus.txt", row.names = FALSE, 
    col.names = FALSE, quote = FALSE)

ramp_lefse_23 <- read.table("ramp_23_lefse_result.txt", header = FALSE, sep = "\t")
ramp_lefse_23 <- ramp_lefse_23[complete.cases(ramp_lefse_23), ]
ramp_lefse_23$V1 <- gsub("OTU", "", ramp_lefse_23$V1)
write.table(ramp_lefse_23$V1, file = "ramp_23_lefse_otus.txt", row.names = FALSE, 
    col.names = FALSE, quote = FALSE)
```


```bash
#replace "OTU"
filter_otus_from_otu_table.py -i split_total/rumen.adaptation.otu_table.tax.final__Diet_Corn__.filter.biom -o corn_lefse.biom -e corn_lefse_otus.txt --negate_ids_to_exclude

biom convert -i corn_lefse.biom -o corn_lefse.txt --table-type="OTU table" --to-tsv --header-key taxonomy

awk '{gsub("; ","\t",$0); print;}' corn_lefse.txt | awk  '{gsub("#OTU","OTU",$0); print;}' | cut -f-11,16 | tail -n +2 | awk '{if(NR==1){print $0,"\tfamily"}else{print }}' > corn_lefse_tax.txt

filter_otus_from_otu_table.py -i split_total/rumen.adaptation.otu_table.tax.final__Diet_Ramp__.filter.biom -o ramp_12_lefse.biom -e ramp_12_lefse_otus.txt --negate_ids_to_exclude

biom convert -i ramp_12_lefse.biom -o  ramp_12_lefse.txt --table-type="OTU table" --to-tsv --header-key taxonomy

awk '{gsub("; ","\t",$0); print;}' ramp_12_lefse.txt | awk  '{gsub("#OTU","OTU",$0); print;}' | cut -f-16,21 | tail -n +2 | awk '{if(NR==1){print $0,"\tfamily"}else{print }}' > ramp_12_lefse_tax.txt

filter_otus_from_otu_table.py -i split_total/rumen.adaptation.otu_table.tax.final__Diet_Ramp__.filter.biom -o ramp_23_lefse.biom -e ramp_23_lefse_otus.txt --negate_ids_to_exclude

biom convert -i ramp_23_lefse.biom -o  ramp_23_lefse.txt --table-type="OTU table" --to-tsv --header-key taxonomy

awk '{gsub("; ","\t",$0); print;}' ramp_23_lefse.txt | awk  '{gsub("#OTU","OTU",$0); print;}' | cut -f-16,21 | tail -n +2 | awk '{if(NR==1){print $0,"\tfamily"}else{print }}' > ramp_23_lefse_tax.txt
```

One shift in the microbial community was identified for corn-adaptation. Plot the heatmap for OTUs identified as having a significantly different abundance around this shift. Heatmap is for OTUs with a maximum relative abundance >1% and sorted by LDA score:

```r
corn_otu <- read.table("corn_lefse_tax.txt", header = TRUE, sep = "\t", fill = TRUE)
corn_otu$family <- sub("f__", "", corn_otu$family)
corn_otu$family <- sub("\\]", "", corn_otu$family)
corn_otu$family <- sub("\\[", "", corn_otu$family)
corn_otu$family <- sub("^$", "No Assigned Family", corn_otu$family)
row.names(corn_otu) <- corn_otu$OTU.ID
corn_otu <- corn_otu[, -1]
corn_fam <- subset(corn_otu, select = c(family))

corn_lefse <- read.table("corn_lefse_result.txt", header = FALSE, sep = "\t")
corn_lefse$V1 <- sub("OTU", "", corn_lefse$V1)
colnames(corn_lefse) <- c("OTU.ID", "raw", "breaks", "LDA", "pval")
row.names(corn_lefse) <- corn_lefse$OTU.ID
corn_lefse <- corn_lefse[, -1]

corn_fam_lefse <- merge(corn_fam, corn_lefse, by = "row.names")
corn_fam_lefse <- corn_fam_lefse[with(corn_fam_lefse, order(breaks, -LDA)), 
    ]
corn_supp_table <- subset(corn_fam_lefse, select = c(family, breaks))
write.table(corn_supp_table, file = "TableS2-1.txt", sep = "\t", quote = FALSE, 
    col.names = NA)

corn_biom <- read_biom("split_total/rumen.adaptation.otu_table.tax.final__Diet_Corn__.filter.biom")
corn_table <- as.data.frame(as(biom_data(corn_biom), "matrix"))
colnames(corn_table) <- c("CF_332", "C3_346", "C4_332", "CF_346", "C3_332", 
    "C1_346", "C2_332", "C1_332", "C2_346", "C4_346")
corn_table <- corn_table[c("C1_346", "C1_332", "C2_346", "C2_332", "C3_346", 
    "C3_332", "C4_346", "C4_332", "CF_346", "CF_332")]
corn_trans <- as.data.frame(t(corn_table))
corn_rel <- corn_trans/rowSums(corn_trans)
scalewhiteblack <- colorRampPalette(c("white", "black"), space = "rgb")(100)
maxab <- apply(corn_rel, 2, max)
n1 <- names(which(maxab < 0.01))
corn_rel2 <- corn_rel[, -which(names(corn_rel) %in% n1)]
corn_rel2 <- as.data.frame(t(corn_rel2))

corn_merge <- merge(corn_fam, corn_rel2, by = "row.names")
row.names(corn_merge) <- corn_merge$Row.names
corn_merge <- corn_merge[, -1]
corn_merge2 <- merge(corn_merge, corn_lefse, by = "row.names")
row.names(corn_merge2) <- corn_merge2$Row.names
corn_merge2 <- corn_merge2[, -1]
corn_merge2 <- corn_merge2[with(corn_merge2, order(breaks, -LDA)), ]

lmat = rbind(c(4, 0, 0), c(2, 1, 3))
lwid = c(0.6, 1.9, 0.3)
lhei = c(0.3, 1.5)

corn_fam2 <- subset(corn_merge2, select = c(family))
corn_plot <- subset(corn_merge2, select = -c(family, breaks, LDA, raw, pval))
corn_plot <- as.data.frame(t(corn_plot))

pdf("Figure3_panelA.pdf", width = 12, height = 9)
heatmap.2(as.matrix(corn_plot), Rowv = FALSE, Colv = FALSE, col = scalewhiteblack, 
    margins = c(13, 9.5), trace = "none", density.info = "none", xlab = "", 
    ylab = "", main = "", srtCol = 67.5, cexCol = 1.3, cexRow = 2, lmat = lmat, 
    lwid = lwid, lhei = lhei, labCol = corn_fam2$family)
```

```
## NULL
```

```r
dev.off()
```

```
## quartz_off_screen 
##                 2
```

```r
png("Figure3_panelA.png", width = 12, height = 9, units = "in", res = 300)
heatmap.2(as.matrix(corn_plot), Rowv = FALSE, Colv = FALSE, col = scalewhiteblack, 
    margins = c(13, 9.5), trace = "none", density.info = "none", xlab = "", 
    ylab = "", main = "", srtCol = 67.5, cexCol = 1.3, cexRow = 2, lmat = lmat, 
    lwid = lwid, lhei = lhei, labCol = corn_fam2$family)
```

```
## NULL
```

```r
dev.off()
```

```
## quartz_off_screen 
##                 2
```

<div style="text-align:center" markdown="1">
![corn_heatmap](Figure3_panelA.png)
</div>

Two shifts in the microbial community were identified for RAMP-adaptation. Plot the heatmap for OTUs identified as having a significantly different abundance around the first shift. Heatmap is for OTUs with a maximum relative abundance >1% and sorted by LDA score:

```r
ramp_12_otu <- read.table("ramp_12_lefse_tax.txt", header = TRUE, sep = "\t", 
    fill = TRUE)
ramp_12_otu$family <- sub("f__", "", ramp_12_otu$family)
ramp_12_otu$family <- sub("\\]", "", ramp_12_otu$family)
ramp_12_otu$family <- sub("\\[", "", ramp_12_otu$family)
ramp_12_otu$family <- sub("^$", "No Assigned Family", ramp_12_otu$family)
row.names(ramp_12_otu) <- ramp_12_otu$OTU.ID
ramp_12_otu <- ramp_12_otu[, -1]
ramp_12_fam <- subset(ramp_12_otu, select = c(family))

ramp_12_lefse <- read.table("ramp_12_lefse_result.txt", header = FALSE, sep = "\t")
ramp_12_lefse$V1 <- sub("OTU", "", ramp_12_lefse$V1)
colnames(ramp_12_lefse) <- c("OTU.ID", "raw", "breaks", "LDA", "pval")
row.names(ramp_12_lefse) <- ramp_12_lefse$OTU.ID
ramp_12_lefse <- ramp_12_lefse[, -1]

ramp_12_fam_lefse <- merge(ramp_12_fam, ramp_12_lefse, by = "row.names")
ramp_12_fam_lefse <- ramp_12_fam_lefse[with(ramp_12_fam_lefse, order(breaks, 
    -LDA)), ]
ramp_12_supp_table <- subset(ramp_12_fam_lefse, select = c(family, breaks))
write.table(ramp_12_supp_table, file = "TableS2-2.txt", sep = "\t", quote = FALSE, 
    col.names = NA)

ramp_biom <- read_biom("split_total/rumen.adaptation.otu_table.tax.final__Diet_Ramp__.filter.biom")
ramp_table <- as.data.frame(as(biom_data(ramp_biom), "matrix"))
colnames(ramp_table) <- c("R3_259", "R2_343", "R4_343", "R4_259", "R1_222", 
    "RF_343", "RF_222", "R2_222", "R1_343", "R3_343", "R2_259", "R3_222", "R4_222", 
    "RF_259", "R1_259")
ramp_table <- ramp_table[c("R1_222", "R1_259", "R1_343", "R2_222", "R2_259", 
    "R2_343", "R3_222", "R3_259", "R3_343", "R4_222", "R4_259", "R4_343", "RF_222", 
    "RF_259", "RF_343")]
ramp_12_table <- subset(ramp_table, select = c("R1_222", "R1_259", "R1_343", 
    "R2_222", "R2_259", "R2_343"))
ramp_12_trans <- as.data.frame(t(ramp_12_table))
ramp_12_rel <- ramp_12_trans/rowSums(ramp_12_trans)
scalewhiteblack <- colorRampPalette(c("white", "black"), space = "rgb")(100)
maxab <- apply(ramp_12_rel, 2, max)
n1 <- names(which(maxab < 0.01))
ramp_12_rel2 <- ramp_12_rel[, -which(names(ramp_12_rel) %in% n1)]
ramp_12_rel2 <- as.data.frame(t(ramp_12_rel2))

ramp_12_merge <- merge(ramp_12_fam, ramp_12_rel2, by = "row.names")
row.names(ramp_12_merge) <- ramp_12_merge$Row.names
ramp_12_merge <- ramp_12_merge[, -1]
ramp_12_merge2 <- merge(ramp_12_merge, ramp_12_lefse, by = "row.names")
row.names(ramp_12_merge2) <- ramp_12_merge2$Row.names
ramp_12_merge2 <- ramp_12_merge2[, -1]
ramp_12_merge2 <- ramp_12_merge2[with(ramp_12_merge2, order(breaks, -LDA)), 
    ]

lmat = rbind(c(4, 0, 0), c(2, 1, 3))
lwid = c(0.6, 1.9, 0.3)
lhei = c(0.3, 1.5)

ramp_12_fam2 <- subset(ramp_12_merge2, select = c(family))
ramp_12_plot <- subset(ramp_12_merge2, select = -c(family, breaks, LDA, raw, 
    pval))
ramp_12_plot <- as.data.frame(t(ramp_12_plot))

pdf("Figure3_panelB.pdf", width = 12, height = 9)
heatmap.2(as.matrix(ramp_12_plot), Rowv = FALSE, Colv = FALSE, col = scalewhiteblack, 
    margins = c(13, 9.5), trace = "none", density.info = "none", xlab = "", 
    ylab = "", main = "", srtCol = 67.5, cexCol = 1.3, cexRow = 2, lmat = lmat, 
    lwid = lwid, lhei = lhei, labCol = ramp_12_fam2$family)
```

```
## NULL
```

```r
dev.off()
```

```
## quartz_off_screen 
##                 2
```

```r
png("Figure3_panelB.png", width = 12, height = 9, units = "in", res = 300)
heatmap.2(as.matrix(ramp_12_plot), Rowv = FALSE, Colv = FALSE, col = scalewhiteblack, 
    margins = c(13, 9.5), trace = "none", density.info = "none", xlab = "", 
    ylab = "", main = "", srtCol = 67.5, cexCol = 1.3, cexRow = 2, lmat = lmat, 
    lwid = lwid, lhei = lhei, labCol = ramp_12_fam2$family)
```

```
## NULL
```

```r
dev.off()
```

```
## quartz_off_screen 
##                 2
```

<div style="text-align:center" markdown="1">
![ramp_12_heatmap](Figure3_panelB.png)
</div>

Two shifts in the microbial community were identified for RAMP-adaptation. Plot the heatmap for OTUs identified as having a significantly different abundance around the second shift. Heatmap is for OTUs with a maximum relative abundance >1% and sorted by LDA score:

```r
ramp_23_otu <- read.table("ramp_23_lefse_tax.txt", header = TRUE, sep = "\t", 
    fill = TRUE)
ramp_23_otu$family <- sub("f__", "", ramp_23_otu$family)
ramp_23_otu$family <- sub("\\]", "", ramp_23_otu$family)
ramp_23_otu$family <- sub("\\[", "", ramp_23_otu$family)
ramp_23_otu$family <- sub("^$", "No Assigned Family", ramp_23_otu$family)
row.names(ramp_23_otu) <- ramp_23_otu$OTU.ID
ramp_23_otu <- ramp_23_otu[, -1]
ramp_23_fam <- subset(ramp_23_otu, select = c(family))

ramp_23_lefse <- read.table("ramp_23_lefse_result.txt", header = FALSE, sep = "\t")
ramp_23_lefse$V1 <- sub("OTU", "", ramp_23_lefse$V1)
colnames(ramp_23_lefse) <- c("OTU.ID", "raw", "breaks", "LDA", "pval")
row.names(ramp_23_lefse) <- ramp_23_lefse$OTU.ID
ramp_23_lefse <- ramp_23_lefse[, -1]

ramp_23_fam_lefse <- merge(ramp_23_fam, ramp_23_lefse, by = "row.names")
ramp_23_fam_lefse <- ramp_23_fam_lefse[with(ramp_23_fam_lefse, order(breaks, 
    -LDA)), ]
ramp_23_supp_table <- subset(ramp_23_fam_lefse, select = c(family, breaks))
write.table(ramp_23_supp_table, file = "TableS2-3.txt", sep = "\t", quote = FALSE, 
    col.names = NA)

ramp_biom <- read_biom("split_total/rumen.adaptation.otu_table.tax.final__Diet_Ramp__.filter.biom")
ramp_table <- as.data.frame(as(biom_data(ramp_biom), "matrix"))
colnames(ramp_table) <- c("R3_259", "R2_343", "R4_343", "R4_259", "R1_222", 
    "RF_343", "RF_222", "R2_222", "R1_343", "R3_343", "R2_259", "R3_222", "R4_222", 
    "RF_259", "R1_259")
ramp_table <- ramp_table[c("R1_222", "R1_259", "R1_343", "R2_222", "R2_259", 
    "R2_343", "R3_222", "R3_259", "R3_343", "R4_222", "R4_259", "R4_343", "RF_222", 
    "RF_259", "RF_343")]
ramp_23_table <- subset(ramp_table, select = c("R2_222", "R2_259", "R2_343", 
    "R3_222", "R3_259", "R3_343", "R4_222", "R4_259", "R4_343", "RF_222", "RF_259", 
    "RF_343"))
ramp_23_trans <- as.data.frame(t(ramp_23_table))
ramp_23_rel <- ramp_23_trans/rowSums(ramp_23_trans)
scalewhiteblack <- colorRampPalette(c("white", "black"), space = "rgb")(100)
maxab <- apply(ramp_23_rel, 2, max)
n1 <- names(which(maxab < 0.01))
ramp_23_rel2 <- ramp_23_rel[, -which(names(ramp_23_rel) %in% n1)]
ramp_23_rel2 <- as.data.frame(t(ramp_23_rel2))

ramp_23_merge <- merge(ramp_23_fam, ramp_23_rel2, by = "row.names")
row.names(ramp_23_merge) <- ramp_23_merge$Row.names
ramp_23_merge <- ramp_23_merge[, -1]
ramp_23_merge2 <- merge(ramp_23_merge, ramp_23_lefse, by = "row.names")
row.names(ramp_23_merge2) <- ramp_23_merge2$Row.names
ramp_23_merge2 <- ramp_23_merge2[, -1]
ramp_23_merge2 <- ramp_23_merge2[with(ramp_23_merge2, order(breaks, -LDA)), 
    ]

lmat = rbind(c(4, 0, 0), c(2, 1, 3))
lwid = c(0.6, 1.9, 0.3)
lhei = c(0.3, 1.5)

ramp_23_fam2 <- subset(ramp_23_merge2, select = c(family))
ramp_23_plot <- subset(ramp_23_merge2, select = -c(family, breaks, LDA, raw, 
    pval))
ramp_23_plot <- as.data.frame(t(ramp_23_plot))

pdf("Figure3_panelC.pdf", width = 12, height = 9)
heatmap.2(as.matrix(ramp_23_plot), Rowv = FALSE, Colv = FALSE, col = scalewhiteblack, 
    margins = c(13, 9.5), trace = "none", density.info = "none", xlab = "", 
    ylab = "", main = "", srtCol = 67.5, cexCol = 1.3, cexRow = 2, lmat = lmat, 
    lwid = lwid, lhei = lhei, labCol = ramp_23_fam2$family)
```

```
## NULL
```

```r
dev.off()
```

```
## quartz_off_screen 
##                 2
```

```r
png("Figure3_panelC.png", width = 12, height = 9, units = "in", res = 300)
heatmap.2(as.matrix(ramp_23_plot), Rowv = FALSE, Colv = FALSE, col = scalewhiteblack, 
    margins = c(13, 9.5), trace = "none", density.info = "none", xlab = "", 
    ylab = "", main = "", srtCol = 67.5, cexCol = 1.3, cexRow = 2, lmat = lmat, 
    lwid = lwid, lhei = lhei, labCol = ramp_23_fam2$family)
```

```
## NULL
```

```r
dev.off()
```

```
## quartz_off_screen 
##                 2
```

<div style="text-align:center" markdown="1">
![ramp_23_heatmap](Figure3_panelC.png)
</div>
