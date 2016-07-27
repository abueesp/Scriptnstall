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
sudo apt-get install secure-delete -y
sudo apt-get install duplicity deja-dup pyrenamer -y
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
sudo apt-get install git -y

git clone https://github.com/kvhnuke/etherwallet
git clone https://github.com/ryepdx/ethaddress.org

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
read -p "Please ENTER if PACKAGE VERIFIED. Otherwise Ctrl-C " pause
unzip Ethereum-**
sudo rm Ethereum-**.zip
cd Ethereum**
nohup ./Ethereum-Wallet
cd ..
df
echo "alias ethwallet='cd ~/Ethereum-Wal** && ./Ethereum-Wal**'" >> sudo /etc/bash.bashrc
echo "This is your free space to download the blockchain. Last time it took 6GB and 3 hours."


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
read -p "Please ENTER if PACKAGE VERIFIED. Otherwise Ctrl-C " pause
unzip Mist-**
cd Mist
nohup ./Mist
cd ..
sudo rm Mist-**.zip
df
echo "This is your free space to download the blockchain. Last time it took 6GB and 3 hours."
echo "alias ethmist='cd ~/Mist** && ./Mist**'" >> sudo /etc/bash.bashrc 

read -p "Do you want to install Geth? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
curl -L https://install-geth.ethereum.org
echo "alias privchain='geth --networkid 1 --ipcpath route/geth.ipc --datadir'" >> sudo /etc/bash.bashrc
fi

read -p "Do you want to open Myetherwallet? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
   midori https://www.myetherwallet.com/#the-dao
fi
