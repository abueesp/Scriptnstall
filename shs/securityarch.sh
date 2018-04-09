echo "Security Apps: For detailed guides, see the main ArchWiki page, Security https://wiki.archlinux.org/index.php/List_of_applications/Security"

echo "### Network security ###"
echo "Network security"
echo "Arpwatch — Tool that monitors ethernet activity and keeps a database of Ethernet/IP address pairings. http://ee.lbl.gov/" 
sudo pacman -S arpwatch --needed --noconfirm 
echo "Bro — Powerful network analysis framework that is much different from the typical IDS you may know. https://www.bro.org/" 
sudo pacman -S bro-git --needed --noconfirm
git clone https://github.com/bro/package-manager
cd package-manager
sudo python setup.py install
cd ..
sudo rm -r package-manager
#bro-pkg install bro_bitcoin
echo "EtherApe — Graphical network monitor for Unix modeled after etherman. Featuring link layer, IP and TCP modes, it displays network activity graphically. Hosts and links change in size with traffic. Color coded protocols display. http://etherape.sourceforge.net/" 
sudo pacman -S etherape --needed --noconfirm
echo "Honeyd — Tool that allows the user to set up and run multiple virtual hosts on a computer network. http://www.honeyd.org/" 
sudo pacman -S honeyd --needed --noconfirm
echo "vnStat — Console-based network traffic monitor that keeps a log of network traffic for the selected interfaces. http://humdi.net/vnstat/" 
sudo pacman -S vnstat --needed --noconfirm
echo "Nmap — Security scanner used to discover hosts and services on a computer network, thus creating a map of the network. https://nmap.org/" 
sudo pacman -S nmap --needed --noconfirm
echo "Ntop — Network probe that shows network usage in a way similar to what top does for processes. http://www.ntop.org/" 
sudo pacman -S ntop --needed --noconfirm
echo "Spectools — A set of utilities for spectrum analyzer hardware including Wi-Spy devices. https://www.kismetwireless.net/spectools/" 
sudo pacman -S spectools --needed --noconfirm
echo "Sshguard — Daemon that protects SSH and other services against brute-force attacts, similar to Fail2ban. https://www.sshguard.net/" 
sudo pacman -S sshguard --needed --noconfirm


echo "Wireshark — Network protocol analyzer that lets you capture and interactively browse the traffic running on a computer network. https://www.wireshark.org/" 
sudo pacman -S wireshark-cli wireshark-qt --needed --noconfirm #QT prefered over GTK, iptraf, kismet and tcpdump
echo "Metasploit Framework — An advanced open-source platform for developing, testing, and using exploit code. https://www.metasploit.com/ 
sudo pacman -S metasploit --needed --noconfirm
echo "Nessus — Comprehensive vulnerability scanning program. http://www.nessus.org/products/nessus" 
sudo pacman -S nessus --needed --noconfirm
echo "OSSEC — Open Source Host-based Intrusion Detection System that performs log analysis, file integrity checking, policy monitoring, rootkit detection, real-time alerting and active response. https://ossec.github.io/" 
sudo pacman -S sec-agent ossec-local ossec --needed --noconfirm
echo "Samhain — Host-based intrusion detection system (HIDS) provides file integrity checking and log file monitoring/analysis, as well as rootkit detection, port monitoring, detection of rogue SUID executables, and hidden processes. http://www.la-samhna.de/samhain/index.html" 
sudo pacman -S samhain --needed --noconfirm
echo "Tiger — Security tool that can be use both as a security audit and intrusion detection system. http://www.nongnu.org/tiger/" 
sudo pacman -S tiger --needed --noconfirm
echo "Tripwire — Intrusion detection system. https://github.com/Tripwire/tripwire-open-source"
sudo pacman -S tripwire --needed --noconfirm
echo "File security AIDE — File and directory integrity "checker. http://aide.sourceforge.net/" 
sudo pacman -S aide --needed --noconfirm
echo "Package integrity"
sudo pacman -S paccheck --needed --noconfirm
sudo pacman -Qq | sudo paccheck --sha256sum --quiet

echo "### File Security  ###"
#echo "Logcheck — Simple utility which is designed to allow a system administrator to view the logfiles which are produced upon hosts under their control. https://logcheck.alioth.debian.org/ 
#sudo pacman -S logcheck --needed --noconfirm
#echo "Logwatch — Customizable log analysis system. https://sourceforge.net/projects/logwatch/ 
#sudo pacman -S logwatch --needed --noconfirm

echo "### Anti Malware ###"
echo "Lynis — Security and system auditing tool to harden Unix/Linux systems. https://cisofy.com/lynis/ 
sudo pacman -S lynis --needed --noconfirm
sudo lynis audit system
#Unhide
sudo pacman unhide -S --noconfirm --needed #Rkhunter instead of chkrootkit
echo "Unhide — A forensic tool to find processes hidden by rootkits, LKMs or by other techniques." 
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

echo "Rootkit Hunter — Checks machines for the presence of rootkits and other unwanted tools. http://rkhunter.sourceforge.net/ 
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
echo "Hostsblock — A script that downloads, sorts, and compiles multiple ad- and malware-blocking hosts files. http://gaenserich.github.io/hostsblock/" 
sudo pacman -S hostsblock --needed --noconfirm


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
echo "ccrypt — A command-line utility for encrypting and decrypting files and streams. http://ccrypt.sourceforge.net/ 
sudo pacman -S ccrypt --needed --noconfirm
echo "Enigmail — A security extension to Mozilla Thunderbird and Seamonkey. It enables you to write and receive email messages signed and/or encrypted with the OpenPGP standard. https://enigmail.net thunderbird-
sudo pacman -S enigmail --needed --noconfirm
echo "Keybase — Key directory mapping social media identities, with cross platform encrypted chat, cloud storage, and git repositories. https://keybase.io/ keybase or keybase-
sudo pacman -S bin --needed --noconfirm
echo "KGpg — a simple interface for GnuPG for KDE. https://www.kde.org/applications/utilities/kgpg/ 
sudo pacman -S kgpg --needed --noconfirm
echo "Seahorse — GNOME application for managing encryption keys and passwords in the GnomeKeyring. http://library.gnome.org/users/seahorse/stable/ 
sudo pacman -S seahorse --needed --noconfirm
echo "steghide — A steganography utility that is able to hide data in various kinds of image and audio files. http://steghide.sourceforge.net 
sudo pacman -S steghide --needed --noconfirm

echo "### Password managers ###"
echo "Encryptr — Zero-knowledge, cloud-based password manager. https://spideroak.com/encryptr/ 
sudo pacman -S encryptr --needed --noconfirm
echo "KeePass Password Safe — Free open source Mono-based password manager, which helps you to manage your passwords in a secure way. https://keepass.info/ 
sudo pacman -S keepass --needed --noconfirm
echo "KeePassXC — A community fork of KeePassX with more active development. https://keepassxc.org/ 
sudo pacman -S keepassxc --needed --noconfirm
echo "pass — Simple console based password manager, using GnuPG encryption. https://www.passwordstore.org/ 
sudo pacman -S pass --needed --noconfirm
echo "Password Safe — Simple and secure password manager. https://pwsafe.org/ 
sudo pacman -S passwordsafe --needed --noconfirm
echo "pwsafe — Unix commandline program that manages encrypted password databases. http://nsd.dyndns.org/pwsafe/ 
sudo pacman -S pwsafe --needed --noconfirm
echo "Revelation — Password manager for the GNOME desktop. https://revelation.olasagasti.info/ 
sudo pacman -S revelation --needed --noconfirm
echo "spm — Simple Password Manager written entirely in POSIX shell using PGP. Fast, lightweight and easily scriptable. https://notabug.org/kl3/spm/ 
sudo pacman -S spm --needed --noconfirm
echo "Seahorse — GNOME application for managing encryption keys and passwords in the GnomeKeyring. https://wiki.gnome.org/Apps/Seahorse 
sudo pacman -S seahorse --needed --noconfirm
