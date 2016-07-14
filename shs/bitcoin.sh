sudo apt-get install python-qt4 python-pip -y
sudo pip install https://download.electrum.org/2.6.4/Electrum-2.6.4.tar.gz
tar zxvf Electrum**gz
cd Electrum**
./configure
sudo make
sudo make install
cd ..
sudo rm -r **Electrum
