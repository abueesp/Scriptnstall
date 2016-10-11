#!/bin/bash
#TestDisk & PhotoRec: A Linux Recuva
wget https://www.cgsecurity.org/testdisk-7.0.linux26-x86_64.tar.bz2 #also with photorec
tar -jxvf testdisk**.bz2
cd testdisk
./configure
make
sudo make install
cd ..
echo "TestDisk & PhotoRec are portable applications, extract the files and the applications are ready to be used. No need to run an installer. "


