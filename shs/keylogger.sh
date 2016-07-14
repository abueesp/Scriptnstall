sudo apt-get install -y autotools
git clone https://github.com/kernc/logkeys
cd logkeys
git clean -xdf
sudo ./autogen.sh
cd build 
./configure
sudo make
sudo make install
cd ..
cd ..
#To uninstall logkeys, remove accompanying scripts and manuals or use make uninstall    # in the same build dir
touch test.log
logkeys --start --output test.log
