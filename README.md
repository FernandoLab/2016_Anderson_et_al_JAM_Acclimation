To recreate the anlaysis used in the Anderson et al. manuscript, "Adaptation of the rumen microbiota during a finishing study",
 there are two steps (follow the guidelines below). All of the commands to generate the manuscript outputs have been ran on Mac OS X 10.9 (others systems should work fine) with 8 GB RAM. No root access is needed. This should all work in a linux enviornmnet as well if you use a linux version of USEARCH and the anaconda package manager [download page](http://continuum.io/downloads). The only two dependencies I believe are X11 (remember if logging onto a server) and perl (version shouldnt matter).

  1. Run the bash script to create a virtual enironment and download/install programs **LOCALLY** with the anaconda package manager. This will recreate the same enivronment I used.
    
  2. Render the R Markdown file with knitR to recreate the workflow and outputs.

Due to licensing issues, USEARCH can not be included in the setup. To obtain a download link, go to the USEARCH [download page](http://www.drive5.com/usearch/download.html) and select version USEARCH v7.0.1090 for linux. **A link (expires after 30 days) will be sent to the provided email. Use the link as an argument for shell script below**.

Simply download the bash script from the github repository and run it (provide the link to download your licensed USEARCH version as an argument for setup.sh):

  1. wget https://raw.githubusercontent.com/chrisLanderson/rumen_adaptation/master/setup.sh
  2. chmod 775 setup.sh 
  3. ./setup.sh usearch_link

**Miniconda is downloaded and prompts you during installataion of the packages above. The prompts are as follows:**

  1. Press enter to view the license agreement
  2. Press enter to read the license and q to exit
  3. Accept the terms
  4. Prompts you where to install anaconda.  Simply type anaconda to create a directory within the current directory. Should be:
  [/Users/user/anaconda] >>> anaconda
  5. No to prepend anaconda to your path. Choosing yes should not impact the installation though.
  6. Will be asked a few times if you wish to proceed with installing the packages...agree to it.
  7. After installation, enter 'source anaconda/bin/activate rumenEnv' on the command line to activate the virtual enviornment with all dependencies.
  

To convert the R markdown to html use the command: **render("rumen_adaptation.Rmd")**. To start a R session and run the workflow, use these commands from within the  direcotry you initiated installation:

  1. source anaconda/bin/activate rumenEnv
  2. R
  3. install.packages("rmarkdown")
  4. install.packages("knitr")
  5. library(rmarkdown)
  6. library(knitr)
  7. render("rumen_adaptation.Rmd")
  


The html rendered version can be found [here]()