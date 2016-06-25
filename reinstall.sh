#!/bin/bash
# My first script to reinstall
#Bluetooth
sudo sed -i 's/InitiallyPowered = true/InitiallyPowered = false/g' /etc/bluetooth/main.conf
rfkill block bluetooth
#mirror
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
#Minus
sudo apt-get purge imagemagick fontforge geary -y
#Docker 
sudo wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker $USER
sudo apt-get purge apparmor -y
sudo rm -rf /etc/apparmor.d/
sudo rm -rf /etc/apparmor

#KeePass (see KeeFox in Browsers)
sudo apt-get install mono-complete mono-dmcs libmono-system-management4.0-cil libmono-system-xml-linq4.0-cil libmono-system-data-datasetextensions4.0-cil libmono-system-runtime-serialization4.0-cil mono-mcs -y
mkdir KeePass
cd KeePass
sudo wget http://downloads.sourceforge.net/project/keepass/KeePass%202.x/2.33/KeePass-2.33.zip
sudo unzip KeePass**.zip
sudo rm **.zip
sudo add-apt-repository ppa:dlech/keepass2-plugins
sudo apt-get update 
sudo wget https://raw.github.com/pfn/keepasshttp/master/KeePassHttp.plgx
sudo chmod 644 KeePassHttp.plgx
sudo wget https://keepass.info/extensions/v2/kpscript/KPScript-2.32.zip
wget -r --no-parent -A 'KPScript*.zip' https://keepass.info/extensions/v2/kpscript/
sudo unzip KPScript**.zip
sudo rm KPScript**.zip
sudo wget https://downloads.sourceforge.net/project/kp-googlesync/GoogleSyncPlugin-2.x/GoogleSyncPlugin-2.1.2.zip
sudo unzip GoogleSync**.zip
sudo rm GoogleSync**.zip
sudo wget https://github.com/islog/keepassrfid/releases/download/1.0.0/keepassrfid.plgx
sudo git clone git://github.com/dlech/KeeAgent --recursive
cd KeeAgent
sudo mozroots --import --machine --sync
sudo certmgr -ssl -m https://go.microsoft.com
sudo certmgr -ssl -m https://nugetgallery.blob.core.windows.net
sudo certmgr -ssl -m https://nuget.org
sudo rm nuget.exe*
sudo wget https://nuget.org/nuget.exe
sudo mono nuget.exe restore
sudo rm nuget.exe*
sudo xbuild /property:Configuration=ReleasePlgx KeeAgent.sln
cd
sudo cp bin/ReleasePlgx/KeeAgent.plgx /KeePass
sudo chmod +x /KeePass
rm keepassrfid.plgx 
rm -r KeeAgent
sudo apt-get purge keepass2-plugin-rpc

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

#Some tools
sudo apt-get install secure-delete -y
sudo apt-get install traceroute -y
sudo apt-get install zsh -y 
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sudo sed -ir 's/ZSH_THEME="robbyrussell"/ZSH_THEME="norm"/g' ~/.oh-my-zsh #noroot
sudo apt-get install iotop -y 
sudo apt-get install fish -y
sudo apt-get install byobu -y
sudo apt-get install unoconv -y
sudo apt-get install detox -y
sudo apt-get install autojump -y
sudo apt-get install nmap -y
sudo apt-get install tmux -y
sudo apt-get install htop -y
sudo apt-get install pandoc -y
sudo apt-get install vnstat -y
sudo apt-get install duplicity deja-dup -y

##GNUPG
sudo apt-get install libgtk2.0-dev -y
sudo mkdir gpg
cd gpg
sudo wget https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.22.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.22.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "c40015ed88bf5f50fa58d02252d75cf20b858951" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd libgp**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo rm -r libgp**

sudo wget https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.7.0.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.7.0.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "f840b737faafded451a084ae143285ad68bbfb01" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd libgcr**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo rm -r libgcr**

sudo wget https://www.gnupg.org/ftp/gcrypt/libksba/libksba-1.3.4.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/libksba/libksba-1.3.4.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "bc84945400bd1cabfd7b8ba4e20e71082f32bcc9" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd libks**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo rm -r libks**

sudo wget https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-2.4.2.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-2.4.2.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "ac1047f9764fd4a4db7dafe47640643164394db9" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd libas**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo rm -r libas**

sudo wget https://www.gnupg.org/ftp/gcrypt/npth/npth-1.2.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/npth/npth-1.2.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "3bfa2a2d7521d6481850e8a611efe5bf5ed75200" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd npth**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo npth**

sudo wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.1.12.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.1.12.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "3b01a35ac04277ea31cc01b4ac4e230e54b5480c" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd gnupg**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo rm -r gnupg**

sudo wget https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.6.0.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.6.0.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "f840b737faafded451a084ae143285ad68bbfb01" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd gpgm**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo rm -r gpgm**

sudo wget https://www.gnupg.org/ftp/gcrypt/gpa/gpa-0.9.9.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/gpa/gpa-0.9.9.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "1cf86c9e38aa553fdb880c55cbc6755901ad21a4" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd gpa**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo rm -r gpa**

cd ..
sudo rm -r gpg
##Fail2ban
sudo apt-get install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
echo "Please write down an email to send you notifications when someone is attacking your ports: "
read email
echo "You entered: $email"
sed "s/destemail = your_email@domain.com/destemail = $email/g" /etc/fail2ban/jail.local
sed "s/action = %(action_)s/action = %(action_mw)s/g" /etc/fail2ban/jail.local
sed -e "s/enabled  = false/enabled  = true/g" /etc/fail2ban/jail.local
sudo apt-get install zenmap -y

##Virtualbox
sudo apt-get purge virtualbox
while true; do
    read -p "Please introduce introduce OS Ubuntu 16.04 ('xenial_amd64') Ubuntu 15.10 ('wily_amd64') or Ubuntu 14.04 ('trusty_amd64') / 14.10 Utopic/ 15.04 Vivid: " OS $OS
    sudo wget http://download.virtualbox.org/virtualbox/5.0.20/virtualbox-5.0_5.0.20-106931~Ubuntu~$OS.deb
    break
done
sudo dpkg -i virtualbox**.deb
sudo rm virtualbox**.deb
sudo apt-get install vagrant -y
vagrant box add precise64 http://files.vagrantup.com/precise64.box
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
wget http://download.virtualbox.org/virtualbox/5.0.16/VBoxGuestAdditions_5.0.16.iso
sudo mv VBoxGuestAdditions**.iso /usr/share/Virtualbox/VBoxGuestAdditions.iso
echo "insert iso additions"
VBoxManage.exe storageattach work --storagectl IDE --port 0 --device 0 --type dvddrive --medium "/home/$USER/VBox**.iso"
read -p "Introduce un usuario de vbox " user1 $user1
sudo usermod -G vboxusers -a $user1
read -p "Introduce otro usuario de vbox " user2 $user2
sudo usermod -G vboxusers -a $user2

##Utils
sudo apt-get install gparted -y
sudo apt-get install nemo -y
sudo apt-get install thunderbird -y
thunderbird https://addons.mozilla.org/thunderbird/downloads/latest/775/addon-775-latest.xpi
sudo apt-get install firefox -y
firefox https://addons.mozilla.org/firefox/downloads/file/271802/no_more_install_delay-3.0-fx+sm+fn+tb.xpi
#Text Edition Tools
sudo add-apt-repository ppa:webupd8team/sublime-text-3 -y 
sudo apt-get update -y
sudo apt-get install vim vim-scripts -y
git clone https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
sudo apt-get install gedit -y
sudo apt-get install sublime-text-installer -y
sudo apt-get install libreoffice -y
wget http://www.literatureandlatte.com/scrivenerforlinux/scrivener-1.9.0.1-amd64.deb
sudo dpkg -i scrivener**
sudo rm scrivener**

##Emacs
sudo rm -r /usr/local/stow
set -e

readonly version="24.5"

# install dependencies
sudo apt-get install -y stow build-essential libx11-dev xaw3dg-dev libjpeg-dev libpng12-dev libgif-dev libtiff5-dev libncurses5-dev libxft-dev librsvg2-dev libmagickcore-dev libmagick++-dev libxml2-dev libgpm-dev libghc-gconf-dev libotf-dev libm17n-dev  libgnutls-dev -y

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
sudo git clone http://github.com/syl20bnr/spacemacs ~/.emacs.d
##plugins
cd ~/.emacs.d
wget http://github.com/ethereum/emacs-solidity/blob/master/solidity-mode.el ##solidity
(add-to-list load-path "~/.emacs.d/") 
(load "myplugin.el")
cd
sudo rm emacs-"$version".tar.xz
sudo rm -r emacs-**


##Github
sudo apt-get install git -y 
git config --global credential.helper cache
# Set git to use the credential memory cache
git config --global credential.helper 'cache --timeout=3600'
# Set the cache to timeout after 1 hour (setting is in seconds)
while true; do
    read -p "Please set your username: " username $username
    git config --global user.name $username
    break
done
while true; do
    read -p "Please set your email: " mail $mail
    git config --global user.email $mail
    break
done

while true; do
    read -p "Please set your core editor: " editor $editor
    git config --global core.editor $editor
    break
done
while true; do
    read -p "Please set your diff app: " diff $diff
    git config --global merge.tool $diff
    break
done
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
wget https://addons.mozilla.org/firefox/downloads/latest/722/addon-722-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/363974/addon-363974-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/409964/addon-409964-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/261959/addon-261959-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/261959/addon-261959-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/1865/addon-1865-latest.xpi  
wget https://addons.mozilla.org/firefox/downloads/latest/748/addon-748-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/7447/addon-7447-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/1122/addon-1122-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/1237/addon-1237-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/3497/addon-3497-latest.xpi t 
wget https://addons.mozilla.org/firefox/downloads/latest/10900/addon-10900-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/306880/platform:2/addon-306880-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/193270/addon-193270-latest.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/5791/addon-5791-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/4775/addon-4775-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/file/342774/tineye_reverse_image_search-1.2.1-fx.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/1117/addon-1117-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/60/addon-60-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/1843/addon-1843-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/355192/addon-355192-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/file/229626/sql_inject_me-0.4.7-fx.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/2324/addon-2324-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/532/addon-532-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/5523/addon-5523-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/file/413865/mutetab-0.0.2-fx.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/387051/addon-387051-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/10586/addon-10586-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/607454/addon-607454-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/521554/addon-521554-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/file/262658/cryptocat-2.2.2-fx.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/383235/addon-383235-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/file/387220/text_to_voice-1.15-fx.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/161670/addon-161670-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/3899/addon-3899-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/file/281702/google_privacy-0.2.4-sm+fx.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/329784/addon-329784-latest.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/509336/addon-509336-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/496120/addon-496120-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/8661/addon-8661-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/599152/addon-599152-latest.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/473878/addon-473878-latest.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/45281/addon-45281-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/3829/addon-3829-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/229918/addon-229918-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/file/373868/soundcloud_downloader_soundgrab-0.98-fx.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/415846/addon-415846-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/387429/addon-387429-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/292320/addon-292320-latest.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/695840/addon-695840-latest.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/3456/addon-3456-latest.xpi
sudo git clone https://github.com/cryptocat/cryptocat-legacy
cd cryptocat-legacy
sudo make firefox
cd
sudo cp Downloads/extensions/cryptocat-legacy/release/**.xpi Downloads/extensions
sudo rm -r Downloads/extensions/cryptocat-legacy

#thunderbird extensions
mkdir thunderbird
cd thunderbird
wget https://addons.mozilla.org/thunderbird/downloads/latest/611/addon-611-latest.xpi 
wget https://addons.mozilla.org/thunderbird/downloads/latest/1339/addon-1339-latest.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/556/addon-556-latest.xpi 
wget https://addons.mozilla.org/thunderbird/downloads/latest/4003/addon-4003-latest.xpi
wget https://addons.mozilla.org/thunderbird/downloads/latest/1556/addon-1556-latest.xpi 
wget https://addons.mozilla.org/thunderbird/downloads/latest/550/addon-550-latest.xpi 
wget https://addons.mozilla.org/thunderbird/downloads/latest/2313/platform:2/addon-2313-latest.xpi 
wget https://addons.mozilla.org/thunderbird/downloads/latest/4631/addon-4631-latest.xpi 
wget https://addons.mozilla.org/thunderbird/downloads/latest/2199/addon-2199-latest.xpi 
wget https://addons.mozilla.org/thunderbird/downloads/latest/550/addon-550-latest.xpi 
wget https://addons.mozilla.org/thunderbird/downloads/latest/71/addon-71-latest.xpi 
wget https://addons.mozilla.org/thunderbird/downloads/latest/210/addon-210-latest.xpi 
wget https://addons.mozilla.org/thunderbird/downloads/latest/875/addon-875-latest.xpi 
wget https://addons.mozilla.org/thunderbird/downloads/latest/1003/addon-1003-latest.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/390151/addon-390151-latest.xpi
cd ..
keepass2
sudo cp /home/node/.mozilla/firefox/**.default/extensions/keefox@chris.tomlinson/deps/KeePassRPC.plgx /usr/lib/keepass2


sudo apt-get autoremove -y

EOF
