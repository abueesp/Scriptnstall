#!/bin/bash

## OpenVPN ##
sudo apt-get install openvpn network-manager-openvpn -y
sudo service network-manager restart
sleep 10s
sudo apt-get install gdebi -y #forprivacyguard
sudo chmod 755 /home/node/.gnupg/pubring.gpg
gpg2 --recv 198D22A3
OPVPNVERSION=2.4.2
echo "installing openvpn-"$OPVPNVERSION
mkdir ovpn
cd ovpn
sudo apt-get install libssl1.0.0 libssl-dev liblzo2-dev libpam0g-dev -y
sudo wget https://swupdate.openvpn.org/community/releases/openvpn-$OPVPNVERSION.tar.gz
sudo wget https://swupdate.openvpn.org/community/releases/openvpn-$OPVPNVERSION.tar.gz.asc
gpg2 --verify openvpn-$OPVPNVERSION.tar.gz.asc openvpn-$OPVPNVERSION.tar.gz
tar xfz openvpn-$OPVPNVERSION.tar.gz
cd openvpn-$OPVPNVERSION
./configure
make
sudo make install
cd ..
rm openvpn-$OPVPNVERSION.tar.gz.asc
rm openvpn-$OPVPNVERSION.tar.gz
rm -r openvpn-$OPVPNVERSION
cd ..
sudo rm -r ovpn
echo "All algos"
openssl ciphers -v 'ALL:COMPLEMENTOFALL'
echo "High security algos"
openssl ciphers -v 'HIGH'
echo "Perfect forward secrecy algos"
openssl ciphers -v 'kEECDH+aECDSA+AES:kEECDH+AES+aRSA:kEDH+aRSA+AES' | column -t
##settinf files
sudo apt-get install ca-certificates -y
sudo apt-get autoremove
sudo wget -O /etc/openvpn/ca.vyprvpn.com.crt https://support.goldenfrog.com/hc/en-us/article_attachments/205312238/ca.vyprvpn.com.crt
read -p "Create a new VPN. Type: select Password. Introduce your credentials and the CA certificate from /etc/openvpn/ca.vyprvpn.com.crt. Select the gateway server (such as ch1.vpn.goldenfrog.com) from https://support.goldenfrog.com/hc/en-us/articles/203733723-What-are-the-VyprVPN-server-addresses- On Advanced, select  Use LZO data compression. Then push ENTER. You can also manage your account and servers here: https://www.goldenfrog.com/login." $extravpn
##closing
sudo gpg2 --delete-key 198D22A3 -y
sudo chmod 600 /home/node/.gnupg/pubring.gpg

## VyprVPN ##
read -p "Do you know that Vyprvpn trust on Cisco concentrators and 'they cannot give you more info about, but trust us, your information is secure with us'? Are you sure you want to install it? They use vpnc, vpnc-scripts and network-manager-vpnc Cisco 3000; which also use the broken SHA1; and Chameleon scramble protocol is -oh surprise- well recognized by the Chinese government?"
sudo apt-get install vpnc vpnc-scripts network-manager-vpnc -y 
sudo wget https://support.goldenfrog.com/hc/article_attachments/212490988/vyprvpn-linux-cli-1.7.amd64.deb
sudo dpkg -i vyprvpn*.deb
vyprvpn protocol set chameleon
vyprvpn server list
vyprvpn protocol list
vyprvpn server set ch1.vpn.goldenfrog.com
vyprvpn server show
vyprvpn protocol show
vyprvpn login
vyprvpn connect
sudo rm vyprvpn*.deb

## Test ##
sudo apt-get install traceroute -y
traceroute www.google.es
