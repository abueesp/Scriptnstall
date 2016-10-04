#!/bin/bash

##install openvpn and prepare key
sudo apt-get install openvpn network-manager-openvpn -y
sudo service network-manager restart
sleep 10s
sudo apt-get install gdebi -y #forprivacyguard
sudo chmod 755 /home/node/.gnupg/pubring.gpg
gpg --keyserver pgp.mit.edu --recv 198D22A3


##install openvpn from website
echo "installing openvpn-2.3.11"
mkdir ovpn
cd ovpn
sudo wget https://swupdate.openvpn.org/community/releases/openvpn-2.3.11.tar.gz
sudo wget https://swupdate.openvpn.org/community/releases/openvpn-2.3.11.tar.gz.asc
gpg --verify **.asc
tar xfz openvpn-**.tar.gz
cd openvpn**
./configure
make
sudo make install
cd ..
sudo rm -r openvpn**
sudo rm **.gz
sudo rm **.asc
cd ..
sudo rm -r ovpn

##settinf files
sudo apt-get install ca-certificates -y
sudo apt-get autoremove
sudo wget -O /etc/openvpn/ca.vyprvpn.com.crt https://support.goldenfrog.com/hc/en-us/article_attachments/205312238/ca.vyprvpn.com.crt
read -p "Create a new VPN. Type: select Password. Introduce your credentials and the CA certificate from /etc/openvpn/ca.vyprvpn.com.crt. Select the gateway server (such as ch1.vpn.goldenfrog.com) from https://support.goldenfrog.com/hc/en-us/articles/203733723-What-are-the-VyprVPN-server-addresses- On Advanced, select  Use LZO data compression. Then push ENTER. You can also manage your account and servers here: https://www.goldenfrog.com/login." $extravpn
##closing
sudo gpg --delete-key 198D22A3 -y
sudo chmod 644 /home/node/.gnupg/pubring.gpg

##vyvpr
sudo wget http://www.goldenfrog.com/downloads/vyprvpn/desktop/linux/0.0.1-55/amd64/vyprvpn-linux-cli-0.0.1-55.amd64.deb
sudo dpkg -i vyprvpn**
vyprvpn protocol set chameleon
vyprvpn server list
vyprvpn protocol list
vyprvpn server set ch1.vpn.goldenfrog.com
vyprvpn server show
vyprvpn protocol show
vyprvpn login
vyprvpn connect
sudo rm vyprvpn

#testing
traceroute www.google.es
