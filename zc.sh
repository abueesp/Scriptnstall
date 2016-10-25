read -p "Delete swapfile and create a 3GB new one [yn]" answer
if [[ $answer == "y" ]] ; then
read -e -p "Choose a number og GB (3 by default)" -i "3" gygas
sudo swapon -s
sudo swapoff -v /swapfile
sudo rm /swapfile
bytes=$gygas*1024000
sudo dd if=/dev/zero of=/swapfile bs=1024 count=bytes
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon -s
fi
sudo apt-get update -y
sudo apt-get install build-essential pkg-config libgtest-dev libc6-dev m4 autoconf libtool ncurses-dev unzip git python zlib1g-dev wget bsdmainutils automake aptitude -y
sudo aptitude install g++ g++-multilib -y
git clone https://github.com/zcash/zcash.git
cd zcash/
git checkout v1.0.0-rc2
./zcutil/fetch-params.sh
echo "now compilation will start"
./zcutil/build.sh -j$(nproc)
echo "now testing will start"
./qa/zcash/full-test-suite.sh
./qa/pull-tester/rpc-tests.sh
echo "now solo mining will start"
mkdir -p ~/.zcash
echo "testnet=1" >> ~/.zcash/zcash.conf
echo "addnode=betatestnet.z.cash" >> ~/.zcash/zcash.conf
echo "rpcuser=$USER" >> ~/.zcash/zcash.conf
echo "rpcpassword=$passw" >> ~/.zcash/zcash.conf
echo "gen=1" >> ~/.zcash/zcash.conf
echo "genproclimit=-1" >> ~/.zcash/zcash.conf
echo "Check your conf, add new nodes, etc:"
nano ~/.zcash/zcash.conf
~/zcash/./src/zcashd -daemon
~/zcash/./src/zcash-cli getmininginfo
sleep 5
~/zcash/./src/zcash-cli getwalletinfo
"Welcome to Zcash. You can check you hashrate using zcbm, consult the info on zcinfo, read the txs with zctxs, and use zcstart and zcstop to manage it. You can also use >>watch free<< to watch your memory consumption."
~/zcash/./src/zcash-cli getinfo
~/zcash/src/./zcash-cli zcbenchmark solveequihash 10
~/zcash/./src/zcash-cli listtransactions
echo "alias zcbm='watch -n 2 ~/zcash/src/./zcash-cli zcbenchmark solveequihash 10 && watch -n 2 free -m && watch -n 2 ~/zcash/./src/zcash-cli getinfo'"  >> sudo /etc/bash.bashrc
echo "alias zcinfo='~/zcash/./src/zcash-cli getinfo && ~/zcash/./src/zcash-cli getwalletinfo && ~/zcash/./src/zcash-cli getmininginfo'"  >> sudo /etc/bash.bashrc
echo "alias zctxs='~/zcash/./src/zcash-cli listtransactions'" >> sudo /etc/bash.bashrc
echo "alias zcstart='~/zcash/./src/zcashd -daemon'" >> sudo /etc/bash.bashrc
echo "alias zcstop='lsof -i | grep zcashd && ~/zcash/./src/zcash-cli stop && sudo pkill -9 zcashd && sudo pkill -9 zcash-cli'" >> sudo /etc/bash.bashrc
echo '\
\
zclog() {\
memory=$(free|awk "/^Mem:/{print $2}")\
memory=$(echo "$memory/1000" | bc) # integer math in bash\
mydate=$(date +"%D")\
echo "$mydate" | tee -a zclog.txt\
echo "time, block number, difficulty, CPU%, RAM in MB per core" | tee -a zclog.txt\
c=1\
until [ $c -gt 240 ]; do # for 1 hour\
     let c=c+1\
     mytime=$(date +"%T")\
     block=$(~/zcash/./src/zcash-cli getblockcount)\
     difficulty=$(~/zcash/./src/zcash-cli getdifficulty)\
     difficulty=${difficulty:0:5}\
     p=$(ps aux | grep zcashd)\
     q=$(echo "$p" | tail -n1) \
     cpu=${q:16:3}\
     if [ "$cpu" == "0.0" ]; then\
         p=$(echo "$p" | tail -n2)\
     fi	 	\
    cpu=${p:16:3}\
    ram=${p:20:4}\
     rampercore=$(echo "($ram*$memory/($cpu+1)" | bc)\
     echo "$mytime $block $difficulty $cpu $rampercore" | tee -a log.txt\
     sleep 15 # seconds\
done\
}'

##Install GUI
read -p "Do you want to install GUI?" answer
if [[ $answer == "y" ]] ; then
sudo apt-get install git default-jdk ant -y
git clone https://github.com/vaklinov/zcash-swing-wallet-ui.git
cd zcash-swing-wallet-ui/
ant -buildfile ./src/build/build.xml
chmod u+x ./build/jars/ZCashSwingWalletUI.jar
./build/jars/ZCashSwingWalletUI.jar
java -jar /home/user/zcash/src/ZCashSwingWalletUI.jar
fi
##Benchmarks

#as in Intel(R) Core(TM) i5-4310U CPU @ 2.00GHz 64bits 8GB SODIMM DDR3 Synchronous 1600 MHz Integrated Intel Haswell-ULT Integrated Graphics Controller

#AssWinonLinux & Linux 1s/100-200ms 10-5S/s  Tromp

#CudaLinux 1S/200ms 5S/s  (on GTX 980 224GB/S 20S/s)  XenonCat

#David CPU Segmentation fault

firefox -new-tab https://docs.google.com/spreadsheets/d/1Um22iBf8bPbfuI4rUDZzSB4W444ouUEnQTBnb8EsdYk/edit

read -p "Do you want to install OpenCL 2.0 for AMD" answer
if [[ $answer == "y" ]] ; then
lspci | grep VGA
sudo apt-get install xorg -y
sudo rm -r /tmp/**
firefox -new-tab http://support.amd.com/en-us/kb-articles/Pages/OpenCL2-Driver.aspx
unzip /Downloads/linux**.zip
cd fglrx**
./amd-driver-installer
#error: Detected X Server version 'XServer 1.18.3_64a' is not supported. Supported versions are X.Org 6.9 or later, up to XServer 1.10 (default:v2:x86_64:lib:XServer 1.18.3_64a:none:4.4.0-42-generic:) Installation will not proceed.
fi

read -p "Do you want to install Libsodium?" answer
if [[ $answer == "y" ]] ; then
wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.9.tar.gz
wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.9.tar.gz.sig

tar -zxvf libsodium**tar.gz
rm libsodium**tar.gz
cd libsodium**
./configure
make && make check
sudo make install
fi
