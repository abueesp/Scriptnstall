#Build
sudo apt-get install android-tools-adb android-tools-fastboot mtp-tools mtpfs libusb-dev gmtp -y android-tools-adb android-tools-fastboot bison build-essential curl flex git gnupg gperf libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk2.8-dev libxml2 libxml2-utils lzop maven openjdk-7-jdk openjdk-7-jre pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev g++-multilib gcc-multilib lib32ncurses5-dev lib32readline-gplv2-dev lib32z1-dev -y
mkdir -p ~/bin
mkdir -p ~/android/system/vendor/cm
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
echo '\n# set PATH so it includes user private bin if it exists
\nif [ -d "$HOME/bin" ] ; then
\n    PATH="$HOME/bin:$PATH"
\nfi' >> ~/bin/.profile
cd ~/android/system/
repo init -u https://github.com/CyanogenMod/android.git -b cm-13.0
repo sync
source build/envsetup.sh
breakfast z3c
cd ..
cd ..
cd ~/android/system/vendor/cm
./get-prebuilts
cd ..
cd ..
cd ..
cd ..
cd ~/android/system/device/sony/z3c
./extract-files.sh
cd ..
cd ..
cd ..
cd ..
cd ..
echo "\nexport USE_CCACHE=1" >> sudo /etc/bash.bashrc

chroot 
brunch z3c
cd $OUT
