Adaptation of the rumen microbiota during a finishing study
===============
Author: Christopher L. Anderson (canderson30@unl.edu)

##Introduction
To recreate the analysis from Anderson et al. manuscript.  All commands below were ran on Mac OS X 10.9.5. Other software needed are listed, and when they are needed I try to demonstrate how to install.

- MacQIIME 1.9.0-20140227
- R v.
- USEARCH v7.0.1090
- mothur v.1.35.1
- python
- perl


##Retrieve Raw Data and Intermediate Files
Seqeuncing was done on 454.  Initial QC was done before I recieved files - need to find out what was done...just trimmed to 200 bp, but no .qual files either?

To make things easier for us, lets set a shortcut the directory you are going to work on this analysis:

	cd ~
	vim .bash_profile

Then add something like this to the file and type 'esc' ':wq' to save

	alias RumenAdaptation='cd <path_to_directory>'

Then you can automatically jump to that directory during the analysis and run commands exactly as I ahve them without worrying about altering the path. You can delete the above from your bash_profile after you are done working on recreating the analysis.

To download the raw data and intermediate files/scripts for the analysis:
	
	cd RumenAdaptation
    scp -r canderson3@crane.unl.edu:/work/samodha/canderson3/rumen_adaptation_2015/intermediate_files/ ./

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

Replace the string of 10As from the .tre file with nothing in a text editor.

Resulting files are found at intermediate_files/aligned_rumen.adaptation.otus2.phylip.dist and intermediate_files/aligned_rumen.adaptation.otus2.phylip.tre

##Beta Diversity



##Defining Core Measureable Microbiota




##Core Beta Diversity

	

	
 
