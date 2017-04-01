sudo apt-get install apt-transport-https apt-transport-tor -y
sudo sed -i 's/http:\/\/us.archive.ubuntu.com\/ubuntu/https:\/\/mirror.cpsc.ucalgary.ca\/mirror\/ubuntu.com\/packages\//g' /etc/apt/sources.list
sudo apt-get install tor -y


#python libraries for terminal
sudo -H pip install --upgrade pip
sudo -H pip install requests urllib**
sudo -H  pip install beautifulsoup
sudo easy_install requests-toolbelt
sudo -H  pip install contextlib #for aleatority model close session
sudo -H  pip install time for aleatority model wait
#requesocks
wget https://pypi.python.org/packages/2b/33/0ecebf3903181cd74d9ff885da4029f59e5f61c99dc66f39c5a170a66d27/requesocks-0.10.8.tar.gz
tar -zxvf requesocks**.gz
cd requesocks**
sudo python setup.py install
rm requesocks**.gz
sudo apt-get install python-socksipy #other option to socks5 if not working properly yet

#install last version of openssl
sudo dpkg --remove --force-depends openssl
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
sudo make MANDIR=/usr/share/man MANSUFFIX=ssl install
sudo install -dv -m755 /usr/share/doc/openssl-** #check the version
sudo cp -vfr doc/*     /usr/share/doc/openssl-**

sudo apt-get install tor deb.torproject.org-keyring
tor
export http_proxy='http://localhost:9010'  #the port is on 9010 instead of 9050
export https_proxy='http://localhost:9010'

#Configure Firefox to tunnel requests to .onion domains via the Tor network
#and Configure Firefox to tunnel DNS queries via a SOCKS5 proxy

function FindProxyForURL(url, host) {
       isp = "PROXY ip_address:port; DIRECT";
           tor = "SOCKS 127.0.0.1:9050";
               if (shExpMatch(host,"*.onion")) {
                           return tor;
                               }
                                   return "DIRECT";
 } | sudo tee -a ~/proxy.pac
 
 
 echo "Add file://home/node/$USER/proxy.pac route to Edit->Preferences->Advanced->Network->Settings->Automatic proxy configuration URL. Then search for  network.proxy.    socks in about:config and put network.proxy.socks_remote_dns to true"


##proxychains
git clone https://github.com/rofl0r/proxychains-ng
./configure --prefix=/usr --sysconfdir=/etc
make
sudo make install
sudo make install-config
proxychains4 firefox
proxychains bash


