wget https://1.na.dl.wireshark.org/src/wireshark-2.2.4.tar.bz2
tar -xvjf wireshark**.tar.bz2
rm wireshark**.tar.bz2
cd wireshark**
sudo apt-get install libpcap-dev -y
./configure
make
sudo make install
sudo ldconfig
sudo wireshark
