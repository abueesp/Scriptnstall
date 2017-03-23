#!/bin/bash
#TCP flood mitigation
echo "net.ipv4.tcp_challenge_ack_limit = 999999999" >> /etc/sysctl.conf
sudo sysctl -p
#Bluetooth
sudo sed -i 's/InitiallyPowered = true/InitiallyPowered = false/g' /etc/bluetooth/main.conf
rfkill block bluetooth
#mirror
sudo apt-get install apt-transport-https apt-transport-tor -y
sudo sed -i 's|http://us.archive.ubuntu.com/ubuntu|http://mirrors.mit.edu/ubuntu|g' /etc/apt/sources.list
sudo wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/bash.bashrc
sudo cp bash.bashrc /etc/bash.bashrc
# Secure environment
sudo apt-get autoremove -y
#Prntscreensound
sudo mv /usr/share/sounds/freedesktop/stereo/camera-shutter.oga /usr/share/sounds/freedesktop/stereo/camera-shutter-disabled.oga
#Sudo on Files Eos
echo "[Contractor Entry]\nName=Open folder as root\nIcon=gksu-root-terminal\nDescription=Open folder as root\nMimeType=inode;application/x-sh;application/x-executable;\nExec=gksudo pantheon-files -d %U\nGettext-Domain=pantheon-files" >> Open_as_admin.contract
sudo mv Open_as_admin.contract /usr/share/contractor/Open_as_admin.contract
rm Open_as_admin.contract
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

#MEWMy
mkdir MEWMy
wget https://github.com/kvhnuke/etherwallet/releases/download/v3.5.7/dist-v3.5.7.zip
unzip dist*.zip
rm dist*.zip
firefox index.html
cd ..


##Electrum Wallet
#from https://github.com/ethereum/mist/releases
wget https://github.com/ethereum/mist/releases/download/v0.8.6/Ethereum-Wallet-linux64-0-8-6.zip
sha1 = $(sha1sum Ethereum**.zip)
if [ $sha1 "73499c9624518de0276e9894d8596c85adb6aded9c9d97f3ea3fbb3282ad115c" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
read -p "Please ENTER if PACKAGE VERIFIED. Otherwise Ctrl-C " pause
unzip Ethereum-**
sudo rm Ethereum-**.zip
echo "This is your free space to download the blockchain. Last time it took 6GB and 3 hours."
cd linux
nohup ./Ethereum-Wallet
cd ..
df


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
##psad
service psad stop
sudo apt-get -y install libcarp-clan-perl libdate-calc-perl libiptables-chainmgr-perl libiptables-parse-perl libnetwork-ipv4addr-perl libunix-syslog-perl libbit-vector-perl gcc wget -y
wget https://cipherdyne.org/psad/download/psad-2.4.3.tar.gz
wget https://cipherdyne.org/psad/download/psad-2.4.3.tar.gz.asc
gpg --verify psad**.asc
md5 = $(md5sum **tar.gz)
if [ $md5 "5aa0d22f0bea3ba32e3b9730f78157cf" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
tar xvf psad**.gz
cd psad**
sudo ./install.pl
cd
sudo rm -r psad**
service psad start

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
sudo apt-get install logcheck logcheck-database -y
logcheck -p -u -m -h $email

sudo apt-get install git -y

git clone https://github.com/kvhnuke/etherwallet
git clone https://github.com/ryepdx/ethaddress.org


##Mist browser
#from https://github.com/ethereum/mist/releases
sudo wget https://github.com/ethereum/mist/releases/download/v0.8.6/Mist-linux64-0-8-6.zip
sha1 = $(sha1sum Mist**.zip)
if [ $sha1 "6160f6d04201495d7f49b75c0e5dd6edda0f7aa82f0a12325cef37d675131395" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
read -p "Please ENTER if PACKAGE VERIFIED. Otherwise Ctrl-C " pause

read -p "Please ENTER if PACKAGE VERIFIED. Otherwise Ctrl-C " pause
unzip Mist-**.zip
cd linux
nohup ./Mist
cd ..
sudo rm Mist-**.zip
df
echo "This is your free space to download the blockchain. Last time it took 6GB and 3 hours."

##Geth
echo "Geth"
cd linux
wget https://github.com/ethereum/go-ethereum/releases/download/v1.4.18/geth-linux-amd64-1.4.18-ef9265d0.tar.gz
tar -zxvf geth**.tar.gz
sha1 = $(sha1sum geth**.tar.gz)
if [ $sha1 "efbace0ef748974becd563803b518965f1567de55b51a444d54a619ed3dae612" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
read -p "Please ENTER if PACKAGE VERIFIED. Otherwise Ctrl-C " pause
sudo rm geth**.tar.gz
./geth


##Parity
read -p "Parity. Copy and paste this bash <(curl https://get.parity.io -Lk)" pause
$pause
sudo sed -i  "alias paritysheet='firefox -new-tab https://ethcore.github.io/parity/ethcore/index.html'" /etc/bash.bashrc
#Connect to ethstats
git clone https://github.com/cubedro/eth-net-intelligence-api
cd eth-net-intelligence-api
sudo npm install
sudo npm install -g pm2
sudo mv app.json.example app.json
echo "a38e1e50b1b82fa | ~ | ethfans4you"
echo "wss://rpc.ethstats.net | wws://stats.parity.io | wss://stats.ethfans.org"
gedit app.json
sudo pm2 start app.json
#Miner
sudo add-apt-repository ppa:ethereum/ethereum -y
sudo apt-get update
sudo apt-get install ethminer -y
parity account new
read "Introduce your coinbase address" coinbase
parity --author $coinbase
sudo apt-get install xterm
ethminer -G --opencl-device 0 #use --notify-work URL,URL to set urls to push work notifications 

##firejail & firetools
wget https://downloads.sourceforge.net/project/firejail/firejail/firejail_0.9.44_1_amd64.deb
wget https://downloads.sourceforge.net/project/firejail/firetools/firetools_0.9.44_1_amd64.deb
sudo dpkg -i firejails**
rm firejails
sudo dpkg -i firetools**
rm firetools

#openbsd
wget https://ftp.heanet.ie/pub/OpenBSD/6.0/amd64/install60.iso
wget https://ftp.heanet.ie/pub/OpenBSD/6.0/amd64/SHA256
sha256 -C SHA256 install*.iso
wget https://ftp.heanet.ie/pub/OpenBSD/6.0/amd64/SHA256.sig
signify -Cp /etc/signify/openbsd-XX-base.pub -x SHA256.sig install*.iso
