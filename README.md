To recreate the anlaysis used in the Anderson et al. manuscript, "Adaptation of the rumen microbiota during a finishing study",
 there are two steps (follow the guidelines below). All of the commands to generate the manuscript outpurs have been ran in linux enviornment (did not have root privileges).  Should work on Mac as well if you install a Mac version of R and USEARCH.

  1. Run a bash script to create a virtual enironment and download/install the following programs:
    + Python
    + Perl
    + QIIME
    + FASTX
    + Mothur
    + USEARCH
    + R Markdown file to render
    
  2. Render the R Markdown file with knitR to recreate the workflow and outputs.

Due to licensing issues, USEARCH can not be included in the setup. To obtain a download link, go to the USEARCH [download page](http://www.drive5.com/usearch/download.html) and select version USEARCH v7.0.1090 for linux. **A link (expires after 30 days) will be sent to the provided email. The setup.sh script downloaded below will prompt you for the download link**.

Simply download the bash script from the github repository and run it (**the script will prompt you for the link to download USEARCH**):


**wget https://raw.githubusercontent.com/chrisLanderson/rumen_adaptation/master/setup.sh**

**./setup.sh**


**Note: It will take some time to install everything**


If you use just used the above bash script to install R, then the R program can be simply started by typing R into your terminal. If you are starting a R session from a new terminal window, you can start R by running these two commands from within the rumenEnv/ direcotry:

  1. source bin/activate
  2. R

To convert the R markdown to html (or any other format) use the [knitr package](http://yihui.name/knitr/) from within R using the command: **knit2html("rumen_adaptation.Rmd")**.


The html rendered version can be found [here]()