read -p "Do you want to delete last swapfile and create a 3GB new one [yn]?" answer
if [[ $answer == "y" ]] ; then
read -e -p "Choose the number of GBs for the swapfile (3 by default): " -i "3" gygas
sudo swapon -s
sudo swapoff -v /swapfile
sudo rm /swapfile
echo "Creating swapfile"
bytes=$(($gygas*1024000))
sudo dd if=/dev/zero of=/swapfile bs=1024 count=$bytes ##Gracias Salva!
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon -s
fi

read -p "Do you want to install the ZCash daemon+client [yn]?" answer
if [[ $answer == "y" ]] ; then
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install build-essential pkg-config libgtest-dev libc6-dev m4 autoconf libtool ncurses-dev unzip git python zlib1g-dev wget bsdmainutils automake aptitude -y
sudo aptitude install g++ g++-multilib -y
git clone https://github.com/zcash/zcash.git
cd zcash/
git fetch origin
git checkout v1.0.0-rc4
./zcutil/fetch-params.sh
echo "now compilation will start"
./zcutil/build.sh -j$(nproc)
     read -p "Do you want to execute the tests [yn]?" answer
     if [[ $answer == "y" ]] ; then 
          echo "now testing will start"
          ./qa/zcash/full-test-suite.sh
          ./qa/pull-tester/rpc-tests.sh
     else
          echo "Continue" 
     fi
echo "now solo mining will start"
mkdir -p ~/.zcash
echo "rpcuser=$USER" > ~/.zcash/zcash.conf
echo "addnode=mainnet.z.cash" >> ~/.zcash/zcash.conf
echo "rpcpassword=`head -c 32 /dev/urandom | base64`" >> ~/.zcash/zcash.conf
echo "gen=1" >> ~/.zcash/zcash.conf
echo "genproclimit=-1" >> ~/.zcash/zcash.conf ##Gracias Salva!!
     read -p "Are you going to mine with Tromp [yn]?" answer
     if [[ $answer == "y" ]] ; then 
     echo "equihashsolver=tromp" >> ~/.zcash/zcash.conf
     else
          echo "Continue" 
     fi
     read -p "Are you going to mine with GPU (deviceid=0 used by default) [yn]?" answer
     if [[ $answer == "y" ]] ; then 
     echo "GPU=1" >> ~/.zcash/zcash.conf
     echo "deviceid=0" >> ~/.zcash/zcash.conf
     else
          echo "Continue" 
     fi
read -p "Check your conf, activate GPU and select the deviceid, add new nodes, change usr and passw, etc." pause 
nano ~/.zcash/zcash.conf
~/zcash/./src/zcashd -daemon
sleep 12
~/zcash/./src/zcash-cli getmininginfo
~/zcash/./src/zcash-cli getwalletinfo
"Welcome to Zcash. You can check you hashrate using zcbm, consult the info on zcinfo, read the txs with zctxs, and use zcstart and zcstop to manage it. You can also use >>watch free<< to watch your memory consumption."
~/zcash/./src/zcash-cli getinfo
~/zcash/./src/zcash-cli z_getnewaddress
~/zcash/./src/zcash-cli z_listaddresses
read -p "Select your coinbase address" ZADDR
~/zcash/./src/zcash-cli z_listreceivedbyaddress "$ZADDR"
~/zcash/./src/zcash-cli listtransactions
fi


read -p "Do you want to create aliases for ZCash daemon+client [yn]?" answer
if [[ $answer == "y" ]] ; then
echo "alias zcnewaddress='~/zcash/./src/zcash-cli z_getnewaddress'" | sudo tee -a  /etc/bash.bashrc 
echo "alias zcbm='~/zcash/src/./zcash-cli zcbenchmark solveequihash 10; watch -n 2 ~/zcash/./src/zcash-cli getinfo; watch -n 2 ~/zcash/./src/zcash-cli getmininginfo'" | sudo tee -a  /etc/bash.bashrc
echo "alias zcinfo='echo "Info" && ~/zcash/./src/zcash-cli getinfo && echo \"Wallet info\" && ~/zcash/./src/zcash-cli getwalletinfo && echo \"Mining info\" && ~/zcash/./src/zcash-cli getmininginfo'" | sudo tee -a  /etc/bash.bashrc
echo "alias zctxs='~/zcash/./src/zcash-cli listtransactions; ~/zcash/./src/zcash-cli z_listaddresses; read -p \"Introduce your address without quotes:\" ZADDR; ~/zcash/./src/zcash-cli z_listreceivedbyaddress $ZADDR'" | sudo tee -a  /etc/bash.bashrc
echo "alias zcgpu='~/zcash/./src/zcash-miner -G'" | sudo tee -a  /etc/bash.bashrc 
echo "alias zcstart='~/zcash/./src/zcashd -daemon'" | sudo tee -a  /etc/bash.bashrc
echo "alias zchelp='~/zcash/./src/zcash-cli -help'" | sudo tee -a  /etc/bash.bashrc
echo "alias zcstratum='echo \"ADD -stratum=\'stratum+tcp://<address>:<port>\' -user=<user> -password=<pass> TO zcgpu or zcstart\"'" | sudo tee -a  /etc/bash.bashrc
echo "alias zcstop='lsof -i | grep zcashd && ~/zcash/./src/zcash-cli stop && sudo pkill -9 zcashd && sudo pkill -9 zcash-cli'" | sudo tee -a  /etc/bash.bashrc
echo "alias zcgui='java -jar ~/zcash/src/ZCashSwingWalletUI.jar'" | sudo tee -a  /etc/bash.bashrc
echo 'zcsend() { \
~/zcash/./src/zcash-cli listtransactions \
~/zcash/./src/zcash-cli z_listaddresses \
read -p "Select your sender address" ZADDR \
~/zcash/./src/zcash-cli z_listreceivedbyaddress "$ZADDR" \
read -p "Write the amount" AMNT \
read -p "Write your friend address" FRIEND \
~/zcash/./src/zcash-cli z_sendmany "$ZADDR" "[{\"amount\": $AMNT, \"address\": \"$FRIEND\"}]" \
sleep 1.1 \
~/zcash/./src/zcash-cli z_getoperationresult \
}' | sudo tee -a /etc/bash.bashrc \
echo "alias zclog='tail -f ~/.zcash/debug.log; watch -n 2 free; date; ~/zcash/./src/zcash-cli getblockcount; ~/zcash/./src/zcash-cli getdifficulty; nproc'" | sudo tee -a /etc/bash.bashrc
fi

read -p "Do you want to install GUI [yn]?" answer
if [[ $answer == "y" ]] ; then
sudo apt-get install git default-jdk ant -y
git clone https://github.com/vaklinov/zcash-swing-wallet-ui.git
cd zcash-swing-wallet-ui
ant -buildfile ./src/build/build.xml
chmod u+x ./build/jars/ZCashSwingWalletUI.jar
cp ./build/jars/ZCashSwingWalletUI.jar ~/zcash/src
java -jar ~/zcash/src/ZCashSwingWalletUI.jar
cd ..
fi

read -p "Do you want to configure your mail postfix system [yn]?" answer
if [[ $answer == "y" ]] ; then
sudo apt-get install mailutils ssmtp postfix -y
read -p "Email Configuration for a mail integrated on terminal. Introduce email  \n" emmail
read -p "Password  \n" Passs
read -p "SMTP. Gmail uses smtp.gmail.com:587    \n" SMTP
sudo sed -i 's/#FromLineOverride=YES/FromLineOverride=YES \AuthUser=$emmail \AuthPass=$Passs \mailhub=$SMTP \UseSTARTTLS=YES/g' /etc/ssmtp/ssmtp.conf
echo "Is blacklisted my domain-name or ip?"
wget http://ipinfo.io/ip -qO -
firefox -new-tab https://www.spamhaus.org/lookup/ -new-tab https://www.whatismyip.com/blacklist-check/
echo "Configure (use a postmaster mail)"
firefox -new-tab https://www.spamhaus.org/pbl/removal/form/ -new-tab https://postmaster.google.com/managedomains?pli=1
echo "$(echo $(wget http://ipinfo.io/ip -qO -) | rev | cut -d. -f2-).in-addr.arpa" #zone file
echo "$($(echo "$(wget http://ipinfo.io/ip -qO -)" | cut -d. -f2- | cut -d. -f2- | cut -d. -f2-).$(echo "$(wget http://ipinfo.io/ip -qO -)" | rev | cut -d. -f2-).in-addr.arpa)" #PTRRecord
firefox -new-tab http://www.digwebinterface.com/?hostnames=$(wget http://ipinfo.io/ip -qO -)%0D%0A&type=&ns=resolver&useresolver=8.8.4.4&nameservers=
read -p 'Write recipient email' REmail
alertnotify = "mail -s 'ZC Alert' $REmail < 'This is a ZC Alert, please check'"
fi

read -p "Do you want to open the Info (Gpu Cpu Pool Cost) data document [yn]?" answer
if [[ $answer == "y" ]] ; then
firefox -new-tab https://docs.google.com/spreadsheets/d/1Um22iBf8bPbfuI4rUDZzSB4W444ouUEnQTBnb8EsdYk/edit
fi

read -p "Do you want to install OpenCL 2.0 for AMD (OpenCL 1.2 is already included in the latest NVIDIA GPU drivers) [yn]?" answer
if [[ $answer == "y" ]] ; then
lspci | grep VGA
sudo apt-get install xorg -y
sudo rm -r /tmp/**
firefox --new-tab http://support.amd.com/en-us/kb-articles/Pages/AMDGPU-PRO-Install.aspx; firefox --new-tab http://support.amd.com/en-us/kb-articles/Pages/AMDGPU-PRO-Install.aspx
unzip /Downloads/linux**.zip
cd fglrx**
./amd-driver-installer
#error: Detected X Server version 'XServer 1.18.3_64a' is not supported. Supported versions are X.Org 6.9 or later, up to XServer 1.10 (default:v2:x86_64:lib:XServer 1.18.3_64a:none:4.4.0-42-generic:) Installation will not proceed.
fi

read -p "Do you want to install CUDA 8.0 [yn]?" answer
if [[ $answer == "y" ]] ; then
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1404/x86_64/7fa2af80.pub
cat 7fa2af80.pub | sudo apt-key add -
read -p "Is your linux version 1404 or 1604?" response
wget https://developer.nvidia.com/compute/cuda/8.0/prod/local_installers/cuda-repo-ubuntu$response-8-0-local_8.0.44-1_amd64-deb
mv cuda-repo-ubuntu$response-8-0-local_8.0.44-1_amd64-deb cuda-repo-ubuntu$response-8-0-local_8.0.44-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu$response-8-0-local_8.0.44-1_amd64.deb
sudo apt-get update
sudo apt-get install cuda nvidia-cuda-toolkit -y
fi

read -p "Do you want to install TrompMiner (CUDA - Nvidia)? https://github.com/tromp/equihash [yn]?" answer
if [[ $answer == "y" ]] ; then
git clone https://github.com/tromp/equihash
cd equihash
make all
echo "RUN <time ./equi1>. The options are -n NONCE -h HEADER -r RANGESIZE, f.i.  -n 255 -r 100"
fi

read -p "Do you want to install Duggard ZMiner (CUDA - Nvidia)? https://github.com/douggard/zmine [yn]?" answer
if [[ $answer == "y" ]] ; then
git clone https://github.com/douggard/zmine
cd zmine
wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.9.tar.gz
wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.9.tar.gz.sig
gpg libsodium**.sig
tar -zxvf libsodium**tar.gz
rm libsodium**tar.gz
cd libsodium**
./configure
make && make check
sudo make install
cd ..
export LD_LIBRARY_PATH=`pwd`/libs/libsodium-1.0.11/src/libsodium/.libs/:/usr/local/cuda-7.5/lib64
./a.out
cd ..
fi

read -p "Do you want to install XenonCatMiner (Demo) https://github.com/xenoncat/equihash-xenon [yn]?" answer
if [[ $answer == "y" ]] ; then
git clone https://github.com/xenoncat/equihash-xenon
cd equihash-xenon
cd Linux
cd blake2b
make
cd ..
cd demo
make
./solver**avx1
./quick**avx1
./solver**avx2
./quick**avx2
cd ..
cd ..
cd ..
fi


read -p "Do you want to install ZogMiner (OpenCL - AMD) https://github.com/nginnever/zogminer.git [yn]?" answer
if [[ $answer == "y" ]] ; then
sudo apt-get install build-essential pkg-config libc6-dev m4 g++-multilib autoconf libtool ncurses-dev unzip git python zlib1g-dev wget bsdmainutils automake opencl-headers mesa-common-dev -y
git clone https://github.com/nginnever/zogminer.git
cd zogminer
./zcutil/fetch-params.sh
./zcutil/build.sh -j$(nproc)
./src/zcash-miner -help
./src/zcashd
fi


read -p "Do you want to install Nheqminer (CPU) https://github.com/nicehash/nheqminer [yn]?" answer
if [[ $answer == "y" ]] ; then
sudo apt-get install cmake build-essential libboost-all-dev -y 
git clone https://github.com/nicehash/nheqminer
cd ~/nheqminer/nheqminer
mkdir build
cd build
cmake ..
make
~/nheqminer/nheqminer/build/./nheqminer
cd
fi


read -p "Do you want to install Kost Nheqminer (CPU) https://github.com/kost/nheqminer [yn]?" answer
if [[ $answer == "y" ]] ; then
sudo apt-get install git cmake make gcc g++ libc-dev boost-dev -y 
git clone https://github.com/kost/nheqminer 
cd ~/nheqminer/nheqminer
mkdir build
cd build
echo "Check your paramenters and continue"
firefox --new-tab http://stackoverflow.com/questions/943755/gcc-optimization-flags-for-xeon
read -p "Introduce your parameters (fi. E3 -DSTATIC_BUILD=1 -DXENON=1 -DMARCH=-m64 -march=core-avx2 )" params
cmake $params
make
~/nheqminer/nheqminer/build/./nheqminer
cd
fi

read -p "Do you want to install Mbevand SilentArmy (OpenCL2.0 AMD) https://github.com/STRML/nheqminer [yn]?" answer
if [[ $answer == "y" ]] ; then 
git clone https://github.com/mbevand/silentarmy
echo "CODING HERE"
fi

read -p "Do you want to create aliases for miners [yn]?" answer
if [[ $answer == "y" ]] ; then
read -p "Write pool server:port ( zec.suprnova.cc:2142 ): " serverr
read -p "Write pool address user: " addd
read -p "Write pool worker name: " workk
read -p "Write pool worker pass: " pazz
echo "alias trompminer='~/zcash/./src/zcashd -alerts -alertnotify=$alertnotify -blocknotify=$alertnotify -daemon -par=0 -debug -gen=1 -genproclimit=-1 -equihashsolver=\"~/equihash/./eq14451\"'" | sudo tee -a /etc/bash.bashrc #Trompminer
echo "alias zminer='~/zcash/./src/zcashd -alerts -alertnotify=$alertnotify -blocknotify=$alertnotify  -daemon -par=0 -debug -gen=1  -genproclimit=-1 -equihashsolver=\"~/zmine/./a.out\"'" | sudo tee -a /etc/bash.bashrc #Zminer
echo "alias xenon1miner='~/zcash/./src/zcashd -alerts -alertnotify=$alertnotify -blocknotify=$alertnotify  -daemon -par=0 -debug -gen=1  -genproclimit=-1 -equihashsolver=\"~/equihash-xenon/Linux/blake2b/./solver**avx1\"'" | sudo tee -a /etc/bash.bashrc #XenonCatMiner1
echo "alias xenon2miner='~/zcash/./src/zcashd -alerts -alertnotify=$alertnotify -blocknotify=$alertnotify -daemon -par=0 -debug -gen=1  -genproclimit=-1 -equihashsolver=\"~/equihash-xenon/Linux/blake2b/./solver**avx2\"'" | sudo tee -a /etc/bash.bashrc  #XenonCatMiner2
echo "alias zogminer='./src/zcash-miner -G -alerts -alertnotify=$alertnotify -blocknotify=$alertnotify  -daemon -par=0 -debug -gen=1  -genproclimit=-1'" | sudo tee -a /etc/bash.bashrc #ZogMiner
echo "alias nheqminer='~/nheqminer/nheqminer/build/./nheqminer -l $serverr -u $addd.$workk -p $pazz -t $(nproc)" | sudo tee -a /etc/bash.bashrc #Nheqminer
echo "alias silentminer='~/zcash/./src/zcashd -alerts -alertnotify=$alertnotify -blocknotify=$alertnotify -daemon -par=0 -debug -gen=1  -genproclimit=-1 -equihashsolver=\"SILENTMINEEEEEEEEEERRRRRR\"'" | sudo tee -a /etc/bash.bashrc #Mbevand SilentArmy 
fi
