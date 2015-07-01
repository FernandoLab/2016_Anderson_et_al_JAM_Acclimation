#!/bin/bash

echo -n "Provided download link (from email) for USEARCH: "
	read USEARCH_LINK
	
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

cd rumenEnv/bin
cur="$PWD"
cd ..
wget http://rweb.quant.ku.edu/cran/src/base/R-3/R-3.2.0.tar.gz  
tar -zxvf R-3.2.0.tar.gz
cd R-3.2.0
./configure --prefix=$cur
make
make install
cd ..

wget -O bin/usearch $USEARCH_LINK
chmod 775 usearch

wget https://raw.githubusercontent.com/chrisLanderson/rumen_adaptation/master/rumen_adaptation.Rmd

