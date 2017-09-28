
##Password management
sudo apt-get install libpwquality-tools -y
pwmake 256
#As the root user is the one who enforces the rules for password creation, they can set any password for themselves or for a regular user, despite the warning messages, so this is only for users.
echo "password    required    pam_pwquality.so retry=3" | sudo tee -a /etc/pam.d/passwd #max 3 tries
echo "minlen = 8" | sudo tee -a  /etc/security/pwquality.conf #min 8 characteres
echo "minclass = 4" | sudo tee -a  /etc/security/pwquality.conf #min all kind of characteres
echo "maxsequence = 3" | sudo tee -a  /etc/security/pwquality.conf #min strength-check for character sequences (no abcd)
echo "maxrepeat = 3" | sudo tee -a  /etc/security/pwquality.conf #min strength-check for  same consecutive characters (no 1111)
sudo chage -M -1 90 $USER #force to change password every 90 days (-M, -W only for warning) but without password expiration (-1, -I will set a different days for password expiration, and -E a data where account will be locked)
chage -l $USER

##USB readonly
echo 'SUBSYSTEM=="block",ATTRS{removable}=="1",RUN{program}="/sbin/blockdev --setro %N"' | sudo tee -a  /etc/udev/rules.d/80-readonly-removables.rules
sudo udevadm trigger
sudo udevadm control --reload

##Vulnerability assessment https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Security_Guide/sec-Vulnerability_Assessment.html

##To prevent sudo from certains ttys: Disable on /etc/securetty. However, a blank /etc/securetty file does not prevent the root user from logging in remotely using the OpenSSH suite of tools because the console is not opened until after authentication.
##To prevent sudo from SSH: sudo vi /etc/ssh/sshd_config -c ':%s/\<PermitRootLogin without password\>/<PermitRootLogin no>/gIc' -c ':wq'
##To prevent sudo from SFTP: echo "auth   required   /lib/security/pam_listfile.so   item=user sense=deny file=/etc/vsftpd.ftpusers onerr=succeed" | sudo tee -a /etc/pam.d/vsftpd
##Similar line can be added to the PAM configuration files, such as /etc/pam.d/pop and /etc/pam.d/imap for mail clients, or /etc/pam.d/sshd for SSH clients.

echo "tty | grep tty && TMOUT=10 >/dev/null" | sudo tee -a /etc/profile #log out virtual /dev/tty consoles out after 5s inactivity

#Do not use rlogin, rsh, and telnet
#Take care of securing sftp, auth, nfs, rpc, postfix, samba and sql https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Security_Guide/sec-Securing_Services.html
#Take care of securing Docker https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html-single/getting_started_with_containers/

##TCP Wrappers
echo "Hello. All activity on this server is logged. Inappropriate uses and access will result in defensive counter-actions." | sudo tee -a /etc/banners/sshd
echo "ALL : ALL : spawn /bin/echo `date` %c %d >> /var/log/intruder_alert" | sudo tee -a /etc/hosts.deny ##log any connection attempt from any IP and send the date to intruder_alert logfile
echo "in.telnetd : ALL : severity emerg" | sudo tee -a /etc/hosts.deny ##log any attempt to connect to in.telnetd posting emergency log messages directly to the console

##Disable Source Routing
sudo /sbin/sysctl -w net.ipv4.conf.all.accept_source_route=0 | sudo tee -a /etc/sysctl.conf

##Disable Port Forwarding
echo 'net.ipv4.conf.all.forwarding=0' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding=0' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.conf.all.mc_forwarding=0' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.mc_forwarding=0' | sudo tee -a /etc/sysctl.conf

##Disable ICMP Redirection
echo 'net.ipv4.conf.all.accept_redirects=0' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv6.conf.all.accept_redirects=0' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.conf.all.secure_redirects=0' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.conf.all.send_redirects=0' | sudo tee -a /etc/sysctl.conf

##TCP flood mitigation - Vulnerability solved since 4.7 kernel version
RNGA=$(expr $RANDOM % 9223372036854775807)
RNGB=$(expr $RANDOM % 9223372036854775807) #5 digits each
echo 'net.ipv4.tcp_challenge_ack_limit = $RNGA$RNGB' | sudo tee -a /etc/sysctl.conf
ip6tables -t raw -I PREROUTING -m rpfilter --invert -j DROP

#xDSL or satellite links with 3G modems require turning off reverse path forwarding on the incoming interface (in that case, for forwarding you might use iptables)
echo 'net.ipv4.conf.all.send_redirects=0' | sudo tee -a /etc/sysctl.conf 
echo 'net.ipv4.conf.default.rp_filter=0' | sudo tee -a /etc/sysctl.conf

#Ethernet networks provide additional ways to redirect traffic, such as ARP or MAC address spoofing, unauthorized DHCP servers, and IPv6 router or neighbor advertisements. In addition, unicast traffic is occasionally broadcast, causing information leaks. These weaknesses can only be addressed by specific countermeasures im

##Firewalls and iptables
#other option is Firewalld https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Security_Guide/sec-Using_Firewalls.htmla
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

### GNU GPG 2 ###
SCRIPTPLACE=https://raw.githubusercontent.com/abueesp/Scriptnstall/master
wget $SCRIPTPLACE/shs/gpg2.sh
source ./gpg2.sh
rm gpg2.sh

### OPENSSL ###
wget $SCRIPTPLACE/shs/openssl.sh
source ./openssl.sh
rm openssl.sh

#mirror
sudo apt-get install apt-transport-https apt-transport-tor -y
sudo sed -i 's/http:\/\/us.archive.ubuntu.com\/ubuntu/https:\/\/mirrors.mit.edu\/ubuntu/g' /etc/apt/sources.list
#sudo sed -i 's/http:\/\/us.archive.ubuntu.com\/ubuntu/https:\/\/mirror.cpsc.ucalgary.ca\/mirror\/ubuntu.com\/packages\//g' /etc/apt/sources.list
mv .bashrc .previous-bashrc
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/.bashrc
sudo apt-get update
sudo apt-get install apt-file -y
sudo apt-file update

#SSH
sudo apt-get purge ssh -y
SSHVERSION=7.5p1
gpg --keyserver hkp://keys.gnupg.net --recv-keys CE8ECB0386FF9C48
gpg --keyserver hkp://keys.gnupg.net --recv-keys A2B989F511B5748F
gpg --keyserver hkp://keys.gnupg.net --recv-keys A819A2D8691EF8DA
gpg --keyserver hkp://keys.gnupg.net --recv-keys D3E5F56B6D920D30
wget https://mirrors.ucr.ac.cr/pub/OpenBSD/OpenSSH/portable/openssh-$SSHVERSION.tar.gz
wget https://mirrors.ucr.ac.cr/pub/OpenBSD/OpenSSH/portable/openssh-$SSHVERSION.tar.gz.asc
gpg2 --verify openssh-$SSHVERSION.tar.gz.asc openssh-$SSHVERSION.tar.gz
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
    gpg --delete-secret-and-public-keys --batch --yes CE8ECB0386FF9C48
    gpg --delete-secret-and-public-keys --batch --yes A2B989F511B5748F
    gpg --delete-secret-and-public-keys --batch --yes A819A2D8691EF8DA
    gpg --delete-secret-and-public-keys --batch --yes D3E5F56B6D920D30
else
    echo "BAD SIGNATURE"
    exit
fi
tar -xvzf openssh-$SSHVERSION.tar.gz
rm openssh-$SSHVERSION.tar.gz
rm openssh-$SSHVERSION.tar.gz.asc
cd openssh-$SSHVERSION
./configure
make
make tests
sudo make install
cd ..
sudo rm -r openssh-$SSHVERSION
sudo mkdir .ssh
sudo chown -R $USER:$USER ~/.ssh
sudo chmod -R 750 ~/.ssh
sudo chmod +x ~/.ssh
numberssh=0
if [numberssh]
    then
    while [ ! -f lastid_rsa$numberssh ] ;
        do
             $numberssh++
        done
    while [ ! -f lastid_rsa$numberssh ] ;
        do
             numberssh1=$numberssh+1
             sudo mv ~/.ssh/$1 ~/.ssh/lastid_rsa$numberssh ~/.ssh/lastid_rsa$numberssh1
             sudo mv ~/.ssh/$1 ~/.ssh/lastid_rsa$numberssh.pub ~/.ssh/lastid_rsa$numberssh1.pub
             $numberssh--
        done 
    echo "-------------> Your last key is now lastid_rsa (priv) and lastid_rsa0.pub (pub). If you want to create a new one type mysshkey. If you want to copy the last one type mylastsshkey"
    sudo mv ~/.ssh/$1 ~/.ssh/id_rsa ~/.ssh/lastid_rsa0
    sudo mv ~/.ssh/$1 ~/.ssh/id_rsa.pub ~/.ssh/lastid_rsa0.pub
    else
    echo "-------------> Those are your current keys: "
    ls -al -R ~/.ssh
fi
sudo mkdir ~/.ssh
echo "-------------> Those are your keys up to now"
sudo ls -al -R ~/.ssh # Lists the files in your .ssh directory, if they exist
read -p "Please, introduce 'youremail@server.com' for ssh: " emai
echo "------------->Introduce this /home/$USER/.ssh/id_rsa as file, OTHERWISE YOU WONT BE ABLE TO USE MYSSHKEY AND THE REST OF SSH MANAGEMENT COMMANDS, and a password longer or equal to 5 caractheres"
ssh-keygen -t rsa -b 4096 -C $emai
eval "$(ssh-agent -s)" 
sudo ssh-add ~/.ssh/id_rsa**
sudo chmod -R 600 ~/.ssh
sudo vi /etc/xdg/autostart/gnome-keyring-ssh.desktop -c ':%s/\<NoDisplay=true\>/<NoDisplay=false\>/gIc' -c ':wq'
sudo vi /etc/ssh/sshd_config -c ':%s/\<PermitRootLogin without password\>/<PermitRootLogin no>/gIc' -c ':wq'  #noroot
sudo vi /etc/ssh/sshd_config -c ':%s/\<Port **\>/<Port 1022\>/gIc' -c ':wq' #SSH PORT OTHER THAN 22, SET 1022
sudo /etc/init.d/ssh restart
man sshd_config | col -b | awk "/Ciphers/,/ClientAlive/"

#Bash
BASHVERSION=4.4
wget https://ftp.gnu.org/gnu/bash/bash-$BASHVERSION.tar.gz
wget https://ftp.gnu.org/gnu/bash/bash-$BASHVERSION.tar.gz.sig
gpg --keyserver hkp://keys.gnupg.net --recv-keys 64EA74AB
gpg --output bash-$BASHVERSION.tar.gz --decrypt bash-$BASHVERSION.tar.gz.sig
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
    gpg --delete-secret-and-public-keys --batch --yes 64EA74AB
else
    echo "BAD SIGNATURE"
    exit
fi
tar -xvzf bash-$BASHVERSION.tar.gz
rm bash-$BASHVERSION.tar.gz
rm bash-$BASHVERSION.tar.gz.sig
cd bash-$BASHVERSION
./configure
make
make tests
sudo make install
cd ..
sudo rm -r bash-$BASHVERSION

#Kernel
KERNELVERSION=4.11.4
KERNELVDATA=4.11.4-041104_4.11.4-041104.201706071003
KERNELVTD=4.11.4-041104-generic_4.11.4-041104.201706071003
while true; do
    read -p "Do you want 1) Install directly from package kernel.deb? 2) Compile the kernel by yourself? " 12
    case $12 in
        [1]* )
            #-lowlatency kernel - very similar to the -preempt kernel and based on the -generic kernel source tree, but uses a more aggressive configuration to further reduce latency. Also known as a soft real-time kernel.
            #-realtime kernel - is based on the vanilla kernel source tree with Ingo Molnar maintained PREEMPT_RT patch applied to it. Also known as a hard real-time kernel. 
            ARCHIT=amd64 #i386 for 32bits
            wget --referer=http://kernel.ubuntu.com/~kernel-ppa/mainline/v$KERNELVERSION/ http://kernel.ubuntu.com/~kernel-ppa/mainline/v"$KERNELVERSION"/linux-headers-"$KERNELVDATA"_all.deb
            wget --referer=http://kernel.ubuntu.com/~kernel-ppa/mainline/v$KERNELVERSION/ http://kernel.ubuntu.com/~kernel-ppa/mainline/v"$KERNELVERSION"/linux-headers-"$KERNELVTD"_"$ARCHIT".deb
            wget --referer=http://kernel.ubuntu.com/~kernel-ppa/mainline/v"$KERNELVERSION"/ http://kernel.ubuntu.com/~kernel-ppa/mainline/v"$KERNELVERSION"/linux-image-"$KERNELVTD"_"$ARCHIT".deb
            wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v"$KERNELVERSION"/CHECKSUMS
            wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v"$KERNELVERSION"/CHECKSUMS.gpg
            gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 60AA7B6F30434AE68E569963E50C6A0917C622B0
            sha256sum -c CHECKSUMS 2>&1 | grep 'OK\|coincide'
            read -p "Press INTRO if you read 3 OK coincidences, otherwise press Ctrl+C to exit"
            gpg --verify CHECKSUMS.gpg linux-headers-"$KERNELVDATA"_all.deb
            if [ $? -eq 0 ]
            then
                echo "GOOD SIGNATURE"
            else
                echo "BAD SIGNATURE"
                exit
            fi
            gpg --verify CHECKSUMS.gpg linux-headers-"$KERNELVTD"_"$ARCHIT".deb
            if [ $? -eq 0 ]
            then
                echo "GOOD SIGNATURE"
            else
                echo "BAD SIGNATURE"
                exit
            fi
            gpg --verify CHECKSUMS.gpg linux-image-"$KERNELVTD"_"$ARCHIT".deb
            if [ $? -eq 0 ]
            then
                echo "GOOD SIGNATURE"
                gpg --delete-secret-and-public-keys --batch --yes 60AA7B6F30434AE68E569963E50C6A0917C622B0
            else
                echo "BAD SIGNATURE"
                exit
            fi
            sudo dpkg -i linux-headers-"$KERNELVDATA"_all.deb
            rm linux-headers-"$KERNELVDATA"_all.deb
            sudo dpkg -i linux-headers-"$KERNELVTD"_"$ARCHIT".deb
            rm linux-headers-"$KERNELVTD"_"$ARCHIT".deb
            sudo dpkg -i linux-image-"$KERNELVTD"_"$ARCHIT".deb
            rm linux-image-"$KERNELVTD"_"$ARCHIT".deb
            sudo update-grub;;
        [2]* ) 
            sudo apt-get install libncurses5-dev libncursesw5-dev -y
            wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$KERNELVERSION.tar.xz
            wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$KERNELVERSION.tar.sign  
            gpg --keyserver hkp://keys.gnupg.net --recv-keys 647F28654894E3BD457199BE38DBBDC86092693E #Greg
            gpg --keyserver hkp://keys.gnupg.net --recv-keys ABAF11C65A2970B130ABE3C479BE3E4300411886 #Torvalds
            gpg --keyserver hkp://keys.gnupg.net --recv-keys 38DBBDC86092693E #Greg
            xz -cd linux-$KERNELVERSION.tar.xz | gpg --verify linux-$KERNELVERSION.tar.sign -
            if [ $? -eq 0 ]
            then
                echo "GOOD SIGNATURE"
                gpg --delete-secret-and-public-keys --batch --yes 647F28654894E3BD457199BE38DBBDC86092693E
                gpg --delete-secret-and-public-keys --batch --yes ABAF11C65A2970B130ABE3C479BE3E4300411886
                gpg --delete-secret-and-public-keys --batch --yes 38DBBDC86092693E 
            else
                echo "BAD SIGNATURE"
                exit
            fi
            tar -xJf linux-$KERNELVERSION.tar.xz
            cd linux-$KERNELVERSION
            make menuconfig
            make && sudo make modules_install
            sudo make install
            sudo update-grub
            cd ..
            sudo rm -r linux-$KERNELVERSION;;
                    * ) echo "Wrong answer. Installation continues." break;; 
        esac 
##psad
PSADVERSION=2.4.4
service psad stop
sudo apt-get -y install libc--clan-perl libdate-calc-perl libiptables-chainmgr-perl libiptables-parse-perl libnetwork-ipv4addr-perl libunix-syslog-perl libbit-vector-perl gcc wget -y
wget https://cipherdyne.org/psad/download/psad-$PSADVERSION.tar.gz
wget https://cipherdyne.org/psad/download/psad-$PSADVERSION.tar.gz.asc
gpg2 --with-fingerprint psad-$PSADVERSION.tar.gz.asc
gpg2 --verify psad**.asc psad-$PSADVERSION.tar.gz
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    exit
fi
tar xvf psad-$PSADVERSION.tar.gz
cd psad-$PSADVERSION
sudo ./install.pl
cd
rm psad-$PSADVERSION.tar.gz && rm psad-$PSADVERSION.tar.gz.asc && sudo rm -r psad-$PSADVERSION
service psad start

#fwsnort
FWSNORTVERSION=1.6.7
wget http://cipherdyne.org/fwsnort/download/fwsnort-$FWSNORTVERSION.tar.gz
wget https://cipherdyne.org/fwsnort/download/fwsnort-$FWSNORTVERSION.tar.gz.asc
gpg2 --with-fingerprint fwsnort-$FWSNORTVERSION.tar.gz.asc
gpg2 --verify fwsnort-$FWSNORTVERSION.tar.gz.asc fwsnort-$FWSNORTVERSION.tar.gz
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    exit
fi
tar xvf fwsnort-$FWSNORTVERSION.tar.gz
cd fwsnort-$FWSNORTVERSION
sudo perl install.pl
cd
rm fwsnort-$FWSNORTVERSION.tar.gz && rm fwsnort-$FWSNORTVERSION.tar.gz.asc && sudo rm -r fwsnort-$FWSNORTVERSION

#Some tools
sudo apt-get install tmux -y
sudo rm ~/tmux.conf~
cp ~/tmux.conf ~/tmux.conf~
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/tmux.conf -O ~/tmux.conf
tmux source-file ~/tmux.conf

sudo apt-get install sysv-rc-conf -y
sudo apt-get install chkrootkit -y
sudo apt-get install secure-delete -y
sudo apt-get install traceroute -y
sudo apt-get install iotop -y 
sudo apt-get install grc -y 
sudo apt-get install unoconv -y
sudo apt-get install detox -y
sudo apt-get install autojump -y
sudo apt-get install nmap arp-scan -y
sudo apt-get install terminator -y
sudo apt-get install htop -y
sudo apt-get install pandoc -y
sudo apt-get install vnstat -y
sudo apt-get install duplicity deja-dup -y
sudo apt-get install at -y




##OSSEC
sudo apt-get install sshfs -y
sudo apt-get install build-essential inotify-tools mailutils postfix -y
OSSECVERSION=2.9.1
wget https://github.com/ossec/ossec-hids/archive/$OSSECVERSION.tar.gz
tar -xf $OSSECVERSION.tar.gz
rm $OSSECVERSION.tar.gz
cd ossec-hids-$OSSECVERSION
bash install.sh
cd ..
rm -r ossec-hids-$OSSECVERSION
openssl genrsa -out /var/ossec/etc/sslmanager.key 4096
openssl req -new -x509 -key /var/ossec/etc/sslmanager.key -out /var/ossec/etc/sslmanager.cert -days 365

#NTPSpec
git clone https://github.com/ntpsec/ntpsec
sudo ./buildprep
sudo ./waf configure
sudo ./waf build
sudo ./waf install
cd ..
sudo rm -r ntpsec
echo '#Logs
driftfile /var/lib/ntp/ntp.drift
statsdir /var/log/ntpstats/
statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable
logfile /var/log/ntpd.log
logconfig =syncall +clockall +peerall +sysall
#Security
restrict default kod limited nomodify nopeer noquery
restrict -6 default kod limited nomodify nopeer noquery
restrict 127.0.0.1
restrict -6 ::1
#Pool servers (configure with your geographical zone reduced packet-transit times. You can add more servers. With 5 servers, you still have 3 if 2 are down and 3 can outvote 2 falsetickers.)
server 0.ubuntu.pool.ntp.org
server 1.ubuntu.pool.ntp.org
server 2.ubuntu.pool.ntp.org
server 3.ubuntu.pool.ntp.org
pool ubuntu.pool.ntp.org' | sudo tee /etc/ntp.config
echo 'if [ -e /var/lib/ntp/ntp.conf.dhcp ]; then
        NTPD_OPTS="$NTPD_OPTS -c /var/lib/ntp/ntp.conf.dhcp"
fi' | sudo tee -a /etc/init.d/ntp
