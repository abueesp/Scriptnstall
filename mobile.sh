##Build
#sudo apt-get install android-tools-adb android-tools-fastboot bison build-essential curl flex git gnupg gperf libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk2.8-dev libxml2 libxml2-utils lzop maven openjdk-7-jdk openjdk-7-jre pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev g++-multilib gcc-multilib lib32ncurses5-dev lib32readline-gplv2-dev lib32z1-dev -y
#mkdir -p ~/bin
#mkdir -p ~/android/system/vendor/cm
#curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
#chmod a+x ~/bin/repo
#echo '\n# set PATH so it includes user private bin if it exists
#\nif [ -d "$HOME/bin" ] ; then
#\n    PATH="$HOME/bin:$PATH"
#\nfi' >> ~/bin/.profile
#cd ~/android/system/
#repo init -u https://github.com/CyanogenMod/android.git -b cm-13.0
#repo sync
#source build/envsetup.sh
#breakfast z3c
#cd ..
#cd ..
#cd ~/android/system/vendor/cm
#./get-prebuilts
#cd ..
#cd ..
#cd ..
#cd ..
#cd ~/android/system/device/sony/z3c
#./extract-files.sh
#cd ..
#cd ..
#cd ..
#cd ..
#cd ..
#echo "\nexport USE_CCACHE=1" >> sudo /etc/bash.bashrc

#chroot 
#brunch z3c
#cd $OUT

##INSTALL
sudo apt-get install android-tools-adb android-tools-fastboot mtp-tools mtpfs libusb-dev gmtp -y
sudo lsusb
sudo mkdir /mnt/mobile
sudo chmod a+rwx /mnt/mobile
ls -lah /usr/lib/libmtp*
#wget http://downloads.sourceforge.net/project/libmtp/libmtp/1.1.11/libmtp-1.1.11.tar.gz
#wget http://downloads.sourceforge.net/project/libmtp/libmtp/1.1.11/libmtp-1.1.11.tar.gz.asc
#gpg --verify libmtp**.asc
#tar xvf libmtp**.tar.gz
#cd libmtp**/
#./configure --prefix=/usr
#make
#sudo make install
#sudo cp 69-libmtp.rules /etc/udev/rules.d
#sudo mtp-detect | grep idVendor
#sudo mtp-detect | grep idProduct
#echo 'write this string into the file: SUBSYSTEM=="usb", ATTR{idVendor}=="VENDORID", ATTR{idProduct}=="PRODUCTID", MODE="0666" and save. Replace VENDORID with the idVendor you had noted down earlier. Similarly, replace PRODUCTID with the idProduct you had noted down. In my case, they were 0fce and 01bb respectively, but they might have been different for you.'
#sudo gedit /etc/udev/rules.d/51-android.rules

sudo chmod +x /etc/udev/rules.d/99-android.rules
sudo service udev restart
sudo sed -i 's/#user_allow_other/user_allow_other/g' /etc/fuse.conf
sudo chmod a+rwx /etc/fuse.conf
sudo adduser $USER fuse

NOW = date
mtpfs -o allow_other /mnt/mobile/

adb backup -apk -shared -f backup$NOW.ab
echo "insert *#06# on the phone and take note of the IMEI"
read $pause
echo "put the device into fastboot mode. With the device powered down, hold Volume Up and connect the USB cable. The notification light should turn blue to indicate you are in fastboot mode. If you receive the message waiting for device fastboot is not configured properly"
read $pause
sudo fastboot getvar version
wget https://download.cyanogenmod.org/get/jenkins/161009/cm-12.1-20160509-NIGHTLY-z3-recovery.img
wget https://download.cyanogenmod.org/get/jenkins/161009/cm-12.1-20160509-NIGHTLY-z3.zip
wget https://github.com/opengapps/arm64/releases/download/20160511/open_gapps-arm64-6.0-super-20160511.zip
firefox https://wiki.cyanogenmod.org/w/Build_for_z3c --new-tab -url https://wiki.cyanogenmod.org/w/Install_CM_for_z3c --new-tab -url http://forum.xda-developers.com/z3-compact --new-tab -url http://developer.sonymobile.com/unlockbootloader/ --new-tab -url https://wiki.cyanogenmod.org/w/Google_Apps
echo "Unlocking the bootloader on a Sony device may automatically wipe internal storage; a backup of the sdcard is suggested. It will also irreversibly erase the DRM keys stored in the TA partition of some devices, which will result in the loss of certain proprietary features that may have been included."
fastboot flash boot /Downloads/**z3**.img 
fastboot reboot 
echo "Once the device boots into CyanogenMod Recovery, use the physical volume buttons to move up and down. Select wipe data/factory reset."
adb sideload update.zip
echo "On the device, navigate to the mounts and storage menu. If you see /storage/sdcard0 as a mountable volume, go ahead and mount it. If you do not see this directory, then instead mount the /data directory. Take note of which volume you mounted to write it now one or the other and push the package(s) to your device"
read $folder
adb push update.zip $folder
echo "Select reboot the system. When it is rooted press ENTER. Then you can use adb install example.apk to install in internal memory and adb install -s example.apk to install in sd card"
read $pause
fusermount -u /mnt/mobile
sudo rm -r /mnt/mobile
sudo sed -i 's/user_allow_other/#user_allow_other/g' /etc/fuse.conf
