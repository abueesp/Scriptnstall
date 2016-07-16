#!/bin/bash
##install openvpn and prepare key
sudo apt-get install openvpn network-manager-openvpn-gnome -y
 sudo apt-get install gdebi -y #forprivacyguard
sudo chmod 755 /home/node/.gnupg/pubring.gpg
gpg --keyserver pgp.mit.edu --recv 198D22A3

##install openvpn from website
echo "installing openvpn-2.3.11"
mkdir ovpn
cd ovpn
wget https://swupdate.openvpn.org/community/releases/openvpn-2.3.11.tar.gz
wget https://swupdate.openvpn.org/community/releases/openvpn-2.3.11.tar.gz.asc
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

##setting files
sudo apt-get install unzip
cd /etc/openvpn
sudo wget https://torguard.net/downloads/OpenVPN-UDP.zip
sudo wget https://torguard.net/downloads/OpenVPN-TCP.zip
read -p 'Those are your TCP ovpns. Choose yours and write it here, the you could use it using openvpn:'
sudo wget https://nordvpn.com/api/files/zip ##CHANGE THE LINK FOR OTHER VPN
sudo rm -r zipvpn
sudo rm -r OpenVPN-UDP
sudo rm -r OpenVPN-TCP
sudo mv zip zipvpn.zip
sudo unzip zipvpn.zip
sudo unzip OpenVPN-UDP.zip
sudo unzip OpenVPN-TCP.zip
sudo rm **.zip
sudo apt-get install ca-certificates -y
sudo apt-get autoremove

#show setting files and select one
cd OpenVPN-TCP
ls -al
cd ..
cd zip
ls -al
read -p 'Those are your TCP ovpns. Choose yours and write it here (Tor are /OpenVPN-TCP/nameof.ovpn and your VPN files are /zipvpn/nameof.ovpn. Then you will be able to use it just with the *ovpn* shortcut command instead of *openvpn /route/file.ovp*: ' fille
comman = echo 'alias ovpn="openvpn --config /etc/openvpn$fille"' 
sudo echo comman >> /etc/bash.bashrc
cd


##closing
sudo gpg --delete-key 198D22A3 -y
sudo chmod 644 /home/node/.gnupg/pubring.gpg

# Ruta de los certificados
#ca /etc/ssl/certs/Sobrebits_CA.crt
#cert /etc/ssl/certs/Nombredeusuario.crt
#key /etc/ssl/private/Nombredeusuario.key

# Redirigimos todo el tráfico a través de la VPN
redirect-gateway def1

#client route /etc/openvpn/client.conf


#testing
traceroute www.google.es
