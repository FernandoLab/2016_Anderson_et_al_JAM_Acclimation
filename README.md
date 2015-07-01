#Adaptation of the rumen microbiota during a finishing study

To recreate the anlaysis used in the Anderson et al. manuscript, there are two steps (Follow the guidelines below):

  1. Run a shell script to create a virtual enironment, download USEARCH, and download R.
  2. Render the R Markdown file with knitR to recreate the workflow and outputs.

Due to licensing issues, USEARCH can not be included or downloaded from a provided link. To obtain a download link, go to the USEARCH [download page](http://www.drive5.com/usearch/download.html) and select version USEARCH v7.0.1090 for linux. **A link (expires after 30 days) will be sent to the provided email. The setup.sh script downloaded below will prompt you for the download link to make USEARCH available when rendering the R Markdown file**. 

Simply download the shell script from the github repository and run the shell script (**will prompt you for the link to download USEARCH**):


**wget <shell script from github link>**

**shell script**


To convert the R markdown to html (or any other format) use the [knitr package](http://yihui.name/knitr/) from within R using the command: knit2html("rumen_adaptation.Rmd").

The html rendered version can be found [here]()