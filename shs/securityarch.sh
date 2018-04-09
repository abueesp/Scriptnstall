echo "Security Apps: For detailed guides, see the main ArchWiki page, Security https://wiki.archlinux.org/index.php/List_of_applications/Security"
sudo pacman -S aurman --needed --noconfirm --noedit

echo "### Network security ###"
echo "Network security"
echo "Arpwatch — Tool that monitors ethernet activity and keeps a database of Ethernet/IP address pairings. http://ee.lbl.gov/" 
sudo pacman -S arpwatch --needed --noconfirm 
echo "Bro — Powerful network analysis framework that is much different from the typical IDS you may know. https://www.bro.org/" 
aurman -S bro-git --needed --noconfirm --noedit
git clone https://github.com/bro/package-manager
cd package-manager
sudo python setup.py install
cd .. 
sudo rm -r package-manager
#bro-pkg install bro_bitcoin/
echo "EtherApe — Graphical network monitor for Unix modeled after etherman. Featuring link layer, IP and TCP modes, it displays network activity graphically. Hosts and links change in size with traffic. Color coded protocols display. http://etherape.sourceforge.net/" 
sudo pacman -S etherape --needed --noconfirm
echo "Honeyd — Tool that allows the user to set up and run multiple virtual hosts on a computer network. http://www.honeyd.org/" 
aurman -S honeyd --needed --noconfirm --noedit --noedit
echo "vnStat — Console-based network traffic monitor that keeps a log of network traffic for the selected interfaces. http://humdi.net/vnstat/" 
sudo pacman -S vnstat --needed --noconfirm --noedit
echo "Nmap — Security scanner used to discover hosts and services on a computer network, thus creating a map of the network. https://nmap.org/" 
aurman -S nmap --needed --noconfirm --noedit
echo "Ntop — Network probe that shows network usage in a way similar to what top does for processes. http://www.ntop.org/" 
sudo pacman -S ntop --needed --noconfirm

echo "Sshguard — Daemon that protects SSH and other services against brute-force attacts, similar to Fail2ban. https://www.sshguard.net/" 
sudo pacman -S sshguard --noconfirm --needed
sudo vim -c ":%s ":%s|BLACKLIST_FILE=120:/var/db/sshguard/blacklist.db|BLACKLIST_FILE=50:/var/db/sshguard/blacklist.db|g" -c ":wq" /etc/sshguard.conf #Danger level: 5 failed logins -> banned
sudo vim -c ":%s ":%s|THRESHOLD=30|THRESHOLD=10|g" -c ":wq"  /etc/sshguard.conf 
sudo systemctl enable --now sshguard.service --restart

echo "Wireshark — Network protocol analyzer that lets you capture and interactively browse the traffic running on a computer network. https://www.wireshark.org/" 
sudo pacman -S wireshark-cli wireshark-qt --needed --noconfirm #QT prefered over GTK, iptraf, kismet and tcpdump

echo "Metasploit Framework — An advanced open-source platform for developing, testing, and using exploit code. https://www.metasploit.com/ "
aurman -S metasploit-git armitage  jdk10-openjdk jre10-openjdk jre10-openjdk-headless --noconfirm --noedit --needed
echo 'alias msfconsole="echo \"Run msfconsole and write \'db_connect $USER@msf\' and \'db_rebuild_cache\'\" && msfconsole --quiet -x \"db_connect $USER@msf\""' | tee -a /home/$USER/.bashrc
cp /usr/share/metasploit/database.yml.sample ~/.msf4/database.yml
read -p "Introduce msf user: " MSFUSER
vim -c ":%s/#username here/$MSFUSER/g" -c ":wq" ~/.msf4/database.yml
  read -p "Introduce msf password: " MSFPASSWORD
vim -c ":%s/#password here/$MSFPASSWORD/g" -c ":wq" ~/.msf4/database.yml

curl -L get.rvm.io > rvm-install #for msfconsole you need RVM
bash < ./rvm-install
rm rvm-install
echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && export rvm_ignore_gemrc_issues=1 && source "$HOME/.rvm/scripts/rvm' | tee -a /home/$USER/.bashrc
source /home/$USER/.bashrc
rvm list known
RVMVERSION=$(rvm list known | awk 'NR==12{print $1}' | cut -d ']' -f 2 | rev | cut -c4- | rev)
rvm install $RVMVERSION
rvm use $RVMVERSION --default
gem install bundler
echo "PATH=\"$PATH:$(ruby -e 'print Gem.user_dir\')bin\"" | tee -a /home/$USER/.bashrc
echo 'export GEM_HOME=$HOME/.gem' | tee -a /home/$USER/.bashrc
gem env
gem list


echo "### File Security  ###"
#echo "Logcheck — Simple utility which is designed to allow a system administrator to view the logfiles which are produced upon hosts under their control. https://logcheck.alioth.debian.org/ 
#sudo pacman -S logcheck --needed --noconfirm
#echo "Logwatch — Customizable log analysis system. https://sourceforge.net/projects/logwatch/ 
#sudo pacman -S logwatch --needed --noconfirm
#echo "File security AIDE — File and directory integrity checker. http://aide.sourceforge.net/" 
#sudo pacman -S aide --needed --noconfirm
echo "Package integrity"
sudo pacman -S paccheck --needed --noconfirm
sudo pacman -Qq | sudo paccheck --sha256sum --quiet


echo "### Anti Malware ###"
echo "Tiger — Security tool that can be use both as a security audit and intrusion detection system. http://www.nongnu.org/tiger/" 
aurman -S tiger --needed --noconfirm --noedit
sudo tiger
echo "Lynis — Security and system auditing tool to harden Unix/Linux systems. https://cisofy.com/lynis/ "
sudo pacman -S lynis --needed --noconfirm
sudo lynis audit system
echo "Unhide — A forensic tool to find processes hidden by rootkits, LKMs or by other techniques. "
sudo pacman unhide -S --noconfirm --needed
sudo unhide -m -d sys procall brute reverse
printf'[Unit]
Unit sudo unhide -m -d sys procall brute reverse
Description=Run unhide weekly and on boot

[Timer]
#OnBootSec=15min
#OnUnitActiveSec=1w
OnCalendar=weekly
Persistent=true

[Install]
WantedBy=timers.target
#for mail check https://wiki.archlinux.org/index.php/Systemd/Timers#MAILTO' | sudo tee /etc/systemd/system/unhide.timer
sudo chmod u+rwx /etc/systemd/system/unhide.timer
sudo chmod go-rwx /etc/systemd/system/unhide.timer
sudo chmod go-rwx /etc/rkhunter.conf

echo "Rkhunter — Checks machines for the presence of rootkits and other unwanted tools."
sudo pacman rkhunter -S --noconfirm --needed #Rkhunter instead of chkrootkit
echo 'SCRIPTWHITELIST="/usr/bin/egrep"' | sudo tee -a /etc/rkhunter.conf #false positive In Arch it is a bash script not a binary
echo 'SCRIPTWHITELIST="/usr/bin/fgrep"' | sudo tee -a /etc/rkhunter.conf #false positive In Arch it is a bash script not a binary
echo 'SCRIPTWHITELIST="/usr/bin/ldd"' | sudo tee -a /etc/rkhunter.conf #false positive In Arch it is a bash script not a binary
echo 'EXISTWHITELIST="/usr/bin/vendor_perl/GET"' | sudo tee -a /etc/rkhunter.conf #false positive Not in Arch installations
echo 'ALLOWHIDDENFILE="/etc/.updated"' | sudo tee -a /etc/rkhunter.conf #false positive This file was created by systemd-update-done. Its only purpose is to hold a timestamp of the time this directory was updated. See man:systemd-update-done.service(8).
echo 'ALLOWHIDDENFILE="/usr/share/man/man5/.k5login.5.gz"' | sudo tee -a /etc/rkhunter.conf #false positive duplicated for krb5 package
echo 'ALLOWHIDDENFILE="/usr/share/man/man5/.k5login.5.gz"' | sudo tee -a  /etc/rkhunter.conf #false positive duplicated for krb5 package
echo 'ALLOWDEVFILE="/dev/dsp"' | sudo tee -a  /etc/rkhunter.conf #false positive https://wiki.archlinux.org/index.php/Open_Sound_System
printf'[Unit]
Unit=sudo rkhunter --skip-keypress --summary --check --hash sha256 -x
Description=Run unhide weekly and on boot

[Timer]
#OnBootSec=15min
#OnUnitActiveSec=1w
OnCalendar=weekly
Persistent=true

[Install]
WantedBy=timers.target
#for mail check https://wiki.archlinux.org/index.php/Systemd/Timers#MAILTO' |  sudo tee /etc/systemd/system/unhide.timer
sudo chmod u+rwx /etc/systemd/system/unhide.timer 
sudo chmod go-rwx /etc/systemd/system/unhide.timer 
sudo chmod go-rwx /etc/rkhunter.conf 
sudo rkhunter --skip-keypress --summary --check --hash sha256 -x


echo "### Hash checkers ###"
echo "MassHash — A set of file hashing tools (both CLI and GTK+ GUI) written in Python. Supported algorithms include MD5, SHA-1, SHA-224, SHA-256, SHA-384, SHA-512. http://jdleicher.github.io/MassHash/ "
sudo pacman -S masshash --needed --noconfirm
echo "Hashalot"
git clone https://gitlab.com/hashalot/hashalot.git
cd hashalot
./configure
ACLOCALVERSION=$(pacman -Qo $(which aclocal) | awk '{print $6}' | head -c4)
vim -c ":%s/1.7/$ACLOCALVERSION/g" -c ":wq" Makefile
make --ignore-errors
sudo make install --ignore-errors
cd ..
sudo rm -r hashalot


echo "### Encryption, signing, steganography ###"
echo "ccrypt — A command-line utility for encrypting and decrypting files and streams. http://ccrypt.sourceforge.net/"
aurman -S ccrypt --needed --noconfirm --noedit
echo "Keybase-bin — Key directory mapping social media identities, with cross platform encrypted chat, cloud storage, and git repositories."
aurman -S keybase-bin --noconfirm --noedit --needed #better than keybase
run_keybase
echo "KGpg — a simple interface for GnuPG for KDE. https://www.kde.org/applications/utilities/kgpg/"
sudo pacman -S gnupg kgpg --needed --noconfirm
echo "steghide — A steganography utility that is able to hide data in various kinds of image and audio files. http://steghide.sourceforge.net "
sudo pacman -S steghide --needed --noconfirm


echo "### Password managers ###"
echo "Encryptr — Zero-knowledge, cloud-based password manager. https://spideroak.com/encryptr/" 
aurman -S encryptr --needed --noconfirm --noedit
echo "KeePassXC — A community fork of KeePassX with more active development. https://keepassxc.org/ "
sudo pacman -S keepassxc --needed --noconfirm #prefered over keepass and keepassX
echo "pass — Simple console based password manager, using GnuPG encryption. https://www.passwordstore.org/ "
sudo pacman -S pass --needed --noconfirm
echo "spm — Simple Password Manager written entirely in POSIX shell using PGP. Fast, lightweight and easily scriptable. https://notabug.org/kl3/spm/ "
aurman spm --needed --noconfirm --noedit
echo "Seahorse — GNOME application for managing encryption keys and passwords in the GnomeKeyring. https://wiki.gnome.org/Apps/Seahorse "
sudo pacman -S seahorse --needed --noconfirm
