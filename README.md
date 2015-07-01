#To recreate the analysis for the Adaptation of the rumen microbiota during a finishing study manuscript: 
Using the guidelines below, run the shell script (setup.sh) that will setup a virtual environment, download USEARCH, and download R before you render the provided R Markdown file:

Due to licensing issues, USEARCH can not be included or downloaded from a provided link. To obtain a download link, go to the USEARCH [download page](http://www.drive5.com/usearch/download.html) and select version USEARCH v7.0.1090 for linux. **A link (expires after 30 days) will be sent to the provided email. Change <link> in the setup.sh script downloaded below to make USEARCH available when rendering the R Markdown file**. 

Simply download the shell script from the github repository and run the shell script (**need to insesrt usearch download link, see paragraph above**):


**wget <shell script from github link>**
**makefile**


To convert the R markdown to html (or any other format) use the [knitr package](http://yihui.name/knitr/) from within R using the command: knit2html("rumen_adaptation.Rmd")