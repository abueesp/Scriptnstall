sudo mkdir -p /media/cdrom
sudo mount /dev/sr0 /media/cdrom
cd /media/cdrom
sudo ./VBoxLinuxAdditions.run


echo "[Contractor Entry] 
Name=Open folder as root
Icon=gksu-root-terminal
Description=Open folder as root
MimeType=inode;application/x-sh;application/x-executable;
Exec=gksudo pantheon-files -d %U
Gettext-Domain=pantheon-files" >> sudo /usr/share/contractor/Open_as_admin.contract

mirror
sudo sed -i 's|http://us.archive.ubuntu.com/ubuntu|http://mirrors.mit.edu/ubuntu|g' /etc/apt/sources.list
sudo wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/bash.bashrc
sudo cp bash.bashrc /etc/bash.bashrc
#SSH
sudo apt-get install ssh -y
newsshkey
sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/gnome-keyring-ssh.desktop
sudo sed -i 's/PermitRootLogin without password/PermitRootLogin no/' /etc/ssh/sshd_config #noroot
sudo sed -i 's/Port **/Port 1022/' /etc/ssh/sshd_config #SSH PORT OTHER THAN 22, SET 1022
sudo /etc/init.d/ssh restart
sudo chown -R $USER:$USER .ssh
sudo chmod -R 600 .ssh
sudo chmod +x .ssh

#UFW
sudo apt-get install gufw -y
sudo ufw enable
sudo ufw allow 1022/tcp
sudo iptables -F
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 1022 -j ACCEPT
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT ACCEPT ##If you are a server change this to DROP OUTPUT connections by default too
sudo iptables -P FORWARD DROP
sudo iptables restart
sudo service avahi-daemon stop
sudo cupsctl -E --no-remote-any
sudo service cups-browsed stop

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
sudo rm -r psad**
service psad start

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
