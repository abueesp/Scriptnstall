

##Installing packages
sudo apt-get install android-tools-adb android-tools-fastboot mtp-tools mtpfs libusb-dev gmtp -y
ls -lah /usr/lib/libmtp*
wget http://downloads.sourceforge.net/project/libmtp/libmtp/1.1.11/libmtp-1.1.11.tar.gz
wget http://downloads.sourceforge.net/project/libmtp/libmtp/1.1.11/libmtp-1.1.11.tar.gz.asc
gpg --verify libmtp**.asc
tar xvf libmtp**.tar.gz
cd libmtp**/
./configure --prefix=/usr
make
sudo make install
cd ..
sudo rm -r libmtp**
##mounting
sudo lsusb
sudo mkdir /mnt/mobile
sudo chmod a+rwx /mnt/mobile
##setting
sudo mtp-detect | grep id
echo 'write this string into the file: SUBSYSTEM=="usb", ATTR{idVendor}=="VENDORID", ATTR{idProduct}=="PRODUCTID", MODE="0666" and save. Replace VENDORID with the idVendor you had noted down earlier. Similarly, replace PRODUCTID with the idProduct you had noted down. In my case, they were 0fce and 01bb respectively, but they might have been different for you.'
sudo gedit /etc/udev/rules.d/51-android.rules
sudo chmod +x /etc/udev/rules.d/51-android.rules
sudo service udev restart
sudo sed -i 's/#user_allow_other/user_allow_other/g' /etc/fuse.conf
sudo chmod a+rwx /etc/fuse.conf
sudo adduser $USER fuse
sudo xterm -e sudo gmtp #you can also use xterm -e mtpfs -o allow_other /mnt/mobile/
##backup
NOW = date
cd android-backup-extractor
wget http://downloads.sourceforge.net/project/adbextractor/android-backup-extractor-20151102-bin.zip
unzip android-backup-extractor**
cd android-backup-extractor**
adb backup -apk -shared -f backup-apps-$NOW.ab
adb backup -shared -f backup-sd-$NOW.ab
adb backup -all -f backup-all-$NOW.ab
sudo hexdump -C backup-apps-$NOW.ab
sudo hexdump -C backup-sd-$NOW.ab
sudo hexdump -C backup-all-$NOW.ab
echo "The first line is the name ANDROID BACKUP. The next line is the version of the Android Backup file format. The next line is a boolean (true or false, 1 or 0) indicating if the file is compressed. The last line is the type of encryption. This example is not using any encryption. If there was a password, the line would read AES-256. Files "
echo "introduce password if encrypted"
read $pazz
java -jar /home/$USER/android-backup-extractor**/abe.jar unpack backup-apps-$NOW.ab backup-apps-$NOW.tar $pazz
java -jar /home/$USER/android-backup-extractor**/abe.jar unpack backup-sd-$NOW.ab backup-sd-$NOW.tar $pazz
java -jar /home/$USER/android-backup-extractor**/abe.jar unpack backup-all-$NOW.ab backup-all-$NOW.tar $pazz
tar -xvf backup-apps-$NOW.tar
tar -xvf backup-sd-$NOW.tar
tar -xvf backup-all-$NOW.tar
sudo cd ..

##Second preparation
echo "HEEEEEEEYYYYYYYY  !!!! insert *#06# on the phone and take note of the IMEI while this is downloading. Also USB debugging enabled,  
Settings => About phone => Click 7 times on Android Build (Numero de Compilacion) and Model Number (en mi caso D5803) to unlock developer options and check it for later, and Settings => Developer Settings Allow mock locations (ubicaciones simuladas). DOWNLOAD giefroot and TAKE INTO ACCOUNT YOU MAY ALSO BACKUP TA PARTITION WITH DMR KEYS FOR Z3C ON WINDOWS WITH https://github.com/DevShaft/Backup-TA and http://forum.xda-developers.com/showthread.php?t=2292598  !!!!!! HEEEEEEEYYYYYYY"
read $read
firefox https://forum.xda-developers.com/z3-compact/general/how-to-root-backup-drm-keys-t3013343 && --new-tab -url https://encrypted.google.com/search?q=$read+ftf+spanish && --newtab -url https://forum.xda-developers.com/crossdevice-dev/sony/giefroot-rooting-tool-cve-2014-4322-t3011598 && --new-tab -url https://wiki.cyanogenmod.org/w/Install_CM_for_z3c --new-tab -url http://developer.sonymobile.com/unlockbootloader/ --new-tab -url https://wiki.cyanogenmod.org/w/Google_Apps && --new-tab -url https://www.movilzona.es/tutoriales/android/root/principales-comandos-para-adb-y-fastboot-guia-basica/
mkdir downm
cd downm
wget https://download.cyanogenmod.org/get/jenkins/162724/cm-12.1-20160523-NIGHTLY-z3c-recovery.img
wget https://download.cyanogenmod.org/get/jenkins/161009/cm-12.1-20160509-NIGHTLY-z3.zip
unzip cm**.zip
cd ..

#Official versions
firefox http://forum.xda-developers.com/attachment.php?attachmentid=3752944&d=1463432738
sudo apt-get install mono-complete
cd Downloads
unzip XperiFirm**.zip
sudo mozroots --import --machine --sync
sudo certmgr -ssl -m https://software.sonymobile.com
mono XperiFirm.exe
sudo rm -r XperiFirm**
cd..

##TWRP
read -p "check your TWRP img model"
wget https://dl.twrp.me/z3c/twrp-3.0.2-0-z3c.img
sudo dd if=/sdcard/twrp**.img of=/dev/block/platform/msm_sdcc.1/by-name/FOTAKernel

##ROOT
##METHOD1
wget http://d.kingoapp.com/default/KingoRoot.apk
adb install KingRoot.apk
read -p "search kingoroot on your phone and root it. Then check root with root checker on play storage"
sudo rm KingRoot.apk
##METHOD2
###Flashtool to up/downgrade
#wget http://dl-developer.sonymobile.com/code/copylefts/23.0.A.2.93.tar.bz2
#wget http://spflashtool.com/download/SP_Flash_Tool_exe_Linux_64Bit_v5.1520.00.100.zip
#unzip SP**.zip
#sudo rm SP**.zip
#cd SP
#sudo sh flash_tool.sh
#cd ..
#sudo rm -r SP**
###Root 
#mv Downloads/giefroot**.zip /home/$USER/downm/
#mv /home/$USER/giefroot**.zip /home/$USER/downm/
#unzip giefroot**.zip
#cd files 
#sh install.sh
#cd ..
#sudo rm -r giefroot**.zip files

##Fastboot
read -p "now device will be on fastboot mode. can you see the blue light of the corner?"
adb reboot bootloader
sudo fastboot getvar version
git clone https://github.com/DevShaft/Backup-TA
read -p " SONY Xperia Z To enter  into  Fastboot : (while turned off) Press and hold the  Volume Up button, at the same time plug in the micro USB cable which is already connected to PC. To enter  into  Flash Mode : (while turned off) Press and hold the  Volume Down button, at the same time plug in the micro USB cable which is already connected to PC. To enter  into Recovery: (while turned off) Power on or plug into charger and keep pressing Volume Up repeatedly. More on : http://www.droidviews.com/how-to-boot-android-devices-in-fastboot-download-bootloader-or-recovery-mode/

If you dont see the bluelight, shut down the device, start it while you are holding Volume Up and then connect the USB cable. The notification light should turn blue to indicate you are in fastboot mode. If you receive the message waiting for device fastboot is not configured properly. If you see the blue light then now you must know you are going to UNLOCK THE BOOTLOADER of your phone. If you have a Z3C DO NOT FORGET TO MAKE FIRST A BACKUP OF YOUR TA PARTITION FOR DRM FILES. YOU CAN DOWNLOAD https://github.com/DevShaft/Backup-TA FROM WINDOWS AND THEN BACKUP IF YOU ARE ROOTED. IT DOES NOT WORK WITH WINE. LINUX VERSION ON GITHUB DOES NOT WORK EITHER. BACKUP TA FIRST!!!"
read -p "Unlocking the bootloader on a Sony device may automatically wipe internal storage; a backup of the sdcard is suggested. It will also irreversibly erase the DRM keys stored in the TA partition of some devices, which will result in the loss of certain proprietary features that may have been included. LAST WARNING"
sudo fastboot devices
firefox http://developer.sonymobile.com/unlockbootloader/unlock-yourboot-loader/
read -p "Introduce 0x oem to unlock. You can get it using your IMEI on the http://developer.sonymobile.com/unlockbootloader/unlock-yourboot-loader/ Warranty is not lost by default only when you unlock properly, but you can lock again" $0xnumber
fastboot -i 0x0fce oem unlock $0xnumber
sudo fastboot flash boot cm**z3c-recovery.img
sudo fastboot reboot 
echo "Once the device boots into CyanogenMod Recovery, use the physical volume buttons to move up and down. Select wipe data/factory reset."
adb sideload update.zip
echo "On the device, navigate to the mounts and storage menu. If you see /storage/sdcard0 as a mountable volume, go ahead and mount it. If you do not see this directory, then instead mount the /data directory. Take note of which volume you mounted to write it now one or the other and push the package(s) to your device"
read $folder
adb push update.zip $folder
echo "Select reboot the system. When it is rooted press ENTER. Then you can use adb install example.apk to install in internal memory and adb install -s example.apk to install in sd card"
read $pause

##Gapps
echo "installing opengapps"
wget https://github.com/opengapps/arm64/releases/download/20160511/open_gapps-arm64-6.0-super-20160511.zip
adb push open_gapps**.zip /sdcard/
adb reboot recovery
fusermount -u /mnt/mobile
sudo rm -r /mnt/mobile
sudo sed -i 's/user_allow_other/#user_allow_other/g' /etc/fuse.conf
