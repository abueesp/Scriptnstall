

##Installing packages (specially Android Debugging Bridge)
echo 'Installing packages (specially Android Debugging Bridge)'
sudo apt-get install android-tools-adb android-tools-fastboot mtp-tools mtpfs libusb-dev gmtp unzip -y
ls -lah /usr/lib/libmtp*
wget https://sourceforge.net/projects/libmtp/files/libmtp/1.1.12/libmtp-1.1.12.tar.gz
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
sudo apt-get install xterm -y
sudo xterm -e sudo gmtp #you can also use xterm -e mtpfs -o allow_other /mnt/mobile/
sudo apt-get purge xterm -y
##Installing Android Backup Extractor
echo "Installing Android Backup Extractor"
NOW = date
wget http://downloads.sourceforge.net/project/adbextractor/android-backup-extractor-20160710-bin.zip
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
cd ..

##Second preparation
read -p "insert *#06# on the phone and take note of the IMEI while this is downloading. Also USB debugging enabled, Settings => About phone => Click 7 times on Android Build (Numero de Compilacion) and Model Number (en mi caso D5803) to unlock developer options and check it for later, and Settings => Developer Settings Allow mock locations (ubicaciones simuladas). IF YOU HAVE A SONY DEVICE INTO ACCOUNT YOU MAY ALSO BACKUP TA PARTITION WITH DMR KEYS FOR Z3C ON WINDOWS WITH git clone https://github.com/DevShaft/Backup-TA and http://forum.xda-developers.com/showthread.php?t=2292598" pause
firefox https://forum.xda-developers.com/z3-compact/general/how-to-root-backup-drm-keys-t3013343 && --new-tab -url https://encrypted.google.com/search?q=$read+ftf+spanish && --newtab -url https://forum.xda-developers.com/crossdevice-dev/sony/giefroot-rooting-tool-cve-2014-4322-t3011598 && --new-tab -url https://wiki.cyanogenmod.org/w/Install_CM_for_z3c --new-tab -url http://developer.sonymobile.com/unlockbootloader/ --new-tab -url https://wiki.cyanogenmod.org/w/Google_Apps && --new-tab -url https://www.movilzona.es/tutoriales/android/root/principales-comandos-para-adb-y-fastboot-guia-basica/
mkdir downm
cd downm
wget https://ga1.androidfilehost.com/dl/a9h_hMJ8GbiEH0eZCxoRow/1475894608/24459283995301330/D5803_23.4.A.1.264_R8C_SLiM_5.0.zip
wget https://download.cyanogenmod.org/get/jenkins/181764/cm-12.1-20161002-NIGHTLY-z3c-recovery.img
wget https://download.cyanogenmod.org/get/jenkins/181764/cm-12.1-20161002-NIGHTLY-z3c.zip
##TWRP
read -p "check your TWRP img model. Then copy all downm and the files you also want to add to sdcard1, included opengapps, and if your device is Sony consider also TA partition." pause
wget https://dl.twrp.me/z3c/twrp-3.0.2-1-z3c.img
##Gapps
read -p "installing opengapps. Please select the correct version according to your model arch and cm base ROM version" pause
wget https://github.com/opengapps/arm/releases/download/20161005/open_gapps-arm-4.4-aroma-20161005.zip
##Xposed
read -p "installing Xposed. Please select the correct version according to your model arch and cm base ROM version" pause
wget http://dl-xda.xposed.info/framework/sdk22/arm/xposed-v86-sdk22-arm.zip
wget http://dl-xda.xposed.info/framework/sdk22/arm/xposed-v86-sdk22-arm.zip.asc
gpg --verify xposed**.asc
rm xposed**.asc
wget http://dl-xda.xposed.info/framework/sdk23/arm/xposed-v87-sdk23-arm.zip
wget http://dl-xda.xposed.info/framework/sdk23/arm/xposed-v87-sdk23-arm.zip.asc
gpg --verify xposed**.asc
rm xposed**.asc
wget https://forum.xda-developers.com/attachment.php?attachmentid=3921508&d=1477916609 -O Xposed.apk
echo "Downloading SuperSu"
wget https://s3-us-west-2.amazonaws.com/supersu/download/zip/SuperSU-v2.78-20160831113855.apk
cd ..

#Official versions and twrp
firefox http://forum.xda-developers.com/attachment.php?attachmentid=3752944&d=1463432738
sudo apt-get install mono-complete
cd Downloads
unzip XperiFirm**.zip
sudo mozroots --import --machine --sync
sudo certmgr -ssl -m https://software.sonymobile.com
mono XperiFirm.exe
sudo rm -r XperiFirm**
cd ..



##ROOT
##METHOD1
#wget http://d.kingoapp.com/default/KingoRoot.apk
#adb install KingRoot.apk
#read -p "search kingoroot on your phone and root it. Then check root with root checker on play storage"
#sudo rm KingRoot.apk
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

##Root & Fastboot
cd downm
read -p "now device will be on fastboot mode. can you see the blue light of the corner?"
adb reboot bootloader
sudo fastboot getvar version
read -p " SONY Xperia Z To enter  into  Fastboot : (while turned off) Press and hold the  Volume Up button, at the same time plug in the micro USB cable which is already connected to PC. To enter  into  Flash Mode : (while turned off) Press and hold the  Volume Down button, at the same time plug in the micro USB cable which is already connected to PC. To enter  into Recovery: (while turned off) Power on or plug into charger and keep pressing Volume Up repeatedly. More on : http://www.droidviews.com/how-to-boot-android-devices-in-fastboot-download-bootloader-or-recovery-mode/
If you dont see the bluelight, shut down the device, start it while you are holding Volume Up and then connect the USB cable. The notification light should turn blue to indicate you are in fastboot mode. If you receive the message waiting for device fastboot is not configured properly. If you see the blue light then now you must know you are going to UNLOCK THE BOOTLOADER of your phone. If you have a Z3C iF YOU ARE A SONY DO NOT FORGET TO MAKE FIRST A BACKUP OF YOUR TA PARTITION FOR DRM FILES. YOU CAN DOWNLOAD git clone https://github.com/DevShaft/Backup-TA FROM WINDOWS AND THEN BACKUP IF YOU ARE ROOTED. IT DOES NOT WORK WITH WINE. LINUX VERSION ON GITHUB DOES NOT WORK EITHER. BACKUP TA FIRST!!!" pause 
read -p "Unlocking the bootloader on a Sony device may automatically wipe internal storage; a backup of the sdcard is suggested. It will also irreversibly erase the DRM keys stored in the TA partition of some devices, which will result in the loss of certain proprietary features that may have been included. LAST WARNING" pause
sudo fastboot devices
firefox http://developer.sonymobile.com/unlockbootloader/unlock-yourboot-loader/
read -p "Introduce 0x oem to unlock. You can get it using your IMEI on the http://developer.sonymobile.com/unlockbootloader/unlock-yourboot-loader/ Warranty is not lost by default only when you unlock properly, but you can lock again" $0xnumber
fastboot -i 0x0fce oem unlock $0xnumber
sudo fastboot flash recovery twrp**.img
sudo fastboot flash boot cm**z3c-recovery.img
sudo fastboot reboot 
echo "Once the device boots into CyanogenMod Recovery, use the physical volume buttons to move up and down. Select wipe data/factory reset. Then Apply Update from sdcard1 (I suppose you already copied imgs and zips from /downm to SD card)." pause
#adb sideload update.zip #this options is to load directly from adb
#adb push update.zip $folder #this options allows to load from phone or sdcard from terminal
echo "If Cyanogenmod recovery does not start, or happens a softc brick, push POWER and VOLUME UP at the same time till it starts to get blue bulb of fastboot (red is nothing, green correct, pink CM). Then repeat $ sudo fastboot getvar version $ sudo fastboot devices sudo fastboot reboot"
echo "On the device, navigate to the mounts and storage menu. If you see /storage/sdcard0 as a mountable volume, go ahead and mount it. If you do not see this directory, then instead mount the /data directory. Take note of which volume you mounted to write it now one or the other and push the package(s) to your device"
echo "Select reboot the system. When it is rooted press ENTER. Then you can use adb install example.apk to install in internal memory and adb install -s example.apk to install in sd card. Configure you phone and push INTRO when you are ready to install OpenGapps"
read -p "When you see your OS working correctly then push ENTER" pause
cd ..
adb reboot recovery
fusermount -u /mnt/mobile
sudo rm -r /mnt/mobile
sudo sed -i 's/user_allow_other/#user_allow_other/g' /etc/fuse.conf
sudo rm -r /downm

##Installing Android Studio SDK
echo 'Installing Android Studio SDK'
sudo apt-get install libdconf-dev libnotify-dev intltool libgtk2.0-dev libgtk-3-dev libdbus-1-dev -y
wget https://github.com/ibus/ibus/releases/download/1.5.15/ibus-1.5.15.tar.gz
tar -xvf ibus-**.tar.gz
cd ibus**
sudo apt-get install intltool libgtk-3-dev libnotify-dev dconf. -y
./configure --prefix=/usr --sysconfdir=/etc && make
sudo make install
cd ..
sudo rm -r ibus**
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer
sudo apt-get install oracle-java7-set-default
sudo javac -version
wget https://fossies.org/linux/misc/android-studio-ide-162.3764568-linux.zip
sha1 = $(sha1sum **-linux.zip)
if [ $sha1 "517fc0ffe135c52e22d3f6a8165ea9b7b68f2d7e" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
unzip android-studio-ide-**-linux.zip
cd android-studio
cd bin
./studio.sh
echo 'Android SDK installed. Run it using "androidsdk" (you also have "androidsheet". You can now also emulate a virtual device using the green insect symbol.'
##APKdecompiler
sudo apt-get install oracle-java7-installer
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update -y
sudo sudo apt-get install oracle-java7-installer  openjdk-7-jre openjdk-7-jdk -y
sudo apt-get install openjdk-7-jre
wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.2.2.jar
mv apktool**.jar apktool.jar
sudo chmod +x apktool
sudo chmod +x apktool.jar
echo 'APKdecompiler Apktool installed. Run it using decompileapk <nameof.apk>'
##APKsigner
git clone https://github.com/appium/sign
mv sign/** .
sudo rm -r sign
cd
echo 'APKsigner installed. Run it using signapk <nameof.apk>'

##Write disable protection for Xperia
firefox "https://mega.nz/#!CJMzVTJD!INyqTPX601_cFJbpNHM9iNoOTu8NC1_3I8Pqq9OHrs0"
