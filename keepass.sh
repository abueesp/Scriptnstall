
#KeePass (see KeeFox in Browsers)
sudo apt-get install mono-complete mono-dmcs libmono-system-management4.0-cil libmono-system-xml-linq4.0-cil libmono-system-data-datasetextensions4.0-cil libmono-system-runtime-serialization4.0-cil mono-mcs -y
mkdir KeePass
cd KeePass
sudo wget http://downloads.sourceforge.net/project/keepass/KeePass%202.x/2.33/KeePass-2.33.zip
sudo unzip KeePass**.zip
sudo rm **.zip
sudo add-apt-repository ppa:dlech/keepass2-plugins
sudo apt-get update 
sudo wget https://raw.github.com/pfn/keepasshttp/master/KeePassHttp.plgx
sudo chmod 644 KeePassHttp.plgx
sudo wget https://keepass.info/extensions/v2/kpscript/KPScript-2.32.zip
wget -r --no-parent -A 'KPScript*.zip' https://keepass.info/extensions/v2/kpscript/
sudo unzip KPScript**.zip
sudo rm KPScript**.zip
sudo wget https://downloads.sourceforge.net/project/kp-googlesync/GoogleSyncPlugin-2.x/GoogleSyncPlugin-2.1.2.zip
sudo unzip GoogleSync**.zip
sudo rm GoogleSync**.zip
sudo wget https://github.com/islog/keepassrfid/releases/download/1.0.0/keepassrfid.plgx
sudo git clone git://github.com/dlech/KeeAgent --recursive
cd KeeAgent
sudo mozroots --import --machine --sync
sudo certmgr -ssl -m https://go.microsoft.com
sudo certmgr -ssl -m https://nugetgallery.blob.core.windows.net
sudo certmgr -ssl -m https://nuget.org
sudo rm nuget.exe*
sudo wget https://nuget.org/nuget.exe
sudo mono nuget.exe restore
sudo rm nuget.exe*
sudo xbuild /property:Configuration=ReleasePlgx KeeAgent.sln
cd
sudo cp bin/ReleasePlgx/KeeAgent.plgx /KeePass
sudo chmod +x /KeePass
rm keepassrfid.plgx 
rm -r KeeAgent
sudo apt-get purge keepass2-plugin-rpc

keepass2
sudo cp /home/node/.mozilla/firefox/**.default/extensions/keefox@chris.tomlinson/deps/KeePassRPC.plgx /usr/lib/keepass2
