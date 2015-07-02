#!/bin/bash

if [ "$1" = "" ]; then
    printf "\nProvide a link for USEARCH download (from email) as argument.\nGet a license from http://www.drive5.com/usearch/download.html\nSee RMarkdown file for details.\n\n"
    exit 1
fi

wget http://www.python.org/ftp/python/2.7.9/Python-2.7.9.tgz
tar -zxvf Python-2.7.9.tgz
cd Python-2.7.9
cur="$PWD"
./configure --prefix=$cur
make
make install
cd ..

wget https://pypi.python.org/packages/source/v/virtualenv/virtualenv-12.0.7.tar.gz
tar -zxvf virtualenv-12.0.7.tar.gz
Python-2.7.9/bin/python2.7 virtualenv-12.0.7/virtualenv.py rumenEnv
source rumenEnv/bin/activate
wget https://pypi.python.org/packages/source/n/numpy/numpy-1.9.2.tar.gz
wget https://pypi.python.org/packages/source/q/qiime/qiime-1.9.1.tar.gz
pip install numpy-1.9.2.tar.gz
pip install qiime-1.9.1.tar.gz

#For Mac, take out following three lines 
#if want to install linux that has gfortran already
wget http://coudert.name/software/gfortran-4.8.2-Mavericks.dmg
hdiutil attach gfortran-4.8.2-Mavericks.dmg
sudo installer -pkg /Volumes/gfortran-4.8.2-Mavericks/gfortran-4.8.2-Mavericks/gfortran.pkg -target /

cd rumenEnv/bin
cur="$PWD"
cd ..
wget http://rweb.quant.ku.edu/cran/src/base/R-3/R-3.2.0.tar.gz  
tar -zxvf R-3.2.0.tar.gz
cd R-3.2.0
./configure --prefix=$cur
make

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

rm R-3.2.0.tar.gz
rm Mothur.mac_64.OSX-10.9.zip
rm -rf fastx
