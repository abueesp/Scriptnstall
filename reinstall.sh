#!/bin/bash
PCVER=$(uname -m)
if [ $PCVER == x86_64 ]; then
    ARCHIT=amd64
elif [ $PCVER == i386 ] || [ $PCVER == i686 ]; then
    PCVER=i686
    ARCHIT=i386
else
  echo "ERROR: The system is neither 64bits nor 32 bits?"
fi

##OS mods
#Prntscreensound
sudo mv /usr/share/sounds/freedesktop/stereo/camera-shutter.oga /usr/share/sounds/freedesktop/stereo/camera-shutter-disabled.oga
#Bluetooth
sudo vi /etc/bluetooth/main.conf -c ':%s/\<InitiallyPowered = true\>/<InitiallyPowered = false\>/gIc' -c ':wq'
rfkill block bluetooth
#Minus
sudo apt-get purge imagemagick fontforge geary whoopsie -y

#mirror
sudo apt-get install apt-transport-https apt-transport-tor -y
sudo sed -i 's/http:\/\/us.archive.ubuntu.com\/ubuntu/https:\/\/mirrors.mit.edu\/ubuntu/g' /etc/apt/sources.list
#sudo sed -i 's/http:\/\/us.archive.ubuntu.com\/ubuntu/https:\/\/mirror.cpsc.ucalgary.ca\/mirror\/ubuntu.com\/packages\//g' /etc/apt/sources.list
mv .bashrc .previous-bashrc
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/.bashrc
sudo apt-get update
sudo apt-get install apt-file -y
sudo apt-file update

##Password management
sudo authconfig --passalgo=sha512 --update
#sudo chage -d 0 tiwary #To force new password in next login, but unnecessary as we are going to renew it now
sudo apt-get install libpwquality-tools -y
#As the root user is the one who enforces the rules for password creation, they can set any password for themselves or for a regular user, despite the warning messages, so this is only for users.
echo "password    required    pam_pwquality.so retry=3" | sudo tee -a /etc/pam.d/passwd #max 3 tries
echo "minlen = 8" | sudo tee -a  /etc/security/pwquality.conf #min 8 characteres
echo "minclass = 4" | sudo tee -a  /etc/security/pwquality.conf #min all kind of characteres
echo "maxsequence = 3" | sudo tee -a  /etc/security/pwquality.conf #min strength-check for character sequences (no abcd)
echo "maxrepeat = 3" | sudo tee -a  /etc/security/pwquality.conf #min strength-check for  same consecutive characters (no 1111)
#sudo chage -M -1 90 $USER #force to change password every 90 days (-M, -W only for warning) but without password expiration (-1, -I will set a different days for password expiration, and -E a data where account will be locked)
sudo chage -W 365 $USER #warningdays for password changing
pwmake 256
chage -l $USER

##USB readonly (-noexec --rw included on alias monta)
#echo 'SUBSYSTEM=="block",ATTRS{removable}=="1",RUN{program}="/sbin/blockdev --setro %N"' | sudo tee -a  /etc/udev/rules.d/80-readonly-removables.rules
#sudo udevadm trigger
#sudo udevadm control --reload

##Vulnerability assessment https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Security_Guide/sec-Vulnerability_Assessment.html
##To prevent sudo from certains ttys: Disable on /etc/securetty. However, a blank /etc/securetty file does not prevent the root user from logging in remotely using the OpenSSH suite of tools because the console is not opened until after authentication.
##To prevent sudo from SSH: 
if [ -s /etc/ssh/sshd_config ]
then
    echo "PermitRootLogin no" | sudo tee -a /etc/ssh/sshd_config
    echo "Protocol 2" | sudo tee -a /etc/ssh/sshd_config
else
    sudo vi /etc/ssh/sshd_config -c ':%s/PermitRootLogin without password/PermitRootLogin no/g' -c ':wq'
    sudo vi /etc/ssh/sshd_config -c ':%s/Protocol 2,1/Protocol 2/g' -c ':wq'
fi
/etc/init.d/sshd restart
##To prevent sudo from SFTP: 
echo "auth   required   /lib/security/pam_listfile.so   item=user sense=deny file=/etc/vsftpd.ftpusers onerr=succeed" | sudo tee -a /etc/pam.d/vsftpd
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
wget $SCRIPTPLACE/shs/gnupg.sh
source ./gnupg.sh
rm gnupg.sh

### OPENSSL ###
wget $SCRIPTPLACE/shs/openssl.sh
source ./openssl.sh
rm openssl.sh
cd

#SSH
sudo apt-get purge ssh -y
SSHVERSION=7.5p1
gpg --keyserver hkp://keys.gnupg.net --recv-keys CE8ECB0386FF9C48
gpg --keyserver hkp://keys.gnupg.net --recv-keys A2B989F511B5748F
gpg --keyserver hkp://keys.gnupg.net --recv-keys A819A2D8691EF8DA
gpg --keyserver hkp://keys.gnupg.net --recv-keys D3E5F56B6D920D30
wget https://mirrors.ucr.ac.cr/pub/OpenBSD/OpenSSH/portable/openssh-$SSHVERSION.tar.gz
wget https://mirrors.ucr.ac.cr/pub/OpenBSD/OpenSSH/portable/openssh-$SSHVERSION.tar.gz.asc
gpg --verify openssh-$SSHVERSION.tar.gz.asc openssh-$SSHVERSION.tar.gz
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
read -p "Do you want 1) Install directly from package kernel.deb? 2) Compile the kernel by yourself? " QUESTION
    case $QUESTION in
        [1]* )
            #-lowlatency kernel - very similar to the -preempt kernel and based on the -generic kernel source tree, but uses a more aggressive configuration to further reduce latency. Also known as a soft real-time kernel.
            #-realtime kernel - is based on the vanilla kernel source tree with Ingo Molnar maintained PREEMPT_RT patch applied to it. Also known as a hard real-time kernel. 
            wget --referer=http://kernel.ubuntu.com/~kernel-ppa/mainline/v$KERNELVERSION/ http://kernel.ubuntu.com/~kernel-ppa/mainline/v"$KERNELVERSION"/linux-headers-"$KERNELVDATA"_all.deb
            wget --referer=http://kernel.ubuntu.com/~kernel-ppa/mainline/v$KERNELVERSION/ http://kernel.ubuntu.com/~kernel-ppa/mainline/v"$KERNELVERSION"/linux-headers-"$KERNELVTD"_"$ARCHIT".deb
            wget --referer=http://kernel.ubuntu.com/~kernel-ppa/mainline/v"$KERNELVERSION"/ http://kernel.ubuntu.com/~kernel-ppa/mainline/v"$KERNELVERSION"/linux-image-"$KERNELVTD"_"$ARCHIT".deb
            wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v"$KERNELVERSION"/CHECKSUMS
            wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v"$KERNELVERSION"/CHECKSUMS.gpg
            gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 60AA7B6F30434AE68E569963E50C6A0917C622B0
            sha256sum -c CHECKSUMS 2>&1
            if [ $? -eq 0 ]
            then
                echo "GOOD HASH"
            else
                echo "BAD HASH"
                exit
            fi
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
                    * ) echo "Wrong answer. Installation continues.";; 
        esac

##psad
PSADVERSION=2.4.5
service psad stop
sudo apt-get -y install libc--clan-perl libdate-calc-perl libiptables-chainmgr-perl libiptables-parse-perl libnetwork-ipv4addr-perl libunix-syslog-perl libbit-vector-perl gcc wget -y
wget https://cipherdyne.org/psad/download/psad-$PSADVERSION.tar.gz
wget https://cipherdyne.org/psad/download/psad-$PSADVERSION.tar.gz.asc
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 0D3E7410 #from asc
gpg --with-fingerprint psad-$PSADVERSION.tar.gz.asc
gpg --verify psad**.asc psad-$PSADVERSION.tar.gz
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
cd ..
rm psad-$PSADVERSION.tar.gz && rm psad-$PSADVERSION.tar.gz.asc && sudo rm -r psad-$PSADVERSION
service psad start

#fwsnort
FWSNORTVERSION=1.6.7
wget http://cipherdyne.org/fwsnort/download/fwsnort-$FWSNORTVERSION.tar.gz
wget https://cipherdyne.org/fwsnort/download/fwsnort-$FWSNORTVERSION.tar.gz.asc
gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys E6C9E3350D3E7410 #from asc
gpg --with-fingerprint fwsnort-$FWSNORTVERSION.tar.gz.asc
gpg --verify fwsnort-$FWSNORTVERSION.tar.gz.asc fwsnort-$FWSNORTVERSION.tar.gz
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
cd ..
rm fwsnort-$FWSNORTVERSION.tar.gz && rm fwsnort-$FWSNORTVERSION.tar.gz.asc && sudo rm -r fwsnort-$FWSNORTVERSION

#keybase
KEYBASEVERSION=_$ARCHIT
sudo apt-get install libappindicator1 -y
curl -O https://prerelease.keybase.io/keybase$KEYBASEVERSION.deb
sudo dpkg -i keybase$KEYBASEVERSION.deb
gpg --list-secret-keys
run_keybase
keybase pgp gen --multi
rm keybase$KEYBASEVERSION.deb

##Fail2ban & logcheck
sudo apt-get purge fail2ban -y
FAIL2BANVERSION=0.10
wget https://github.com/fail2ban/fail2ban/archive/$FAIL2BANVERSION.tar.gz
tar -xf $FAIL2BANVERSION.tar.gz
rm $FAIL2BANVERSION.tar.gz
cd fail2ban-$FAIL2BANVERSION
sudo python setup.py install
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
read -p "Write down an email to send you notifications when someone is attacking your ports: " email
echo "You entered: $email"
sudo vi /etc/fail2ban/jail.local ':%s/\<destemail = your_email@domain.com\>/<destemail = $email\>/gIc' ':wq'
cat /etc/fail2ban/jail.local | grep destemail
sudo vi /etc/fail2ban/jail.local ':%s/\<action = %(action_)s\>/<action = %(action_mw)s\>/gIc' ':wq'
sudo vi /etc/fail2ban/jail.local ':%s/\<enabled  = false\>/<enabled  = true\>/gIc' ':wq'
cp files/debian-initd /etc/init.d/fail2ban
sudo vi -c 's|[sshd]|#[sshd]|g' -c ':wq' /etc/fail2ban/jail.d/defaults-debian.conf
sudo vi -c 's|enabled = true|#enabled = true|g' -c ':wq' /etc/fail2ban/jail.d/defaults-debian.conf
update-rc.d fail2ban defaults
service fail2ban start
cd ..
sudo rm -r fail2ban-$FAIL2BANVERSION

sudo apt-get install zenmap logcheck logcheck-database -y
logcheck -p -u -m -h $email

sudo apt-get dist-upgrade -y
sudo apt-get upgrade -y 

##Virtualbox
VIRTUALBOXVERSION=5.2.8
VBOXVERSION=5.2.8-121009
sudo apt-get purge virtualbox -y
sudo apt-get build-dep virtualbox
sudo apt-get -f install -y
PCVER=$(uname -m)
if [ $PCVER == x86_64 ]; then
    ARCHIT=amd64
    ARCHITECTURE=64
elif [ $PCVER == i386 ] || [ $PCVER == i686 ]; then
    ARCHIT=i386
    ARCHITECTURE=32
    wget http://security.ubuntu.com/ubuntu/pool/main/libv/libvpx/libvpx1_1.0.0-1_i386.deb
    sudo dpkg -i libvpx1_1.0.0-1_i386.deb
    rm libvpx1_1.0.0-1_i386.deb
    sudo apt-get install libcurl3 -y
else
  echo "ERROR: The system is neither 64bits nor 32 bits?"
fi
echo "This is your version:"
cat /etc/issue
read -p "Introduce 'zesty_$ARCHIT' for Ubuntu 17.04, 'yakkety_$ARCHIT' for Ubuntu 16.10, xenial_$ARCHIT for Ubuntu 16.04, wily_$ARCHIT for Ubuntu 15.10, Vivid_$ARCHIT for Ubuntu 15.04, Utopic_$ARCHIT for Ubuntu 14.10 or trusty_$ARCHIT for Ubuntu 14.04: " OS
wget http://download.virtualbox.org/virtualbox/$VIRTUALBOXVERSION/virtualbox-$VBOXVERSION~Ubuntu~$OS.deb
sudo dpkg -i virtualbox-$VBOXVERSION~Ubuntu~$OS.deb
sudo rm virtualbox-$VBOXVERSION~Ubuntu~$OS.deb
sudo apt-get install vagrant -y
vagrant box add precise64 http://files.vagrantup.com/precise64.box #always64
sudo apt-get -f install -y
version=$(vboxmanage -v)
echo $version
var1=$(echo $version | cut -d 'r' -f 1)
echo $var1
var2=$(echo $version | cut -d 'r' -f 2)
echo $var2
file="Oracle_VM_VirtualBox_Extension_Pack-$var1-$var2.vbox-extpack"
echo $file
sudo wget http://download.virtualbox.org/virtualbox/$var1/$file -O $file
#sudo VBoxManage extpack uninstall "Oracle VM VirtualBox Extension Pack"
sudo VBoxManage extpack install $file --replace
sudo rm $file
sudo apt-get install dkms
sudo apt-get -f install -y
vagrant plugin install vagrant-vbguest
wget http://download.virtualbox.org/virtualbox/$VIRTUALBOXVERSION/VBoxGuestAdditions_$VIRTUALBOXVERSION.iso
sudo mv VBoxGuestAdditions_$VIRTUALBOXVERSION.iso /usr/share/VBoxGuestAdditions_$VIRTUALBOXVERSION.iso
echo "To insert iso additions, install first your vm"
virtualbox
vboxmanage storageattach work --storagectl IDE --port 0 --device 0 --type dvddrive --medium "/home/$USER/VBox**.iso"
read -p "Introduce un usuario de vbox " user1 $user1
sudo usermod -G vboxusers -a $user1
read -p "Introduce otro usuario de vbox " user2 $user2
sudo usermod -G vboxusers -a $user2
read -p "Introduce otro usuario de vbox " user2 $user3
sudo usermod -G vboxusers -a $user3
openssl req -new -x509 -newkey rsa:4096 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 365 -subj "/CN=VirtualboxSSL/"
sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n vboxdrv)
sudo mokutil --import MOK.der

##Emacs
sudo apt-get install texlive-latex-base -y
sudo rm -r /usr/local/stow
set -e
EMACSVERSION=25.2
# install dependencies
sudo apt-get install stow build-essential libx11-dev xaw3dg-dev libjpeg-dev libpng12-dev libgif-dev libtiff5-dev libncurses5-dev libxft-dev librsvg2-dev libmagickcore-dev libmagick++-dev libxml2-dev libgpm-dev libotf-dev libm17n-dev libgnutls-dev -y
# download source package
wget http://ftp.gnu.org/gnu/emacs/emacs-$EMACSVERSION.tar.xz
tar xvf emacs-$EMACSVERSION.tar.xz
# build and install
sudo mkdir -p /usr/local/stow
cd emacs-$EMACSVERSION
./configure \
    --with-xft \
    --with-x-toolkit=lucid
make
sudo rm -r /usr/local/stow
sudo make install prefix=/usr/local/stow/emacs-$EMACSVERSION && cd /usr/local/stow
sudo rm /usr/local/share/info/dir
sudo stow emacs-$EMACSVERSION
#spacemacs
sudo apt-get install git -y
git clone http://github.com/syl20bnr/spacemacs ~/.emacs.d
##plugins
cd ~/.emacs.d
wget http://github.com/ethereum/emacs-solidity/blob/master/solidity-mode.el ##solidity
echo 'Carga los elementos de emacs con (add-to-list load-path "~/.emacs.d/") + (load "myplugin.el")' >> README
cd ..
sudo rm emacs-$EMACSVERSION.tar.xz
sudo rm -r emacs-$EMACSVERSION

##Tools and utils
sudo apt-get install mlocate recoll -y #Searchtools
sudo updatedb
sudo apt-get install tmux -y
sudo rm ~/.tmux.conf~
cp ~/.tmux.conf ~/.tmux.conf~
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/.tmux.conf
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/.bc
sudo apt-get install hashalot -y
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
sudo apt-get install brasero -y
sudo apt-get install at -y
sudo apt-get install xmlstarlet jq datamash bc gawk mawk -y #xml and jquery #wc join paste cut sort uniq
sudo apt-get install gparted -y
sudo apt-get install baobab -y
sudo apt-get install nemo -y
sudo apt-get install gtk-recordmydesktop recordmydesktop -y
sudo apt-get install tree -y
sudo apt-get install task -y
sudo apt-get install thunderbird -y
thunderbird https://addons.mozilla.org/thunderbird/downloads/latest/775/addon-775-latest.xpi
sudo apt-get install firefox -y
firefox -P https://addons.mozilla.org/firefox/downloads/file/271802/no_more_install_delay-3.0-fx+sm+fn+tb.xpi

#Python essentials
sudo apt-get install build-essential python-dev python-setuptools python-virtualenv libxml2-dev libxslt1-dev zlib1g-dev -y
sudo apt-get install python3-pip python-pip -y
pip install --upgrade pip
pip3 install --upgrade pip

#Some Python tools
sudo -H pip3 install percol #Indexer
sudo -H pip install shyaml csvkit #yaml csv

#youtube-dl and soundcloud
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/bin/youtube-dl
sudo chmod a+rx /usr/bin/youtube-dl
sudo apt-get install libav-tools -y #for ytbmp3
sudo -H pip install scdl

#Saltpack
sudo apt-get install libffi-dev python-cffi -y
sudo -H pip3 install setuptools
sudo -H pip3 install saltpack

#Text Edition Tools
sudo apt-get install software-properties-common -y ##for add-apt-repository
sudo apt-get install libreoffice apvlv fim -y #office pdf images
sudo apt-get install nano gedit -y

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text -y

sudo apt-get install libgstreamer-plugins-base0.10-0 -y #for scrivener requirements libgstapp-0.10.so.0
SCRIVENERVERSION="1.9.0.1-"$ARCHIT
wget http://www.literatureandlatte.com/scrivenerforlinux/scrivener-$SCRIVENERVERSION.deb
sudo dpkg -i scrivener-$SCRIVENERVERSION.deb
sudo rm scrivener-$SCRIVENERVERSION.deb

##Vim##
sudo apt-get install vim -y
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
sudo apt-get install powerline supercollider-vim vim-addon-manager vim-latexsuite vim-pathogen vim-python-jedi vim-rails vim-scripts vim-snipmate vim-snippets vim-syntastic vim-tabular  vim-ultisnips vim-youcompleteme -y
cd .vim
mkdir bundle
cd bundle
git clone git://github.com/tpope/vim-fugitive.git
vim -u NONE -c "helptags vim-fugitive/doc" -c q
autocmd QuickFixCmdPost *grep* cwindow
sudo apt-get install build-essential cmake
sudo apt-get install python-dev python3-dev
cd ~/.vim/bundle
git clone https://github.com/valloric/youcompleteme
cd youcompleteme
git submodule update --init --recursive
cd ~/.vim/bundle/youcompleteme/third_party/ycmd/clang_archives
rm clang*
wget http://releases.llvm.org/5.0.1/clang+llvm-5.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz
wget http://releases.llvm.org/5.0.1/clang+llvm-5.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz.sig
./install.py --all
cd ~/.vim/bundle
git clone https://github.com/tpope/vim-rails.git
vim -u NONE -c "helptags vim-rails/doc" -c q
git clone https://github.com/plasticboy/vim-markdown.git
git clone https://github.com/elzr/vim-json
git clone --recursive https://github.com/davidhalter/jedi-vim.git
git clone https://github.com/mxw/vim-jsx.git ~/.vim/bundle/vim-jsx
git clone https://github.com/othree/html5.vim
git clone git://github.com/tpope/vim-sensible.git
git clone https://github.com/janko-m/vim-test
git clone https://github.com/StanAngeloff/php.vim.git
git clone https://github.com/vim-scripts/grep.vim
git clone https://github.com/chrisbra/csv.vim
git clone https://github.com/sirver/ultisnips
#Vimpolyglot
#ansible (syntax, indent, ftplugin)apiblueprint (syntax)applescript (syntax)arduino (syntax, indent)asciidoc (syntax)blade (syntax, indent, ftplugin)c++11 (syntax)c/c++ (syntax)caddyfile (syntax, indent, ftplugin)cjsx (syntax, ftplugin)clojure (syntax, indent, autoload, ftplugin)coffee-script (syntax, indent, compiler, autoload, ftplugin)cql (syntax)cryptol (syntax, compiler, ftplugin)crystal (syntax, indent, autoload, ftplugin)css (syntax)cucumber (syntax, indent, compiler, ftplugin)dart (syntax, indent, autoload, ftplugin)dockerfile (syntax)elixir (syntax, indent, compiler, autoload, ftplugin)elm (syntax, indent, autoload, ftplugin)emberscript (syntax, indent, ftplugin)emblem (syntax, indent, ftplugin)erlang (syntax, indent)fish (syntax, indent, compiler, autoload, ftplugin)git (syntax, indent, ftplugin)glsl (syntax, indent)gnuplot (syntax)go (syntax, compiler, indent)graphql (syntax, ftplugin)groovy (syntax)haml (syntax, indent, compiler, ftplugin)handlebars (syntax, indent, ftplugin)haskell (syntax, indent, ftplugin)haxe (syntax)html5 (syntax, indent, autoload, ftplugin)i3 (syntax, ftplugin)jasmine (syntax)javascript (syntax, indent, compiler, ftplugin, extras)json (syntax, indent, ftplugin)jst (syntax, indent)jsx (after)julia (syntax, indent)kotlin (syntax, indent)latex (syntax, indent, ftplugin)less (syntax, indent, ftplugin)liquid (syntax, indent, ftplugin)livescript (syntax, indent, compiler, ftplugin)lua (syntax, indent)mako (syntax, indent, ftplugin)markdown (syntax)mathematica (syntax, ftplugin)nginx (syntax, indent, ftplugin)nim (syntax, compiler, indent)nix (syntax, ftplugin)objc (ftplugin, syntax, indent)ocaml (syntax, indent, ftplugin)octave (syntax)opencl (syntax, indent, ftplugin)perl (syntax, indent, ftplugin)pgsql (syntax)php (syntax)plantuml (syntax, indent, ftplugin)powershell (syntax, indent, ftplugin)protobuf (syntax, indent)pug (syntax, indent, ftplugin)puppet (syntax, indent, ftplugin)purescript (syntax, indent, ftplugin)python-compiler (compiler, autoload)python (syntax, indent)qml (syntax, indent, ftplugin)r-lang (syntax, ftplugin)racket (syntax, indent, autoload, ftplugin)ragel (syntax)raml (syntax, ftplugin)rspec (syntax)ruby (syntax, indent, compiler, autoload, ftplugin)rust (syntax, indent, compiler, autoload, ftplugin)sbt (syntax)scala (syntax, indent, compiler, ftplugin)scss (syntax, autoload, ftplugin)slim (syntax, indent, ftplugin)solidity (syntax, indent)stylus (syntax, indent, ftplugin)swift (syntax, indent, ftplugin)sxhkd (syntax)systemd (syntax)terraform (syntax, indent, ftplugin)textile (syntax, ftplugin)thrift (syntax)tmux (syntax, ftplugin)tomdoc (syntax)toml (syntax, ftplugin)twig (syntax, indent, ftplugin)typescript (syntax, indent, compiler, ftplugin)vala (syntax, indent)vbnet (syntax)vcl (syntax)vm (syntax, indent)vue (syntax, indent, ftplugin)xls (syntax)yaml (syntax, ftplugin)yard (syntax)
git clone https://github.com/sheerun/vim-polyglot
git clone https://github.com/tomlion/vim-solidity.git ~/.vim/bundle/vim-solidity
#Vimux for tmux
wget https://github.com/benmills/vimux/tarball/master -O benmill-vimux.tar.gz
tar -xf benmill-vimux.tar.gz
rm benmill-vimux.tar.gz
cd
mv ~/.vim/autoload/plug.vim ~/.vim/autoload/plug-backup.vim
wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O ~/.vim/autoload/plug.vim
mkdir -p ~/.vim/vim-snippets
cd ~/.vim/vim-snippets
sh -c "curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh"
echo "installed vimcr"
wget https://raw.githubusercontent.com/Russell91/sshrc/master/sshrc && sudo chmod -R 600 sshrc && chmod +x sshrc && sudo mv sshrc /usr/local/bin
echo "ssh bashcr vimcr portability installed"
cd
echo ":nnoremap <C-B> <C-V>" | sudo tee -a /usr/share/vim/vimrc
echo ":nnoremap <C-O> o<Esc>" | sudo tee -a /usr/share/vim/vimrc
#echo ":command! Vb exe "norm! \<C-V>" | sudo tee -a /usr/share/vim/vimrc

##Github
sudo pacman -S git --noconfirm --needed
git config --global credential.helper cache
# Set git to use the credential memory cache
git config --global credential.helper 'cache --timeout=3600'
# Set the cache to timeout after 1 hour (setting is in seconds)
read -p "Please set your username: " username
git config --global user.name $username
read -p "Please set your email: " mail
git config --global user.email $mail
read -p "Please set your core editor: " editor
git config --global core.editor $editor
read -p "Please set your diff app: " diff
git config --global merge.tool $diff
gpg --list-secret-keys
read -p "Introduce the key id (and open https://github.com/settings/keys): " keyusername
gpg --export -a $keyusername
git config --global user.signingkey $keyusername
git config --global commit.gpgsign true
git config --list
echo "Here you are an excellent Github cheatsheet https://raw.githubusercontent.com/hbons/git-cheat-sheet/master/preview.png You can also access as gitsheet"
echo "If you get stuck, run ‘git branch -a’ and it will show you exactly what’s going on with your branches. You can see which are remotes and which are local."
echo "Do not forget to add a newsshkey or clipboard your mysshkey or mylastsshkey (if you switchsshkey before) and paste it on Settings -> New SSH key and paste it there." 



##Browsers
#sudo apt-get install firefox -y it is ready
cd Downloads
mkdir extensions
cd extensions
mkdir privacy
cd privacy
wget https://www.eff.org/files/privacy-badger-latest.xpi
wget https://addons.mozilla.org/firefox/downloads/file/706680/google_redirects_fixer_tracking_remover-3.0.0-an+fx.xpi GoogleRedirectFixer.xpi
wget https://addons.mozilla.org/firefox/downloads/file/727843/skip_redirect-2.2.1-fx.xpi SkipRedirect.xpi
wget https://addons.mozilla.org/firefox/downloads/file/808841/addon-808841-latest.xpi -O AdblockPlus.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/497366/addon-497366-latest.xpi -O DisableWebRTC.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/92079/addon-92079-latest.xpi -O CookieManager.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/383235/addon-383235-latest.xpi -O FlashDisable.xpi
wget https://addons.mozilla.org/firefox/downloads/file/281702/google_privacy-0.2.4-sm+fx.xpi -O GooglePriv.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/415846/addon-415846-latest.xpi -O SelfDestructing Cookies.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/387051/addon-387051-latest.xpi -O RemoveGoogleTracking.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/722/addon-722-latest.xpi -O NoScript.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/1865/addon-1865-latest.xpi  -O AdBlock Plus.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/496120/addon-496120-latest.xpi -O LocationGuard.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/473878/addon-473878-latest.xpi -O RandomAgentSpoofer.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/229918/addon-229918-latest.xpi -O HTTPSEverywhere.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/607454/addon-607454-latest.xpi -O UBlockOrigin.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/addon-534930-latest.xpi -O Avoid HTML5 Canvas.xpi
wget https://addons.mozilla.org/firefox/downloads/file/790214/umatrix-1.1.12-an+fx.xpi -O UMatrix.xpi
mkdir otherprivacy
wget https://addons.mozilla.org/firefox/downloads/latest/certificate-patrol/addon-6415-latest.xpi -O certificate patrol.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/6196/addon-6196-latest.xpi -O PassiveRecon.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/521554/addon-521554-latest.xpi -O DecentralEyes.xpi
cd ..
cd ..
wget https://addons.mozilla.org/firefox/downloads/file/769143/blockchain_dns-1.0.9-an+fx.xpi -O Blockchaindns.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/1843/addon-1843-latest.xpi -O Firebug.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/5791/addon-5791-latest.xpi -O FlagFox.xpi
wget https://addons.mozilla.org/en-US/firefox/downloads/latest/2109/addon-2109-latest.xpi -O FEBEBackups.xpi
#wget https://addons.mozilla.org/firefox/downloads/latest/363974/addon-363974-latest.xpi -O Lightbeam.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/409964/addon-409964-latest.xpi -O VideoDownloadHelper.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/export-to-csv/addon-364467-latest.xpi -O ExportTabletoCSV.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/tabletools2/addon-296783-latest.xpi -O TableTools2.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/748/addon-748-latest.xpi -O Greasemonkey.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/7447/addon-7447-latest.xpi -O NetVideoHunter.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/1237/addon-1237-latest.xpi -O QuickJava.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/3497/addon-3497-latest.xpi -O EnglishUSDict.xpi
wget https://addons.mozilla.org/firefox/downloads/file/502726/colorfultabs-31.0.8-fx+sm.xpi -O ColorfulTabs.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/193270/addon-193270-latest.xpi -O PrintEdit.xpi
wget https://addons.mozilla.org/firefox/downloads/file/342774/tineye_reverse_image_search-1.2.1-fx.xpi -O TinyEyeReverseImageSearch.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/355192/addon-355192-latest.xpi -O MindTheTime.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/1843/addon-1843-latest.xpi -O Firebug.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/161670/addon-161670-latest.xpi -O FlashFirebug.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/tab-groups-panorama/addon-671381-latest.xpi -O Tabgroups.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/532/addon-532-latest.xpi -O LinkChecker.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/5523/addon-5523-latest.xpi -O guiconfigextraoptions.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/10586/addon-10586-latest.xpi -O URLShortener.xpi
wget https://addons.mozilla.org/firefox/downloads/file/387220/text_to_voice-1.15-fx.xpi -O TextToVoice.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/8661/addon-8661-latest.xpi -O WorldIP.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/3829/addon-3829-latest.xpi -O liveHTTPHeaders.xpi
wget https://addons.mozilla.org/firefox/downloads/file/373868/soundcloud_downloader_soundgrab-0.98-fx.xpi -O Soundcloud.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/695840/addon-695840-latest.xpi -O FlashDebugger.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/video-downloadhelper/addon-3006-latest.xpi -O VideoDownloadHelper.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/390151/addon-390151-latest.xpi -O TOS.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/3456/addon-3456-latest.xpi -O WOT.xpi
#wget https://addons.mozilla.org/firefox/downloads/latest/perspectives/addon-7974-latest.xpi -O perspectivenetworknotaries.xpi
wget https://www.roboform.com/dist/roboform-firefox.xpi
mkdir extratools
wget https://addons.mozilla.org/firefox/downloads/file/140447/cryptofox-2.2-fx.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/copy-as-plain-text/addon-344925-latest.xpi -O CopyasPlainText.xpi
wget https://addons.mozilla.org/firefox/downloads/file/229626/sql_inject_me-0.4.7-fx.xpi 
wget https://addons.mozilla.org/firefox/downloads/file/215802/rightclickxss-0.2.1-fx.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/3899/addon-3899-latest.xpi -O HackBar.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/wappalyzer/addon-10229-latest.xpi -O Wappanalyzer.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/344927/addon-344927-latest.xpi -O CookieExportImport.xpi
wet https://addons.mozilla.org/firefox/downloads/file/204186/fireforce-2.2-fx.xpi 
wget https://addons.mozilla.org/firefox/downloads/file/224182/csrf_finder-1.2-fx.xpi 
wget https://addons.mozilla.org/firefox/downloads/file/345004/live_http_headers_fixed_by_danyialshahid-0.17.1-signed-sm+fx.xpi
wget https://addons.mozilla.org/firefox/downloads/file/782839/recap-1.1.8-an+fx.xpi -O RECAPforsearchingUSLawDB.xpi
cd ..
cd ..
cd ..
cd ~/.mozilla/firefox/*.default
echo 'privacy.firstparty.isolate = true
privacy.resistFingerprinting = true
privacy.trackingprotection.enabled = true
browser.cache.offline.enable = false
browser.safebrowsing.malware.enabled = false
browser.safebrowsing.phishing.enabled = false
browser.send_pings = false
browser.sessionstore.max_tabs_undo = 0
browser.urlbar.speculativeConnect.enabled = false
dom.battery.enabled = false
accessibility.blockautorefresh = 1
dom.event.clipboardevents.enabled = false
geo.enabled = false
media.navigator.enabled = false
network.cookie.cookieBehavior = 1
network.cookie.lifetimePolicy = 2
webgl.disabled = true
user_pref("browser.search.defaulturl","https://searx.me/");
user_pref("browser.search.defaultenginename","Searx");
' | tee -a user.js 
cd
firefox --new-tab about:config 

#thunderbird extensions
cd Downloads
mkdir -p extensions
cd extensions
mkdir thunderbird
cd thunderbird
wget https://addons.mozilla.org/thunderbird/downloads/latest/611/addon-611-latest.xpi -O Signature Switch.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/1339/addon-1339-latest.xpi -O ExpressionSearchGmail.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/556/addon-556-latest.xpi -O attachmentextractor.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/4003/addon-4003-latest.xpi -O autozipattachments.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/1556/addon-1556-latest.xpi -O allowhtmltemp.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/550/addon-550-latest.xpi -O mailredirect.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/2313/platform:2/addon-2313-latest.xpi -O sm+tblinux.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/4631/addon-4631-latest.xpi -O providerforgooglecalendar.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/2199/addon-2199-latest.xpi -O withattach.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/550/addon-550-latest.xpi -O mailredirect.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/71/addon-71-latest.xpi -O enigmail.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/210/addon-210-latest.xpi -O viewheaders.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/875/addon-875-latest.xpi -O tb header tools.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/1003/addon-1003-latest.xpi -O headerscrollextension.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/torbirdy/platform:2/addon-381417-latest.xpi -O torbirdy.xpi
cd ..
cd ..
cd ..

## Opera ##
PCVER=$(uname -m)
if [ $PCVER == x86_64 ]; then
    ARCHIT=amd64
    OPERAVERSION=46.0.2573.0"_"$ARCHIT
elif [ $PCVER == i386 ] || [ $PCVER == i686 ]; then
    ARCHIT=i386
    OPERAVERSION=developer-51.0.2809.0"_"$ARCHIT
else
  echo "ERROR: The system is neither 64bits nor 32 bits?"
fi
OPERADEVVERSION=$OPERAVERSION"_"$ARCHIT
sudo apt-get install libpangox-1.0-0  libpango1.0-0 -y
wget https://ftp.opera.com/pub/opera-developer/$OPERAVERSION/linux/opera-$OPERAVERSION.deb
sudo dpkg -i opera-$OPERAVERSION.deb
sudo rm opera-$OPERAVERSION.deb

#ironchrome
IRONFOLDER=/opt/iron/
PCVER=$(uname -m)
if [ $PCVER == x86_64 ]; then
    wget http://www.srware.net/downloads/iron64.deb
    sudo dpkg -i iron64.deb
    sudo rm iron64.deb
elif [ $PCVER == i386 ] || [ $PCVER == i686 ]; then
    wget http://www.srware.net/downloads/iron.deb
    sudo dpkg -i iron.deb
    sudo rm iron.deb
else
  echo "ERROR: The system is neither 64bits nor 32 bits?"
fi
sudo mv /usr/share/iron $IRONFOLDER
$IRONFOLDER/./chrome https://chrome.google.com/webstore/detail/url-tracking-stripper-red/flnagcobkfofedknnnmofijmmkbgfamf
$IRONFOLDER/./chrome https://chrome.google.com/webstore/detail/dont-track-me-google/gdbofhhdmcladcmmfjolgndfkpobecpg
$IRONFOLDER/./chrome https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm
$IRONFOLDER/./chrome https://chrome.google.com/webstore/detail/adblock/gighmmpiobklfepjocnamgkkbiglidom
$IRONFOLDER/./chrome chromium-browser https://chrome.google.com/webstore/detail/session-buddy/edacconmaakjimmfgnblocblbcdcpbko
$IRONFOLDER/./chrome https://chrome.google.com/webstore/detail/project-naptha/molncoemjfmpgdkbdlbjmhlcgniigdnf
$IRONFOLDER/./chrome https://chrome.google.com/webstore/detail/form-filler/bnjjngeaknajbdcgpfkgnonkmififhfo
$IRONFOLDER/./chrome https://chrome.google.com/webstore/detail/autoform/fdedjnkmcijdhgbcmmjdogphnmfdjjik
$IRONFOLDER/./chrome https://chrome.google.com/webstore/detail/m-i-m/jlppachnphenhdidmmpnbdjaipfigoic
$IRONFOLDER/./chrome https://chrome.google.com/webstore/detail/librarian-for-arxiv-ferma/ddoflfjcbemgfgpgbnlmaedfkpkfffbm
$IRONFOLDER/./chrome https://chrome.google.com/webstore/detail/noiszy/immakaidhkcddagdjmedphlnamlcdcbg
$IRONFOLDER/./chrome https://chrome.google.com/webstore/detail/ciiva-search/fkmanbkfjcpkhonmmdopjmjopbclegel
$IRONFOLDER/./chrome https://chrome.google.com/webstore/detail/project-naptha/molncoemjfmpgdkbdlbjmhlcgniigdnf
$IRONFOLDER/./chrome https://blockchain-dns.info/files/BDNS-1.0.8.crx

#chromium
sudo add-apt-repository ppa:canonical-chromium-builds/stage -y
sudo apt-get update
sudo apt-get install chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg-extra -y
chromium-browser https://chrome.google.com/webstore/detail/url-tracking-stripper-red/flnagcobkfofedknnnmofijmmkbgfamf
chromium-browser https://chrome.google.com/webstore/detail/dont-track-me-google/gdbofhhdmcladcmmfjolgndfkpobecpg
chromium-browser https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm
chromium-browser https://chrome.google.com/webstore/detail/adblock/gighmmpiobklfepjocnamgkkbiglidom
#chromium-browser https://chrome.google.com/webstore/detail/session-buddy/edacconmaakjimmfgnblocblbcdcpbko
#chromium-browser https://chrome.google.com/webstore/detail/project-naptha/molncoemjfmpgdkbdlbjmhlcgniigdnf
#chromium-browser https://chrome.google.com/webstore/detail/form-filler/bnjjngeaknajbdcgpfkgnonkmififhfo
#chromium-browser https://chrome.google.com/webstore/detail/autoform/fdedjnkmcijdhgbcmmjdogphnmfdjjik
#chromium-browser https://chrome.google.com/webstore/detail/m-i-m/jlppachnphenhdidmmpnbdjaipfigoic
#chromium-browser https://chrome.google.com/webstore/detail/librarian-for-arxiv-ferma/ddoflfjcbemgfgpgbnlmaedfkpkfffbm
#chromium-browser https://chrome.google.com/webstore/detail/noiszy/immakaidhkcddagdjmedphlnamlcdcbg
#chromium-browser https://chrome.google.com/webstore/detail/ciiva-search/fkmanbkfjcpkhonmmdopjmjopbclegel
#chromium-browser https://blockchain-dns.info/files/BDNS-1.0.8.crx
#chromium-browser https://chrome.google.com/webstore/detail/video-downloadhelper/lmjnegcaeklhafolokijcfjliaokphfk

#icecat
PCVER=$(uname -m)
if [ $PCVER == x86_64 ]; then
    ARCHIT=amd64
elif [ $PCVER == i386 ] || [ $PCVER == i686 ]; then
    PCVER=i686
    ARCHIT=i386
else
  echo "ERROR: The system is neither 64bits nor 32 bits?"
fi
ICECATVERSION=52.3.0
wget http://gnuftp.uib.no/gnuzilla/$ICECATVERSION/icecat-$ICECATVERSION.en-US.linux-$PCVER.tar.bz2
wget http://gnuftp.uib.no/gnuzilla/$ICECATVERSION/icecat-$ICECATVERSION.en-US.linux-$PCVER.tar.bz2.sig
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys A57369A8BABC2542B5A0368C3C76EED7D7E04784
gpg --verify icecat-$ICECATVERSION.en-US.linux-$PCVER.tar.bz2.sig icecat-$ICECATVERSION.en-US.linux-$PCVER.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
    gpg --delete-secret-and-public-keys --batch --yes A57369A8BABC2542B5A0368C3C76EED7D7E04784
    rm icecat-$ICECATVERSION.en-US.linux-$PCVER.tar.bz2.sig
else
    echo "BAD SIGNATURE"
    exit
fi
tar xfvj icecat-$ICECATVERSION.en-US.linux-$PCVER.tar.bz2
rm icecat-$ICECATVERSION.en-US.linux-$PCVER.tar.bz2
sudo mv icecat /opt/icecat
mkdir /opt/icecat/profiles

##Tor
TORVERSION=7.0.10
TORLANG=en-US
PCVER=$(uname -m)
if [ $PCVER == x86_64 ]; then
    LINUXVER=64
elif [ $PCVER == i386 ] || [ $PCVER == i686 ]; then
    LINUXVER=32
else
  echo "ERROR: The system is neither 64bits nor 32 bits?"
fi
wget https://www.torproject.org/dist/torbrowser/$TORVERSION/tor-browser-linux$LINUXVER-"$TORVERSION"_$TORLANG.tar.xz
wget https://www.torproject.org/dist/torbrowser/$TORVERSION/tor-browser-linux$LINUXVER-"$TORVERSION"_$TORLANG.tar.xz.asc
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B1172656DFF983C3042BC699EB5A896A28988BF5
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys F65CE37F04BA5B360AE6EE17C218525819F78451
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 2133BC600AB133E1D826D173FE43009C4607B1FB
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B35BF85BF19489D04E28C33C21194EBB165733EA
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 8738A680B84B3031A630F2DB416F061063FEE659
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys C2E34CFC13C62BD92C7579B56B8AAEB1F1F5C9B5
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 68278CC5DD2D1E85C4E45AD90445B7AB9ABBEEC6
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys C963C21D63564E2B10BB335B29846B3C683686CC
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 261C5FBE77285F88FB0C343266C8C2D7C5AA446D
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 25FC1614B8F87B52FF2F99B962AF4031C82E0039
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys AD1AB35C674DF572FBCE8B0A6BC758CBC11F6276
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 8C4CD511095E982EB0EFBFA21E8BF34923291265
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 35CD74C24A9B15A19E1A81A194373AA94B7C3223
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 4A90646C0BAED9D456AB3111E5B81856D0220E4B
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys D6A948CF297F753930B4756AFA7F0E44D487F03F
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys EF6E286DDA85EA2A4BA7DE684E2C6E8793298290
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B74417EDDF22AC9F9E90F49142E86A2A11F48D36
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys E4ACD3975427A5BA8450A1BEB01C8B006DA77FAA
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys A490D0F4D311A4153E2BB7CADBB802B258ACD84F
gpg --verify tor-browser-linux$LINUXVER-"$TORVERSION"_$TORLANG.tar.xz.asc tor-browser-linux$LINUXVER-"$TORVERSION"_$TORLANG.tar.xz
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
    gpg --delete-secret-and-public-keys --batch --yes B1172656DFF983C3042BC699EB5A896A28988BF5
    gpg --delete-secret-and-public-keys --batch --yes F65CE37F04BA5B360AE6EE17C218525819F78451
    gpg --delete-secret-and-public-keys --batch --yes 2133BC600AB133E1D826D173FE43009C4607B1FB
    gpg --delete-secret-and-public-keys --batch --yes B35BF85BF19489D04E28C33C21194EBB165733EA
    gpg --delete-secret-and-public-keys --batch --yes 8738A680B84B3031A630F2DB416F061063FEE659
    gpg --delete-secret-and-public-keys --batch --yes C2E34CFC13C62BD92C7579B56B8AAEB1F1F5C9B5
    gpg --delete-secret-and-public-keys --batch --yes A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89
    gpg --delete-secret-and-public-keys --batch --yes 68278CC5DD2D1E85C4E45AD90445B7AB9ABBEEC6
    gpg --delete-secret-and-public-keys --batch --yes C963C21D63564E2B10BB335B29846B3C683686CC
    gpg --delete-secret-and-public-keys --batch --yes 261C5FBE77285F88FB0C343266C8C2D7C5AA446D
    gpg --delete-secret-and-public-keys --batch --yes 25FC1614B8F87B52FF2F99B962AF4031C82E0039
    gpg --delete-secret-and-public-keys --batch --yes AD1AB35C674DF572FBCE8B0A6BC758CBC11F6276
    gpg --delete-secret-and-public-keys --batch --yes 8C4CD511095E982EB0EFBFA21E8BF34923291265
    gpg --delete-secret-and-public-keys --batch --yes 35CD74C24A9B15A19E1A81A194373AA94B7C3223
    gpg --delete-secret-and-public-keys --batch --yes 4A90646C0BAED9D456AB3111E5B81856D0220E4B
    gpg --delete-secret-and-public-keys --batch --yes D6A948CF297F753930B4756AFA7F0E44D487F03F
    gpg --delete-secret-and-public-keys --batch --yes EF6E286DDA85EA2A4BA7DE684E2C6E8793298290
    gpg --delete-secret-and-public-keys --batch --yes B74417EDDF22AC9F9E90F49142E86A2A11F48D36
    gpg --delete-secret-and-public-keys --batch --yes E4ACD3975427A5BA8450A1BEB01C8B006DA77FAA
    gpg --delete-secret-and-public-keys --batch --yes A490D0F4D311A4153E2BB7CADBB802B258ACD84F
    rm tor-browser-linux$LINUXVER-"$TORVERSION"_en-US.tar.xz.asc
else
    echo "BAD SIGNATURE"
exit
fi
tar -xvJf tor-browser-linux$LINUXVER-"$TORVERSION"_$TORLANG.tar.xz
rm tor-browser-linux$LINUXVER-"$TORVERSION"_$TORLANG.tar.xz
sudo apt-get install tor-dbg apt-transport-tor onionshare -y

##firejail
FIREVERSION=0.9.50
sudo apt-get install libqtgui4  libqt4-svg libqtcore4 libmng2 libqt4-declarative libqt4-network libqt4-script  libqt4-sql libqt4-xmlpatterns libqtcore4 libqtdbus4 libqtdbus4  qtcore4-l10n libqt4-xml -y
wget https://downloads.sourceforge.net/project/firejail/firejail/firejail-$FIREVERSION.tar.xz
wget https://downloads.sourceforge.net/project/firejail/firejail/firejail-$FIREVERSION.tar.xz.asc
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys A490D0F4D311A4153E2BB7CADBB802B258ACD84F
gpg --verify firejail-$FIREVERSION.tar.xz.asc firejail-$FIREVERSION.tar.xz
if [ $?==FC5849A7 ]
then
    echo "GOOD SIGNATURE"
    rm firejail-$FIREVERSION.tar.xz.asc
else
    echo "BAD SIGNATURE"
    exit
fi
tar -xJvf firejail-$FIREVERSION.tar.xz
rm firejail-$FIREVERSION.tar.xz
cd firejail-$FIREVERSION
./configure && make && sudo make install-strip
cd ..
rm -r firejail-$FIREVERSION
firecfg --fix-sound #The first command solves some shared memory/PID namespace bugs in PulseAudio software prior to version 9. You would need to logout and login back to apply PulseAudio changes. 
pulseaudio --kill
pulseaudio --start
#sudo firecfg #The second command integrates Firejail into your desktop. You can read more about system integration in Linux Mint Sandboxing Guide.
#firetools
FIREVERSION=0.9.50
wget https://downloads.sourceforge.net/project/firejail/firetools/firetools-$FIREVERSION.tar.xz
wget https://downloads.sourceforge.net/project/firejail/firetools/firetools-$FIREVERSION.tar.xz.asc
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys A490D0F4D311A4153E2BB7CADBB802B258ACD84F
gpg --verify firetools-$FIREVERSION.tar.xz.asc firetools-$FIREVERSION.tar.xz
if [ $?==FC5849A7 ]
then
    echo "GOOD SIGNATURE"
    rm firetools-$FIREVERSION.tar.xz.asc
else
    echo "BAD SIGNATURE"
    exit
fi
 
tar -xJvf firetools-$FIREVERSION.tar.xz
rm firetools-$FIREVERSION.tar.xz
cd firetools-0.9.50
./configure && make && sudo make install-strip
cd ..
rm -r firetools-$FIREVERSION

#terminal explorers
sudo apt-get install lynx netrik -y

##blindlector
sudo apt-get install libttspico** -y

### Calc Tools ###
cd Documents
mkdir bctools
cd bctools
wget http://phodd.net/gnu-bc/code/array.bc
wget http://phodd.net/gnu-bc/code/collatz.bc    
wget http://phodd.net/gnu-bc/code/digits.bc    
wget http://phodd.net/gnu-bc/code/funcs.bc   
wget http://phodd.net/gnu-bc/code/interest.bc      
wget http://phodd.net/gnu-bc/code/melancholy.bc      
wget http://phodd.net/gnu-bc/code/primes.bc      
wget http://phodd.net/gnu-bc/code/thermometer.bc      
wget http://phodd.net/gnu-bc/code/cf.bc       
wget http://phodd.net/gnu-bc/code/complex.bc     
wget http://phodd.net/gnu-bc/code/factorial.bc      
wget http://phodd.net/gnu-bc/code/intdiff.bc      
wget http://phodd.net/gnu-bc/code/logic.bc      
wget http://phodd.net/gnu-bc/code/output_formatting.bc      
wget https://raw.githubusercontent.com/sevo/Calc/master/bc/rand.bc
cd ..
cd ..

###WeeChat###
WEECHATVERSION=1.8
sudo apt-get install cmake libncurses5 libcurl3 dh-autoreconf libgcrypt20 libcurl4-openssl-dev -y
gpg --keyserver ha.pool.sks-keyservers.net --recv-keys A9AB5AB778FA5C3522FD0378F82F4B16DEC408F8
wget https://weechat.org/files/src/weechat-$WEECHATVERSION.tar.xz
wget https://weechat.org/files/src/weechat-$WEECHATVERSION.tar.xz.asc
gpg --verify weechat-$WEECHATVERSION.tar.xz.asc weechat-$WEECHATVERSION.tar.xz
if [ $? -eq 0 ]
then
echo "GOOD SIGNATURE"
gpg --delete-secret-and-public-keys --batch --yes A9AB5AB778FA5C3522FD0378F82F4B16DEC408F8
else
echo "BAD SIGNATURE"
exit
fi
rm weechat-$WEECHATVERSION.tar.xz.asc
wget https://weechat.org/download/checksums/weechat-$WEECHATVERSION-sha512.txt
sha512sum -c weechat-$WEECHATVERSION-sha512.txt 2>&1 | grep 'OK\|coincide'
if [ $? -eq 0 ]
then
echo "GOOD SHA 512"
else
echo "BAD SHA 512"
exit
fi
rm weechat-$WEECHATVERSION-sha512.txt
tar xf weechat-$WEECHATVERSION.tar.xz
rm weechat-$WEECHATVERSION.tar.xz
cd weechat-$WEECHATVERSION
bash autogen.sh
mkdir build
cd build
cmake ..
make
sudo make install
cd ..
sudo rm -r weechat-$WEECHATVERSION

#Conf file
rm ~/.weechat/weechat.conf
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/weechat.conf -O ~/.weechat/weechat.conf
#weechat -r "/script install vimode.py" script not installed to avoid conflicts
weechat -r "/key bind meta-g /go"  -r "/quit -yes"
weechat -r "/set weechat.bar.status.color_bg 0" "/set weechat.bar.title.color_bg 0" "/set weechat.color.chat_nick_colors 1,2,3,4,5,6" "/set buffers.color.hotlist_message_fg 7" "/set weechat.bar.buffers.position top" "/set weechat.bar.buffers.items buffers" "/set weechat.look.prefix_same_nick '⤷'" "/set weechat.look.prefix_error '⚠'" "/set weechat.look.prefix_network 'ℹ'" "/set weechat.look.prefix_action '⚡'" "/set weechat.look.bar_more_down '▼▼'" "/set weechat.look.bar_more_left '◀◀'" "/set weechat.look.bar_more_right '▶▶'" "/set weechat.look.bar_more_up '▲▲'" "/set weechat.look.prefix_suffix '╡'" "/set weechat.look.prefix_align_max '15'"  -r "/quit -yes"
weechat -r "/mouse enable" -r "/quit -yes"
read -p "Introduce Weechat username: " UNAME
weechat -r '/set irc.server.freenode.username "$UNAME"  -r "/quit -yes"'
weechat -r "/server add freenode chat.freenode.net/6697 -ssl -autoconnect" -r '/set irc.server.freenode.addresses "chat.freenode.net/6697"' -r "/set irc.server.freenode.ssl on" -r "/quit -yes"


#Whatsapp and axolotl
sudo pip install wheel --upgrade
sudo pip3 install wheel --upgrade
sudo -H pip install python-dateutil protobuf pycrypto python-axolotl-curve25519 argparse readline pillow pyaxo
sudo -H pip3 install python-dateutil protobuf pycrypto python-axolotl-curve25519 argparse readline pillow pyaxo
sudo -H pip install yowsup2
sudo -H pip3 install yowsup2
weechat -r "/script install whatsapp.py axolotl.py" -r "/quit"
#Plugins
sudo -H pip install python-potr
sudo -H pip3 install python-potr
weechat -r "/script install arespond.py atcomplete.py auth.rb auto_away.py autoauth.py autoconf.py autoconnet.py autojoin.py autjoinem.py awaylog.pl bandwidth.py bufsave.py bufsize.py chanmon.pl colorize_nicks.py  completion.py correction_completion.py fish.py go.py gribble.py highmon.pl ircrypt.py iset.pl notifo.py  otr.py queryman.py seeks.pl responsive_layout.py screen_away.py urlbuf.py urlgrab.py urlhinter.py weefish.rb yaaa.pl yaurls.pl weerock.pl whatismyip.py whowas_timeago.py whoissource.py whois_on_query.py windicate.py"  -r "/quit"
#Slack
sudo -H pip install websocket-client
sudo -H pip3 install websocket-client
wget https://raw.githubusercontent.com/wee-slack/wee-slack/master/wee_slack.py
cp wee_slack.py ~/.weechat/python/autoload
read -p "Introduce a secure pass to protect tokens: " PAZWE
weechat -r "/secure passphrase $PAZWE" -r "/quit"
read -p "Introduce your Slack token. For connected groups introduce tokens separated by commas: " SLACKTOKEN
weechat -r "/set plugins.var.python.slack.slack_api_token $SLACKTOKEN" -r "/secure set slack_token $SLACKTOKEN" -r "/set plugins.var.python.slack.slack_api_token ${sec.data.slack_token}" -r "/save" -r "/python reload" -r "/set plugins.var.python.slack.server_aliases 'my-slack-subdomain:mysub,other-domain:coolbeans'" -r "/set plugins.var.python.slack.show_reaction_nicks on" -r "/quit"
#As a relay host server
#read -p "Introduce password for relay host: " PRHOST
#mkdir -p ~/.weechat/ssl && cd ~/.weechat/ssl && openssl req -nodes -newkey rsa:4096 -keyout relay.pem -x509 -days 365 -out relay.pem -sha256 -subj "/CN=localhost/" && cd
#weechat -r "/relay add weechat 9001" -r "/set relay.network.password $PRHOST" -r "/relay sslcertkey" -r "/relay add ssl.weechat 9001"  -r "/quit"
#echo "You need to verify the certificate at ~/.weechat/ssl first"
#firefox --new-tab https://www.glowing-bear.org/

##Last vulnerability assessment https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Security_Guide/sec-Vulnerability_Assessment.html
sudo apt-get autoremove -y
sudo vi -c "s/if $ssh -G 2>&1 | grep -e illegal -e unknow >/if $ssh -G 2>&1 | grep -e illegal -e unknown -e Gg >/g" -c "wq" /usr/sbin/chkrootkit
sudo /usr/sbin/./chkrootkit -x
sudo /usr/sbin/./chkrootkit
sudo apt-get install rkhunter -y
echo "PKGMGR=DPKG" | sudo tee -a /etc/rkhunter.conf.local
sudo rkhunter --propupd
sudo rkhunter --update
rkhunter --check --rwo --vl -x

echo "EOF" 
