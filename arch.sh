#Update and Upgrade
sudo pacman -Syu --noconfirm 

#Restoring Windows on Grub2
sudo os-prober
if [ $? -eq 0 ]
            then
                sudo grub-mkconfig -o /boot/grub/grub.cfg
            else
                echo "No Windows installed"
            fi
            
#Prntscreensound
sudo mv /usr/share/sounds/freedesktop/stereo/camera-shutter.oga /usr/share/sounds/freedesktop/stereo/camera-shutter-disabled.oga

#Tor
sudo pacman -S arch-install-scripts base arm --noconfirm --needed
sudo pacman -S tor --noconfirm --needed

#Run Tor as chroot
sudo find /var/lib/tor/ ! -user tor -exec chown tor:tor {} \;
sudo chown -R tor:tor /var/lib/tor/
sudo chmod -R 755 /var/lib/tor
systemctl --system daemon-reload

export TORCHROOT=/opt/torchroot
sudo mkdir -p $TORCHROOT
sudo mkdir -p $TORCHROOT/etc/tor
sudo mkdir -p $TORCHROOT/dev
sudo mkdir -p $TORCHROOT/usr/bin
sudo mkdir -p $TORCHROOT/usr/lib
sudo mkdir -p $TORCHROOT/usr/share/tor
sudo mkdir -p $TORCHROOT/var/lib
sudo ln -s /usr/lib  $TORCHROOT/lib
sudo cp /etc/hosts           $TORCHROOT/etc/
sudo cp /etc/host.conf       $TORCHROOT/etc/
sudo cp /etc/localtime       $TORCHROOT/etc/
sudo cp /etc/nsswitch.conf   $TORCHROOT/etc/
sudo cp /etc/resolv.conf     $TORCHROOT/etc/
sudo cp /etc/tor/torrc       $TORCHROOT/etc/tor/
sudo cp /usr/bin/tor         $TORCHROOT/usr/bin/
sudo cp /usr/share/tor/geoip* $TORCHROOT/usr/share/tor/
sudo cp /lib/libnss* /lib/libnsl* /lib/ld-linux-*.so* /lib/libresolv* /lib/libgcc_s.so* $TORCHROOT/usr/lib/
sudo cp $(ldd /usr/bin/tor | awk '{print $3}'|grep --color=never "^/") $TORCHROOT/usr/lib/
sudo cp -r /var/lib/tor      $TORCHROOT/var/lib/
sudo chown -R tor:tor $TORCHROOT/var/lib/tor
sh -c "grep --color=never ^tor /etc/passwd > $TORCHROOT/etc/passwd"
sh -c "grep --color=never ^tor /etc/group > $TORCHROOT/etc/group"
mknod -m 644 $TORCHROOT/dev/random c 1 8
mknod -m 644 $TORCHROOT/dev/urandom c 1 9
mknod -m 666 $TORCHROOT/dev/null c 1 3
if [[ "$(uname -m)" == "x86_64" ]]; then
  sudo cp /usr/lib/ld-linux-x86-64.so* $TORCHROOT/usr/lib/.
  sudo ln -sr /usr/lib64 $TORCHROOT/lib64
  sudo ln -s $TORCHROOT/usr/lib ${TORCHROOT}/usr/lib64
fi
echo 'alias chtor="chroot --userspec=tor:tor /opt/torchroot /usr/bin/tor"' | tee -a .bashrc

#If you want to run tor as a non-root user, and use a port lower than 1024 you can use kernel capabilities. As any upgrade to the tor package will reset the permissions, consider using pacman#Hooks, to automatically set the permissions after upgrades.
sudo setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/tor
echo "[Action]
Description = Ports lower than 1024 available for Tor
Exec = sudo setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/tor" | sudo tee -a /usr/share/libalpm/hooks/tor.hook
TORPORT=$(shuf -i 2000-65000 -n 1)
echo "TORPORT $TORPORT"
TORCONTROLPORT=$(shuf -i 2000-65000 -n 1)
echo "TORCONTROLPORT $TORCONTROLPORT"
TORHASH=$(echo -n $RANDOM | sha256sum)
sudo vi -c "s/#SocksPort 9050/SocksPort $TORPORT/g" -c ":wq" /etc/tor/torrc
sudo vi -c "s/#ControlPort 9051/#ControlPort $TORCONTROLPORT/g" -c ":wq" /etc/tor/torrc
sudo vi -c "s/#HashedControlPassword*$/#HashedControlPassword 16:${HASH:-2}/g" -c ":wq" /etc/tor/torrc

#Running Tor in a systemd-nspawn container with a virtual network interface [which is more scure than chroot]
sudo mkdir /srv/container
sudo mkdir /srv/container/tor-exit
sudo pacstrap -i -c -d /srv/container/tor-exit base tor arm
sudo mkdir /var/lib/container
sudo ln -s /srv/container/tor-exit /var/lib/container/tor-exit
sudo mkdir /etc/systemd/system/systemd-nspawn@tor-exit.service.d
echo "[Service]
ExecStart=
ExecStart=/usr/bin/systemd-nspawn --quiet --keep-unit --boot --link-journal=guest --network-macvlan=$INTERFACE --private-network --directory=/var/lib/container/%i
LimitNOFILE=32768" | tee -a /etc/systemd/system/systemd-nspawn@tor-exit.service.d/tor-exit.conf
#Checking conf
machinectl login tor-exit
systemd-nspawn@tor-exit.service
networkctl

#All DNS queries to Tor
echo "DNSPort $TORPORT
AutomapHostsOnResolve 1
AutomapHostsSuffixes .exit,.onion" | sudo tee -a /etc/tor/torrc
sudo pacman -S dnsmasq --noconfirm --needed
sudo vi -c "s/#port=5353/port=$TORPORT/g" -c ":wq" /etc/dnsmasq.conf
sudo vi -c "s/#conf-file=/usr/share/dnsmasq/trust-anchors.conf/conf-file=/usr/share/dnsmasq/trust-anchors.conf/g" -c ":wq" /etc/dnsmasq.conf
sudo vi -c "s/#dnssec/dnssec/g" -c ":wq" /etc/dnsmasq.conf
sudo vi -c "s/#no-resolv/no-resolv/g" -c ":wq" /etc/dnsmasq.conf
sudo vi -c "s/#server=/localnet/192.168.0.1server=127.0.0.1/g" -c ":wq" /etc/dnsmasq.conf
sudo vi -c "s/#listen-address=listen-address=127.0.0.1" -c ":wq" /etc/dnsmasq.conf
sudo vi -c "s/#nohook resolv.conf/nohook resolv.conf/g" -c ":wq" /etc/dhcpcd.conf
sudo dnsmasq 
echo "You can run Tor DNS queries using tor-resolve duckduckgo.com"
tor-resolve duckduckgo.com
#Pacman over Tor
echo "XferCommand = /usr/bin/curl --socks5-hostname localhost:$TORPORT -C - -f %u > %o" | sudo tee -a /etc/pacman.conf

#Start Tor
tor

#GPG2
mkdir gpg2
cd gpg2

gpg --keyserver hkp://pgp.mit.edu --recv-keys 4F25E3B6
gpg --keyserver hkp://pgp.mit.edu --recv-keys 33BD3F06

installfunction(){
wget https://www.gnupg.org/ftp/gcrypt/$NAME/$NAME-$VERSION.tar.bz2
sha1=$(sha1sum $NAME-$VERSION.tar.bz2)
if [ "$sha1" == "$SHA  $NAME-$VERSION.tar.bz2" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    exit
fi
wget https://www.gnupg.org/ftp/gcrypt/$NAME/$NAME-$VERSION.tar.bz2.sig
gpg --verify $NAME-$VERSION.tar.bz2.sig $NAME-$VERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    exit
fi
tar xvjf $NAME-$VERSION.tar.bz2
cd $NAME-$VERSION
./configure
sudo make
sudo make install
cd ..
rm $NAME-$VERSION.tar.bz2 
rm $NAME-$VERSION.tar.bz2.sig
sudo rm -r $NAME-$VERSION
}

NAME=libgpg-error
VERSION=1.28
SHA=2b9baae264f3e82ebe00dcd10bae3f2d64232c10
#installfunction

NAME=libgcrypt
VERSION=1.8.2
SHA=ab8aae5d7a68f8e0988f90e11e7f6a4805af5c8d
installfunction

NAME=libassuan
VERSION=2.5.1
SHA=c8432695bf1daa914a92f51e911881ed93d50604
installfunction

NAME=npth
VERSION=1.5
SHA=93ddf1a3bdbca00fb4cf811498094ca61bbb8ee1
installfunction

NAME=gnupg
VERSION=2.2.5
SHA=9dec110397e460b3950943e18f5873a4f277f216
installfunction

NAME=gpgme
VERSION=1.10.0
SHA=77d3390887da25ed70b7ac04392360efbdca501f
installfunction

NAME=gpa
VERSION=0.9.10
SHA=c629348725c1bf5dafd57f8a70187dc89815ce60
installfunction

gpg --delete-keys 4F25E3B6
gpg --delete-keys 33BD3F06

cd ..
sudo rm -r gpg2

#Virtualbox
sudo pacman -S virtualbox-host-modules-arch qt4 virtualbox --noconfirm --needed
sudo gpasswd -a $USER vboxusers
sudo /sbin/rcvboxdrv setup
version=$(vboxmanage -v)
echo $version
var1=$(echo $version | cut -d 'r' -f 1)
echo $var1
var2=$(echo $version | cut -d 'r' -f 2)
echo $var2
file="Oracle_VM_VirtualBox_Extension_Pack-$var1.vbox-extpack"
echo $file
sudo wget http://download.virtualbox.org/virtualbox/$var1/$file -O $file
sudo VBoxManage extpack install $file --replace
sudo rm $file
sudo pacman -S dkms vagrant --noconfirm --needed
vagrant plugin install vagrant-vbguest
wget http://download.virtualbox.org/virtualbox/$var1/VBoxGuestAdditions_$var1.iso
sudo mv VBoxGuestAdditions_$var1.iso /usr/share/VBoxGuestAdditions_$var1.iso
echo "To insert iso additions, install first your vm"
virtualbox
vboxmanage storageattach work --storagectl IDE --port 0 --device 0 --type dvddrive --medium "/home/$USER/VBox**.iso"

#Emacs
sudo pacman -S emacs --noconfirm --needed
sudo pacman -S git --noconfirm --needed
git clone http://github.com/syl20bnr/spacemacs ~/.emacs.d
cd ~/.emacs.d
wget http://github.com/ethereum/emacs-solidity/blob/master/solidity-mode.el
echo 'Carga los elementos de emacs con (add-to-list load-path "~/.emacs.d/") + (load "myplugin.el")' >> README
cd ..

#Tmux
sudo pacman -S tmux  --noconfirm --needed
sudo rm ~/.tmux.conf~
cp ~/.tmux.conf ~/.tmux.conf~
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/.tmux.conf

#Office
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/.bc
sudo pacman -S libreoffice grc unoconv detox pandoc duplicity deja-dup --noconfirm --needed
sudo pacman -S  xmlstarlet jq datamash bc gawk mawk --noconfirm --needed #xml and jquery #wc join paste cut sort uniq
sudo pacman -S blender --noconfirm --needed

#Other Tools
sudo pacman -S traceroute nmap arp-scan -noconfirm --needed
sudo pacman -S terminator htop autojump iotop vnstat at nemo task tree recordmydesktop --noconfirm --needed

#Explorers
