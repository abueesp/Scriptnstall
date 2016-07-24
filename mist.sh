##Mist Wallet and Mist Beta with Hard Fork choice 0.8.1
#from https://github.com/ethereum/mist/releases
wget https://github.com/ethereum/mist/releases/download/0.8.1/Ethereum-Wallet-linux64-0-8-1.zip
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "c90ef7cdbb5f8d05e4a3c69e3851973ff878481269472f0397ef97b9bfbe397a" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
unzip Ethereum-**
##Mist browser
#from https://github.com/ethereum/mist
#sudo apt-get install npm -y
#sudo curl https://install.meteor.com/ | sh
#sudo npm install -g electron-prebuilt@1.2.5
#sudo npm install -g gulp
#sudo git clone https://github.com/ethereum/mist.git
#cd mist
#sudo git submodule update --init
#sudo npm install
#sudo gulp update-nodes
#sudo git pull && git submodule update
#sudo echo "alias mist='cd mist && electron . --mode wallet && electron && cd interface && meteor'" >> /etc/bash.bashrc 
#sudo echo "alias privchain='geth --networkid 1 --ipcpath route/geth.ipc --datadir'" >> /etc/bash.bashrc
#sudo echo "alias daosheet='firefox -new-tab -url https://github.com/slockit/DAO/wiki/ && firefox -newtab- -url https://daohub.org'" >> /etc/bash.bashrc
#cd ..
#rm Ethereum**.zip
#cd mist/interface && meteor
#cd
#cd /home/$User/meteor-dapp-wallet/app && meteor --port 3050
