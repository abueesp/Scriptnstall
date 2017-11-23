read -p "Be sure of having last version of kernel, bash, browser, openssl and gpg2. Disconnect connected any connected app, and avoid fingerprints such as adblock (you may also want to use Random Agent Spoofer). Deactivating browser.cache in about:config in your browser, and Polipo (set by default), could also be used for fingerprinting. Activate your VPN . Use the commands changemymac and changemyhost first, and cleanall or cleanexcept (cache, memory, history...)"
#Check arrow for python
sudo apt-get install apt-transport-https apt-transport-tor -y
sudo sed -i 's/http:\/\/us.archive.ubuntu.com\/ubuntu/https:\/\/mirror.cpsc.ucalgary.ca\/mirror\/ubuntu.com\/packages\//g' /etc/apt/sources.list
sudo apt-get install tor -y

echo "VirtualAddrNetwork 10.192.0.0/10
#define a non-standard ports to not conflicts with other tor instances
TransPort 127.0.0.1:9040 IsolateClientAddr IsolateSOCKSAuth IsolateClientProtocol IsolateDestPort IsolateDestAddr
SocksPort 127.0.0.1:9050 IsolateClientAddr IsolateSOCKSAuth IsolateClientProtocol IsolateDestPort IsolateDestAddr
DNSPort 127.0.0.1:53
AutomapHostsOnResolve 1
AutomapHostsSuffixes .exit,.onion
#daemonize
RunAsDaemon 1
#sandbox
Sandbox 1
#use hardware accaleration when possible for crypto
HardwareAccel 1
#socket safety hacks
TestSocks 1
WarnUnsafeSocks 1
AllowNonRFC953Hostnames 0
AllowDotExit 0
WarnPlaintextPorts 23,109,110,143,80
#dns safety hacks
ClientRejectInternalAddresses 1
#circuit hacks
NewCircuitPeriod 40
MaxCircuitDirtiness 600
MaxClientCircuitsPending 48
UseEntryGuards 1
UseEntryGuardsAsDirGuards 1
EnforceDistinctSubnets 1
#ok, it is a bit complex, so i will spend more words here:
#this option means that tor will try to use the previously used
#exit node for these domains, this is helpful in case of
#websites with sessions related to your IP that may change
#their behavior if your ip changes, but this option may help
#websites to associate all your actions to a single
#navigation session, by watching your IP.
#
#We decided to use it for the following addresses
#because they track you anyway by using cookies
#(so they will know who you are wven if you
#change IP), so we decided to use the IP of the
#same exit node in order to not let these services
#map your exit nodes pool, so they will know
#only one of the exit nodes in your pool.
TrackHostExits .facebook.com,.facebook.net,.twitter.com,.fbcdn.com,.fbcdn.net,.akamaihd.com,.google.com,.google.it,.google.fr,.google.de,.google.br,.yandex.ru,.yandex.com,.gmail.com,.googleapis.com,.gstatic.com,.adform.net,.google-analitics.com,.googletagservices.com
ExcludeNodes {US},{FR},{UK},{GB}
ExitNodes 217.115.10.132,217.115.10.131,{kp},{af},{dz},{cu},{gm},{ht},{is},{mr},{ng},{ru},{vn},{so}
StrictNodes 1" | sudo tee -a /etc/tor/torrc

#### Polipo (the best web cache - Using persistent caching like this will reduce the anonymity of tor (or another proxy)) ###
sudo apt-get install polipo -y
echo '# This file only needs to list configuration variables that deviate
# from the default values.  See /usr/share/doc/polipo/examples/config.sample
# and "polipo -v" for variables you can tweak and further information.
logSyslog = true
logFile = /var/log/polipo/polipo.log
dnsUseGethostbyname = yes
# Envoyer moins d'informations personnelles sur le net :
censoredHeaders = from, accept-language
censorReferer = maybe
# tor
socksParentProxy = "localhost:9050"
socksProxyType = socks5' | sudo tee -a /etc/polipo/config

#python libraries for terminal
sudo -H pip install --upgrade pip
sudo -H pip install requests urllib3
sudo -H  pip install beautifulsoup
sudo easy_install requests-toolbelt
sudo -H  pip install contextlib2 #for aleatority model close session
sudo -H  pip install time #for aleatority model wait
#requesocks
wget https://pypi.python.org/packages/2b/33/0ecebf3903181cd74d9ff885da4029f59e5f61c99dc66f39c5a170a66d27/requesocks-0.10.8.tar.gz
tar -zxvf requesocks**.gz
cd requesocks**
sudo python setup.py install
rm requesocks**.gz
sudo apt-get install python-socksipy #other option to socks5 if not working properly yet

sudo apt-get install tor deb.torproject.org-keyring
tor
export http_proxy='http://localhost:9010'  #the port is on 9010 instead of 9050
export https_proxy='http://localhost:9010'

#Configure Firefox to tunnel requests to .onion domains via the Tor network
#and Configure Firefox to tunnel DNS queries via a SOCKS5 proxy

echo 'function FindProxyForURL(url, host) {
       isp = "PROXY ip_address:port; DIRECT";
           tor = "SOCKS 127.0.0.1:9050";
               if (shExpMatch(host,"*.onion")) {
                           return tor;
                               }
                                   return "DIRECT";
 }' | sudo tee -a ~/proxy.pac
 
 
 echo "Add file://home/node/$USER/proxy.pac route to Edit->Preferences->Advanced->Network->Settings->Automatic proxy configuration URL. Then search for  network.proxy.    socks in about:config and put network.proxy.socks_remote_dns to true"


##proxychains
git clone https://github.com/rofl0r/proxychains-ng
./configure --prefix=/usr --sysconfdir=/etc
make
sudo make install
sudo make install-config
proxychains4 firefox
proxychains bash

read -p "Please, changemymac and changemyhost when finished, and cleanall or cleanexcept (cache, memory, swap, history...)"
