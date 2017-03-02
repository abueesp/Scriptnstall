### YUBIKEY Slot 1 has a Symantec Identity !
echo "Did you know that YUBIKEY Slot 1 has a Symantec Identity?"

#sudo apt-get install yubikey-manager python-yubikey-manager python3-yubikey-manager yubikey-manager-qt -y
sudo apt-get install autoconf cmake -y

mkdir yubikey

echo "YUBIKEY PERSONALIZATION GUI"
#git clone https://github.com/Yubico/yubikey-personalization-gui.git
wget https://developers.yubico.com/yubikey-personalization-gui/Releases/yubikey-personalization-gui-3.1.24.tar.gz
tar -xf yubikey*.tar.gz
rm yubikey-perso*.tar.gz
cd yubikey-perso*
sudo apt-get install libusb-1.0-0-dev qt4-qmake libykpers-1-dev libyubikey-dev libqt4-dev -y
./configure
qmake && make
chmod u+x -R *
bash prepare-travis.sh
chmod u+x -R *
cd /build/release
chmod u+x -R *
cd build
cd release
./yubikey-personalization-gui
echo "alias yubikey='/home/$USER/yubikey/yubikey-personalization-gui*/build/release/./yubikey-personalization-gui'" >> /home/$USER/.bashrc
cd ..
cd ..
cd ..


echo "YUBIKEY PERSONALIZATION COMMAND LINE"
wget https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.17.3.tar.gz
tar -xf ykpers*.tar.gz
#it needs autoconf
rm ykpers*.tar.gz
cd ykpers*
chmod u+x -R *
./configure
make
make install
bash build-and-test.sh
./ykinfo
./ykchalresp
./ykpersonalize
echo "alias ykinfo='/home/$USER/yubikey/ykpers*/./ykinfo'>> /home/$USER/.bashrc"
echo "alias ykchalresp='/home/$USER/yubikey/ykpers*/./ykchalresp'>> /home/$USER/.bashrc"
echo "alias ykpersonalize='/home/$USER/yubikey/ykpers*/./ykpersonalize'>> /home/$USER/.bashrc"
cd ..
