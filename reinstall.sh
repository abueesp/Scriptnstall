#!/bin/bash
# My first script to reinstall
#TCP flood mitigation
echo 'net.ipv4.tcp_challenge_ack_limit = 999999999' | sudo tee -a /etc/sysctl.conf
#Prntscreensound
sudo mv /usr/share/sounds/freedesktop/stereo/camera-shutter.oga /usr/share/sounds/freedesktop/stereo/camera-shutter-disabled.oga
#Bluetooth
sudo vi /etc/bluetooth/main.conf -c ':%s/\<InitiallyPowered = true\>/<InitiallyPowered = false\>/gIc' -c ':wq'
rfkill block bluetooth
#Sudo on Files Eos
echo "[Contractor Entry]\nName=Open folder as root\nIcon=gksu-root-terminal\nDescription=Open folder as root\nMimeType=inode;application/x-sh;application/x-executable;\nExec=gksudo pantheon-files -d %U\nGettext-Domain=pantheon-files" >> Open_as_admin.contract
sudo mv Open_as_admin.contract /usr/share/contractor/Open_as_admin
rm Open_as_admin.contract

#mirror
sudo apt-get install apt-transport-https apt-transport-tor -y
sudo sed -i 's/http:\/\/us.archive.ubuntu.com\/ubuntu/http:\/\/mirrors.mit.edu\/ubuntu/g' /etc/apt/sources.list
#sudo sed -i 's/http:\/\/us.archive.ubuntu.com\/ubuntu/https:\/\/mirror.cpsc.ucalgary.ca\/mirror\/ubuntu.com\/packages\//g' /etc/apt/sources.list
mv .bashrc .previous-bashrc
sudo wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/.bashrc
sudo apt-get update
sudo apt-get install apt-file
sudo apt-file update

#SSH
sudo apt-get purge ssh -y
SSHVERSION=7.5p1
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys CE8ECB0386FF9C48
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys A2B989F511B5748F
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys A819A2D8691EF8DA
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D3E5F56B6D920D30
wget https://mirrors.ucr.ac.cr/pub/OpenBSD/OpenSSH/portable/openssh-$SSHVERSION.tar.gz
wget https://mirrors.ucr.ac.cr/pub/OpenBSD/OpenSSH/portable/openssh-$SSHVERSION.tar.gz.asc
gpg2 --verify openssh-$SSHVERSION.tar.gz.asc openssh-$SSHVERSION.tar.gz
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
    gpg2 --delete-secret-and-public-keys --batch --yes CE8ECB0386FF9C48
    gpg2 --delete-secret-and-public-keys --batch --yes A2B989F511B5748F
    gpg2 --delete-secret-and-public-keys --batch --yes A819A2D8691EF8DA
    gpg2 --delete-secret-and-public-keys --batch --yes D3E5F56B6D920D30
else
    echo "BAD SIGNATURE"
    break
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
numberssh = 0
if [$1]
    then
    while [ ! -f lastid_rsa$numberssh ] ;
        do
             numberssh++
        done
    while [ ! -f lastid_rsa$numberssh ] ;
        do
             numberssh1 = $numberssh+1
             sudo mv ~/.ssh/$1 ~/.ssh/lastid_rsa$numberssh ~/.ssh/lastid_rsa$numberssh1
             sudo mv ~/.ssh/$1 ~/.ssh/lastid_rsa$numberssh.pub ~/.ssh/lastid_rsa$numberssh1.pub
             numberssh--
        done 
    echo "-------------> Your last key is now lastid_rsa (priv) and lastid_rsa0.pub (pub). If you want to create a new one type mysshkey. If you want to copy the last one type mylastsshkey"
    sudo mv ~/.ssh/$1 ~/.ssh/id_rsa ~/.ssh/lastid_rsa0
    sudo mv ~/.ssh/$1 ~/.ssh/id_rsa.pub ~/.ssh/lastid_rsa0.pub
    else
    echo "-------------> Those are your current keys: "
    ls -al -R ~/.ssh
fi
$emai = emai
sudo mkdir ~/.ssh
echo "-------------> Those are your keys up to now"
sudo ls -al -R ~/.ssh # Lists the files in your .ssh directory, if they exist
echo "Please, introduce 'youremail@server.com'"
read emai
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
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 64EA74AB
gpg2 --output bash-$BASHVERSION.tar.gz --decrypt bash-$BASHVERSION.tar.gz.sig
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
    gpg2 --delete-secret-and-public-keys --batch --yes 64EA74AB
else
    echo "BAD SIGNATURE"
    break
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
KERNELVERSION=4.11.2
wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$KERNELVERSION.tar.xz
wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-$KERNELVERSION.tar.sign  
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 647F28654894E3BD457199BE38DBBDC86092693E #Greg
gpg2 --keyserver hkp://keys.gnupg.net --recv-keys ABAF11C65A2970B130ABE3C479BE3E4300411886 #Torvalds
xz -cd linux-*.tar.xz | gpg2 --verify linux-*.tar.sign -
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
    gpg2 --delete-secret-and-public-keys --batch --yes 647F28654894E3BD457199BE38DBBDC86092693E
    gpg2 --delete-secret-and-public-keys --batch --yes ABAF11C65A2970B130ABE3C479BE3E4300411886
else
    echo "BAD SIGNATURE"
    break
fi
tar -xJf linux-$KERNELVERSION.tar.xz
cd linux-$KERNELVERSION
make menuconfig
make && make modules_install
sudo make install
sudo update-grub
cd ..
sudo rm -r linux-KERNELVERSION

#Minus
sudo apt-get purge imagemagick fontforge geary whoopsie -y

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
    break
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
    break
fi
tar xvf fwsnort-$FWSNORTVERSION.tar.gz
cd fwsnort-$FWSNORTVERSION
./configure
sudo make
sudo make install
cd
rm fwsnort-$FWSNORTVERSION.tar.gz && rm fwsnort-$FWSNORTVERSION.tar.gz.asc && sudo rm -r fwsnort-$FWSNORTVERSION

#Some tools
sudo apt-get install tmux terminator -y

sudo rm ~/tmux.conf~
cp ~/tmux.conf ~/tmux.conf~
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/tmux.conf -O ~/tmux.conf
tmux source-file ~/tmux.conf

sudo apt-get install sysv-rc-conf -y
sudo apt-get install chkrootkit -y
sudo apt-get install secure-delete -y
sudo apt-get install traceroute -y
sudo apt-get install iotop -y 
sudo apt-get install unoconv -y
sudo apt-get install detox -y
sudo apt-get install autojump -y
sudo apt-get install nmap arp-scan -y
sudo apt-get install tmux -y
sudo apt-get install htop -y
sudo apt-get install pandoc -y
sudo apt-get install vnstat -y
sudo apt-get install duplicity deja-dup -y
sudo apt-get install brasero -y
sudo apt-get install at -y

#youtube-dl
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/bin/youtube-dl
sudo chmod a+rx /usr/bin/youtube-dl

##GNUPG
sudo apt-get install libgtk2.0-dev -y
mkdir gpg2
cd gpg2
GNUPGVERSION=2.1.16
wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPGVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPGVERSION.tar.bz2.sig
gpg2 --recv-key D8692123C4065DEA5E0F3AB5249B39D24F25E3B6
gpg2 --recv-key 46CC730865BB5C78EBABADCF04376F3EE0856959
gpg2 --recv-key 031EC2536E580D8EA286A9F22071B08A33BD3F06
gpg2 --recv-key D238EA65D64C67ED4C3073F28A861B1C7EFD60D9
gpg2 --verify gnupg-$GNUPGVERSION.tar.bz2.sig gnupg-$GNUPGVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
sudo pkill -9 gpg-agent #kill gpg-agent service
sudo apt-get purge gnupg gnupg2 -y #remove previous gnupg
if [ -f "/etc/init.d/gpg-agent" ] then sudo rm /etc/init.d/gpg-agent #remove previous gpg-agent from boot
sudo sh -c "echo 'gpg-agent --daemon --verbose --sh --enable-ssh-support --no-allow-external-cache --no-allow-loopback-pinentry --allow-emacs-pinentry --log-file \"~/.gpg-agent-info\"' >> /etc/init.d/gpg-agent" #add gpg-agent with steroids
tar xvjf gnupg-$GNUPGVERSION.tar.bz2
cd gnupg-$GNUPGVERSION
./configure
make
sudo make install
sudo cp /usr/bin/pinentry /usr/local/bin/pinentry #a new copy of pinentry (to introduce passwords) to local
cd ..
rm gnupg-$GNUPGVERSION.bz2 && rm gnupg-$GNUPGVERSION.sig && sudo rm -r gnupg-$GNUPGVERSION
gpg-agent --daemon --verbose --sh --enable-ssh-support --pinentry-program pinentry-tty --no-allow-external-cache --no-allow-loopback-pinentry --allow-emacs-pinentry --log-file \"~/.gpg-agent-info\"

LIBGPGVERSION=1.27
wget https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-$LIBGPGVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-$LIBGPGVERSION.tar.bz2.sig
gpg2 --verify libgpg-error-$LIBGPGVERSION.tar.bz2.sig libgpg-error-$LIBGPGVERSION.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf libgpg-error-$LIBGPGVERSION.tar.bz2
cd libgpg-error-$LIBGPGVERSION
./configure
make
sudo make install
cd ..
sudo rm libgpg-error-$LIBGPGVERSION.bz2 && sudo rm libgpg-error-$LIBGPGVERSION.sig && sudo rm -r libgpg-error-$LIBGPGVERSION

LIBGCRYPTVERSION=1.7.6
wget https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-$LIBGCRYPTVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-$LIBGCRYPTVERSION.tar.bz2.sig
gpg2 --verify libgcrypt-$LIBGCRYPTVERSION.tar.bz2.sig libgcrypt-$LIBGCRYPTVERSION.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf libgcrypt-$LIBGCRYPTVERSION.tar.bz2
cd libgcrypt-$LIBGCRYPTVERSION
./configure
make
sudo make install
cd ..
rm libgcrypt-$LIBGCRYPTVERSION.bz2 && rm libgcrypt-$LIBGCRYPTVERSION.sig && sudo rm -r libgcrypt-$LIBGCRYPTVERSION

LIBKSBAVERSION=1.3.5
wget https://www.gnupg.org/ftp/gcrypt/libksba/libksba-$LIBKSBAVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/libksba/libksba-$LIBKSBAVERSION.tar.bz2.sig
gpg2 --verify libksba-$LIBKSBAVERSION.tar.bz2.sig libksba-$LIBKSBAVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf libksba-$LIBKSBAVERSION.tar.bz2
cd libksba-$LIBKSBAVERSION
./configure
make
sudo make install
cd ..
rm libksba-$LIBKSBAVERSION.tar.bz2 && rm libksba-$LIBKSBAVERSION.tar.bz2.sig && sudo rm -r libksba-$LIBKSBAVERSION

LIBASSUANVERSION=2.4.3
wget https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-$LIBASSUANVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-$LIBASSUANVERSION.tar.bz2.sig
gpg2 --verify libassuan-$LIBASSUANVERSION.tar.bz2.sig libassuan-$LIBASSUANVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf libassuan-$LIBASSUANVERSION.tar.bz2
cd libassuan-$LIBASSUANVERSION
./configure
make
sudo make install
cd ..
rm libassuan-$LIBASSUANVERSION.tar.bz2 && rm libassuan-$LIBASSUANVERSION.tar.bz2.sig && sudo rm -r libassuan-$LIBASSUANVERSION

NPTHVERSION=1.4
wget https://www.gnupg.org/ftp/gcrypt/npth/npth-$NPTHVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/npth/npth-$NPTHVERSION.tar.bz2.sig
gpg2 --verify npth-$NPTHVERSION.tar.bz2.sig npth-$NPTHVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf npth-$NPTHVERSION.tar.bz2
cd npth-$NPTHVERSION
./configure
make
sudo make install
cd ..
rm npth-$NPTHVERSION.tar.bz2 && rm npth-$NPTHVERSION.tar.bz2.sig && sudo rm -r npth-$NPTHVERSION

GNUPGVERSION=2.1.21
wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPGVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPGVERSION.tar.bz2.sig
gpg2 --verify gnupg-$GNUPGVERSION.tar.bz2.sig gnupg-$GNUPGVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf gnupg-$GNUPGVERSION.tar.bz2
cd gnupg-$GNUPGVERSION
./configure
make
sudo make install
cd ..
rm gnupg-$GNUPGVERSION.tar.bz2 && rm gnupg-$GNUPGVERSION.tar.bz2.sig && sudo rm -r gnupg-$GNUPGVERSION

GPGMEVERSION=1.9.0
wget https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-$GPGMEVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-$GPGMEVERSION.tar.bz2.sig
gpg2 --verify gpgme-$GPGMEVERSION.tar.bz2.sig gpgme-$GPGMEVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf gpgme-$GPGMEVERSION.tar.bz2
cd gpgme-$GPGMEVERSION
./configure
make
sudo make install
cd ..
rm gpgme-$GPGMEVERSION.tar.bz2 && rm gpgme-$GPGMEVERSION.tar.bz2.sig && sudo rm -r gpgme-$GPGMEVERSION

GPAVERSION=0.9.10
sudo wget https://www.gnupg.org/ftp/gcrypt/gpa/gpa-$GPAVERSION.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/gpa/gpa-$GPAVERSION.tar.bz2.sig
gpg2 --verify gpa-$GPAVERSION.tar.bz2.sig gpa-$GPAVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf gpa-$GPAVERSION.tar.bz2
cd gpa-$GPAVERSION
./configure
sudo make
sudo make install
cd ..
rm gpa-$GPAVERSION.tar.bz2 && rm gpa-$GPAVERSION.tar.bz2.sig && sudo rm -r gpa-$GPAVERSION

cd ..
sudo rm -r gpg2
gpg2 --delete-secret-and-public-keys --batch --yes D8692123C4065DEA5E0F3AB5249B39D24F25E3B6
gpg2 --delete-secret-and-public-keys --batch --yes 46CC730865BB5C78EBABADCF04376F3EE0856959
gpg2 --delete-secret-and-public-keys --batch --yes 031EC2536E580D8EA286A9F22071B08A33BD3F06
gpg2 --delete-secret-and-public-keys --batch --yes D238EA65D64C67ED4C3073F28A861B1C7EFD60D9
gpg2 --version
gpgconf --list-components

#keybase
sudo apt-get install libappindicator1 -y
curl -O https://prerelease.keybase.io/keybase_amd64.deb
sudo dpkg -i keybase_amd64.deb
gpg2 --list-secret-keys
run_keybase; keybase pgp gen --multi; rm keybase_amd64.deb

##Fail2ban & logcheck
sudo apt-get install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
echo "Please write down an email to send you notifications when someone is attacking your ports: "
read email
echo "You entered: $email"

sudo vi /etc/fail2ban/jail.local ':%s/\<destemail = your_email@domain.com\>/<destemail = $email\>/gIc' ':wq'
cat /etc/fail2ban/jail.local | grep destemail
sudo vi /etc/fail2ban/jail.local ':%s/\<action = %(action_)s\>/<action = %(action_mw)s\>/gIc' ':wq'
sudo vi /etc/fail2ban/jail.local ':%s/\<enabled  = false\>/<enabled  = true\>/gIc' ':wq'
sudo apt-get install zenmap logcheck logcheck-database -y
logcheck -p -u -m -h $email

sudo apt-get dist-upgrade -y
sudo apt-get upgrade -y 

##Virtualbox
sudo apt-get purge virtualbox -y
sudo apt-get build-dep virtualbox
sudo apt-get -f install -y
while true; do
    read -p "Please introduce introduce OS Ubuntu 16.10 ('yaketty_amd64') Ubuntu 16.04 ('xenial_amd64') Ubuntu 15.10 ('wily_i386') or Ubuntu 14.04 ('trusty_amd64') / 14.10 Utopic/ 15.04 Vivid: " OS $OS
    wget http://download.virtualbox.org/virtualbox/5.1.18/virtualbox-5.1_5.1.18-114002~Ubuntu~$OS.deb
    break
done
sudo dpkg -i virtualbox**.deb
sudo rm virtualbox**.deb
sudo apt-get install vagrant -y
vagrant box add precise64 http://files.vagrantup.com/precise64.box
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
sudo rm VBoxGuestAdditions**
wget http://download.virtualbox.org/virtualbox/5.1.0_RC1/VBoxGuestAdditions_5.1.0_RC1.iso
sudo mv VBoxGuestAdditions**.iso /usr/share/Virtualbox/VBoxGuestAdditions.iso
echo "To insert iso additions, install first yout vm"
virtualbox
vboxmanage storageattach work --storagectl IDE --port 0 --device 0 --type dvddrive --medium "/home/$USER/VBox**.iso"
read -p "Introduce un usuario de vbox " user1 $user1
sudo usermod -G vboxusers -a $user1
read -p "Introduce otro usuario de vbox " user2 $user2
sudo usermod -G vboxusers -a $user2
read -p "Introduce otro usuario de vbox " user2 $user3
sudo usermod -G vboxusers -a $user3

##Emacs
sudo rm -r /usr/local/stow
set -e
readonly version="25.1"

# install dependencies
sudo apt-get install stow build-essential libx11-dev xaw3dg-dev libjpeg-dev libpng12-dev libgif-dev libtiff5-dev libncurses5-dev libxft-dev librsvg2-dev libmagickcore-dev libmagick++-dev libxml2-dev libgpm-dev libotf-dev libm17n-dev  libgnutls-dev -y

# download source package
wget http://ftp.gnu.org/gnu/emacs/emacs-"$version".tar.xz
tar xvf emacs-"$version".tar.xz

# build and install
sudo mkdir -p /usr/local/stow
cd emacs-"$version"
./configure \
    --with-xft \
    --with-x-toolkit=lucid
make
sudo rm -r /usr/local/stow
sudo make install prefix=/usr/local/stow/emacs-"$version" && cd /usr/local/stow
sudo rm /usr/local/share/info/dir
sudo stow emacs-"$version" 
#spacemacs
sudo apt-get install git -y
git clone http://github.com/syl20bnr/spacemacs ~/.emacs.d
##plugins
cd ~/.emacs.d
wget http://github.com/ethereum/emacs-solidity/blob/master/solidity-mode.el ##solidity
echo 'Carga los elementos de emacs con (add-to-list load-path "~/.emacs.d/") + (load "myplugin.el")'
cd
sudo rm emacs-"$version".tar.xz
sudo rm -r emacs-**

##Utils
sudo apt-get install gparted -y
sudo apt-get install baobab -y
sudo apt-get install nemo -y
sudo apt-get install thunderbird -y
thunderbird https://addons.mozilla.org/thunderbird/downloads/latest/775/addon-775-latest.xpi
sudo apt-get install gtk-recordmydesktop recordmydesktop -y
sudo apt-get install firefox -y
firefox -P https://addons.mozilla.org/firefox/downloads/file/271802/no_more_install_delay-3.0-fx+sm+fn+tb.xpi

#Python essentials
sudo apt-get install build-essential python-dev python-setuptools python-virtualenv libxml2-dev libxslt1-dev zlib1g-dev -y
sudo apt-get install python3-pip python-pip -y
pip install --upgrade pip
pip3 install --upgrade pip

#Saltpack
sudo apt-get install libffi-dev python-cffi -y
sudo -H pip3 install saltpack

#Text Edition Tools
sudo apt-get install software-properties-common -y ##for add-apt-repository
sudo add-apt-repository ppa:webupd8team/sublime-text-3 -y 
sudo apt-get install vim vim-scripts -y
git clone https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
mv ~/.vim/autoload/plug.vim ~/.vim/autoload/plug-backup.vim
wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O ~/.vim/autoload/plug.vim
sudo apt-get install gedit -y
sudo apt-get install sublime-text-installer -y
sudo apt-get install libreoffice -y
sudo apt-get install libgstreamer-plugins-base0.10-0 -y#for scrivener requirements libgstapp-0.10.so.0
wget http://www.literatureandlatte.com/scrivenerforlinux/scrivener-1.9.0.1-amd64.deb
sudo dpkg -i scrivener**
sudo rm scrivener**


##Github
sudo apt-get install git -y 
git config --global credential.helper cache
# Set git to use the credential memory cache
git config --global credential.helper 'cache --timeout=3600'
# Set the cache to timeout after 1 hour (setting is in seconds)
while true; do
    read -p "Please set your username: " username
    git config --global user.name $username
    break
done
while true; do
    read -p "Please set your email: " mail
    git config --global user.email $mail
    break
done

while true; do
    read -p "Please set your core editor: " editor
    git config --global core.editor $editor
    break
done
while true; do
    read -p "Please set your diff app: " diff
    git config --global merge.tool $diff
    break
done
while true; do
    gpg2 --list-secret-keys
    read -p "Introduce the key Username (and open https://github.com/settings/keys): " keyusername
    gpg2 --export -a $keyusername > githubpublic.key
    git config --global user.signingkey $(cat githubpublic.key)
    git config --global commit.gpgsign true
    break
done
rm githubpublic.key
git config --list
echo "Here you are an excellent Github cheatsheet https://raw.githubusercontent.com/hbons/git-cheat-sheet/master/preview.png You can also access as gitsheet"
echo "If you get stuck, run ‘git branch -a’ and it will show you exactly what’s going on with your branches. You can see which are remotes and which are local."
echo "Do not forget to add a newsshkey or clipboard your mysshkey or mylastsshkey (if you switchsshkey before) and paste it on Settings -> New SSH key and paste it there." 

sh -c "curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh"
echo "installed vimcr"
wget https://raw.githubusercontent.com/Russell91/sshrc/master/sshrc && sudo chmod -R 600 sshrc && chmod +x sshrc && sudo mv sshrc /usr/local/bin
echo "ssh bashcr vimcr portability installed"

##Browsers
sudo apt-get install firefox -y
cd Downloads
mkdir extensions
cd extensions

wget https://raw.githubusercontent.com/abueesp/Firefox-Security-Toolkit/master/firefox_security_toolkit.sh ## Cookie Manager # Copy as Plain Text # Crypto Fox # CSRF-Finder # Disable WebRTC # FireBug # Fireforce # FlagFox # Foxy Proxy # HackBar # Live HTTP Headers # Multi Fox # PassiveRecon # Right-Click XSS # Tamper Data # User Agent Switcher # Wappalyzer # Web Developer
#chmod 777 firefox_security_toolkit.sh
#bash firefox_security_toolkit.sh run
#rm firefox_security_toolkit.sh
wget https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/addon-534930-latest.xpi #Avoid HTML5 Canvas
#wget https://addons.mozilla.org/firefox/downloads/file/229626/sql_inject_me-0.4.7-fx.xpi #SQL Inject Me
wget https://addons.mozilla.org/firefox/downloads/latest/521554/addon-521554-latest.xpi #DecentralEyes
wget https://addons.mozilla.org/firefox/downloads/latest/607454/addon-607454-latest.xpi #UBlockOrigin
wget https://addons.mozilla.org/firefox/downloads/latest/383235/addon-383235-latest.xpi #FlashDisable
wget https://addons.mozilla.org/firefox/downloads/file/281702/google_privacy-0.2.4-sm+fx.xpi #GooglePriv
wget https://addons.mozilla.org/firefox/downloads/latest/415846/addon-415846-latest.xpi #SelfDestructing Cookies
wget https://addons.mozilla.org/firefox/downloads/latest/387051/addon-387051-latest.xpi #RemoveGoogleTracking
wget https://addons.mozilla.org/firefox/downloads/latest/722/addon-722-latest.xpi #NoScript
wget https://addons.mozilla.org/firefox/downloads/latest/1865/addon-1865-latest.xpi  #AdBlock Plus
wget https://addons.mozilla.org/firefox/downloads/latest/496120/addon-496120-latest.xpi #LocationGuard
wget https://addons.mozilla.org/firefox/downloads/latest/473878/addon-473878-latest.xpi #RandomAgentSpoofer
wget https://addons.mozilla.org/firefox/downloads/latest/229918/addon-229918-latest.xpi #HTTPS Everywhere
wget https://addons.mozilla.org/en-US/firefox/downloads/latest/2109/addon-2109-latest.xpi #FEBE Backups
#wget https://addons.mozilla.org/firefox/downloads/latest/363974/addon-363974-latest.xpi #Lightbeam
wget https://addons.mozilla.org/firefox/downloads/latest/409964/addon-409964-latest.xpi #VideoDownloadHelper
wget https://addons.mozilla.org/firefox/downloads/latest/export-to-csv/addon-364467-latest.xpi #Export Table to CSV
wget https://addons.mozilla.org/firefox/downloads/latest/tabletools2/addon-296783-latest.xpi #TableTools2
wget https://addons.mozilla.org/firefox/downloads/latest/261959/addon-261959-latest.xpi #Bloody Vikings Disposable Email
wget https://addons.mozilla.org/firefox/downloads/latest/748/addon-748-latest.xpi #Greasemonkey
wget https://addons.mozilla.org/firefox/downloads/latest/7447/addon-7447-latest.xpi #NetVideoHunter
wget https://addons.mozilla.org/firefox/downloads/latest/1237/addon-1237-latest.xpi #QuickJava
wget https://addons.mozilla.org/firefox/downloads/latest/3497/addon-3497-latest.xpi #EnglishUSDict
wget https://addons.mozilla.org/firefox/downloads/file/502726/colorfultabs-31.0.8-fx+sm.xpi #ColorfulTabs
wget https://addons.mozilla.org/firefox/downloads/latest/193270/addon-193270-latest.xpi #PrintEdit
wget https://addons.mozilla.org/firefox/downloads/latest/5791/addon-5791-latest.xpi #Flagfox
wget https://addons.mozilla.org/firefox/downloads/latest/dummy-form-filler/addon-502178-latest.xpi #AutoFill DummyForms
wget https://addons.mozilla.org/firefox/downloads/file/342774/tineye_reverse_image_search-1.2.1-fx.xpi #TinyEye Reverse ImageSearch
wget https://addons.mozilla.org/firefox/downloads/latest/355192/addon-355192-latest.xpi #MindTheTime
wget https://addons.mozilla.org/firefox/downloads/latest/1843/addon-1843-latest.xpi #Firebug
wget https://addons.mozilla.org/firefox/downloads/latest/161670/addon-161670-latest.xpi #FlashFirebug
wget https://addons.mozilla.org/firefox/downloads/latest/tab-groups-panorama/addon-671381-latest.xpi #Tabgroups
wget https://addons.mozilla.org/firefox/downloads/latest/532/addon-532-latest.xpi #LinkChecker
wget https://addons.mozilla.org/firefox/downloads/latest/5523/addon-5523-latest.xpi #gui:config extraoptions
wget https://addons.mozilla.org/firefox/downloads/file/413865/mutetab-0.0.2-fx.xpi #mutetab
wget https://addons.mozilla.org/firefox/downloads/latest/10586/addon-10586-latest.xpi #URL Shortener
wget https://addons.mozilla.org/firefox/downloads/file/387220/text_to_voice-1.15-fx.xpi #TextToVoice
wget https://addons.mozilla.org/firefox/downloads/latest/8661/addon-8661-latest.xpi #WorldIP
wget https://addons.mozilla.org/firefox/downloads/latest/3829/addon-3829-latest.xpi #liveHTTPHeaders
wget https://addons.mozilla.org/firefox/downloads/file/373868/soundcloud_downloader_soundgrab-0.98-fx.xpi #Soundcloud
wget https://addons.mozilla.org/firefox/downloads/latest/387429/addon-387429-latest.xpi #Reddit Enhacenment Suit
wget https://addons.mozilla.org/firefox/downloads/latest/695840/addon-695840-latest.xpi #FlashDebugger
wget https://addons.mozilla.org/firefox/downloads/latest/video-downloadhelper/addon-3006-latest.xpi #VideoDownloadHelper
wget https://addons.mozilla.org/firefox/downloads/latest/390151/addon-390151-latest.xpi #TOS
wget https://addons.mozilla.org/firefox/downloads/latest/3456/addon-3456-latest.xpi #WOT
wget https://addons.mozilla.org/firefox/downloads/latest/certificate-patrol/addon-6415-latest.xpi #certificate patrol
#wget https://addons.mozilla.org/firefox/downloads/latest/perspectives/addon-7974-latest.xpi #perspectivenetworknotaries

#thunderbird extensions
mkdir thunderbird
cd thunderbird
wget https://addons.mozilla.org/thunderbird/downloads/latest/611/addon-611-latest.xpi #Signature Switch
wget https://addons.mozilla.org/thunderbird/downloads/latest/1339/addon-1339-latest.xpi #Expression Search Gmail
wget https://addons.mozilla.org/thunderbird/downloads/latest/556/addon-556-latest.xpi #attachmentextractor
wget https://addons.mozilla.org/thunderbird/downloads/latest/4003/addon-4003-latest.xpi #autozipattachments
wget https://addons.mozilla.org/thunderbird/downloads/latest/1556/addon-1556-latest.xpi #allowhtmltemp
wget https://addons.mozilla.org/thunderbird/downloads/latest/550/addon-550-latest.xpi #mailredirect
wget https://addons.mozilla.org/thunderbird/downloads/latest/2313/platform:2/addon-2313-latest.xpi #sm+tb linux
wget https://addons.mozilla.org/thunderbird/downloads/latest/4631/addon-4631-latest.xpi #provider for google calendar
wget https://addons.mozilla.org/thunderbird/downloads/latest/2199/addon-2199-latest.xpi #withattach
wget https://addons.mozilla.org/thunderbird/downloads/latest/550/addon-550-latest.xpi #mailredirect
wget https://addons.mozilla.org/thunderbird/downloads/latest/71/addon-71-latest.xpi #enigmail
wget https://addons.mozilla.org/thunderbird/downloads/latest/210/addon-210-latest.xpi #viewheaders
wget https://addons.mozilla.org/thunderbird/downloads/latest/875/addon-875-latest.xpi #tb header tools
wget https://addons.mozilla.org/thunderbird/downloads/latest/1003/addon-1003-latest.xpi #header scroll extension
wget https://addons.mozilla.org/thunderbird/downloads/latest/torbirdy/platform:2/addon-381417-latest.xpi #torbirdy
cd ..

##Opera
sudo apt-get install libpangox-1.0-0  libpango1.0-0 -y
wget https://ftp.opera.com/pub/opera-developer/46.0.2602.0/linux/opera-developer_46.0.2602.0_amd64.deb
sudo dpkg -i opera**.deb
sudo rm opera**.deb

##Superbeam
mkdir superbeam && cd superbeam
wget http://superbe.am/download/5173
mv 5173 superbeam-linux.tar.gz
tar xvf superbeam-linux.tar.gz
cd ..
sudo mv superbeam /bin/superbeam
sudo chmod +x /bin/superbeam/start-superbeam.sh
echo "[Desktop Entry]" >> ~/Desktop/superbeam.desktop
echo "Encoding=UTF-8" | tee -a ~/Desktop/superbeam.desktop
echo "Name=Mobile Door" | tee -a ~/Desktop/superbeam.desktop
echo "Comment=STEMBEAMpedazodeprogramaparapasararchivosalmovil" | tee -a ~/Desktop/superbeam.desktop
echo "Exec=gnome-terminal -e sh '/bin/superbeam/start-superbeam.sh'" | tee -a ~/Desktop/superbeam.desktop
echo "Icon=/bin/superbeam/icon.png" | tee -a ~/Desktop/superbeam.desktop
echo "Type=Application" | tee -a ~/Desktop/superbeam.desktop

##firejail & firetools
sudo apt-get install libqtgui4  libqt4-svg libqtcore4 libmng2 libqt4-declarative libqt4-network libqt4-script  libqt4-sql libqt4-xmlpatterns libqtcore4 libqtdbus4 libqtdbus4  qtcore4-l10n libqt4-xml -y
wget https://downloads.sourceforge.net/project/firejail/firejail/firejail_0.9.44_1_amd64.deb
wget https://downloads.sourceforge.net/project/firejail/firetools/firetools_0.9.44_1_amd64.deb
sudo dpkg -i firejail**
rm firejail**
sudo dpkg -i firetools**
rm firetools**

##blindlector
sudo apt-get install libttspico** -y

#ironchrome
wget http://www.srware.net/downloads/iron64.deb
sudo dpkg -i iron64.deb
sudo rm iron64.deb
sudo mv /usr/share/iron /bin/iron/
echo "alias iron='/bin/iron/./chrome'" | tee -a ~/.bashrc
/bin/iron/./chrome https://chrome.google.com/webstore/detail/form-filler/bnjjngeaknajbdcgpfkgnonkmififhfo
/bin/iron/./chrome https://chrome.google.com/webstore/detail/autoform/fdedjnkmcijdhgbcmmjdogphnmfdjjik
/bin/iron/./chrome https://chrome.google.com/webstore/detail/m-i-m/jlppachnphenhdidmmpnbdjaipfigoic

sudo apt-get autoremove -y

EOF
