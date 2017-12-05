TORVERSION=7.0.10
TORLANG=en-US
PCVER=$(uname -m)
if [ $PCVER == x86_64 ]; then
    LINUXVER=64
elif [ $PCVER == i386 ] || [ $PCVER == i686 ]; then
    LINUXVER=32
else
  echo "ERROR: The system is neither 64bits nor 32 bits?"
fi
tar -xvJf tor-browser-linux$LINUXVER-"$TORVERSION"_$TORLANG.tar.xz
rm tor-browser-linux$LINUXVER-"$TORVERSION"_$TORLANG.tar.xz
sudo mv tor-browser_$TORLANG /opt/tor-browser
echo "alias tor='cd /opt/tor-browser/ && bash ./start-tor-browser.desktop && cd'" | tee -a ~/.bashrc
