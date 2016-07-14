#!/bin/bash
wget http://dl.winehq.org/wine/source/1.8/wine-1.8.2.tar.bz2
tar -jxvf wine**.bz2
cd wine**
sudo apt-get build-dep wine1.6
./configure --enable-win64
make
sudo make install
sudo apt-get install winetrics -y
winetricks msxml3 dotnet20 gdiplus riched20 riched30 vcrun2005sp1
#sudo wine64 cmd $filewine
#sudo make uninstall
#sudo apt-get purge winetricks bison comerr-dev docbook docbook-dsssl docbook-to-man docbook-utils docbook-xsl execstack flex fontforge fontforge-common gir1.2-gst-plugins-base-0.10 gir1.2-gstreamer-0.10 jadetex krb5-multidev libasound2-dev libavahi-client-dev libavahi-common-dev libbison-dev libcapi20-3 libcapi20-dev libcups2-dev libdrm-amdgpu1 libdrm-dev libfl-dev libfontforge1 libgdraw4 libgl1-mesa-dev libglu1-mesa-dev libgphoto2-dev libgsm1-dev libgssrpc4 libgstreamer-plugins-base0.10-dev libgstreamer0.10-dev libieee1284-3-dev libkadm5clnt-mit9 libkadm5srv-mit9 libkdb5-7 libkrb5-dev libldap2-dev libmpg123-dev libodbc1 libopenal-dev libosmesa6 libosmesa6-dev libosp5 libostyle1c2 libptexenc1 libpulse-dev libsane-dev libsgmls-perl libsp1c2 libspiro0 libuninameslist0 libusb-1.0-0-dev libv4l-dev libv4l2rds0 libx11-xcb-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-glx0-dev libxcb-present-dev libxcb-randr0 libxcb-randr0-dev libxcb-shape0-dev libxcb-sync-dev libxcb-xfixes0-dev libxshmfence-dev libxslt1-dev libxxf86vm-dev luatex lynx lynx-cur m4 mesa-common-dev ocl-icd-libopencl1 odbcinst odbcinst1debian2 opencl-headers openjade oss4-dev prelink sgml-data sgmlspl sp tex-common texlive-base texlive-binaries texlive-fonts-recommended texlive-generic-recommended texlive-latex-base texlive-latex-recommended tipa unixodbc unixodbc-dev valgrind x11proto-dri2-dev x11proto-gl-dev x11proto-xf86vidmode-dev

