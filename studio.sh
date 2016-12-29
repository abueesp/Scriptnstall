#!/bin/bash
#Bluetooth
sudo sed -i 's/InitiallyPowered = true/InitiallyPowered = false/g' /etc/bluetooth/main.conf
rfkill block bluetooth
#Sudo on Files Eos
echo "[Contractor Entry]\nName=Open folder as root\nIcon=gksu-root-terminal\nDescription=Open folder as root\nMimeType=inode;application/x-sh;application/x-executable;\nExec=gksudo pantheon-files -d %U\nGettext-Domain=pantheon-files" >> Open_as_admin.contract
sudo mv Open_as_admin.contract /usr/share/contractor/Open_as_admin.contract
rm Open_as_admin.contract.contract
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
sudo apt-get install pulseaudio-module-gconf pulseaudio module-hal pulseaudio-module-x11 aconnectgui alsa-tools alsa-tools-gui audacity audacious audacious-plugins-extra ardour beast bitscope creox denemo timemachine gtick hydrogen jackbeat jackd jackeq jack-rack jack-tools jamin jdelay lilypond lilypond-data meterbridge muse patchage qamix vkeybd qjackctl puredata rosegarden timidity seq24 shaketracker sooperlooper swami csound tapiir freqtweak mixxx terminatorx zynaddsubfx fluidsynth bristol freebirth qsynth tk707 linux-rt ubuntustudio-controls -y 
#audio plugins
sudo apt-get install aeolus blop caps cmt hexter fil-plugins ladspa-sdk mcp-plugins omins swh-plugins tap-plugins vcf dssi-example-plugins dssi-host-jack fluidsynth-dssi xsynth-dssi dssi-utils-y
# graphics
sudo apt-get install inkscape blender gimp gimp-data-extras gimp-gap gimp-ufraw gimp-plugin-registry f-spot scribus fontforge gnome-raw-thumbnailer xsane wacom-tools hugin agave yafray synfigstudio  -y
#video
sudo apt-get install openmovieeditor ffmpeg ffmpeg2theora kino stopmotion dvgrabgtk-recordmydesktop recordmydesktop -y
##video Natron
sudo apt-get install libegl1-mesa -y 
wget -c https://downloads.natron.fr/Linux/releases/64bit/files/Natron-2.1.2-Linux-x86_64bit.tgz
tar xzvf Natron**tgz
./Natro**bit
sudo rm -r Natron**
#guitar
sudo apt install tuxguitar tuxguitar-alsa tuxguitar-jsa tuxguitar-oss
echo "Tools -> Settings -> MIDI Port -> Gervill" 


#download 
sudo apt-get install qbittorrent
echo "check also `music` command"

#Sudo on Files Eos
echo "[Contractor Entry] 
Name=Open folder as root
Icon=gksu-root-terminal
Description=Open folder as root
MimeType=inode;application/x-sh;application/x-executable;
Exec=gksudo pantheon-files -d %U
Gettext-Domain=pantheon-files" >> sudo /usr/share/contractor/Open_as_admin.contract


##DEEPDREAMER
sudo apt-get install build-essential git ipython ipython-notebook -y
cd ~
git clone https://github.com/BVLC/caffe.git
sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev python python-dev python-scipy python-setuptools python-numpy python-pip libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler libatlas-dev libatlas-base-dev libatlas3-base libatlas-test -y
sudo apt-get install --no-install-recommends libboost-all-dev -y
sudo pip install --upgrade pip
sudo pip install --upgrade numpy
cd ~/caffe
cp Makefile.config.example Makefile.config
echo " If you're not using CUDA, then you'll want CPU only mode. Edit Makefile.config and uncomment LINE8: CPU_ONLY := 1 LINE 37: BLAS_INCLUDE := /opt/intel/composer_xe_2011_sp1.10.319/mkl/include LINE 38: BLAS_LIB := /opt/intel/composer_xe_2011_sp1.10.319/mkl/lib/intel64" 
gedit Makefile.config
make all -j$(nproc)
make test -j$(nproc)
make runtest -j$(nproc)
make pycaffe -j$(nproc)
cd ~
git clone https://github.com/google/deepdream.git
wget -P ~/caffe/models/bvlc_googlenet http://dl.caffe.berkeleyvision.org/bvlc_googlenet.caffemodel
cd ~/deepdream
ipython notebook ./dream.ipynb
