To recreate the anlaysis used in the Anderson et al. manuscript, "Adaptation of the rumen microbiota during a finishing study",
 there are two steps (follow the guidelines below). All of the commands to generate the manuscript outpurs have been ran on Mac OS X (10.9 but others will work I believe). You do not root to install a local version of R if you don't have gfortran. This all works in a linux enviornmnet as well but you should comment out lines 28-30 in the bash setup.sh script. Two dependencies are X11 (remember if logging onto server) and perl, which comes on all Mac and linux systems and to my knowledge, the version shouldn't matter for running the few custom scripts here.

  1. Run the bash script to create a virtual enironment and download/install the following programs **LOCALLY** so everything is the same version used in the manuscript:
    + Python
    + QIIME
    + FASTX
    + Mothur
    + USEARCH
    + R
    + R Markdown file to render
    
  2. Render the R Markdown file with knitR to recreate the workflow and outputs.

Due to licensing issues, USEARCH can not be included in the setup. To obtain a download link, go to the USEARCH [download page](http://www.drive5.com/usearch/download.html) and select version USEARCH v7.0.1090 for linux. **A link (expires after 30 days) will be sent to the provided email. Use the link as an argument for shell script below**.

Simply download the bash script from the github repository and run it (**provide the link to download your licensed USEARCH version as an argument for setup.sh**):

  1. wget https://raw.githubusercontent.com/chrisLanderson/rumen_adaptation/master/setup.sh
  2. chmod 775 setup.sh 
  3. ./setup.sh usearch_link


**Note: It will take some time to install everything**


To start a R session, run these two commands from within the rumenEnv/ direcotry:

  1. source bin/activate
  2. R-3.2.0/bin/R

To convert the R markdown to html (or any other format) use the [knitr package](http://yihui.name/knitr/) from within R using the command: **knit2html("rumen_adaptation.Rmd")**.


The html rendered version can be found [here]()