
#Prntscreensound
sudo mv /usr/share/sounds/freedesktop/stereo/camera-shutter.oga /usr/share/sounds/freedesktop/stereo/camera-shutter-disabled.oga

sudo pacman -S arch-install-scripts base arm --noconfirm --needed
sudo pacman -S tor --noconfirm #--needed

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
sudo pacman -S dnsmasq --noconfirm
sudo vi -c "s/#port=5353/port=$TORPORT/g" -c ":wq" /etc/dnsmasq.conf
sudo vi -c "s/#conf-file=/usr/share/dnsmasq/trust-anchors.conf/conf-file=/usr/share/dnsmasq/trust-anchors.conf/g" -c ":wq" /etc/dnsmasq.conf
sudo vi -c "s/#dnssec/dnssec/g" -c ":wq" /etc/dnsmasq.conf
sudo vi -c "s/#no-resolv/no-resolv/g" -c ":wq" /etc/dnsmasq.conf
sudo vi -c "s/#server=/localnet/192.168.0.1server=127.0.0.1/g" -c ":wq" /etc/dnsmasq.conf
sudo vi -c "s/#listen-address=listen-address=127.0.0.1" -c ":wq" /etc/dnsmasq.conf
sudo vi -c "s/#nohook resolv.conf/nohook resolv.conf/g" -c ":wq" /etc/dhcpcd.conf
sudo dnsmasq #--needed
echo "You can run Tor DNS queries using tor-resolve duckduckgo.com"
tor-resolve duckduckgo.com
#Pacman over Tor
echo "XferCommand = /usr/bin/curl --socks5-hostname localhost:$TORPORT -C - -f %u > %o" | sudo tee -a /etc/pacman.conf

#Start Tor
tor
