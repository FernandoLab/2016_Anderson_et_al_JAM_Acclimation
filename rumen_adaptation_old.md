Adaptation of the rumen microbiota during a finishing study
===============
Author: Christopher L. Anderson (canderson30@unl.edu)

##Introduction
To recreate the analysis from Anderson et al. manuscript.  All commands below were ran on Mac OS X 10.9.5. Other software needed are listed, and when they are needed I try to demonstrate how to install.

- MacQIIME 1.9.0-20140227
- R 3.1.1
- USEARCH v7.0.1090
- mothur v.1.35.1
- python
- perl


##Retrieve Raw Data and Intermediate Files
Seqeuncing was done on 454.  Initial QC was done before I recieved files - need to find out what was done...just trimmed to 200 bp, but no .qual files either?

Information about study...

To download the raw data and intermediate files/scripts for the analysis:

    scp -r canderson3@crane.unl.edu:/work/samodha/canderson3/rumen_adaptation_2015/intermediate_files.tar.gz ./
    tar -zxvf intermediate_files.tar.gz

##Install MacQIIME:

If you already have macqiime, you can skip this section. If you dont already have macqiime or want to use the same version as I used during the analysis, it is straightforward to install (be aware this will overwrite other versions of MacQIIME and you will need root access):
	
	wget ftp://ftp.microbio.me/pub/macqiime-releases/MacQIIME_1.9.0-20150227_OS10.6.tgz
	tar -xvf MacQIIME_1.9.0-20150227_OS10.6.tgz
	cd MacQIIME_1.9.0-20150227_OS10.6
	./install.s

Can remove the files from local firectory as they were copied to root.
	
	cd ..
	rm -rf MacQIIME_1.9.0-20150227_OS10.6
	rm MacQIIME_1.9.0-20150227_OS10.6.tgz
	
##Demultiplex and Quality Control:
First, need to demultiplex the samples using the provided barcodes.  This information can be found in the mapping file located in the downloaded intermediate_files directory.
	
	macqiime
	split_libraries.py -m intermediate_files/mapping.txt -f intermediate_files/rumen.adaptation.fasta -b hamming_8 -l 0 -L 1000 -M 1 -o rumen_adaptation_demultiplex
	
The results from this command could be found in directory intermediate_files/rumen_adaptation_demultiplex

Now, remove the reverse primer:

	truncate_reverse_primer.py -f rumen_adaptation_demultiplex/seqs.fna -o rumen_adaptation_rev_primer -m intermediate_files/mapping.txt -z truncate_only -M 2
	exit
	
The results from this command could be found in directory intermediate_files/rumen_adaptation_rev_primer


Trim the seqeunes to a fixed length to improve OTU picking donwstream with UPARSE. I do this with a combination of mothur and FASTX - likely is easier way to do this though.

	wget https://github.com/mothur/mothur/releases/download/v1.35.1/Mothur.mac_64.OSX-10.9.zip
	unzip Mothur.mac_64.OSX-10.9.zip
	
	mothur/mothur 
	trim.seqs(fasta=rumen_adaptation_rev_primer/seqs_rev_primer_truncated.fna, minlength=400)
	quit()

The results from this command could be found atintermediate_files/rumen_adaptation_rev_primer/seqs_rev_primer_truncated.fna

Use FASTX to trim all seqeunces back to a length of 400 bp.

	wget http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_MacOSX.10.5.8_i386.tar.bz2
	bzip2 -d fastx_toolkit_0.0.13_binaries_MacOSX.10.5.8_i386.tar.bz2
	tar -xvf fastx_toolkit_0.0.13_binaries_MacOSX.10.5.8_i386.tar
	mv bin fastx_bin
	fastx_bin/fastx_trimmer -i rumen_adaptation_rev_primer/seqs_rev_primer_truncated.trim.fasta -l 400 -o rumen.adaptation.qc.trim.fasta

Output can be found at intermediate_files/rumen.adaptation.qc.trim.fasta

Reverse complement the sequences since we seqeunced off the 518 primer towards 27.

	mothur/mothur 
	reverse.seqs(fasta=rumen.adaptation.qc.trim.fasta)
	quit()
	grep -c ">" rumen.adaptation.qc.trim.rc.fasta
	#272630 seqeunces should be in the final FASTA file

Output can be found at intermediate_files/rumen.adaptation.qc.trim.rc.fasta

##Pick OTUs, assign taxonomy, and align sequences
We use UPARSE to pick OTUs and remove chimeras, etc.  First, we need to get the seqeunces into a format more compatible with UPARSE.  Can use a cutom perl script to do so:

	intermediate_files/./qiime_to_usearch.pl -fasta=rumen.adaptation.qc.trim.rc.fasta -prefix=rumen
	mv format.fasta rumen.adaptation.format.fasta
	
Output can be found at intermediate_files/rumen.adaptation.format.fasta

Going to need to download USEARCH to complete the next steps.  The free version suffices for this dataset. To get it, go to http://www.drive5.com/usearch/download.html and select version USEARCH v7.0.1090 for Mac OSX.  Enter your email and hit submit. You should receive an email with the download link. Use that link below to download the exectuable:

	wget <link>
	mv <filename> usearch
	chmod 775 usearch

Now, going to go through several steps to pick OTUs:
	
	mkdir usearch_results
	./usearch -derep_fulllength rumen.adaptation.format.fasta -sizeout -output usearch_results/rumen.adaptation.derep.fasta
	./usearch -sortbysize usearch_results/rumen.adaptation.derep.fasta -minsize 2 -output usearch_results/rumen.adaptation.derep.sort.fasta
	./usearch -cluster_otus usearch_results/rumen.adaptation.derep.sort.fasta -otus usearch_results/rumen.adaptation.otus1.fasta
	./usearch -uchime_ref usearch_results/rumen.adaptation.otus1.fasta -db intermediate_files/gold.fasta -strand plus -nonchimeras usearch_results/rumen.adaptation.otus1.nonchimera.fasta
	python intermediate_files/usearch_python_scripts/fasta_number.py usearch_results/rumen.adaptation.otus1.nonchimera.fasta > usearch_results/rumen.adaptation.otus2.fasta
	./usearch -usearch_global rumen.adaptation.format.fasta -db usearch_results/rumen.adaptation.otus2.fasta -strand plus -id 0.97 -uc usearch_results/rumen.adaptation.otu_map.uc
	python intermediate_files/usearch_python_scripts/uc2otutab.py usearch_results/rumen.adaptation.otu_map.uc > usearch_results/rumen.adaptation.otu_table.txt
	cp usearch_results/rumen.adaptation.otu_table.txt ./
	
Output files from above commands can be found at intermediate_files/usearch_result

Assign taxonomy to the representative sequences for each OTU:

	macqiime
	assign_taxonomy.py -i usearch_results/rumen.adaptation.otus2.fasta -t /macqiime/greengenes/gg_13_8_otus/taxonomy/97_otu_taxonomy.txt -r /macqiime/greengenes/gg_13_8_otus/rep_set/97_otus.fasta -o assign_gg_taxa
	exit

Outputs from above command can be found at intermediate_files/assign_gg_taxa

Add the taxa outputted to the OTU table with the column header "taxonomy".

	awk 'NR==1; NR > 1 {print $0 | "sort"}' rumen.adaptation.otu_table.txt > rumen.adaptation.otu_table.sort.txt 
	sort assign_gg_taxa/rumen.adaptation.otus2_tax_assignments.txt > assign_gg_taxa/rumen.adaptation.otus2_tax_assignments.sort.txt
	{ printf '\ttaxonomy\t\t\n'; cat assign_gg_taxa/rumen.adaptation.otus2_tax_assignments.sort.txt ; }  > assign_gg_taxa/rumen.adaptation.otus2_tax_assignments.sort.label.txt
	paste rumen.adaptation.otu_table.sort.txt <(cut -f 2 assign_gg_taxa/rumen.adaptation.otus2_tax_assignments.sort.label.txt) > rumen.adaptation.otu_table.tax.txt
	rm rumen.adaptation.otu_table.sort.txt

Outputs from above command can be found at intermediate_files/rumen.adaptation.otu_table.tax.txt

You may need to install biom tools if you have not used the software that utilizes biom formats in the past.  Easiest way I found is just:
	
	pip install biom-format
	biom convert --table-type "otu table" -i rumen.adaptation.otu_table.tax.txt -o rumen.adaptation.otu_table.tax.biom --process-obs-metadata taxonomy
	
Two of the samples have duplicates that were seqeunced...not quite sure why...but lets remove the duplicates with the lower depth - samples R6 and R19.
	
	vi remove_samples.txt
	#add samples R6 and R19 on seperate lines and save
	macqiime
	filter_samples_from_otu_table.py -i rumen.adaptation.otu_table.tax.biom -o rumen.adaptation.otu_table.tax.filter.biom --sample_id_fp remove_samples.txt --negate_sample_id_fp
	biom summarize-table -i rumen.adaptation.otu_table.tax.filter.biom -o rumen.adaptation.otu_table.tax.filter.summary.txt
	
Outputs from above command can be found at intermediate_files/rumen.adaptation.otu_table.tax.biom, intermediate_files/rumen.adaptation.otu_table.tax.filter.biom, and intermediate_files/rumen.adaptation.otu_table.tax.filter.summary.txt
	
Need to create an alignment of the 16S seqeunces for each OTU. Our lab prefers to do so using the RDP aligner. Go to https://pyro.cme.msu.edu/aligner/form.spr and type in  a job name (I used rumen) to download file from later. Then select Bacteria 16S for the gene and upload file usearch_results/rumen.adaptation.otus2.fasta for alignment. Click on my jobs near upper right of the webpage to check the status of the job...it should be pretty quick. When the job is completed, hit Download Zip to save the results. Move the results to current directory:

	mv ~/Downloads/rumen.zip ./
	
The alignment results can be found at intermediate_files/rumen.zip

	unzip rumen.zip

RDP over the past year has been misaligning a bit even when we use files that have worked in the past.

If you were to look at file alignment/aligned_rumen.adaptation.otus2.fasta_alignment_summary you would notice OTU 630 does not align very well. So, we need to remove it before continuing on...While we are removing OTUs if were to look at the taxonomy, we would see five OTUs with a cyanobacteria classification.  We also want to remove those as they should not be present in the rumen and are likely derivatives of chloroplast sequences. Since we are removing OTUs we also want to remove any singletons that may have resulted (-n2 option)

	vi remove_otus.txt
	#add 1148,371,554,616,489,630 on seperate lines
	filter_otus_from_otu_table.py -i rumen.adaptation.otu_table.tax.filter.biom -o rumen.adaptation.otu_table.tax.filter.filter.biom -e remove_otus.txt -n 2

Resulting files can be found at intermediate_files/rumen.adaptation.otu_table.tax.filter.filter.biom and intermediate_files/remove_otus.txt

Take the aligned file from the unziped results at alignment/aligned_rumen.adaptation.otus2.fasta and open it in a text editor (the files is small).  We need to replace the dots created by RDP with dashes to work best in mothur.  Just do a simple find and replace.  Also, the clearcut command in mothur we are going to use requires seqeunce names to be longer than 10 characters.  So search and replace '>' with '>AAAAAAAAAA' and later we will remove these again. For some reason, there is a strang seqeunce at the bottom of these aligned files always, remove the seqeunce and header for it.

Move the reformated file to the current directory.

	cp alignment/aligned_rumen.adaptation.otus2.fasta ./

This reformatted file can be found at intermediate_files/aligned_rumen.adaptation.otus2.fasta

Use mothur to calculate form a distance matrix:

	mothur/mothur
	dist.seqs(fasta=aligned_rumen.adaptation.otus2.fasta, countends=F, output=lt)
 
Use mothur to generate a phylogenetic tree:

	clearcut(phylip=aligned_rumen.adaptation.otus2.phylip.dist)
	quit()

Replace the string of 10 'A' from the .tre file with nothing in a text editor.

Resulting files are found at intermediate_files/aligned_rumen.adaptation.otus2.phylip.dist and intermediate_files/aligned_rumen.adaptation.otus2.phylip.tre

##Rarefaction Curves and Alpha Diversity
Want to look at the sequencing depth of each sample by monitoring the number of novel OTUs encountered as depth is increased.  Setup here for a depth roughly equivalent to least sample seqeunced within a step-up diet in our study so we can visually see full depth to give us an idea if the curves were plateauing....Also, want to compare alpha diversity (observed OTUs and chao1 index), but with all samples at the sample depth.	

"If the lines for some categories do not extend all the way to the right end of the x-axis, that means that at least one of the samples in that category does not have that many sequences."

	macqiime
	multiple_rarefactions.py -i rumen.adaptation.otu_table.tax.filter.filter.biom -o alpha_rare -m 10 -x 6600 -s 500 -n 10
	alpha_diversity.py -i alpha_rare/ -o alpha_rare_otu_chao -m observed_otus,chao1 
	collate_alpha.py -i alpha_rare_otu_chao/ -o alpha_rare_collate
	make_rarefaction_plots.py -i alpha_rare_collate/ -m intermediate_files/mapping.txt -e stderr --generate_average_tables -b Treatment -w -o alpha_rare_collate_avgtable	
	
The calculations I need to plot are already in the generated html file.  I opened alpha_rare_collate_avgtable/rarefaction_plots.html, picked observed OTUs by Treatment, and copied the table at the bottom of the page to txt file and saved as alpha_rarefaction_table.txt

Also, want to plot the raw data for each sample at an even depth for both observed OTUs and Chao1 index:

	multiple_rarefactions_even_depth.py -i rumen.adaptation.otu_table.tax.filter.filter.biom -n 10 -d 2164 -o mult_even
	alpha_diversity.py -i mult_even/ -o alpha_even -m observed_otus,chao1 
	collate_alpha.py -i alpha_even -o alpha_even_collate
	exit

Plot results as 4 diagrams in R:

	R
	library(ggplot2)
	library(matrixStats)
	alpha_rare <- read.table("alpha_rarefaction_table.txt", header=TRUE, sep="\t")
	alpha_rare <- na.omit(alpha_rare)
	control_rare <- subset(alpha_rare, Treatment %in% c("C1","C2","C3","C4","CF"))
	ramp_rare <- subset(alpha_rare, Treatment %in% c("R1","R2","R3","R4","RF"))
	control_rare$Diet <- "CON"
	ramp_rare$Diet <- "RAMP"
	alpha_rare <- rbind(control_rare,ramp_rare)
	pd <- position_dodge(width = 275)
	
	rare_otu_plot <- ggplot(alpha_rare, aes(x=Seqs.Sample, y=observed_otus.Ave., colour=Treatment, group=Treatment, ymin=observed_otus.Ave.-observed_otus.Err., ymax=observed_otus.Ave.+observed_otus.Err.)) +
	geom_line(position = pd) +
	geom_pointrange(position=pd) +
	scale_colour_manual(values = c("C1" = "#FF0000", "C2" = "#BF003F", "C3" = "#7F007F", "C4" = "#3F00BF", "CF" = "#0000FF", "R1" = "#FF0000", "R2" = "#BF003F", "R3" = "#7F007F", "R4" = "#3F00BF", "RF" = "#0000FF")) +
	labs(x = "Sequences per Sample", y="Mean Observed OTUs") +
	theme(legend.title=element_blank()) +
	facet_grid(~Diet)
	
	rare_chao1_plot <- ggplot(alpha_rare, aes(x=Seqs.Sample, y=chao1.Ave., colour=Treatment, group=Treatment, ymin=chao1.Ave.-chao1.Err., ymax=chao1.Ave.+chao1.Err.)) +
	geom_line(position = pd) +
	geom_pointrange(position=pd) +
	scale_colour_manual(values = c("C1" = "#FF0000", "C2" = "#BF003F", "C3" = "#7F007F", "C4" = "#3F00BF", "CF" = "#0000FF", "R1" = "#FF0000", "R2" = "#BF003F", "R3" = "#7F007F", "R4" = "#3F00BF", "RF" = "#0000FF")) +
	labs(x = "Sequences per Sample", y="Mean Chao1 Index") +
	theme(legend.title=element_blank()) +
	facet_grid(~Diet)
	
	
	alpha_chao1 <- read.table("alpha_even_collate/chao1.txt", header=TRUE, sep="\t")
	alpha_otu <- read.table("alpha_even_collate/observed_otus.txt", header=TRUE, sep="\t")
	
	alpha_chao1 <- alpha_chao1[-c(1:3)]
	colnames(alpha_chao1) <- c("CF_332", "R3_259", "R2_343", "R4_343", "R4_259", "C3_346", "C4_332", "R1_222", "CF_346", "RF_343", "RF_222", "C3_332", "R2_222", "R1_343", "R3_343", "C1_346", "C2_332", "R2_259", "R3_222", "C1_332", "C2_346", "R4_222", "RF_259", "R1_259", "C4_346")
	alpha_chao1_matrix <- as.matrix(alpha_chao1)
	alpha_chao1_means <- data.frame(Means=colMeans(alpha_chao1_matrix), SD=colSds(alpha_chao1_matrix))
	
	alpha_otu <- alpha_otu[-c(1:3)]
	colnames(alpha_otu) <- c("CF_332", "R3_259", "R2_343", "R4_343", "R4_259", "C3_346", "C4_332", "R1_222", "CF_346", "RF_343", "RF_222", "C3_332", "R2_222", "R1_343", "R3_343", "C1_346", "C2_332", "R2_259", "R3_222", "C1_332", "C2_346", "R4_222", "RF_259", "R1_259", "C4_346")
	alpha_otu_matrix <- as.matrix(alpha_otu)
	alpha_otu_means <- data.frame(Means=colMeans(alpha_otu_matrix), SD=colSds(alpha_otu_matrix))

	 steps <- data.frame(step=c("Finisher","Step3","Step2","Step4","Step4","Step3","Step4","Step1","Finisher","Finisher","Finisher","Step3","Step2","Step1","Step3","Step1","Step2","Step2","Step3","Step1","Step2","Step4","Finisher","Step1","Step4"))
	 diets <- data.frame(diet=c("CON","RAMP","RAMP","RAMP","RAMP","CON","CON","RAMP","CON","RAMP","RAMP","CON","RAMP","RAMP","RAMP","CON","CON","RAMP","RAMP","CON","CON","RAMP","RAMP","RAMP","CON"))
	 
	alpha_chao1_means <- cbind(alpha_chao1_means,steps,diets)
	alpha_chao1_means$step <- factor(alpha_chao1_means$step, c("Step1", "Step2", "Step3", "Step4", "Finisher"))
	alpha_chao1_plot <- ggplot(alpha_chao1_means, aes(x=step, y=Means)) +
	geom_point(size=4) +
	labs(x = "", y="Mean Chao1 Index") +
	facet_wrap(~diet)
	
	alpha_otu_means <- cbind(alpha_otu_means,steps,diets)
	alpha_otu_means$step <- factor(alpha_otu_means$step, c("Step1", "Step2", "Step3", "Step4", "Finisher"))
	alpha_otu_plot <- ggplot(alpha_otu_means, aes(x=step, y=Means)) +
	geom_point(size=4) +
	labs(x = "", y="Mean Observed OTUs") +
	facet_wrap(~diet)
	
	
	
	multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
		library(grid)
		plots <- c(list(...), plotlist)
		numPlots = length(plots)
		if (is.null(layout)) {
			layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),ncol = cols, nrow = ceiling(numPlots/cols))
		}

		if (numPlots==1) {
			print(plots[[1]])

		} else {
			grid.newpage()
			pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
			for (i in 1:numPlots) {
				matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
				print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,layout.pos.col = matchidx$col))
    		}
    	}
	}

	pdf("alpha_diversity.pdf", height=12, width=12)
	multiplot(rare_otu_plot, rare_chao1_plot, alpha_otu_plot, alpha_chao1_plot, cols=2)
	dev.off()
	quit()

##Taxonomy Plots
	macqiime
	summarize_taxa.py -i rumen.adaptation.otu_table.tax.filter.filter.biom -o summarize_taxa -L 2,3,4,5,6,7
	plot_taxa_summary.py -i summarize_taxa/rumen.adaptation.otu_table.tax.filter.filter_L2.txt,summarize_taxa/rumen.adaptation.otu_table.tax.filter.filter_L3.txt,summarize_taxa/rumen.adaptation.otu_table.tax.filter.filter_L4.txt,summarize_taxa/rumen.adaptation.otu_table.tax.filter.filter_L5.txt,summarize_taxa/rumen.adaptation.otu_table.tax.filter.filter_L6.txt,summarize_taxa/rumen.adaptation.otu_table.tax.filter.filter_L7.txt -l Phylum,Class,Order,Family,Genus,Species -c bar,area,pie -o plot_taxa

Outputs can be found at intermediate_files/summarize_taxa and intermediate_files/plot_taxa

##Beta Diversity
	
split the OTU table into RAMP and Control:

	split_otu_table.py -i rumen.adaptation.otu_table.tax.filter.filter.biom -o split_total -m intermediate_files/mapping.txt -f Diet
	
	biom summarize-table -i split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Control__.biom -o split_total/control.summarize.txt
	
	biom summarize-table -i split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Ramp__.biom -o split_total/ramp.summarize.txt
	
	beta_diversity_through_plots.py -i split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Control__.biom -o control_beta_div -t aligned_rumen.adaptation.otus2.phylip.tre -m intermediate_files/mapping.txt -p intermediate_files/qiime_parameters_working.txt -e 2164
	
	beta_diversity_through_plots.py -i split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Ramp__.biom -o ramp_beta_div -t aligned_rumen.adaptation.otus2.phylip.tre -m intermediate_files/mapping.txt -p intermediate_files/qiime_parameters_working.txt -e 2966
	
	
Output can be found at intermediate_files/control_beta_div
Output can be found at intermediate_files/ramp_beta_div
	
	
##Community Statistics
Community level statistics:
	
	#install R and dependencies (phyloseq, biom, ggplot2, vegan,...)
	R
	
	control_unweighted <- read.table("control_beta_div/unweighted_unifrac_dm.txt", sep="\t", header=TRUE)
	row.names(control_unweighted) <- control_unweighted$X
	control_unweighted <- control_unweighted[,-1]
	control_unweighted <- as.dist(control_unweighted)
	
	control_weighted <- read.table("control_beta_div/weighted_unifrac_dm.txt", sep="\t", header=TRUE)
	row.names(control_weighted) <- control_weighted$X
	control_weighted <- control_weighted[,-1]
	control_weighted <- as.dist(control_weighted)
	
	ramp_unweighted <- read.table("ramp_beta_div/unweighted_unifrac_dm.txt", sep="\t", header=TRUE)
	row.names(ramp_unweighted) <- ramp_unweighted$X
	ramp_unweighted <- ramp_unweighted[,-1]
	ramp_unweighted <- as.dist(ramp_unweighted)
	
	ramp_weighted <- read.table("ramp_beta_div/weighted_unifrac_dm.txt", sep="\t", header=TRUE)
	row.names(ramp_weighted) <- ramp_weighted$X
	ramp_weighted <- ramp_weighted[,-1]
	ramp_weighted <- as.dist(ramp_weighted)
	
	control_map <- read.table("split_total/mapping__Diet_Control__.txt", sep="\t", header=FALSE)
	colnames(control_map) <- c("SampleID","BarcodeSequence","LinkerPrimerSequence","ReversePrimer","Treatment","Diet","Step","Individual","Description")
	
	ramp_map <- read.table("split_total/mapping__Diet_Ramp__.txt", sep="\t", header=FALSE)
	colnames(ramp_map) <- c("SampleID","BarcodeSequence","LinkerPrimerSequence","ReversePrimer","Treatment","Diet","Step","Individual","Description")
	
	library(vegan)
	
	adonis(control_unweighted ~ Treatment + Individual, permutations=999, data=control_map)
Treatment   4   1.42318 0.35579  2.0295 0.59941  0.015  </br>
Individual  1   0.24988 0.24988  1.4254 0.10525  0.170  
Residuals   4   0.70123 0.17531         0.29534         
Total       9   2.37429                 1.00000    

	adonis(control_weighted ~ Treatment + Individual, permutations=999, data=control_map)
Treatment   4  0.097088 0.024272  1.7632 0.55599  0.043  </br>
Individual  1  0.022471 0.022471  1.6324 0.12868  0.119  
Residuals   4  0.055063 0.013766         0.31533         
Total       9  0.174621                  1.00000 

	adonis(ramp_unweighted ~ Treatment + Individual, permutations=999, data=ramp_map)
Treatment   4    1.2561 0.31403  1.6796 0.38151  0.002  </br>
Individual  1    0.3536 0.35364  1.8914 0.10741  0.006  </br>
Residuals   9    1.6827 0.18697         0.51108          
Total      14    3.2925                 1.00000     

	adonis(ramp_weighted ~ Treatment + Individual, permutations=999, data=ramp_map)
Treatment   4  0.099273 0.024818  1.6398 0.36763  0.066 </br>
Individual  1  0.034546 0.034546  2.2825 0.12793  0.056 </br>
Residuals   9  0.136216 0.015135         0.50444         
Total      14  0.270035                  1.00000


	#Need to check assumptions:

Post-Hoc Pairwise Distance Comparisons (on unweighted only in future?):
	
	library(reshape)
	
	control_unweighted_matrix <- as.matrix(control_unweighted)
	m <- as.matrix(control_unweighted)
	m2 <- melt(m)[melt(upper.tri(m))$value,]
	names(m2) <- c("Sample1", "Sample2", "distance")
	write.table(m2, "control_unweighted_pariwise_dist.txt", sep="\t", row.names=FALSE)
	
	control_weighted_matrix <- as.matrix(control_weighted)
	m <- as.matrix(control_weighted)
	m2 <- melt(m)[melt(upper.tri(m))$value,]
	names(m2) <- c("Sample1", "Sample2", "distance")
	write.table(m2, "control_weighted_pariwise_dist.txt", sep="\t", row.names=FALSE)
	
	ramp_unweighted_matrix <- as.matrix(ramp_unweighted)
	m <- as.matrix(ramp_unweighted)
	m2 <- melt(m)[melt(upper.tri(m))$value,]
	names(m2) <- c("Sample1", "Sample2", "distance")
	write.table(m2, "ramp_unweighted_pariwise_dist.txt", sep="\t", row.names=FALSE)
	
	ramp_weighted_matrix <- as.matrix(ramp_weighted)
	m <- as.matrix(ramp_weighted)
	m2 <- melt(m)[melt(upper.tri(m))$value,]
	names(m2) <- c("Sample1", "Sample2", "distance")
	write.table(m2, "ramp_weighted_pariwise_dist.txt", sep="\t", row.names=FALSE)
	
	quit()
	n
	
	intermediate_files/./treatment_distances.pl -mapping_file=intermediate_files/mapping.txt -distance_file=control_unweighted_pariwise_dist.txt -category=Treatment
	mv treatment_distances.txt control_unweighted_treatment_distances.txt
	
	intermediate_files/./treatment_distances.pl -mapping_file=intermediate_files/mapping.txt -distance_file=control_weighted_pariwise_dist.txt -category=Treatment
	mv treatment_distances.txt control_weighted_treatment_distances.txt
	
	
	

Intermediate outputs can be found in intermediate_files directory

Look at pairwise ttests for different steps:

	R
	control_unweighted <- read.table("control_unweighted_treatment_distances.txt", sep="\t", header=TRUE)
	control_unweighted_pairs <- split(control_unweighted, control_unweighted$Sample1Diet_Sample2Diet)
	c1c2_c1c3 <- rbind(control_unweighted_pairs$C1_C2, control_unweighted_pairs$C1_C3)
	c1c2_c1c3_test <- pairwise.t.test(c1c2_c1c3$Distance, c1c2_c1c3$Sample1Diet_Sample2Diet)
	c1c2_c1c3_test
	lapply(c1c2_c1c3_test, write, "control_unweighted_c1c2_c1c3_ttest.txt", append=TRUE)

	c1c3_c1c4 <- rbind(control_unweighted_pairs$C1_C3, control_unweighted_pairs$C1_C4)
	c1c3_c1c4_test <- pairwise.t.test(c1c3_c1c4$Distance, c1c3_c1c4$Sample1Diet_Sample2Diet)
	c1c3_c1c4_test
	lapply(c1c3_c1c4_test, write, "control_unweighted_c1c3_c1c4_ttest.txt", append=TRUE)
	
	c1c4_c1cf <- rbind(control_unweighted_pairs$C1_C4, control_unweighted_pairs$C1_CF)
	c1c4_c1cf_test <- pairwise.t.test(c1c4_c1cf$Distance, c1c4_c1cf$Sample1Diet_Sample2Diet)
	c1c4_c1cf_test
	lapply(c1c4_c1cf_test, write, "control_unweighted_c1c4_c1cf_ttest.txt", append=TRUE)
	
	
	
	control_weighted <- read.table("control_weighted_treatment_distances.txt", sep="\t", header=TRUE)
	control_weighted_pairs <- split(control_weighted, control_weighted$Sample1Diet_Sample2Diet)
	c1c2_c1c3 <- rbind(control_weighted_pairs$C1_C2, control_weighted_pairs$C1_C3)
	c1c2_c1c3_test <- pairwise.t.test(c1c2_c1c3$Distance, c1c2_c1c3$Sample1Diet_Sample2Diet)
	c1c2_c1c3_test
	lapply(c1c2_c1c3_test, write, "control_weighted_c1c2_c1c3_ttest.txt", append=TRUE)
	
	c1c3_c1c4 <- rbind(control_weighted_pairs$C1_C3, control_weighted_pairs$C1_C4)
	c1c3_c1c4_test <- pairwise.t.test(c1c3_c1c4$Distance, c1c3_c1c4$Sample1Diet_Sample2Diet)
	c1c3_c1c4_test
	lapply(c1c3_c1c4_test, write, "control_weighted_c1c3_c1c4_ttest.txt", append=TRUE)
	
	c1c4_c1cf <- rbind(control_weighted_pairs$C1_C4, control_weighted_pairs$C1_CF)
	c1c4_c1cf_test <- pairwise.t.test(c1c4_c1cf$Distance, c1c4_c1cf$Sample1Diet_Sample2Diet)
	c1c4_c1cf_test
	lapply(c1c4_c1cf_test, write, "control_weighted_c1c4_c1cf_ttest.txt", append=TRUE)
	
	
	
	ramp_unweighted <- read.table("ramp_unweighted_treatment_distances.txt", sep="\t", header=TRUE)
	ramp_unweighted_pairs <- split(ramp_unweighted, ramp_unweighted$Sample1Diet_Sample2Diet)
	r1r1_r1r2 <- rbind(ramp_unweighted_pairs$R1_R1, ramp_unweighted_pairs$R1_R2)
	r1r1_r1r2_test <- pairwise.t.test(r1r1_r1r2$Distance, r1r1_r1r2$Sample1Diet_Sample2Diet)
	r1r1_r1r2_test
	lapply(r1r1_r1r2_test, write, "ramp_unweighted_r1r1_r1r2_ttest.txt", append=TRUE)
	
	r1r2_r1r3 <- rbind(ramp_unweighted_pairs$R1_R2, ramp_unweighted_pairs$R1_R3)
	r1r2_r1r3_test <- pairwise.t.test(r1r2_r1r3$Distance, r1r2_r1r3$Sample1Diet_Sample2Diet)
	r1r2_r1r3_test
	lapply(r1r2_r1r3_test, write, "ramp_unweighted_r1r2_r1r3_ttest.txt", append=TRUE)
	
	r1r3_r1r4 <- rbind(ramp_unweighted_pairs$R1_R3, ramp_unweighted_pairs$R1_R4)
	r1r3_r1r4_test <- pairwise.t.test(r1r3_r1r4$Distance, r1r3_r1r4$Sample1Diet_Sample2Diet)
	r1r3_r1r4_test
	lapply(r1r3_r1r4_test, write, "ramp_unweighted_r1r3_r1r4_ttest.txt", append=TRUE)
	
	r1r4_r1rf <- rbind(ramp_unweighted_pairs$R1_R4, ramp_unweighted_pairs$R1_RF)
	r1r4_r1rf_test <- pairwise.t.test(r1r4_r1rf$Distance, r1r4_r1rf$Sample1Diet_Sample2Diet)
	r1r4_r1rf_test
	lapply(r1r4_r1rf_test, write, "ramp_unweighted_r1r4_r1rf_ttest.txt", append=TRUE)
	
	
	
	ramp_weighted <- read.table("ramp_weighted_treatment_distances.txt", sep="\t", header=TRUE)
	ramp_weighted_pairs <- split(ramp_weighted, ramp_weighted$Sample1Diet_Sample2Diet)
	r1r1_r1r2 <- rbind(ramp_weighted_pairs$R1_R1, ramp_weighted_pairs$R1_R2)
	r1r1_r1r2_test <- pairwise.t.test(r1r1_r1r2$Distance, r1r1_r1r2$Sample1Diet_Sample2Diet)
	r1r1_r1r2_test
	lapply(r1r1_r1r2_test, write, "ramp_weighted_r1r1_r1r2_ttest.txt", append=TRUE)
	
	r1r2_r1r3 <- rbind(ramp_weighted_pairs$R1_R2, ramp_weighted_pairs$R1_R3)
	r1r2_r1r3_test <- pairwise.t.test(r1r2_r1r3$Distance, r1r2_r1r3$Sample1Diet_Sample2Diet)
	r1r2_r1r3_test
	lapply(r1r2_r1r3_test, write, "ramp_weighted_r1r2_r1r3_ttest.txt", append=TRUE)
	
	r1r3_r1r4 <- rbind(ramp_weighted_pairs$R1_R3, ramp_weighted_pairs$R1_R4)
	r1r3_r1r4_test <- pairwise.t.test(r1r3_r1r4$Distance, r1r3_r1r4$Sample1Diet_Sample2Diet)
	r1r3_r1r4_test
	lapply(r1r3_r1r4_test, write, "ramp_weighted_r1r3_r1r4_ttest.txt", append=TRUE)
	
	r1r4_r1rf <- rbind(ramp_weighted_pairs$R1_R4, ramp_weighted_pairs$R1_RF)
	r1r4_r1rf_test <- pairwise.t.test(r1r4_r1rf$Distance, r1r4_r1rf$Sample1Diet_Sample2Diet)
	r1r4_r1rf_test
	lapply(r1r4_r1rf_test, write, "ramp_weighted_r1r4_r1rf_ttest.txt", append=TRUE)



Intermediate outputs can be found in intermediate_files directory


##Venn Diagrams
	
Collapse samples together based on diet

	macqiime
	
	collapse_samples.py -b rumen.adaptation.otu_table.tax.filter.filter.biom -m intermediate_files/mapping.txt --output_biom_fp rumen.adaptation.collapse_samples.biom --output_mapping_fp intermediate_files/mapping_collapse.txt --collapse_fields Treatment --collapse_mode sum
	split_otu_table.py -i rumen.adaptation.collapse_samples.biom -m intermediate_files/mapping_collapse.txt -f Diet -o split_collapse_samples
	
For some reason file is not reading as JSON

	biom convert -i split_collapse_samples/rumen.adaptation.collapse_samples__Diet_Control__.biom -o split_collapse_samples/rumen.adaptation.collapse_samples__Diet_Control__.json.biom --to-json
	biom convert -i split_collapse_samples/rumen.adaptation.collapse_samples__Diet_Ramp__.biom -o split_collapse_samples/rumen.adaptation.collapse_samples__Diet_Ramp__.json.biom --to-json
	
	R
	library(biom)
	library(gplots)
	
	control_biom <- read_biom("split_collapse_samples/rumen.adaptation.collapse_samples__Diet_Control__.json.biom")
	ramp_biom <- read_biom("split_collapse_samples/rumen.adaptation.collapse_samples__Diet_Ramp__.json.biom")
	control_df <- as.data.frame(as(biom_data(control_biom), "matrix"))
	ramp_df <- as.data.frame(as(biom_data(ramp_biom), "matrix"))
	control_boolean_df <- as.data.frame(control_df > 0 + 0)
	ramp_boolean_df <- as.data.frame(ramp_df > 0 + 0)
	control_boolean_df <- control_boolean_df[c("C1", "C2", "C3", "C4", "CF")]
	ramp_boolean_df <- ramp_boolean_df[c("R1", "R2", "R3", "R4", "RF")]
	pdf("control_venn.pdf")
	control_venn <- venn(control_boolean_df)
	dev.off()
	pdf("ramp_venn.pdf")
	ramp_venn <- venn(ramp_boolean_df)
	dev.off()
	
	
Figures saved to intermediate_files

Get the number of OTUs and sequences shared pairwise:

	shared_phylotypes.py -i rumen.adaptation.collapse_samples.biom -o collapse_samples_shared_outs.txt
	intermediate_files/./pairwise_seq_comparison.pl

Saved to intermediate_files/

##Heatmap

	biom convert -i rumen.adaptation.otu_table.tax.filter.filter.biom -o rumen.adaptation.otu_table.tax.filter.filter.txt --to-tsv --table-type="OTU table"
	vi rumen.adaptation.otu_table.tax.filter.filter.txt 
	#remove the first line about Created from biom and remove comment sign on second line
	
	R
	library(gplots)
	library(Heatplus)
	library(vegan)
	library(RColorBrewer)
	otu_table <- read.table("rumen.adaptation.otu_table.tax.filter.filter.txt", header=TRUE, sep="\t")
	row.names(otu_table) <- otu_table$OTU.ID
	otu_table <- otu_table[,-1]
	colnames(otu_table) <- c("CF_332", "R3_259", "R2_343", "R4_343", "R4_259", "C3_346", "C4_332", "R1_222", "CF_346", "RF_343", "RF_222", "C3_332", "R2_222", "R1_343", "R3_343", "C1_346", "C2_332", "R2_259", "R3_222", "C1_332", "C2_346", "R4_222", "RF_259", "R1_259", "C4_346")
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
	pdf("heatmap.pdf")
	heatmap.2(as.matrix(otu_table_rel2), Rowv = as.dendrogram(row.clus), Colv = as.dendrogram(col.clus), col = scalewhiteblack, margins = c(2, 6), trace = "none", density.info = "none", labCol="", xlab = "OTUs", ylab = "Samples", main = "", lhei = c(2, 8))
	dev.off()

##Cytoscape

	make_otu_network.py -i rumen.adaptation.otu_table.tax.filter.filter.biom -o network/ -m intermediate_files/mapping.txt 

	#Insert notes on what to do in cytoscape with node colors, sizes, etc and uploading attribute tables.
	

##Distance Box and Whisker and Principle Component

	R
	library(ggplot2)
	ramp_unweighted <- read.table("ramp_unweighted_treatment_distances.txt", sep="\t", header=TRUE)
	control_unweighted <- read.table("control_unweighted_treatment_distances.txt", sep="\t", header=TRUE)
	
	control_unweighted_pairs <- split(control_unweighted, control_unweighted$Sample1Diet_Sample2Diet)
	control_1_pairs <- rbind(control_unweighted_pairs$C1_C1, control_unweighted_pairs$C1_C2,control_unweighted_pairs$C1_C3,control_unweighted_pairs$C1_C4,control_unweighted_pairs$C1_CF)
	
	ramp_unweighted_pairs <- split(ramp_unweighted, ramp_unweighted$Sample1Diet_Sample2Diet)
	ramp_1_pairs <- rbind(ramp_unweighted_pairs$R1_R1, ramp_unweighted_pairs$R1_R2,ramp_unweighted_pairs$R1_R3,ramp_unweighted_pairs$R1_R4,ramp_unweighted_pairs$R1_RF)
	
	control_distance <- ggplot(control_1_pairs, aes(x=Sample1Diet_Sample2Diet, y=Distance)) +
	geom_boxplot() +
	geom_point(position = position_jitter(width = 0.15)) +
	labs(x="", y = "Unweighted UniFrac Distance\n") +
	guides(fill=FALSE) +
	theme(axis.text.x = element_text( colour="black"), 	axis.title.y = element_text(size=14), axis.ticks = element_blank())
	#ggsave(control_distance, file="control_distances_box_whisker.pdf", w=5, h=5)
	
	ramp_distance <- ggplot(ramp_1_pairs, aes(x=Sample1Diet_Sample2Diet, y=Distance)) +
	geom_boxplot() +
	geom_point(position = position_jitter(width = 0.15)) +
	labs(x="", y = "Unweighted UniFrac Distance\n") +
	guides(fill=FALSE) +
	theme(axis.text.x = element_text(colour="black"), 	axis.title.y = element_text(size=14), axis.ticks = element_blank())
	ggsave(ramp_distance, file="ramp_distances_box_whisker.pdf", w=5, h=5)
	

I went ahead and manually made a file to upload into R with PC1 and PC2 from beta diversity command before for both control and ramp datasets.  Right now, just doing this with unweighted unifrac.  The file can be found in intermediate_files. It has the SampleID, Treatment (or step), PC1, and PC2. control_unweighted_pc.txt and ramp_unweighted_pc.txt

	R
	library(ggplot2)
	
	control_pc <- read.table("intermediate_files/control_unweighted_pc.txt", header=TRUE, sep="\t")
	ramp_pc <- read.table("intermediate_files/ramp_unweighted_pc.txt", header=TRUE, sep="\t")
	
	
	shape_control <- c("C1" = 15, "C2" = 16, "C3" = 17, "C4" = 18, "CF" = 8)
	control_pc_plot <- ggplot(control_pc, aes(PC1, PC2)) +
	geom_point(aes(size=4, shape = factor(Treatment))) +
	xlab("PC1 (37.1%)") +
	ylab("PC2 (13.7%)") +
	guides(size=FALSE) +
	scale_shape_manual(name = "", values = shape_control) +
	labs(fill="")
	#ggsave(control_pc_plot, file="control_unweighted_pc.pdf", w=6, h=6)
	
	shape_ramp <- c("R1" = 15, "R2" = 16, "R3" = 17, "R4" = 18, "RF" = 8)
	ramp_pc_plot <- ggplot(ramp_pc, aes(PC1, PC2)) +
	geom_point(aes(size=4, shape = factor(Treatment))) +	xlab("PC1 (20.3%)") +
	ylab("PC2 (12.9%)") +
	guides(size=FALSE) + 
	scale_shape_manual(name = "", values = shape_ramp) +
	labs(fill="")
	#ggsave(ramp_pc_plot, file="ramp_unweighted_pc.pdf", w=6, h=6)


Now I want to tile all 4 plots together:
	
	 multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
		library(grid)
		plots <- c(list(...), plotlist)
		numPlots = length(plots)
		if (is.null(layout)) {
			layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),ncol = cols, nrow = ceiling(numPlots/cols))
		}

		if (numPlots==1) {
			print(plots[[1]])

		} else {
			grid.newpage()
			pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
			for (i in 1:numPlots) {
				matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
				print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,layout.pos.col = matchidx$col))
    		}
    	}
	}


	pdf("unweighted_pc_distance.pdf", height=12, width=12)
	multiplot(control_pc_plot, ramp_pc_plot, control_distance, ramp_distance, cols=2)
	dev.off()


##OTU-Level Statistics
Look at differential OTUs at break points in ramp and control based on pairwise t-statstiics before.  We use LEfSe to compare samples - first need to be in relative abundance though.

	macqiime
	filter_otus_from_otu_table.py -i split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Control__.biom -n 1 -o split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Control__.filter.biom
	filter_otus_from_otu_table.py -i split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Ramp__.biom -n 1 -o split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Ramp__.filter.biom

	biom convert -i split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Control__.filter.biom -o split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Control__.filter.txt --table-type="OTU table" --to-tsv
	biom convert -i split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Ramp__.filter.biom -o split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Ramp__.filter.txt --table-type="OTU table" --to-tsv
	exit
	
	Delete the first line and comment from second line on both outputs
	
	
	
	R
	control <- read.table("split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Control__.filter.txt", header=TRUE, sep="\t")
	rownames(control) <- control$OTU.ID
	control <- control[, -1]
	control_rel <- control/rowSums(control)
	write.table(control_rel, sep="\t", file="split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Control__.filter.relative.txt", row.names=TRUE, col.names=TRUE, quote = FALSE)
	
	ramp <- read.table("split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Ramp__.filter.txt", header=TRUE, sep="\t")
	rownames(ramp) <- ramp$OTU.ID
	ramp <- ramp[, -1]
	ramp_rel <- ramp/rowSums(ramp)
	write.table(ramp_rel, sep="\t", file="split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Ramp__.filter.relative.txt", row.names=TRUE, col.names=TRUE, quote = FALSE)
	quit()
	
Now, need to alter relative abundance tables to upload to LEfSe - I did so manually, but files control.lefse.txt, ramp.lefse.break1.txt, and ramp.lefse.break2.txt  can be found in the intermediate files to be uploaded.  Only changes from relative abundance OTU tables were removing sampleIDs and replacing with one row for Break identifier and another row with animal ID.

Unfortunately, I had troubles getting LEfSe to work on command line, so we still use the version hosted on Galaxy. LEfSe on Galaxy can be found at
http://huttenhower.sph.harvard.edu/galaxy/

Upload each file using the Get Data Module as a tabular file. Then run Format Data for LEfSe with BREAK as class, no subclass, and ANIMAL as subject.  Use option Yes for per-sample normalization.

Next, run LDA Effect Size with the output from Format Data with default values and download the results. The outputs I generated can be found in intermediate_files as control.lefse_output.txt, ramp.break1.lefse_output.txt, and ramp.break2.lefse_otuput.txt.  If repreating yourself, you may get a slightly different answer because of changes in LEfSe script on Galaxy.

Manually created a list of OTUs for each break from the LEfSe output.  Simply sorted by fourth column (LDA score) largest to smallest and copied OTUs into text editor and replaced f_ with nothing. Files are named control_break_otus.txt, ramp_break1_otus.txt, and ramp_break2_otus.txt.

	macqiime
	
	filter_otus_from_otu_table.py -i split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Control__.filter.biom -o control.break.biom -e control_break_otus.txt --negate_ids_to_exclude
	filter_otus_from_otu_table.py -i split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Ramp__.filter.biom -o ramp.break1.biom -e ramp_break1_otus.txt --negate_ids_to_exclude
	filter_otus_from_otu_table.py -i split_total/rumen.adaptation.otu_table.tax.filter.filter__Diet_Ramp__.filter.biom -o ramp.break2.biom -e ramp_break2_otus.txt --negate_ids_to_exclude
	biom convert -i control.break.biom -o control.break.txt --table-type="OTU table" --to-tsv --header-key taxonomy
	biom convert -i ramp.break1.biom -o ramp.break1.txt --table-type="OTU table" --to-tsv --header-key taxonomy
	biom convert -i ramp.break2.biom -o ramp.break2.txt --table-type="OTU table" --to-tsv --header-key taxonomy
	

Delete first row of convert file and uncomment second row.
	
Then I am going to sort those new OTU tables by break and LDA score.  So, I created files with OTU ID, break number, and LDA from LEfSe output - control_break_LDA.txt, ramp_break1_LDA.txt, and ramp_break2_LDA.txt.  Using those files I added break number and LDA score to the new OTU tables so we can order the OTU rows in the subsequent heatmaps.

	awk 'NR==1; NR > 1 {print $0 | "sort"}' control.break.txt > control.break.sort.txt
	sort control_break_LDA.txt > control_break_LDA_sort.txt
	{ printf '\tbreak\tLDA\n'; cat control_break_LDA_sort.txt ; }  > control_break_LDA_sort_label.txt
	paste control.break.sort.txt <(cut -f 2,3 control_break_LDA_sort_label.txt) > control.break.LDA.txt
	
	awk 'NR==1; NR > 1 {print $0 | "sort"}' ramp.break1.txt > ramp.break1.sort.txt
	sort ramp_break1_LDA.txt > ramp_break1_LDA_sort.txt
	{ printf '\tbreak\tLDA\n'; cat ramp_break1_LDA_sort.txt ; }  > ramp_break1_LDA_sort_label.txt
	paste ramp.break1.sort.txt <(cut -f 2,3 ramp_break1_LDA_sort_label.txt) > ramp.break1.LDA.txt

	awk 'NR==1; NR > 1 {print $0 | "sort"}' ramp.break2.txt > ramp.break2.sort.txt
	sort ramp_break2_LDA.txt > ramp_break2_LDA_sort.txt
	{ printf '\tbreak\tLDA\n'; cat ramp_break2_LDA_sort.txt ; }  > ramp_break2_LDA_sort_label.txt
	paste ramp.break2.sort.txt <(cut -f 2,3 ramp_break2_LDA_sort_label.txt) > ramp.break2.LDA.txt
	
	
	exit
	
Use R to sort by break and LDA score then make the heatmaps

	R
	library(gplots)
	library(Heatplus)
	library(vegan)
	library(RColorBrewer)
	control <- read.table("control.break.LDA.txt", header=TRUE, sep="\t")
	control <- control[with(control, order(break., -LDA)), ]
	control_samples <- subset(control, select = -c(taxonomy,break.,LDA))
	row.names(control_samples) <- control_samples$OTU.ID
	control_samples <- control_samples[,-1]
	colnames(control_samples) <- c("CF_332", "C3_346", "C4_332", "CF_346", "C3_332", "C1_346", "C2_332", "C1_332", "C2_346", "C4_346")
	control_samples <- control_samples[c("C1_346", "C1_332", "C2_346", "C2_332", "C3_346", "C3_332", "C4_346", "C4_332", "CF_346", "CF_332")]
	control_trans <- as.data.frame(t(control_samples))
	control_rel <- control_trans/rowSums(control_trans)
	scalewhiteblack <- colorRampPalette(c("white", "black"), space = "rgb")(100)
	maxab <- apply(control_rel, 2, max)
	n1 <- names(which(maxab < 0.03))
	control_rel2 <- control_rel[, -which(names(control_rel) %in% n1)]
	otus <- colnames(control_rel2)
	write.table(otus, "control_break_figure_otus.txt", quote=FALSE, sep="\n", row.names = FALSE, col.names=FALSE)
	
	

The last command makes OTUs, so we can go get taxonomy of the printed OTUs on the figure and add them.  Keep the R window open and use a different terminal window to follow these commands:
	
	intermediate_files/parse_taxonomy.pl -otu_text_file=control.break.LDA.txt -figure_otus=control_break_figure_otus.txt 
	
Now, back in R, run the commands inserting taxnomy output from above in the last line of heatmap.2 command:
	
	lmat = rbind(c(4,0,0),c(2,1,3))
	lwid = c(0.60,1.9,0.3)
	lhei = c(0.3,1.5)
	pdf("control_break_heatmap.pdf", width=12, height=9)
	heatmap.2(as.matrix(control_rel2), Rowv = FALSE, Colv = FALSE, col = scalewhiteblack, margins = c(13, 9.5), trace = "none", density.info = "none", xlab = "", ylab = "", main = "", srtCol=67.5, cexCol=1.3, cexRow=2.0, lmat= lmat, lwid = lwid, lhei = lhei, labCol = c("S24-7", "Spirochaetaceae", "S24-7", "S24-7", "S24-7", "No Assigned Family", "No Assigned Family", "No Assigned Family", "No Assigned Family", "Pirellulaceae", "No Assigned Family", "Prevotellaceae", "Prevotellaceae", "Ruminococcaceae", "No Assigned Family", "Lachnospiraceae", "Anaerolinaceae", "Mogibacteriaceae", "Clostridiaceae", "No Assigned Family", "Veillonellaceae", "Prevotellaceae", "Lachnospiraceae", "Veillonellaceae", "Veillonellaceae", "Paraprevotellaceae", "Prevotellaceae", "Prevotellaceae", "Prevotellaceae", "Ruminococcaceae", "Prevotellaceae", "Prevotellaceae", "Succinivibrionaceae", "Veillonellaceae", "Prevotellaceae", "Prevotellaceae", "Prevotellaceae", "Prevotellaceae", "Prevotellaceae", "Lachnospiraceae", "Lachnospiraceae"))
	dev.off()


Repeat the above for ramp break 1:
	
	ramp1 <- read.table("ramp.break1.LDA.txt", header=TRUE, sep="\t")
	ramp1 <- ramp1[with(ramp1, order(break., -LDA)), ]
	ramp1_samples <- subset(ramp1, select = -c(taxonomy,break.,LDA))
	ramp1_samples <- subset(ramp1, select = c(OTU.ID,R18,R8,R24,R23,R38,R12))
	row.names(ramp1_samples) <- ramp1_samples$OTU.ID
	ramp1_samples <- ramp1_samples[,-1]
	colnames(ramp1_samples) <- c("R1_222","R1_259","R1_343","R2_222","R2_259","R2_343")
	ramp1_trans <- as.data.frame(t(ramp1_samples))
	ramp1_rel <- ramp1_trans/rowSums(ramp1_trans)
	scalewhiteblack <- colorRampPalette(c("white", "black"), space = "rgb")(100)
	maxab <- apply(ramp1_rel, 2, max)
	n1 <- names(which(maxab < 0.03))
	ramp1_rel2 <- ramp1_rel[, -which(names(ramp1_rel) %in% n1)]
	otus <- colnames(ramp1_rel2)
	write.table(otus, "ramp_break1_figure_otus.txt", quote=FALSE, sep="\n", row.names = FALSE, col.names=FALSE)

Use seperate terminal window to generate taxonomy:
	
	intermediate_files/parse_taxonomy.pl -otu_text_file=ramp.break1.LDA.txt -figure_otus=ramp_break1_figure_otus.txt 
	
Now, back in R, run the commands inserting taxnomy output from above in the last line of heatmap.2 command:

	lmat = rbind(c(4,0,0),c(2,1,3))
	lwid = c(0.60,1.9,0.3)
	lhei = c(0.3,1.5)
	pdf("ramp_break1_heatmap.pdf", width=12, height=9)
	heatmap.2(as.matrix(ramp1_rel2), Rowv = FALSE, Colv = FALSE, col = scalewhiteblack, margins = c(13, 9.5), trace = "none", density.info = "none", xlab = "", ylab = "", main = "", srtCol=67.5, cexCol=1.3, cexRow=2.0, lmat= lmat, lwid = lwid, lhei = lhei, labCol = c("S24-7", "Ruminococcaceae", "Prevotellaceae", "No Assigned Family", "Lachnospiraceae", "Lachnospiraceae", "Ruminococcaceae", "No Assigned Family", "Coriobacteriaceae", "Ruminococcaceae", "Lachnospiraceae", "Prevotellaceae", "Prevotellaceae", "Eubacteriaceae", "Erysipelotrichaceae", "Prevotellaceae", "No Assigned Family", "No Assigned Family", "Fibrobacteraceae", "Prevotellaceae"))
	dev.off()
	


Do all the above for ramp break 2:

	ramp2 <- read.table("ramp.break2.LDA.txt", header=TRUE, sep="\t")
	ramp2 <- ramp2[with(ramp2, order(break., -LDA)), ]
	ramp2_samples <- subset(ramp2, select = -c(taxonomy,break.,LDA))
	ramp2_samples <- subset(ramp2, select = c(OTU.ID,R23,R38,R12,R4,R11,R3,R5,R14,R13,R21,R7,R20))
	row.names(ramp2_samples) <- ramp2_samples$OTU.ID
	ramp2_samples <- ramp2_samples[,-1]
	colnames(ramp2_samples) <- c("R2_222","R2_259","R2_343","R3_222","R3_259","R3_343","R4_222","R4_259","R4_343","RF_222","RF_259","RF_343")
	ramp2_trans <- as.data.frame(t(ramp2_samples))
	ramp2_rel <- ramp2_trans/rowSums(ramp2_trans)
	scalewhiteblack <- colorRampPalette(c("white", "black"), space = "rgb")(100)
	maxab <- apply(ramp2_rel, 2, max)
	n1 <- names(which(maxab < 0.03))
	ramp2_rel2 <- ramp2_rel[, -which(names(ramp2_rel) %in% n1)]
	otus <- colnames(ramp2_rel2)
	write.table(otus, "ramp_break2_figure_otus.txt", quote=FALSE, sep="\n", row.names = FALSE, col.names=FALSE)

Use seperate terminal window to generate taxonomy:
	
	intermediate_files/parse_taxonomy.pl -otu_text_file=ramp.break2.LDA.txt -figure_otus=ramp_break2_figure_otus.txt 
	
Now, back in R, run the commands inserting taxnomy output from above in the last line of heatmap.2 command:

	lmat = rbind(c(4,0,0),c(2,1,3))
	lwid = c(0.60,1.9,0.3)
	lhei = c(0.3,1.5)
	pdf("ramp_break2_heatmap.pdf", width=12, height=9)
	heatmap.2(as.matrix(ramp2_rel2), Rowv = FALSE, Colv = FALSE, col = scalewhiteblack, margins = c(13, 9.5), trace = "none", density.info = "none", xlab = "", ylab = "", main = "", srtCol=67.5, cexCol=1.3, cexRow=2.0, lmat= lmat, lwid = lwid, lhei = lhei, labCol = c("Prevotellaceae", "Lachnospiraceae", "Prevotellaceae", "Lachnospiraceae", "Prevotellaceae", "Paraprevotellaceae", "No Assigned Family", "No Assigned Family", "Prevotellaceae", "Lachnospiraceae", "Mogibacteriaceae", "Mogibacteriaceae", "Lachnospiraceae", "No Assigned Family", "Lachnospiraceae", "Mogibacteriaceae", "Prevotellaceae", "Prevotellaceae", "Paraprevotellaceae", "No Assigned Family", "Prevotellaceae", "Prevotellaceae", "Prevotellaceae", "RF16", "Prevotellaceae", "Erysipelotrichaceae"))
	dev.off()
	quit()


##Bacteroidetes:Firmicutes

Wanted to look at the ratio of Bacteroidetes to Firmicutes over the course of adaptation.

	macqiime
	filter_taxa_from_otu_table.py -i rumen.adaptation.otu_table.tax.filter.filter.biom -o rumen.adaptation.otu_table.tax.filter.filter.bacteroidetes.biom -p p__Bacteroidetes
	filter_taxa_from_otu_table.py -i rumen.adaptation.otu_table.tax.filter.filter.biom -o rumen.adaptation.otu_table.tax.filter.filter.firmicutes.biom -p p__Firmicutes
	biom summarize-table -i rumen.adaptation.otu_table.tax.filter.filter.bacteroidetes.biom -o summarize_bacteroidetes.txt
	biom summarize-table -i rumen.adaptation.otu_table.tax.filter.filter.firmicutes.biom -o summarize_firmicutes.txt

I used the two summary files to look at the number of seqeunces assigned to each phyla and relabelled the sample identifiers as their diet, step, and animal ID.  The collated summary file used to generate the table in the manuscript is bacteroidetes_firmicutes.txt.



	

