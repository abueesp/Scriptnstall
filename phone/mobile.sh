
##Installing packages (specially Android Debugging Bridge)
echo 'Installing packages (specially Android Debugging Bridge)'
sudo apt-get install android-tools-adb android-tools-fastboot mtp-tools mtpfs libusb-dev gmtp unzip -y
ls -lah /usr/lib/libmtp*
LIBMTPVERSION=1.1.13
wget https://sourceforge.net/projects/libmtp/files/libmtp/$LIBMTPVERSION/libmtp-$LIBMTPVERSION.tar.gz
wget https://sourceforge.net/projects/libmtp/files/libmtp/$LIBMTPVERSION/libmtp-$LIBMTPVERSION.tar.gz.asc
gpg2 --verify libmtp-$LIBMTPVERSION.tar.gz.asc libmtp-$LIBMTPVERSION.tar.gz
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
    rm libmtp-$LIBMTPVERSION.tar.gz.asc
else
    echo "BAD SIGNATURE"
    break
fi
tar xvf libmtp-$LIBMTPVERSION.tar.gz
rm libmtp-$LIBMTPVERSION.tar.gz
cd libmtp-$LIBMTPVERSION
./configure --prefix=/usr
make
sudo make install
cd ..
sudo rm -r libmtp-$LIBMTPVERSION


##FOR PHYSICAL PHONE##
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
echo 'check your permissions for usb connection on settings'
sudo apt-get install xterm -y
sudo xterm -e sudo gmtp #you can also use xterm -e mtpfs -o allow_other /mnt/mobile/
sudo apt-get purge xterm -y
##Installing Android Backup Extractor
echo "Installing Android Backup Extractor"
NOW = $(date)
wget http://downloads.sourceforge.net/project/adbextractor/android-backup-extractor-20160710-bin.zip
unzip android-backup-extractor**
cd android-backup-extractor**
echo "introduce password for encryption"
adb backup -apk -shared -f backup-apps-$NOW.ab
adb backup -shared -f backup-sd-$NOW.ab
adb backup -all -f backup-all-$NOW.ab
sudo hexdump -C backup-apps-$NOW.ab
sudo hexdump -C backup-sd-$NOW.ab
sudo hexdump -C backup-all-$NOW.ab
echo "The first line is the name ANDROID BACKUP. The next line is the version of the Android Backup file format. The next line is a boolean (true or false, 1 or 0) indicating if the file is compressed. The last line is the type of encryption. This example is not using any encryption. If there was a password, the line would read AES-256. Files "
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
firefox https://forum.xda-developers.com/z3-compact/general/how-to-root-backup-drm-keys-t3013343 --new-tab https://encrypted.google.com/search?q=$read+ftf+spanish && --newtab -url https://forum.xda-developers.com/crossdevice-dev/sony/giefroot-rooting-tool-cve-2014-4322-t3011598 && --new-tab -url https://wiki.cyanogenmod.org/w/Install_CM_for_z3c --new-tab -url http://developer.sonymobile.com/unlockbootloader/ --new-tab -url https://wiki.cyanogenmod.org/w/Google_Apps --new-tab -url https://www.movilzona.es/tutoriales/android/root/principales-comandos-para-adb-y-fastboot-guia-basica/
mkdir downm
cd downm
read -p "check your ROM kernel version at https://cve.lineageos.org/ " 
#wget https://download.cyanogenmod.org/get/jenkins/181764/cm-12.1-20161002-NIGHTLY-z3c-recovery.img
#wget https://download.cyanogenmod.org/get/jenkins/181764/cm-12.1-20161002-NIGHTLY-z3c.zip
##LineageOS from https://forum.xda-developers.com/z3-compact/orig-development/rom-unofficial-lineageos-14-1-t3577224
LINEAGEVERSION=14.1-20170607-UNOFFICIAL-z3c
wget http://tx2.androidfilehost.com/dl/X8zHn75ah6jBrWg1NaSWnw/1497255668/673368273298961502/lineage-$LINEAGEVERSION.zip
echo "0fdf63424bfc7096995ed12eef38d262  lineage-$LINEAGEVERSION.zip" >> lineage-$LINEAGEVERSION.zip.md5
if md5sum -c lineage-$LINEAGEVERSION.zip; then
    echo 'The MD5 sum matched'
else
    echo 'The MD5 sum didnt match'
    break
fi
echo 'Please notice this TWRP already includes FOTAKernel' #Source https://www.androidfilehost.com/?fid=961840155545571844
TWRPVERSION=z3c_2017-04-26
wget https://tx4.androidfilehost.com/dl/sXOv1na6Id2t2Ssy4v3mqA/1502726807/961840155545571844/twrp_z3c_2017-04-26.img
echo "52d7a1caf4b22e43fa165e3b640d29e0  twrp_$TWRPVERSION.img" >> twrp_$TWRPVERSION.img.md5
if md5sum -c twrp_$TWRPVERSION.img; then
    echo 'The MD5 sum matched'
else
    echo 'The MD5 sum didnt match'
    break
fi

##TWRP
read -p "Check your TWRP img model. Then copy all downm and the files you also want to add to sdcard1, included opengapps, and if your device is Sony consider also TA partition." pause
wget --referer=https://eu.dl.twrp.me/z3c/twrp-3.0.2-1-z3c.img.html https://eu.dl.twrp.me/z3c/twrp-3.0.2-1-z3c.img
wget https://eu.dl.twrp.me/public.asc
gpg2 --verify public.asc twrp*.img
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
    rm xposed-v86-sdk22-arm.zip.asc
else
    echo "BAD SIGNATURE"
    break
fi

##Gapps
read -p "installing opengapps. Please select the correct version according to your model arch and cm base ROM version" pause
wget https://github.com/opengapps/arm/releases/download/20170601/open_gapps-arm-7.1-aroma-20170601.zip
##Xposed
read -p "installing Xposed. Please select the correct version according to your model arch and cm base ROM version" pause
wget http://dl-xda.xposed.info/framework/sdk22/arm/xposed-v86-sdk22-arm.zip
wget http://dl-xda.xposed.info/framework/sdk22/arm/xposed-v86-sdk22-arm.zip.asc
gpg2 --verify xposed-v86-sdk22-arm.zip.asc xposed-v86-sdk22-arm.zip
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
    rm xposed-v86-sdk22-arm.zip.asc
else
    echo "BAD SIGNATURE"
    break
fi
wget http://dl-xda.xposed.info/framework/sdk23/arm/xposed-v87-sdk23-arm.zip
wget http://dl-xda.xposed.info/framework/sdk23/arm/xposed-v87-sdk23-arm.zip.asc
gpg2 --verify xposed-v86-sdk23-arm.zip.asc xposed-v86-sdk23-arm.zip
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
    rm xposed-v86-sdk23-arm.zip.asc
else
    echo "BAD SIGNATURE"
    break
fi
gpg --verify xposed**.asc
wget https://forum.xda-developers.com/attachment.php?attachmentid=3921508&d=1477916609 -O Xposed.apk
echo "Downloading SuperSu"
#normal supersu
wget https://s3-us-west-2.amazonaws.com/supersu/download/zip/SuperSU-v2.79-20161205182033.apk
#lineageos supersu 
wget https://mirrorbits.lineageos.org/su/addonsu-14.1-arm-signed.zip
wget https://mirrorbits.lineageos.org/su/addonsu-remove-14.1-arm-signed.zip
wget https://mirrorbits.lineageos.org/su/addonsu-remove-14.1-arm-signed.zip?sha256
sha256sum -c addonsu-14.1-arm-signed.zip?sha256 | grep 'OK\|coincide'
sha256sum -c addonsu-remove-14.1-arm-signed.zip?sha256 | grep 'OK\|coincide'
read -p "Were the two checks 0K?"
rm addonsu-14.1-arm-signed.zip?sha256
rm addonsu-remove-14.1-arm-signed.zip?sha256
echo "Download the latest magisk app, remover and manager"
firefox https://forum.xda-developers.com/apps/magisk
##Write disable protection for Xperia
firefox "https://mega.nz/#!CJMzVTJD!INyqTPX601_cFJbpNHM9iNoOTu8NC1_3I8Pqq9OHrs0"
cd ..

#Official firmware
firefox http://forum.xda-developers.com/attachment.php?attachmentid=3752944&d=1463432738
sudo apt-get install mono-complete
cd Downloads
wget http://www-support-downloads.sonymobile.com/Software%20Downloads/Xperia%20Companion/XperiaCompanion.exe
sudo mozroots --import --machine --sync
sudo certmgr -ssl -m https://software.sonymobile.com
mono XperiaCompanion.exe
sudo rm -r XperiaCompanion**
cd ..

##Root & Fastboot
cd downm
adb kill-server
adb reboot bootloader
read -p "now device will be on fastboot mode. you will see a blue light of the corner."
sudo adb start-server
sudo fastboot getvar version
read -p " SONY Xperia Z To enter  into  Fastboot : (while turned off) Press and hold the  Volume Up button, at the same time plug in the micro USB cable which is already connected to PC. To enter  into  Flash Mode : (while turned off) Press and hold the  Volume Down button, at the same time plug in the micro USB cable which is already connected to PC. To enter  into Recovery: (while turned off) Power on or plug into charger and keep pressing Volume Up repeatedly. More on : http://www.droidviews.com/how-to-boot-android-devices-in-fastboot-download-bootloader-or-recovery-mode/ If you dont see the bluelight, shut down the device, start it while you are holding Volume Up and then connect the USB cable. The notification light should turn blue to indicate you are in fastboot mode. If you receive the message waiting for device fastboot is not configured properly. If you see the blue light then now you must know you are going to UNLOCK THE BOOTLOADER of your phone. If you have a Z3C iF YOU ARE A SONY DO NOT FORGET TO MAKE FIRST A BACKUP OF YOUR TA PARTITION FOR DRM FILES. YOU CAN DOWNLOAD git clone https://github.com/DevShaft/Backup-TA FROM WINDOWS AND THEN BACKUP IF YOU ARE ROOTED. IT DOES NOT WORK WITH WINE. LINUX VERSION ON GITHUB DOES NOT WORK EITHER. BACKUP TA FIRST!!!" pause 
read -p "Unlocking the bootloader on a Sony device may automatically wipe internal storage; a backup of the sdcard is suggested. It will also irreversibly erase the DRM keys stored in the TA partition of some devices, which will result in the loss of certain proprietary features that may have been included. LAST WARNING" pause
sudo fastboot devices
firefox http://developer.sonymobile.com/unlockbootloader/unlock-yourboot-loader/
read -p "Introduce 0x oem to unlock. You can get it using your IMEI on the http://developer.sonymobile.com/unlockbootloader/unlock-yourboot-loader/ Warranty is not lost by default only when you unlock properly, but you can lock again" $0xnumber
fastboot -i 0x0fce oem unlock $0xnumber
sudo fastboot flash recovery twrp**.img
#sudo fastboot flash boot cm**z3c-recovery.img
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
sudo sed -i 's/user_allow_other/#user_al/low_other/g' /etc/fuse.conf
sudo rm -r /downm


###APP DEVELOPMENT###
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
sudo apt-get install oracle-java7-installer oracle-java7-set-default -y
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
###Other
echo "A general routing for app mod might be:
echo "adb install app.apk; apktool d app.apk; modify; apktool b app.apk; signapk appmod.apk (or jarsigner -verbose -keystore ~testkey.keystore appmod.apk testkey); adb uninstall app.apk; adb install appmod.apk"
echo "For other tools and further mobile inspection, just try https://santoku-linux.com/"

###FOR DIGITAL PHONE####
###Anbox: Android Apps on Linux 
sudo apt-get install snapd
sudo snap install --classic anbox-installer 
wget https://raw.githubusercontent.com/anbox/anbox-installer/master/installer.sh
chmod +x installer.sh
bash installer.sh
rm installer.sh
echo "Android OS: Remix OS http://www.jide.com/remixos-for-pc" 
wget https://f-droid.org/FDroid.apk
adb install FDroid.apk
