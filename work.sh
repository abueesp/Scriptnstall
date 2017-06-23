
#Docker 
sudo wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker $USER
sudo apt-get purge apparmor -y
sudo rm -rf /etc/apparmor.d/
sudo rm -rf /etc/apparmor
git clone https://github.com/CISOfy/lynis

#Some tools
sudo apt-get install baobab -y
sudo apt-get install brasero -y
sudo apt-get install tmux -y

sudo rm ~/tmux.conf~
cp ~/tmux.conf ~/tmux.conf~
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/tmux.conf -O ~/tmux.conf
tmux source-file ~/tmux.conf

git clone git://github.com/zolrath/wemux.git /usr/local/share/wemuxure to use the full path.
ln -s /usr/local/share/wemux/wemux /usr/local/bin/wemux
cp /usr/local/share/wemux/wemux.conf.example /usr/local/etc/wemux.conf

sudo apt-get install sysv-rc-conf -y
sudo apt-get install chkrootkit -y
sudo apt-get install securedelete -y
sudo apt-get install traceroute -y
sudo apt-get install zsh -y
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sudo sed -ir 's/ZSH_THEME="robbyrussell"/ZSH_THEME="norm"/g' ~/.oh-my-zsh #noroot
sudo apt-get install iotop -y
sudo apt-get install fish -y
sudo apt-get install byobu -y
sudo apt-get install autojump -y
sudo apt-get install nmap arp-scan -y
sudo apt-get install terminator -y
sudo apt-get install htop -y
sudo apt-get install gtk-recordmydesktop recordmydesktop -y
sudo apt-get install vnstat -y
sudo apt-get install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
echo "Please write down an email to send you notifications when someone is attacking your ports: "
read email
echo "You entered: $email"
sed "s/destemail = your_email@domain.com/destemail = $email/g" /etc/fail2ban/jail.local
sed "s/action = %(action_)s/action = %(action_mw)s/g" /etc/fail2ban/jail.local
sed -e "s/enabled  = false/enabled  = true/g" /etc/fail2ban/jail.local
sudo apt-get install zenmap logcheck logcheck-database -y
logcheck -p -u -m -h $email
sudo apt-get install gnupg gpgv2 pbuilder ubuntu-dev-tools bzr-builddeb -y
sudo apt-get install zenmap -y
sudo apt-get install pandoc -y
sudo apt-get install gparted -y
sudo apt-get install nemo -y
sudo apt-get install apt-get install amarok -y
sudo apt-get install duplicity deja-dup -y
sudo apt-get install thunderbird -y
mkdir thunderbird
cd
wget https://addons.mozilla.org/thunderbird/downloads/latest/775/addon-775-latest.xpi
cd ..
sudo apt-get install firefox -y
firefox -P https://addons.mozilla.org/firefox/downloads/file/271802/no_more_install_delay-3.0-fx+sm+fn+tb.xpi


##DataSc Complex Networks
#gephi
wget https://github.com/gephi/gephi/releases/download/v0.9.1/gephi-0.9.1-linux.tar.gz
tar -xf gephi*.tar.gz
rm gephi*.tar.gz
#cytoscape
wget http://chianti.ucsd.edu/cytoscape-3.4.0/Cytoscape_3_4_0_unix.sh
bash Cytoscape*.sh

#youtube-dl
sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/bin/youtube-dl
sudo chmod a+rx /usr/bin/youtube-dl
sudo add-apt-repository ppa:mc3man/trusty-media -y
sudo apt-get update -y
sudo apt-get install ffmpeg -y
sudo add-apt-repository --remove ppa:mc3man/trusty-media -y



##asciinema
sudo apt-add-repository ppa:zanchey/asciinema
sudo apt-get update
sudo apt-get install asciinema


#spacemacs & plugins
sudo apt-get install texlive-latex-base -y
mkdir .emacs.d
mkdir .emacs
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
wget https://github.com/ethereum/emacs-solidity/blob/master/solidity-mode.el -O ~/.emacs.d/solidity-mode.el ##solidity
wget https://github.com/syohex/emacs-emamux/blob/master/emamux.el -O ~/.emacs.d/ #tmux on emacs
sudo emacs --insecure
cd
sudo rm -r emacs-**
#emacsbrowser
git clone http://repo.or.cz/r/conkeror.git
cd conkeror
make
sudo make install
cd ..
sudo rm -r conkeror

##Geth
echo "Geth"
cd linux
wget https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-1.5.2-c8695209.tar.gz
tar -zxvf geth**.tar.gz
sha1 = $(sha1sum geth**.tar.gz)
if [[ $sha1 == "33d0633e1b30491d2dcb3f118350fa7576e47865" ]]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
read -p "Please ENTER if PACKAGE VERIFIED. Otherwise Ctrl-C " pause
sudo rm geth**.tar.gz
cd geth**
./geth

#Ethr
sudo apt-get install gfortran aptitude libghc-curl-dev liblzma-dev -y 
sudo aptitude install r-base -y
sudo aptitude install openjdk-7-source -y
sudo updatedb
sudo wget https://cran.r-project.org/src/base-prerelease/R-latest.tar.gz
tar -xvzf R-latest.tar.gz Rfolder
sudo rm -r -f R-latest.tar.gz
cd Rfolder
sudo wget  ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.20.tar.bz2
sudo wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.20.tar.bz2.sig
sudo gpg2 --verify prce**sig pcre**bz2
sudo bzip2 -d pcre**bz2
sudo tar -xvf pcre**tar
sudo rm pcre**.bz2 pcre**.bz2.sig pcre**.tar
cd pcre**
sudo ./configure --prefix=$HOME/$USER/R**
sudo make -j3
sudo make install
cd ..
./configure --prefix=$HOME/$USER/Rfolder '--with-cairo' \
 '--with-jpeglib' '--with-readline' '--with-tcltk' \
 '--with-blas' '--with-lapack' '--enable-R-profiling' \
 '--enable-R-shlib' \
 '--enable-memory-profiling'
sudo make
sudo make install
echo "install Geth if you want to see EthR working"
cd
sudo wget https://www.mpfr.org/mpfr-current/mpfr-3.1.4.zip
sudo wget https://www.mpfr.org/mpfr-current/mpfr-3.1.4.tar.xz.asc
gpg2 --recv-keys 98C3739D
gpg2 --verify mpfr**.asc
sudo unzip mpfr**
sudo rm -r -f mpfr**.zip
sudo rm -r -f mpfr**.asc
cd mpfr**
./configure
sudo make
sudo make install

echo ' *****************
Install those packages in R. To exit type quit()
setRepositories()
install.packages("Rmpfr", repos="http://cran.cnr.berkeley.edu")
install.packages("devtools", repos="http://cran.cnr.berkeley.edu")
devtools::install_github("BSDStudios/ethr")
install.packages("plyr", repos="http://cran.cnr.berkeley.edu")
install.packages("dplyr", repos="http://cran.cnr.berkeley.edu")
install.packages("httr", repos="http://cran.cnr.berkeley.edu")
install.packages("igraph", repos="http://cran.cnr.berkeley.edu")
install.packages("gmp", repos="http://cran.cnr.berkeley.edu")

Install those packages in R. To exit type quit()' 
sudo R

##Nodejs & NPM 
cd /usr/local
sudo apt-get purge npm nodejs -y
sudo apt-get build-dep nodejs -y
sudo npm build-dep npm -g
versionnpm=v7.7.4
sudo wget $(echo "https://nodejs.org/dist/"$versionnpm"/node-$versionnpm-linux-x64.tar.xz")
gpg2 --keyserver pool.sks-keyservers.net --recv-keys DD8F2338BAE7501E3DD5AC78C273792F7D83545D
sudo wget $(echo "https://nodejs.org/dist/"$versionnpm"/SHASUMS256.txt.asc")
gpg2 --verify SHASUMS256.txt.asc
sudo rm SHASUM**
sudo tar --strip-components 1 -xf /usr/local/node**.tar.xz
sudo npm init -y
cd
sudo npm init -y
sudo npm install error-stack-parser lodash minimatch graceful-fs secp256k1 fs-extra

##Meteor & Web3 Library & Atmosphere
curl https://install.meteor.com/ | sh
meteor create mydapp
cd mydapp
sudo npm install -g harp
meteor add ethereum:web3
meteor add mrt:moment
cd

##Dapple
sudo npm uninstall parse-stack
sudo npm install error-stack-parser lodash minimatch graceful-fs secp256k1 fs-extra
sudo npm install -g dapple leveldown
mkdir myapp
cd mydapp
dapple init
dapple --help
cd

#Uglify
git clone git://github.com/mishoo/UglifyJS2.git
cd UglifyJS2
sudo npm link .
cd
sudo rm -r UglifyJS2

#Grunt for js
sudo npm install -g grunt-cli
#Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript: grunt.loadNpmTasks('grunt-contrib-watch');
sudo npm install grunt-contrib-watch --save-dev
#Once that's done, add this line to your project's Gruntfile: grunt.loadNpmTasks('grunt-embark');
sudo npm install embark --save-dev
sudo npm install grunt-embark --save-dev
#And so on
sudo npm install grunt-contrib-clean --save-dev
sudo npm install grunt-contrib-jshint --save-dev
sudo npm install grunt-contrib-copy --save-dev
sudo npm install grunt-contrib-uglify --save-dev
sudo npm install grunt-mkdir --save-dev
#those have different flavours https://www.npmjs.com/package/grunt-shell
sudo npm install --save-dev grunt-shell
#https://www.npmjs.com/package/grunt-contrib-htmlmin
sudo npm install grunt-contrib-htmlmin --save-dev

##Other npm
sudo npm install -g jshint
sudo npm install -g coffeescript-compiler
sudo npm install -g coffee-script

##npm JS React Boilerplate
sudo npm cheerio
git clone --depth=1 https://github.com/mxstbr/react-boilerplate.git
cd react**
sudo npm run setup
cd
##MongoDB
sudo npm install mongodb

##Frameworks
sudo npm -g install embark-framework
sudo npm install -g truffle
#Install solidity compiler
sudo npm install solc


##Contracts
git clone https://github.com/ethereum/dapp-bin

#Text Edition Tools
sudo apt-get install unoconv -y
sudo apt-get install detox -y
sudo add-apt-repository ppa:webupd8team/sublime-text-3 -y 
sudo apt-get update -y
sudo apt-get install vim vim-scripts -y
mv ~/.vim/autoload/plug.vim ~/.vim/autoload/plug-backup.vim
wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O ~/.vim/autoload/plug.vim
git clone https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
sudo apt-get install gedit -y
sudo apt-get install sublime-text-installer -y
sudo apt-get install libreoffice -y
sudo apt-get install libgstreamer-plugins-base0.10-0 -y #for scrivener requirements libgstapp-0.10.so.0
wget http://www.literatureandlatte.com/scrivenerforlinux/scrivener-1.9.0.1-amd64.deb
sudo dpkg -i scrivener**
sudo rm scrivener**

##Python 2.7 & 3 + readthedocs + saltpack
sudo apt-get install build-essential python-dev python-setuptools python-virtualenv libxml2-dev libxslt1-dev zlib1g-dev -y
sudo apt-get install python-pip python3-pip -y
pip install --upgrade pip
pip3 install --upgrade pip
sudo apt-get install libffi-dev python-cffi -y
sudo -H pip3 install saltpack
sudo -H pip3 install pyminifier
virtualenv rtd
cd rtd
source bin/activate
git clone https://github.com/rtfd/readthedocs.org.git
cd readthedocs.org
sudo pip install -r requirements.txt
sudo easy_install --upgrade pip
sudo pip uninstall pyopenssl
sudo pip install mozdownload
sudo ./manage.py migrate
sudo ./manage.py createsuperuser
sudo ./manage.py collectstatic
#sudo ./manage.py loaddata test_data
#sudo ./manage.py update_repos pip
echo "alias readthedocs='sudo ./manage.py runserver && firefox -new-tab -url http://127.0.0.1:8000'" >> ~/.bashrc
firefox --new-tab https://store.enthought.com/downloads/


##Etherex (This also requires nodejs and npm)
git clone https://github.com/etherex/etherex.git
cd etherex
sudo apt-get install libssl-dev -y
sudo -H pip install -r dev_requirements.txt
sudo npm install error-stack-parser lodash minimatch graceful-fs secp256k1 fs-extra
python setup.py build
sudo python setup.py install
cd frontend
sudo npm install grunt
geth --testnet --rpc --rpccorsdomain https://etherex.github.io
firefox --new-tab http://localhost:8545/



##Automatic Django Project setup, with git, heroku, rvmrc, coffeescript, less, automatic deployment, and many more features from https://github.com/andres-torres-marroquin/django-sparker
curl -L https://raw.github.com/andres-torres-marroquin/django-sparker/master/sparker.sh | bash -s stable

##Jaxx
wget https://jaxx.io/files/1.0.5/Jaxx-v1.0.5-linux-x64.tar.gz
sha1sum Jaxx-v1.0.5-linux-x64.tar.gz d0d74e52d2e8e654d27a6653ed058b412b52d583
tar -xvzf Jaxx**.tar.gz
sudo rm -r -f Jaxx**.tar.gz

##Icecold
git clone https://github.com/ryepdx/ethaddress.org
cd ethaddress.org
gpg2 --verify ryep**.asc
cd ..
echo "alias coldstorage = 'cd /home/$USER/ethaddress.org && firefox -new-tab -url index.html'"
git clone https://github.com/pointbiz/bitaddress.org
cd bitaddress.org
gpg2 --verify CHANGE**.asc
cd ..
git clone https://github.com/litecoin-project/liteaddress.org
cd liteaddress.org
gpg2 --verify CHANGE**.asc
cd ..

##Electrum
sudo apt-get install python-qt4 python-pip -y
sudo pip install https://download.electrum.org/2.7.12/Electrum-2.7.12.tar.gz
tar zxvf Electrum**gz
cd Electrum**
./configure
sudo make
sudo make install
cd ..
sudo rm -r **Electrum

#Bitcoin
sudo apt-get install build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils -y
sudo apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev -y
sudo apt-get install libboost-all-dev -y
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get update
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y
sudo apt-get install libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler -y
./configure
make
sudo make install
sudo add-apt-repository --remove ppa:bitcoin/bitcoin
vi  ~/bitcoin/bitcoin.conf  

#OpenTimestamps
sudo apt-get install git python3 python3-pip -y
sudo -H pip install --upgrade pip
sudo -H pip install --upgrade pip3
git clone https://github.com/opentimestamps/opentimestamps-client.git
cd opentimestamps-client
git checkout opentimestamps-client-v0.2.0
pip3 install -r requirements.txt
cat examples/hello-world.txt
./ots verify examples/hello-world.txt.ots
./ots -v verify examples/hello-world.txt.ots
echo 'Every Bitcoin block header has a field in it called nTime. For a Bitcoin block to be accepted by the network the Bitcoin protocol requires that field to be set to approximately the time the block was created. The timestamp of the blocks is not monotonically increasing. “A timestamp is accepted as valid if it is greater than the median timestamp of the previous 11 blocks, and less than the network-adjusted time + 2 hours. "Network-adjusted time" is the median of the timestamps returned by
all nodes connected to you. To understand why, it’s necessary for us to have a basic understanding of distributed computing systems, one of the elementary characteristics of which is the lack of a global clock. 
In Bitcoin: “A timestamp is accepted as valid if it is greater than the median timestamp of the previous 11 blocks, and less than the network-adjusted time + 2 hours. "Network-adjusted time" is the median of the timestamps returned by all nodes connected to you. Whenever a node connects to another node, it gets a UTC timestamp from it, and stores its offset from node-local UTC. The network-adjusted time is then the node-local UTC plus the median offset from all connected nodes. Network time is never adjusted more than 70 minutes from local system time, however.”
The time adjustment algorithm has even been called the most obvious possible weakness in the Bitcoin protocol. It’s fair to say it’ll very likely be accurate to within two or three hours - even if a sizable minority of Bitcoin miners are trying to create invalid timestamps - and almost certainly within a day. Thus we can say Bitcoin is a notary, and we can use Bitcoin block headers as time attestation. '
echo "CREATING A TIMESTAMP"
echo "You can create timestamps that don’t depend on calendars by using the --wait option. If enabled, the client simply waits until the timestamp is completely confirmed by the Bitcoin blockchain. The resulting timestamp will contain all the data needed to prove the timestamp with Bitcoin, allowing verification to be done completely locally. An incomplete timestamp can be upgraded later with the ‘ots upgrade’ command. The complete Bitcoin proof will be downloaded from the calendar and saved as part of the timestamp, with the result being as though you used the --wait option in the first place."
echo "VERIFICATION"
read -p "We can’t verify it immediately however. It takes a few hours for the timestamp to get confirmed by the Bitcoin blockchain; we’re not doing one transaction per   timestamp. Write the down the route of your notary deeds. It takes a few hours for the timestamp to get confirmed by the Bitcoin blockchain, we are not doing one transaction per timestamp" ROUTE
./ots info $ROUTE
./ots -v verify $ROUTE
echo "Public calendar servers. A calendar is simply a collection of timestamps; a calendar server provides remote access to a calendar. As of writing, there are two public calendar servers in operation, alice.btc.calendar.opentimestamps.org, and bob.btc.calendar.opentimestamps.org. It is redundant. By default when creating timestamps two public calendars are used simultaneously, and the timestamp is only saved if we get a response back from both. You are of course able to use your own calendars, both instead of, and in addition too, the public calendars. The client has a whitelist of calendars it’ll contact automatically, so users external to Example Inc. will just ignore their pending attestation and try the public calendars instead. We can also ask to the remote calendar for only a part of the OTS file without the rest of the timestamp"

##Ruby Version Manager (RVM) with Ruby on Rails
#RVM is a command-line tool which allows you to easily install, manage, and work with multiple ruby environments from interpreters to sets of gems.
sudo apt-get install -y git-core subversion gnupg2
curl -sSL https://get.rvm.io | bash -s stable --rails --ruby
sudo gpg2 --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -O https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer
curl -O https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer.asc
sudo gpg2 --verify rvm-installer.asc 
sudo curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
bash rvm-installer stable
rvm list
rvm rubies

#https://github.com/Nerian/simple_gemset
sudo gem install simple_gemset
##Bundler provides a consistent environment for Ruby projects by tracking and installing the exact gems and versions that are needed. 
sudo gem install bundler
#Etherum
sudo gem install ethereum
##Install ribbot
git clone https://github.com/barmstrong/ribbot
cd ribbot
bundle install
git add Gemfile Gemfile.lock
cd
rvm list
rvm rubies

##Mail
sudo apt-get install mailutils ssmtp postfix -y
read -p "Email Configuration for a mail integrated on terminal. Write your sender email: " emmail
read -p "Password  \n" Passs
read -p "SMTP. Gmail uses smtp.gmail.com:587    \n" SMTP
sudo sed -i 's/#FromLineOverride=YES/FromLineOverride=YES \AuthUser=$emmail \AuthPass=$Passs \mailhub=$SMTP \UseSTARTTLS=YES/g' /etc/ssmtp/ssmtp.conf
echo "Is blacklisted my domain-name or ip?"
wget http://ipinfo.io/ip -qO -
firefox -new-tab https://www.spamhaus.org/lookup/ -new-tab https://www.whatismyip.com/blacklist-check/
echo "Configure (use a postmaster mail)"
firefox -new-tab https://www.spamhaus.org/pbl/removal/form/ -new-tab https://postmaster.google.com/managedomains?pli=1
echo " mail(){ \
read -p 'Write subject' Subject \
read -p 'Write recipient email' REmail \
read -p 'Write a subject' Subject \
read -p 'Introduce text' Textt \
read -p 'Introduce anexxed files routes separated by commas, like /a/b.txt,/c/c.pdf' filesss \
mail -a $filesss -s '$Subject' $REmail < $Textt \
}" | sudo tee -a ~/.bashrc
echo "$(echo $(wget http://ipinfo.io/ip -qO -) | rev | cut -d. -f2-).in-addr.arpa" #zone file
echo "$($(echo '$(wget http://ipinfo.io/ip -qO -)' | cut -d. -f2- | cut -d. -f2- | cut -d. -f2-).$(echo '$(wget http://ipinfo.io/ip -qO -)' | rev | cut -d. -f2-).in-addr.arpa)" #PTRRecord
firefox -new-tab http://www.digwebinterface.com/?hostnames=$(wget http://ipinfo.io/ip -qO -)%0D%0A&type=&ns=resolver&useresolver=8.8.4.4&nameservers=

#Other browsers
sudo apt-get install libpangox-1.0-0  libpango1.0-0 -y
wget https://ftp.opera.com/pub/opera-developer/41.0.2349.0/linux/opera-developer_41.0.2349.0_amd64.deb
sudo dpkg -i opera**.deb
sudo rm opera**.deb

wget http://www.srware.net/downloads/iron64.deb
sudo dpkg -i iron64.deb
sudo rm iron64.deb
sudo mv /usr/share/iron /bin/iron/
echo "alias iron='/bin/iron/./chrome'" | tee -a ~/.bashrc
/bin/iron/./chrome https://chrome.google.com/webstore/detail/form-filler/bnjjngeaknajbdcgpfkgnonkmififhfo
/bin/iron/./chrome https://chrome.google.com/webstore/detail/autoform/fdedjnkmcijdhgbcmmjdogphnmfdjjik
/bin/iron/./chrome https://chrome.google.com/webstore/detail/m-i-m/jlppachnphenhdidmmpnbdjaipfigoic

wget https://ftp.gnu.org/gnu/icecat/38.8.0-gnu2/icecat-38.8.0.en-US.linux-x86_64.tar.bz2
wget https://ftp.gnu.org/gnu/icecat/38.8.0-gnu2/icecat-38.8.0.en-US.linux-x86_64.tar.bz2.sig
gpg2 --output icecat**tar.bz2 --decrypt icecat**tar.bz2.sig
tar -jxvf **tar.bz2

wget http://downloads.sourceforge.net/project/dooble/Version%201.56b/dooble-master.zip


#IPFS 
wget https://dist.ipfs.io/go-ipfs/v0.4.3/go-ipfs_v0.4.3_linux-amd64.tar.gz
tar -zxvf go-ipfs**tar.gz
rm go-ipfs**tar.gz
cd go-ipfs
sudo sh install.sh 

#Go
cd /usr/local
sudo wget https://storage.googleapis.com/golang/go1.7.3.linux-amd64.tar.gz
sudo tar -zxvf go1**.tar.gz
export PATH=$PATH:/usr/local/go/bin


#FTP VSFTPD
wget https://security.appspot.com/downloads/vsftpd-3.0.3.tar.gz
wget https://security.appspot.com/downloads/vsftpd-3.0.3.tar.gz.asc
gpg2 --keyserver pgpkeys.mit.edu --recv-key 3C0E751C
gpg2 --with-fingerprint vsftpd**.asc
sudo rm vsftpd**.asc
read "Is verified?" pause
tar xvzf vsftpd**.tar.gz
sudo rm vsftpd-**tar.gz
cd vsftpd**
make
sudo cp -r /usr/share/man/man5/ /usr/local/man/man5
sudo cp /usr/local/sbin/vsftpd /usr/sbin/vsftpd
sudo make install
cd ..


##blindlector
sudo apt-get install libttspico** -y


EOF
