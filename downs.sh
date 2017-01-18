

"echo Java"
sudo mkdir /usr/java/
cd /usr/java/
firefox --new-tab https://www.java.com/en/download/linux_manual.jsp
sudo mv ~/Downloads/jre-**-linux-x64.tar.gz /usr/java/jre.tar.gz
sudo tar -xf jre.tar.gz
sudo rm jre.tar.gz
cd

#echo "GNUNet"
#sudo apt-get install gnunet gnunet-gtk -y

echo "aMule"
wget https://github.com/wxWidgets/wxWidgets/releases/download/v3.0.2/wxWidgets-3.0.2.tar.bz2
tar -xf wx**.tar.bz2
cd wx**
./configure
make
sudo make install
cd ..
rm wxWidgets**.tar.bz2
sudo apt-get build-dep amule
git clone https://github.com/persmule/amule
sh autogen.sh
./configure
make
sudo make install
sudo chown -R node /home/$USER/.aMule
mkdir datmet
cd datmet
wget http://www.emule.com/server.met
wget http://www.gruk.org/server.met
wget http://upd.emule-security.org/server.met
wget http://upd.emule-security.net/nodes.dat
cd ..

echo "i2p"
sudo apt-get -o Dpkg::Options::="--force-overwrite" install openjdk-9-jdk 
sudo apt-add-repository ppa:i2p-maintainers/i2p && sudo apt-get update && sudo apt-get install i2p
i2prouter start
echo "Select AND start SAM bridge AND Save Configuration"
firefox --new-tab 127.0.0.1:7657/configclients
i2prouter restart

echo "iMule"
sudo apt-get install libcrypto++-dev libcrypto++-doc libcrypto++-utils libupnp-dev  zlib1g-dev wx2.8-headers libwxgtk2.8-0 libwxgtk2.8-dev -y
read -p "Please introduce OS Ubuntu: jessie-amd64 jessie-i386 (v12) trusty-amd64 trusty-i386 (v14) wily-amd64 xenial-amd64 xenial-i386 (v16): " OS $OS
wget http://echelon.i2p.xyz/imule/nodes.dat
echo "Select this nodes.dat as Node list into text file for Kademlia"
wget http://echelon.i2p.xyz/imule/2.3.3.3/imule_2.3.3.3-1-$OS.deb
sudo dpkg -i imule**.deb
rm imule**.deb

echo "LimeWire"
firefox --new-tab https://drive.google.com/drive/folders/0Bwl0hONY_Aj0bk5mTkozZ09hbnM
cd Downloads
sudo dpkg --ignore-depends=sun-java6-jre --ignore-depends=icedtea-java7-jre --ignore-depends=sun-java6-jdk --ignore-depends=icedtea-java7-jdk -i LPE**.deb
cd ..

echo "Bittorrent"
sudo apt-get install bittorrent bittorrent-gui

echo "OpenNap(ster)"
wget http://prdownloads.sourceforge.net/xnap/xnap_2.5r3-1_all.deb

echo "MLDonkey"
sudo apt-get mldonkey-server kmldonkey
mldonkey servers http://www.emule.com/server.met 35
mldonkey servers http://www.gruk.org/server.met 36
mldonkey servers http://upd.emule-security.org/server.met 37
mldonkey servers http://upd.emule-security.net/nodes.dat 38
echo "***COPY ON CONSOLE***"
echo "set enable_overnet true"
echo "set enable_bittorrent true"
echo "set enable_soulseek true"
echo "set enable_opennap true"
echo "set enable_donkey true"
echo "set ED2K-update_server_list_client true"
echo "set ED2K-update_server_list_server true"
echo "set ED2K-update_server_list_server_met true"
echo "set enable_kademlia true"
echo "rem all"
echo "force_web_infos server.met"
echo "***COPY ON CONSOLE***"
kmldonkey


echo "Retroshare"
sudo add-apt-repository ppa:retroshare/stable
sudo add-apt-repository ppa:retroshare/unstable
sudo apt-get update
sudo apt-get install retroshare06

echo "Freenet"
wget 'https://freenetproject.org/assets/jnlp/freenet_installer.jar' -O new_installer_offline.jar
java -jar new_installer_offline.jar


echo "ZeroBundle"
wget https://github.com/HelloZeroNet/ZeroBundle/raw/master/dist/ZeroBundle-linux64.tar.gz
tar -xf ZeroBundle-linux64.tar.gz
rm ZeroBundle-linux64.tar.gz
cd ZeroBundle
./ZeroNet.sh



echo "Gnutella"
sudo apt-get build-dep gtk-gnutella -y
sudo apt-get install libgcrypt11-dev libtasn1-3-bin binutils-dev -y
mkdir gnutella
cd gnutella
wget https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.11/gtk-gnutella_1.1.11-1_amd64.deb
wget https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.1.11/gtk-gnutella_1.1.11-1_amd64.deb.asc
gpg --verify gtk**.deb{.asc*,}
sudo apt-get install libgpg-error0 -y
wget http://security.ubuntu.com/ubuntu/pool/main/libg/libgcrypt11/libgcrypt11_1.5.3-2ubuntu4.4_i386.deb
wget http://security.ubuntu.com/ubuntu/pool/main/g/gnutls26/libgnutls26_2.12.23-12ubuntu2.5_i386.deb 
sudo dpkg -i libcrypt**
sudo dpkg -i libgnutls26**
wget https://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.bz2
tar -xf binutils-2.24.tar.bz2
rm binutils-2.24.tar.bz2
cd binutils-2.24
sudo apt-get install gawk gcc -y
wget http://security.ubuntu.com/ubuntu/pool/main/g/gnutls26/libgnutls26_2.12.14-5ubuntu3.12_amd64.deb
sudo dpkg  --ignore-depends=libgcrypt11 --ignore-depends=libtasn1-3 -i libgnutls26_2**.deb
./configure --disable-werror
sudo make
sudo make install
sudo dpkg --ignore-depends=binutils --ignore-depends=libgnutls26  -i gtk**
cd ..
rm libcrypt**
rm libgnutls26**
rm gtk**.deb
