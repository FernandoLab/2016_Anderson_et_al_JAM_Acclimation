#!/bin/bash

if [ "$1" = "" ]; then
    printf "\nProvide a link for USEARCH download (from email) as argument.\nGet a license from http://www.drive5.com/usearch/download.html\nSee RMarkdown file for details.\n\n"
    exit 1
fi

wget https://repo.continuum.io/miniconda/Miniconda-latest-MacOSX-x86_64.sh
tar -zxvf conda-3.7.0.tar.gz
bash Miniconda-latest-MacOSX-x86_64.sh
miniconda/bin/conda create -n rumenEnv python pip numpy matplotlib IPython future natsort scipy pandas scikit-bio gdata
source miniconda/bin/activate rumenEnv
pip install https://github.com/biocore/qiime/archive/1.9.0.tar.gz
miniconda/bin/conda install -c r r

wget -O bin/usearch $1
chmod 775 bin/usearch

mkdir fastx
cd fastx
wget http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit_0.0.13_binaries_MacOSX.10.5.8_i386.tar.bz2
bzip2 -d fastx_toolkit_0.0.13_binaries_MacOSX.10.5.8_i386.tar.bz2
tar -xvf fastx_toolkit_0.0.13_binaries_MacOSX.10.5.8_i386.tar
cd ..
mv fastx/bin/* bin/

wget https://github.com/mothur/mothur/releases/download/v1.35.1/Mothur.mac_64.OSX-10.9.zip
unzip Mothur.mac_64.OSX-10.9.zip
mv mothur/mothur bin/

wget https://raw.githubusercontent.com/chrisLanderson/rumen_adaptation/master/rumen_adaptation.Rmd

