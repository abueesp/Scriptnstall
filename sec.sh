#!/bin/bash
#TCP flood mitigation
echo "net.ipv4.tcp_challenge_ack_limit = 999999999" >> /etc/sysctl.conf
sudo sysctl -p
#mirror
sudo wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/bash.bashrc
sudo cp bash.bashrc /etc/bash.bashrc
# Secure environment
sudo apt-get autoremove -y
#Prntscreensound
#SSH
sudo sed -i 's/Port 22/Port 1022/' /etc/ssh/sshd_config #SSH PORT OTHER THAN 22, SET 1022
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
sudo apt-get install git tmux -y

sudo apt-get install cmake build-essential libboost-all-dev -y
cd nheqminer/cpu_xenoncat/Linux/asm/ && sh assemble.sh && cd ../../../Linux_cmake/nheqminer_cpu && cmake . && make
~/nheqminer/nheqminer/build/./nheqminer
cd
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
echo "alias knheqminer='~/nheqminer/Linux_cmake/nheqminer_cpu/./nheqminer** -l $serverr -u $addd.$workk -p $pazz -t $(nproc)'" | sudo tee -a /etc/bash.bashrc #Nheqminer
echo "alias knheqminer='~/nheqminer/nheqminer/build/./nheq** -l $serverr -u $addd.$workk -p $pazz -t $(nproc)'" | sudo tee -a /etc/bash.bashrc #Kosh nheqminer
echo "alias silentminer='~/zcash/./src/zcashd -alerts -alertnotify=$alertnotify -blocknotify=$alertnotify -daemon -par=0 -debug -gen=1  -genproclimit=-1 -equihashsolver=\"SILENTMINEEEEEEEEEERRRRRR\"'" | sudo tee -a /etc/bash.bashrc #Mbevand SilentArmy 
fi
