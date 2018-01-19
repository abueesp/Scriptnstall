#!/bin/bash
PCVER=$(uname -m)
if [ $PCVER == x86_64 ]; then
    ARCHIT=amd64
elif [ $PCVER == i386 ] || [ $PCVER == i686 ]; then
    PCVER=i686
    ARCHIT=i386
else
  echo "ERROR: The system is neither 64bits nor 32 bits?"
fi
sudo apt-get install lsb cups -y
EPSONVERSION=_1.6.18-1lsb3.2_$ARCHIT
wget https://download3.ebz.epson.net/dsc/f/03/00/06/86/80/32e2f6797b62bcdc6e162a4805d7f764da5b103e/epson-inkjet-printer-escpr$EPSONVERSION.deb
sudo dpkg -i epson-inkjet-printer-escpr$EPSONVERSION.deb
rm epson-inkjet-printer-escpr$EPSONVERSION.deb
sudo service cups stop
sudo service cups start
firefox --new-tab http://localhost:631/
