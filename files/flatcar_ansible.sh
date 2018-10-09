#!/usr/bin/env bash
LOGFILE='/home/core/install-pypy.log'

exec >> $LOGFILE 2>&1
PYPY_VERSION='pypy2-v5.9.0-linux64'
HOME='/home/core'

echo "Creating folders and downloading pypy binaries"

if [ ! -d $HOME/bin ];
then
  mkdir -p $HOME/bin
fi
cd $HOME
wget -nv https://bitbucket.org/pypy/pypy/downloads/$PYPY_VERSION.tar.bz2 ;
tar -xjf $PYPY_VERSION.tar.bz2 ;
mv $PYPY_VERSION pypy
rm -rf $PYPY_VERSION.tar.bz2
chmod -R ugo+x $HOME/pypy
cd $HOME/pypy/bin

ln -f -s /lib64/libncurses.so.6.1 libtinfo.so.5
wget https://bootstrap.pypa.io/get-pip.py ;
$HOME/pypy/bin/pypy $HOME/pypy/bin/get-pip.py ;
ln -f -s $HOME/pypy/bin/pypy $HOME/bin/python
ln -f -s $HOME/pypy/bin/pip $HOME/bin/pip
ln -f -s $HOME/pypy/bin/easy_install $HOME/bin/easy_install
$HOME/bin/python --version
$HOME/bin/pip --version
$HOME/bin/easy_install --version
