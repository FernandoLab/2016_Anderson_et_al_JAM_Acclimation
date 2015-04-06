Adaptation of the rumen microbiota during a finishing study
===============
Author: Chirstopher L. Anderson (canderson30@unl.edu)

##Introduction
To recreate the analysis from Anderson et al. manuscript.  All commands below were done in a linux enviornment and memory intensive commands were carried out on a high performance cluster at UNL. Programs needed are listed, see below on how to install given a linux environment with no root access.

- QIIME v.
- R v.
- USEARCH v.

##Clone the repository
Clone the repository to get some intermediate files and certain scripts for the analysis:


    git clone https://github.com/chrisLanderson/rumen_virome.git
    cd rumen_virome

##Retrieve Raw Data
Seqeuncing was done on 454.  Initial QC was done before I recieved files - need to find out what was done...just trimmed to 200 bp?

To download this raw data in FASTA format:

    scp canderson3@crane.unl.edu:/work/samodha/canderson3/rumen_adaptation.fasta ./

##QC and Demultiplexing:




