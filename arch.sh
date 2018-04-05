### Restoring Windows on Grub2 ###
sudo os-prober
if [ $? -ne 0 ]
            then
                        sudo grub-mkconfig -o /boot/grub/grub.cfg
            else
                        echo "No Windows installed"
fi

### Update and Upgrade ###
sudo pacman -Syu --noconfirm 

### Tor ###
sudo pacman -S arch-install-scripts base arm --oconfirm --needed
sudo pacman -S tor --noconfirm --needed

#Run Tor as chroot
sudo find /var/lib/tor/ ! -user tor -exec chown tor:tor {} \;
sudo chown -R tor:tor /var/lib/tor/
sudo chmod -R 755 /var/lib/tor
sudo systemctl --system daemon-reload
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
sh -c "grep --color=never ^tor /etc/passwd | sudo tee -a $TORCHROOT/etc/passwd"
sh -c "grep --color=never ^tor /etc/group | sudo tee -a $TORCHROOT/etc/group"
sudo mknod -m 644 $TORCHROOT/dev/random c 1 8
sudo mknod -m 644 $TORCHROOT/dev/urandom c 1 9
sudo mknod -m 666 $TORCHROOT/dev/null c 1 3
if [[ "$(uname -m)" == "x86_64" ]]; then
  sudo cp /usr/lib/ld-linux-x86-64.so* $TORCHROOT/usr/lib/.
  sudo ln -sr /usr/lib64 $TORCHROOT/lib64
  sudo ln -s $TORCHROOT/usr/lib ${TORCHROOT}/usr/lib64
fi
echo 'alias chtor="chroot --userspec=tor:tor /opt/torchroot /usr/bin/tor"' | tee -a .bashrc
#Being able to run tor as a non-root user, and use a port lower than 1024 you can use kernel capabilities. As any upgrade to the tor package will reset the permissions, consider using pacman#Hooks, to automatically set the permissions after upgrades.
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

#Running Tor in a systemd-nspawn container with a virtual network interface [which is more secure than chroot]
TORCONTAINER=tor-exit #creating container and systemd service
SVRCONTAINERS=/srv/container
VARCONTAINERS=/var/lib/container
sudo mkdir $SVRCONTAINERS
sudo mkdir $SVRCONTAINERS/$TORCONTAINER
sudo pacstrap -i -c -d $SVRCONTAINERS/$TORCONTAINER base tor arm --noconfirm --needed
sudo mkdir $VARCONTAINERS
sudo ln -s $SVRCONTAINERS/$TORCONTAINER $VARCONTAINERS/$TORCONTAINER
sudo mkdir /etc/systemd/system/systemd-nspawn@$TORCONTAINER.service.d

sudo ifconfig #adding container ad-hoc vlan
read -p "Write network interface to create VLAN (wlp2s0 by default): " INTERFACE 
INTERFACE="${INTERFACE:=wlp2s0}"
VLANINTERFACE="${INTERFACE:0:2}.tor"
sudo ip link add link $INTERFACE name $VLANINTERFACE type vlan id $(((RANDOM%4094)+1))
networkctl

printf "[Service] 
ExecStart=
ExecStart=/usr/bin/systemd-nspawn --quiet --keep-unit --boot --link-journal=guest --network-macvlan=$VLANINTERFACE --private-network --directory=$VARCONTAINERS/$TORCONTAINER LimitNOFILE=32768" | sudo tee -a /etc/systemd/system/systemd-nspawn@tor-exit.service.d/tor-exit.conf #config file [yes, first empty ExecStart is required]
echo $(tty)
#sudo gedit $SVRCONTAINERS/$TORCONTAINER/etc/securetty
#ExecStop
#https://wiki.archlinux.org/index.php/Systemd-nspawn#root_login_fails

#Checking conf
sudo systemctl daemon-reload
systemctl start systemd-nspawn@tor-exit.service
machinectl -a
machinectl login tor-exit
networkctl
machine enable $TORCONTAINER #enable at boot

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
sed -i "s,-c -O %o %u,-c -O %o %u \nXferCommand = /usr/bin/curl --socks5-hostname localhost:$TORPORT -C - -f %u > %o,g" /etc/pacman.conf

### Shadowsocks ###
sudo pacman -S shadowsocks-qt5 shadowsocks --noconfirm --needed

### GPG2 ###
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

gpg --delete-keys 4F25E3B6 --yes
gpg --delete-keys 33BD3F06 --yes

cd ..
sudo rm -r gpg2

### Tweaks ###
#.bashrc
mv ~/.bashrc ~/.previous-bashrc
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/.bashrc

#AUR-helper and repositories
sudo pacman -S aurman --noconfirm #https://wiki.archlinux.org/index.php/AUR_helpers
echo "alias pacmansheet='firefox --new-tab https://wiki.archlinux.org/index.php/Pacman/Rosetta'" | tee -a ~/.bashrc
echo "alias purgearchrepo=echo 'aurman --stats && read -p \"Name of repo: \" REPO && paclist $REPO && sudo pacman -Rnsc $(pacman -Sl $REPO | grep \"\[installed\]\" | cut -f2 -d\' \')'" | tee -a ~/.bashrc
printf "alias kalifyarch='printf /"[archstrike] \n Server = https://mirror.archstrike.org/$arch/$repo/ /" | sudo tee -a /etc/pacman.conf && sudo pacman-key --recv-keys 9D5F1C051D146843CDA4858BDE64825E7CBC0D51 && sudo pacman-key --finger 9D5F1C051D146843CDA4858BDE64825E7CBC0D51 && sudo pacman-key --lsign-key 9D5F1C051D146843CDA4858BDE64825E7CBC0D51' | sudo tee -a ~/.bashrc"
printf "alias haskellfyarch='printf /"[haskell-core] \n Server = http://xsounds.org/~haskell/core/$arch /" | sudo tee -a /etc/pacman.conf && sudo pacman-key --recv-keys F3104992EBF24EB872B97B9C32B0B4534209170B && sudo pacman-key --finger F3104992EBF24EB872B97B9C32B0B4534209170B && sudo pacman-key --lsign-key F3104992EBF24EB872B97B9C32B0B4534209170B' | sudo tee -a ~/.bashrc"
printf "alias haskellfyarch='printf /"[quarry] \n Server = https://pkgbuild.com/~anatolik/quarry/x86_64/ /" | sudo tee -a /etc/pacman.conf && echo /"This repo has not key!/"' | sudo tee -a ~/.bashrc"
echo "Haskwell WAIs: Yesod Framework brings Wrap Server. It is better than Happstack. For small projects try Scotty that also comes with Wrap, or maybe Snap's snaplets" # https://wiki.haskell.org/Web

#unmute sound
amixer sset Master unmute
amixer cset numid=11,iface=MIXER,name='Capture Switch' off

#less sounds
sudo mv /usr/share/sounds/deepin/stereo/camera-shutter.ogg /usr/share/sounds/deepin/stereo/camera-shutter2.ogg
sudo mv /usr/share/sounds/deepin/stereo/desktop-login.ogg /usr/share/sounds/deepin/stereo/desktop-login2.ogg
sudo mv /usr/share/sounds/deepin/stereo/dialog-error.ogg /usr/share/sounds/deepin/stereo/dialog-error2.ogg
sudo mv /usr/share/sounds/deepin/stereo/suspend-resume.ogg /usr/share/sounds/deepin/stereo/suspend-resume2.ogg

#Search
sudo pacman -S mlocate recoll -y
sudo updatedb

#LANGUAGE=$(locale | grep LANG | cut -d'=' -f 2 | cut -d'_' -f 1)

# Auto-screen rotate
#sudo pacman -S autoconf-archive gtk-doc --noconfirm -needed
#git clone https://github.com/hadess/iio-sensor-proxy
#cd iio-sensor-proxy
#bash autogen.sh
#./configure --prefix=/usr --sysconfdir=/etc
#make
#sudo make install
#cd .. && rm -r iio-sensor-proxy

# Fixing bugs
sudo pacman -S deepin-api --noconfirm -needed

# Prntscreensound
sudo mv /usr/share/sounds/freedesktop/stereo/camera-shutter.oga /usr/share/sounds/freedesktop/stereo/camera-shutter-disabled.oga

### Virtualbox ###
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
wget http://download.virtualbox.org/virtualbox/$var1/$file -O $file
sudo VBoxManage extpack install $file --replace
sudo rm $file
sudo pacman -S dkms vagrant --noconfirm --needed
vagrant plugin install vagrant-vbguest
wget http://download.virtualbox.org/virtualbox/$var1/VBoxGuestAdditions_$var1.iso
sudo mv VBoxGuestAdditions_$var1.iso /usr/share/VBoxGuestAdditions_$var1.iso
echo "To insert iso additions, install first your vm"
virtualbox
vboxmanage storageattach work --storagectl IDE --port 0 --device 0 --type dvddrive --medium "/home/$USER/VBox**.iso"


### Emacs ###
sudo pacman -S emacs --noconfirm --needed
sudo pacman -S git --noconfirm --needed
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
cd ~/.emacs.d
git clone https://github.com/EnigmaCurry/emacs/find/ancient-history
wget https://github.com/ethereum/emacs-solidity/blob/master/solidity-mode.el
echo 'Carga los elementos de emacs con (add-to-list load-path "~/.emacs.d/") + (load "myplugin.el")' >> README
cd ..


### Vim ###
sudo pacman -S vim --noconfirm --needed
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh

#PATHOGENFOLDER="~/.vim/build"
#mkdir $PATHOGENFOLDER
PATHOGENFOLDER="~/.vim_runtime/sources_forked"
echo "PATHOGENFOLDER=$PATHOGENFOLDER" | tee -a .bashrc
echo 'alias pathogen="read -p \"Name of the plugin: \" PLUGINNAME && read -p \"Plugin Git link: \" PLUGINGIT && git clone $PLUGINGIT $PATHOGENFOLDER/$PLUGINNAME"' | tee -a .bashrc
echo 'alias installvimplugin="pathogen"' | tee -a .bashrc

git clone https://github.com/ocaml/merlin $PATHOGENFOLDER/merlin
git clone https://github.com/OmniSharp/omnisharp-vim $PATHOGENFOLDER/omnisharp-vim && cd $PATHOGENFOLDER/omnisharp-vim && git submodule update --init --recursive && cd server && xbuild && cd
#git clone https://github.com/rhysd/vim-crystal/ $PATHOGENFOLDER/vim-crystal
#git clone https://github.com/venantius/vim-eastwood.git $PATHOGENFOLDER/vim-eastwood
git clone https://github.com/rust-lang/rust.vim $PATHOGENFOLDER/rust
git clone https://github.com/kballard/vim-swift.git $PATHOGENFOLDER/swift
git clone --recursive https://github.com/python-mode/python-mode $PATHOGENFOLDER/python-mode
git clone https://github.com/eagletmt/ghcmod-vim $PATHOGENFOLDER/ghcmod-vim
git clone https://github.com/eagletmt/neco-ghc $PATHOGENFOLDER/neco-ghc

vimfunctions(){
echo "### Tools ###"    
echo "ack: Search tool, :grep=:ack :grepadd=:ackadd, :lgrep=LAck, and :lgrepadd=:LAckAdd (see all options with :ack ?)"
echo "bufexplorer: See and manage the current buffers(,o)"
echo "mru: Recently open files (,f)"
echo "ctrlp: Find file or a buffer(,j or c-f)" 
echo "Nerdtree and openfile under cursor: Treemaps (,nn toggle and ,nb bookmark and ,nf find, gf go open file under cursor)"
echo "Goyo.vim and vim-zenroom2: Removes all the distractions (,z)"
echo ":w (,w)"
echo "vim-yankstack: Maintains a history of previous yanks :yanks :registers (meta-p, meta-shift-p)"
echo "vim-multiple-cursors: Select multiple cursors (c-n next and c-p previous and c-x skip)"
echo "vim-fugitive: Git wrapper (:Gbrowse and :Gstatus and - for reset and p for patch and :Gcommit and :Gedit and :Gslipt and :Gvslipt and :Gtabedit and :Gdiff and :Gmove and :Ggrep and :Glog and :Gdelete and :Gread and :Gwrite)"
echo "vim-expand-region: (+ to expand the visual selection and _ to shrink it)"
echo "commentary-vim: Comments management (gcc for a line and gcap for a paragraph and gc in visual mode and :7,17Commentary)"
echo "pathogen: Install plugins and manage your vim runtimepath (use 'installvimplugin' or 'git clone https://github.com/yourplugin ~/.vim_runtime/sources_non_forked/nameofplugin' for example"
echo ""
echo "### Indenters ###"
echo "vim-indent-object: Python indenter (ai and ii and al and il)"
echo ""
echo "### Snippers ###"
echo "snipmate: Alternative to ultisnips for snippers depending the filetype (forTAB for example)" 
echo "Syntastics and linters"
echo ":setlocal spell! (,ss)"
echo "vim-syntastic : Common interface to syntax checkers for as many languages as possible (ACPI Source Language, ActionScript, Ada, Ansible configurations, API Blueprint, AppleScript, AsciiDoc, Assembly languages, BEMHTML, Bro, Bourne shell, C, C++, C#, Cabal, Chef, CMake, CoffeeScript, Coco, Coq, CSS, Cucumber, CUDA, D, Dart, DocBook, Dockerfile, Dust, Elixir, Erlang, eRuby, Fortran, Gentoo metadata, GLSL, Go, Haml, Haskell, Haxe, Handlebars, HSS, HTML, Java, JavaScript, JSON, JSX, Julia, LESS, Lex, Limbo, LISP, LLVM intermediate language, Lua, Markdown, MATLAB, Mercury, NASM, Nix, Objective-C, Objective-C++, OCaml, Perl, Perl 6, Perl POD, PHP, gettext Portable Object, OS X and iOS property lists, Pug (formerly Jade), Puppet, Python, QML, R, Racket, RDF TriG, RDF Turtle, Relax NG, reStructuredText, RPM spec, Ruby, SASS/SCSS, Scala, Slim, SML, Solidity, Sphinx, SQL, Stylus, Tcl, TeX, Texinfo, Twig, TypeScript, Vala, Verilog, VHDL, Vim help, VimL, Vue.js, xHtml, XML, XSLT, XQuery, YACC, YAML, YANG data models, YARA rules, z80, Zope page templates, and Zsh)"
echo "merlin: Ocaml syntastic"
echo "omnisharp: C# syntastic"
#echo "vim-crystal: C but with Ruby syntax syntastic"
#echo "vim-eastwood: Clojure linter syntastic"
echo "rust: Rust syntastic (:RustFmt and :Rustplay)"
echo "vim-swift: Swift syntastic (:help ft-swift)"
echo "python-mode: Python syntastic (:help pymode)"
echo "ghcmod-vim: Haskell syntastic (:help :filetype-overview and ghc-mod type and ghc-mod check or ghc-mod lint and ghc-mod expand and ghc-mod split)"
echo ""
echo "### Completions ###"
echo "neco-ghc: Haskell ghc-mod completion for neocomplcache/neocomplete/deoplete (:help compl-omni)"
}
echo vimfunctions >> $PATHOGENFOLDER/README

### Tmux ###
sudo pacman -S tmux  --noconfirm --needed
sudo rm ~/.tmux.conf~
cp ~/.tmux.conf ~/.tmux.conf~
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/.tmux.conf


### Office tools ###
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/.bc #My programmable calc
sudo pacman -S libreoffice grc unoconv detox pandoc duplicity deja-dup --noconfirm --needed #Text tools
sudo pacman -S xmlstarlet jq datamash bc gawk mawk --noconfirm --needed #XML and jquery #wc join paste cut sort uniq
sudo pacman -S blender --noconfirm --needed
sudo pacman -S krita --noconfirm --needed

sudo pacman -S xournal --noconfirm --needed && sudo pacman -Rs xournal --noconfirm
wget http://www.styluslabs.com/download/write-tgz -O write.tar.gz
tar -xf write.tar.gz && rm write.tar.gz
sudo mv /Write/Write /usr/bin/notes && rm -r Write


### Other Tools ###
sudo pacman -S brasero qemu archiso --noconfirm --needed
sudo pacman -S traceroute nmap arp-scan --noconfirm --needed
sudo pacman -S terminator htop autojump iotop vnstat at nemo task tree recordmydesktop --noconfirm --needed
REPEATVERSION=4.0.1
REPEATVER=4_0_1
wget https://github.com/repeats/Repeat/releases/download/v$REPEATVERSION/Repeat_$REPEATVER.jar -O /usr/src/repeat.jar && pacman -S jdk8-openjdk --noconfirm --needed
echo "alias repeatmouse= java -jar /usr/src/repeat.jar" | tee -a ~/.bashrc
#Blindlector: Orca

### Browsers ###
#Firefox
sudo pacman -S firefox --noconfirm --needed
sudo pacman -S firefox-developer --noconfirm --needed
cd Downloads
mkdir -p extensions
cd extensions
mkdir privacy
cd privacy
wget https://www.eff.org/files/privacy-badger-latest.xpi
wget https://addons.mozilla.org/firefox/downloads/file/706680/google_redirects_fixer_tracking_remover-3.0.0-an+fx.xpi GoogleRedirectFixer.xpi
wget https://addons.mozilla.org/firefox/downloads/file/727843/skip_redirect-2.2.1-fx.xpi SkipRedirect.xpi
wget https://addons.mozilla.org/firefox/downloads/file/808841/addon-808841-latest.xpi -O AdblockPlus.xpi 
wget https://addons.mozilla.org/firefox/downloads/latest/497366/addon-497366-latest.xpi -O DisableWebRTC.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/92079/addon-92079-latest.xpi -O CookieManager.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/383235/addon-383235-latest.xpi -O FlashDisable.xpi
wget https://addons.mozilla.org/firefox/downloads/file/281702/google_privacy-0.2.4-sm+fx.xpi -O GooglePriv.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/415846/addon-415846-latest.xpi -O SelfDestructing Cookies.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/387051/addon-387051-latest.xpi -O RemoveGoogleTracking.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/722/addon-722-latest.xpi -O NoScript.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/1865/addon-1865-latest.xpi  -O AdBlock Plus.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/496120/addon-496120-latest.xpi -O LocationGuard.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/473878/addon-473878-latest.xpi -O RandomAgentSpoofer.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/229918/addon-229918-latest.xpi -O HTTPSEverywhere.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/607454/addon-607454-latest.xpi -O UBlockOrigin.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/addon-534930-latest.xpi -O Avoid HTML5 Canvas.xpi
wget https://addons.mozilla.org/firefox/downloads/file/790214/umatrix-1.1.12-an+fx.xpi -O UMatrix.xpi
mkdir otherprivacy
wget https://addons.mozilla.org/firefox/downloads/latest/certificate-patrol/addon-6415-latest.xpi -O certificate patrol.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/6196/addon-6196-latest.xpi -O PassiveRecon.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/521554/addon-521554-latest.xpi -O DecentralEyes.xpi
cd ..
wget https://addons.mozilla.org/firefox/downloads/file/769143/blockchain_dns-1.0.9-an+fx.xpi -O Blockchaindns.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/1843/addon-1843-latest.xpi -O Firebug.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/5791/addon-5791-latest.xpi -O FlagFox.xpi
wget https://addons.mozilla.org/en-US/firefox/downloads/latest/2109/addon-2109-latest.xpi -O FEBEBackups.xpi
#wget https://addons.mozilla.org/firefox/downloads/latest/363974/addon-363974-latest.xpi -O Lightbeam.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/409964/addon-409964-latest.xpi -O VideoDownloadHelper.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/export-to-csv/addon-364467-latest.xpi -O ExportTabletoCSV.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/tabletools2/addon-296783-latest.xpi -O TableTools2.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/748/addon-748-latest.xpi -O Greasemonkey.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/7447/addon-7447-latest.xpi -O NetVideoHunter.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/1237/addon-1237-latest.xpi -O QuickJava.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/3497/addon-3497-latest.xpi -O EnglishUSDict.xpi
wget https://addons.mozilla.org/firefox/downloads/file/502726/colorfultabs-31.0.8-fx+sm.xpi -O ColorfulTabs.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/193270/addon-193270-latest.xpi -O PrintEdit.xpi
wget https://addons.mozilla.org/firefox/downloads/file/342774/tineye_reverse_image_search-1.2.1-fx.xpi -O TinyEyeReverseImageSearch.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/355192/addon-355192-latest.xpi -O MindTheTime.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/1843/addon-1843-latest.xpi -O Firebug.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/161670/addon-161670-latest.xpi -O FlashFirebug.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/tab-groups-panorama/addon-671381-latest.xpi -O Tabgroups.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/532/addon-532-latest.xpi -O LinkChecker.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/5523/addon-5523-latest.xpi -O guiconfigextraoptions.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/10586/addon-10586-latest.xpi -O URLShortener.xpi
wget https://addons.mozilla.org/firefox/downloads/file/387220/text_to_voice-1.15-fx.xpi -O TextToVoice.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/8661/addon-8661-latest.xpi -O WorldIP.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/3829/addon-3829-latest.xpi -O liveHTTPHeaders.xpi
wget https://addons.mozilla.org/firefox/downloads/file/373868/soundcloud_downloader_soundgrab-0.98-fx.xpi -O Soundcloud.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/695840/addon-695840-latest.xpi -O FlashDebugger.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/video-downloadhelper/addon-3006-latest.xpi -O VideoDownloadHelper.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/390151/addon-390151-latest.xpi -O TOS.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/3456/addon-3456-latest.xpi -O WOT.xpi
#wget https://addons.mozilla.org/firefox/downloads/latest/perspectives/addon-7974-latest.xpi -O perspectivenetworknotaries.xpi
wget https://www.roboform.com/dist/roboform-firefox.xpi
mkdir extratools
wget https://addons.mozilla.org/firefox/downloads/file/140447/cryptofox-2.2-fx.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/copy-as-plain-text/addon-344925-latest.xpi -O CopyasPlainText.xpi
wget https://addons.mozilla.org/firefox/downloads/file/229626/sql_inject_me-0.4.7-fx.xpi 
wget https://addons.mozilla.org/firefox/downloads/file/215802/rightclickxss-0.2.1-fx.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/3899/addon-3899-latest.xpi -O HackBar.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/wappalyzer/addon-10229-latest.xpi -O Wappanalyzer.xpi
wget https://addons.mozilla.org/firefox/downloads/latest/344927/addon-344927-latest.xpi -O CookieExportImport.xpi
wet https://addons.mozilla.org/firefox/downloads/file/204186/fireforce-2.2-fx.xpi 
wget https://addons.mozilla.org/firefox/downloads/file/224182/csrf_finder-1.2-fx.xpi 
wget https://addons.mozilla.org/firefox/downloads/file/345004/live_http_headers_fixed_by_danyialshahid-0.17.1-signed-sm+fx.xpi
wget https://addons.mozilla.org/firefox/downloads/file/782839/recap-1.1.8-an+fx.xpi -O RECAPforsearchingUSLawDB.xpi
cd ..
cd ..
cd ~/.mozilla/firefox/*.default
echo 'privacy.firstparty.isolate = true
privacy.resistFingerprinting = true
privacy.trackingprotection.enabled = true
browser.cache.offline.enable = false
browser.safebrowsing.malware.enabled = false
browser.safebrowsing.phishing.enabled = false
browser.send_pings = false
browser.sessionstore.max_tabs_undo = 0
accessibility.blockautorefresh = 1
browser.urlbar.speculativeConnect.enabled = false
dom.battery.enabled = false
dom.event.clipboardevents.enabled = false
geo.enabled = false
media.navigator.enabled = false
network.cookie.cookieBehavior = 1
network.cookie.lifetimePolicy = 2
webgl.disabled = true
user_pref("browser.search.defaulturl","https://searx.me/");
user_pref("browser.search.defaultenginename","Searx");
' | tee -a user.js 
cd
firefox --new-tab about:config 

#Opera
sudo pacman -S opera opera-developer --noconfirm --needed

#Vivaldi
sudo pacman -S vivaldi --noconfirm --needed

#Chromium
sudo pacman -S chromium --noconfirm --needed
#LANGUAGE=$(locale | grep LANG | cut -d'=' -f 2 | cut -d'_' -f 1)
#vi -c "s/google.com/google.jp/search?q=%s&pws=0&hl=$LANGUAGE&ei=#cns=0&gws_rd=ssl/g" -c ":wq" ~/.config/chromium/Default/Preferences
#CREATEHASH=$(sha256sum ~/.config/chromium/Default/Preferences)
#HASH=$(echo $CREATEHASH | head -n1 | sed -e 's/\s.*$//')
#HASHPREF=$(echo $HASH | awk '{print toupper($0)}')
#vi -c 's/"super_mac":".*"}}/"super_mac":"$HASHPREF"}}/g' -c ":wq" ~/.config/chromium/Default/'Secure Preferences'
chromium-browser https://chrome.google.com/webstore/detail/url-tracking-stripper-red/flnagcobkfofedknnnmofijmmkbgfamf
chromium-browser https://chrome.google.com/webstore/detail/dont-track-me-google/gdbofhhdmcladcmmfjolgndfkpobecpg
chromium-browser https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm
chromium-browser https://chrome.google.com/webstore/detail/adblock/gighmmpiobklfepjocnamgkkbiglidom
chromium-browser https://chrome.google.com/webstore/detail/form-filler/bnjjngeaknajbdcgpfkgnonkmififhfo
chromium-browser https://chrome.google.com/webstore/detail/autoform/fdedjnkmcijdhgbcmmjdogphnmfdjjik
chromium-browser https://chrome.google.com/webstore/detail/m-i-m/jlppachnphenhdidmmpnbdjaipfigoic
chromium-browser https://chrome.google.com/webstore/detail/librarian-for-arxiv-ferma/ddoflfjcbemgfgpgbnlmaedfkpkfffbm
chromium-browser https://chrome.google.com/webstore/detail/noiszy/immakaidhkcddagdjmedphlnamlcdcbg
chromium-browser https://chrome.google.com/webstore/detail/ciiva-search/fkmanbkfjcpkhonmmdopjmjopbclegel
chromium-browser https://blockchain-dns.info/files/BDNS-1.0.8.crx
chromium-browser https://chrome.google.com/webstore/detail/video-downloadhelper/lmjnegcaeklhafolokijcfjliaokphfks

#Icecat
sudo pacman -S icecat --noconfirm --needed

#Terminal explorers: Elinks

#Firejail
sudo pacman -S firejail  --noconfirm --needed

### Calc Tools ###
cd Documents
mkdir bctools
cd bctools
wget http://phodd.net/gnu-bc/code/array.bc
wget http://phodd.net/gnu-bc/code/collatz.bc    
wget http://phodd.net/gnu-bc/code/digits.bc    
wget http://phodd.net/gnu-bc/code/funcs.bc   
wget http://phodd.net/gnu-bc/code/interest.bc      
wget http://phodd.net/gnu-bc/code/melancholy.bc      
wget http://phodd.net/gnu-bc/code/primes.bc      
wget http://phodd.net/gnu-bc/code/thermometer.bc      
wget http://phodd.net/gnu-bc/code/cf.bc       
wget http://phodd.net/gnu-bc/code/complex.bc     
wget http://phodd.net/gnu-bc/code/factorial.bc      
wget http://phodd.net/gnu-bc/code/intdiff.bc      
wget http://phodd.net/gnu-bc/code/logic.bc      
wget http://phodd.net/gnu-bc/code/output_formatting.bc      
wget https://raw.githubusercontent.com/sevo/Calc/master/bc/rand.bc
cd ..
cd ..


### Python ###
sudo pacman -S python python3 --noconfirm --needed
sudo pacman -S python-pip --nonconfirm --needed

#Some Python tools
sudo -H pip install percol #Indexer
sudo -H pip install shyaml csvkit #yaml csv

#youtube-dl and soundcloud
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/bin/youtube-dl
sudo chmod a+rx /usr/bin/youtube-dl
sudo -H pip install scdl

#Saltpack
sudo -H pip install setuptools
sudo -H pip install saltpack


### Autoremove ###
sudo pacman -Rns $(pacman -Qtdq) --noconfirm

### Frugalware Stable ISO
#wget http://www13.frugalware.org/pub/frugalware/frugalware-stable-iso/fvbe-2.1-gnome-x86_64.iso


