#!/bin/bash
# My first script for dnie environment
sudo apt-get autoremove -y
#Bluetooth
sudo sed -i 's/InitiallyPowered = true/InitiallyPowered = false/g' /etc/bluetooth/main.conf
rfkill block bluetooth

#mirror
sudo sed -i 's|http://us.archive.ubuntu.com/ubuntu|http://mirrors.mit.edu/ubuntu|g' /etc/apt/sources.list
sudo apt-get upgrade && update
#SSH
sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/gnome-keyring-ssh.desktop
sudo sed -i 's/PermitRootLogin without password/PermitRootLogin no/' /etc/ssh/sshd_config #noroot
sudo sed -i 's/Port 22/Port 1022/' /etc/ssh/sshd_config #SSH PORT OTHER THAN 22, SET 1022
sudo /etc/init.d/ssh stop
sudo chown -R $USER:$USER .ssh
sudo chmod -R 600 .ssh
sudo chmod +x .ssh
#UFW
sudo apt-get install gufw
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

#Some tools
sudo apt-get install iotop -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
echo "Please write down an email to send you notifications when someone is attacking your ports: "
read email
echo "You entered: $email"
sed "s/destemail = your_email@domain.com/destemail = $email/g" /etc/fail2ban/jail.local
sed "s/action = %(action_)s/action = %(action_mw)s/g" /etc/fail2ban/jail.local
sed -e "s/enabled  = false/enabled  = true/g" /etc/fail2ban/jail.local
##Browsers
sudo apt-get install firefox -y

##DNIe (at last)
sudo apt-get install opensc libccid pcscd libacr38u pinentry-gtk2 pcsc-tools libpcsclite1 libpcsclite-dev libreadline6 libreadline-dev coolkey libnss3-tools -y
sudo apt-get install autoconf subversion libpcsclite-dev libreadline6 libreadline-dev openssl libssl-dev libtool libltdl-dev libccid pinentry-gtk2 build-essential autoconf subversion openssl libssl-dev libtool libltdl-dev pkg-config -y
sudo apt-get autoremove opensc -y
sudo svn list https://forja.cenatic.es/svn/opendnie/opensc-opendnie/trunk
sudo cp /home/$USER/.mozilla/firefox/**.default/cert8.db /etc/firefox-3.0/profile/cert8.db
sudo dpkg-reconfigure ca-certificates
sudo update-ca-certificates
sudo svn checkout --trust-server-cert --no-auth-cache --username anonsvn --pass anonsvn https://forja.cenatic.es/svn/opendnie/opensc-opendnie/trunk
sudo mkdir -p .openscDNIe
cd trunk
sudo sed -i 's:(top_builddir)/src/libopensc/libopensc.la:(top_builddir)/src/libopensc/libopensc.la \ "'$(sudo find / -name libltdl.la)'":g' src/tools/Makefile.am
cd trunk
./bootstrap
./configure --prefix=/usr --sysconfdir=/etc/opensc
make
sudo make install
sudo modutil -add module -libfile /usr/lib/opensc-pkcs11.so -force
sudo sed "s:# enable_pinpad = false;:enable_pinpad = false;:g" $(sudo find / -name opensc.conf)
sudo find / -samefile /home/node/.mozilla/firefox/**.default/prefs.js
##Autoridad de Validación AV DNIE FNMT
wget http://www.dnielectronico.es/descargas/certificados/OCSP_VA_DNIE_FNMT_SHA2.zip
sudo unzip OCSP**
sudo rm OCSP**.zip
sudo mv ACRAIZ**.cer ACRAIZ**.crt
sudo cp OCSP**.crt /usr/share/ca-certificates/OCSP**.crt
sudo cp -rvf OCSP**.crt /usr/share/ca-certificates/mozilla/OCSP**.crt
sudo rm OCSP**.crt
sudo dpkg-reconfigure ca-certificates
sudo update-ca-certificates
## Autoridad de Certificación Raíz del DNIe 
sudo apt-get install cabextract -y
wget http://www.dnielectronico.es/ZIP/ACRAIZ-SHA2.CAB
sudo cabextract ACRAIZ**
sudo rm ACRAIZ**.CAB
sudo mv ACRAIZ**.cer ACRAIZ**.crt
sudo cp ACRAIZ**.crt /usr/share/ca-certificates/ACRAIZ**.crt
sudo cp -rvf ACRAIZ**.crt /usr/share/ca-certificates/mozilla/ACRAIZ**.crt
sudo rm ACRAIZ**.crt
sudo dpkg-reconfigure ca-certificates
sudo apt-get purge cabextract -y
sudo cp /home/$USER/.mozilla/firefox/**.default/cert8.db /etc/firefox-3.0/profile
sudo update-ca-certificates
sudo modutil -add module -libfile /usr/lib/opensc-pkcs11.so
sudo apt-get autoremove -y
echo "HEY! CHECK IF YOU HAVE CORRECTED INSTALLED THE 2 CERTIFICATES!! If so, your 2 CA Certicates from Spanish Admin and DNIe tools have been installed. Write *** lsusb *** to check which usb is dnie connected and *** pcsc_scan *** to check its data. You can also validate your certificates here https://valide.redsara.es/valide/ejecutarValidarCertificado/ejecutar.html and https://av-dnie.cert.fnmt.es/compruebacert/compruebacert"
