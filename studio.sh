#!/bin/bash
#!/bin/bash
#Bluetooth
sudo sed -i 's/InitiallyPowered = true/InitiallyPowered = false/g' /etc/bluetooth/main.conf
rfkill block bluetooth
#mirror
sudo sed -i 's|http://us.archive.ubuntu.com/ubuntu|http://mirrors.mit.edu/ubuntu|g' /etc/apt/sources.list
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/bash.bashrc
sudo mv bash.bashrc /etc/bash.bashrc
sudo apt-get update
sudo apt-get upgrade
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
#Some tools
sudo apt-get install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
echo "Please write down an email to send you notifications when someone is attacking your ports: "
read email
echo "You entered: $email"
sed "s/destemail = your_email@domain.com/destemail = $email/g" /etc/fail2ban/jail.local
sed "s/action = %(action_)s/action = %(action_mw)s/g" /etc/fail2ban/jail.local
sed -e "s/enabled  = false/enabled  = true/g" /etc/fail2ban/jail.local

#audio
sudo apt-get install  pulseaudio-module-gconf pulseaudio module-hal pulseaudio-module-x11 aconnectgui alsa-tools alsa-tools-gui audacity audacious audacious-plugins-extra ardour beast bitscope creox denemo timemachine gtick hydrogen jackbeat jackd jackeq jack-rack jack-tools jamin jdelay lilypond lilypond-data meterbridge muse patchage qamix vkeybd qjackctl puredata rosegarden timidity seq24 shaketracker sooperlooper swami csound tapiir freqtweak mixxx terminatorx zynaddsubfx fluidsynth bristol freebirth qsynth tk707 linux-rt ubuntustudio-controls -y 
#audio plugins
sudo apt-get install aeolus blop caps cmt hexter fil-plugins ladspa-sdk mcp-plugins omins swh-plugins tap-plugins vcf dssi-example-plugins dssi-host-jack fluidsynth-dssi xsynth-dssi dssi-utils-y
# graphics
sudo apt-get install inkscape blender gimp gimp-data-extras gimp-gap gimp-ufraw gimp-plugin-registry f-spot scribus fontforge gnome-raw-thumbnailer xsane wacom-tools hugin agave yafray synfigstudio  -y
#video
sudo apt-get install openmovieeditor ffmpeg ffmpeg2theora kino stopmotion dvgrab -y
##video Natron
sudo apt-get install libegl1-mesa -y 
wget -c https://downloads.natron.fr/Linux/releases/64bit/files/Natron-2.1.2-Linux-x86_64bit.tgz
tar xzvf Natron**tgz
./Natro**bit
sudo rm -r Natron**

#download 
sudo apt-get install qbittorrent
echo "check also `music` command"
