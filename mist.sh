#!/bin/bash
#mirror
sudo sed -i 's|http://us.archive.ubuntu.com/ubuntu|http://mirrors.mit.edu/ubuntu|g' /etc/apt/sources.list
sudo wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/bash.bashrc
sudo cp bash.bashrc /etc/bash.bashrc

# Secure environment
sudo apt-get autoremove -y
#Bluetooth
sudo sed -i 's/InitiallyPowered = true/InitiallyPowered = false/g' /etc/bluetooth/main.conf
rfkill block bluetooth
#mirror
sudo sed -i 's|http://us.archive.ubuntu.com/ubuntu|http://mirrors.mit.edu/ubuntu|g' /etc/apt/sources.list
sudo wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/bash.bashrc
sudo cp bash.bashrc /etc/bash.bashrc
#Prntscreensound
sudo mv /usr/share/sounds/freedesktop/stereo/camera-shutter.oga /usr/share/sounds/freedesktop/stereo/camera-shutter-disabled.oga
#Sudo on Files Eos
echo "[Contractor Entry] 
Name=Open folder as root
Icon=gksu-root-terminal
Description=Open folder as root
MimeType=inode;application/x-sh;application/x-executable;
Exec=gksudo pantheon-files -d %U
Gettext-Domain=pantheon-files" >> sudo /usr/share/contractor/Open_as_admin.contract
#SSH
sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/gnome-keyring-ssh.desktop
sudo sed -i 's/PermitRootLogin without password/PermitRootLogin no/' /etc/ssh/sshd_config #noroot
sudo sed -i 's/Port 22/Port 1022/' /etc/ssh/sshd_config #SSH PORT OTHER THAN 22, SET 1022
sudo /etc/init.d/ssh stop
sudo chown -R $USER:$USER .ssh
sudo chmod -R 600 .ssh
sudo chmod +x .ssh
#UFW
sudo apt-get install gufw -y
sudo ufw enable
#sudo ufw allow 1022/tcp
sudo iptables -F
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#sudo iptables -A INPUT -p tcp --dport 1022 -j ACCEPT
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT ACCEPT ##If you are a server change this to DROP OUTPUT connections by default too
sudo iptables -P FORWARD DROP
sudo iptables restart
sudo service avahi-daemon stop ##This is for when DHCP does not work. Otherwise ps ax | grep dhclient && sudo kill -9 [pid]
sudo cupsctl -E --no-remote-any
sudo service cups-browsed stop
#fwsnort
wget http://cipherdyne.org/fwsnort/download/fwsnort-1.6.5.tar.gz
wget https://cipherdyne.org/fwsnort/download/fwsnort-1.6.5.tar.gz.asc
gpg --verify fwsnort**.asc
md5 = $(md5sum **tar.gz)
if [ $md5 "76552f820e125e97e4dfdd1ce6e3ead6" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
tar xvf fwsnort**.gz
cd fwsnort**
./configure
sudo make
sudo make install
sudo rm -r fwsnort**
#Some tools
sudo apt-get install secure-delete
sudo apt-get install duplicity deja-dup -y
sudo apt-get install iotop htop -y
sudo apt-get install vnstat -y
sudo apt-get install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
echo "Please write down an email to send you notifications when someone is attacking your ports: "
read email
echo "You entered: $email"
sudo sed "s/destemail = your_email@domain.com/destemail = $email/g" /etc/fail2ban/jail.local
sudo sed "s/action = %(action_)s/action = %(action_mw)s/g" /etc/fail2ban/jail.local
sudo sed -e "s/enabled  = false/enabled  = true/g" /etc/fail2ban/jail.local



read -p "Do you want to create some cold storage addresses? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
sudo apt-get install git
git clone https://github.com/kvhnuke/etherwallet
git clone https://github.com/ryepdx/ethaddress.org
fi

sudo nohup pantheon-files ~/ethwallet || sudo nohup nemo ~/ethwallet || sudo nohup nautilus ~/ethwallet
sudo nohup pantheon-files ~/ethaddress.org || sudo nohup nemo ~/ethaddress.org || sudo nohup nautilus ~/ethaddress.org

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
sudo rm Ethereum-**.zip
cd Ethereum**
nohup ./Ethereum-Wallet
cd ..
df -h
echo "This is your free space to download the blockchain"
##Mist browser
#from https://github.com/ethereum/mist/releases
wget https://github.com/ethereum/mist/releases/download/0.8.1/Mist-linux64-0-8-1.zip
if [ $sha1 "2a3cf6e5ddfc46df75f78c4dc7bb2e6248fac2ce84cb2708882895b9f2eda1b7" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
unzip Mist-**
cd Mist
nohup ./Mist
cd ..
sudo rm Mist-**.zip
df -h
echo "This is your free space to download the blockchain"
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

##Geth 
#curl -L https://install-geth.ethereum.org

read -p "Do you want to open the DAO? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   midori https://www.myetherwallet.com/#the-dao
fi
