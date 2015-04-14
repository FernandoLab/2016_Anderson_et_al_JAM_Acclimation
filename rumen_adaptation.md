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

	
	

