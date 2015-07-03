To recreate the anlaysis used in the Anderson et al. manuscript, "Adaptation of the rumen microbiota during a finishing study",
 there are two steps (follow the guidelines below). All of the commands to generate the manuscript outputs have been ran on Mac OS X (10.9 but others systems will work I believe). No root access is needed. This should all work in a linux enviornmnet as well if you use a linux version of USEARCH. The only two dependencies I believe are X11 (remember if logging onto a server) and perl, which comes on all Mac and linux systems and to my knowledge, the version shouldn't matter for running the few custom scripts here.

  1. Run the bash script to create a virtual enironment and download/install the following programs **LOCALLY** with the conda package manager. This helps to recreate the same enivronment I used.
    + Python
    + QIIME
    + FASTX
    + Mothur
    + USEARCH
    + R
    + R Markdown file to render
    
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
  4. Prompts you where to install miniconda.  Simply type miniconda to create a directory within the current directory. Should be:
  [/Users/user/miniconda] >>> miniconda
  5. No to prepend miniconda to you path.  Choosing yes should not impact the installation I believe.
  6. Will be asked a few times if you wish to proceed with installing the packages...agree to it.
  7. After installation, enter source miniconda/bin/activate rumenEnv to activate the virtual enviornment with all dependencies.
  

To start a R session, run these two commands from within the rumenEnv/ direcotry:

  1. source miniconda/bin/activate rumenEnv
  2. R

To convert the R markdown to html (or any other format) use the [knitr package](http://yihui.name/knitr/) from within R using the command: **knit2html("rumen_adaptation.Rmd")**.


The html rendered version can be found [here]()