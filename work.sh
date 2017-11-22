##Random-tester
sudo apt-get install ent dieharder -y

##Hwrng utils
sudo apt-get install haveged -y
cat /dev/hwrng

##Github
sudo apt-get install git -y 
git config --global credential.helper cache
# Set git to use the credential memory cache
git config --global credential.helper 'cache --timeout=3600'
# Set the cache to timeout after 1 hour (setting is in seconds)
read -p "Please set your username: " username
git config --global user.name $username
read -p "Please set your email: " mail
git config --global user.email $mail
read -p "Please set your core editor: " editor
git config --global core.editor $editor
read -p "Please set your diff app: " diff
git config --global merge.tool $diff
gpg --list-secret-keys
read -p "Introduce the key id (and open https://github.com/settings/keys): " keyusername
gpg --export -a $keyusername
git config --global user.signingkey $keyusername
git config --global commit.gpgsign true
git config --list
echo "Here you are an excellent Github cheatsheet https://raw.githubusercontent.com/hbons/git-cheat-sheet/master/preview.png You can also access as gitsheet"
echo "If you get stuck, run ‘git branch -a’ and it will show you exactly what’s going on with your branches. You can see which are remotes and which are local."
echo "Do not forget to add a newsshkey or clipboard your mysshkey or mylastsshkey (if you switchsshkey before) and paste it on Settings -> New SSH key and paste it there." 

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
sudo apt-get install tree -y
sudo apt-get install task -y
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
sudo apt-get install grc -y
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
cd ~/Downloads
mkdir thunderbird
cd
wget https://addons.mozilla.org/thunderbird/downloads/latest/775/addon-775-latest.xpi
cd ..
sudo apt-get install firefox -y
mkdir firefox
wget https://www.eff.org/files/privacy-badger-latest.xpi #Privacy badger
wget https://addons.mozilla.org/firefox/downloads/latest/497366/addon-497366-latest.xpi #Disable WebRTC
wget https://addons.mozilla.org/firefox/downloads/latest/1843/addon-1843-latest.xpi #Firebug
wget https://addons.mozilla.org/firefox/downloads/latest/5791/addon-5791-latest.xpi #FlagFox
wget https://addons.mozilla.org/firefox/downloads/latest/92079/addon-92079-latest.xpi #CookieManager
wget https://addons.mozilla.org/firefox/downloads/latest/521554/addon-521554-latest.xpi #DecentralEyes
wget https://addons.mozilla.org/firefox/downloads/latest/607454/addon-607454-latest.xpi #UBlockOrigin
wget https://addons.mozilla.org/firefox/downloads/latest/383235/addon-383235-latest.xpi #FlashDisable
wget https://addons.mozilla.org/firefox/downloads/file/281702/google_privacy-0.2.4-sm+fx.xpi #GooglePriv
wget https://addons.mozilla.org/firefox/downloads/latest/415846/addon-415846-latest.xpi #SelfDestructing Cookies
wget https://addons.mozilla.org/firefox/downloads/latest/387051/addon-387051-latest.xpi #RemoveGoogleTracking
wget https://addons.mozilla.org/firefox/downloads/latest/722/addon-722-latest.xpi #NoScript
wget https://addons.mozilla.org/firefox/downloads/latest/1865/addon-1865-latest.xpi  #AdBlock Plus
wget https://addons.mozilla.org/firefox/downloads/latest/496120/addon-496120-latest.xpi #LocationGuard
wget https://addons.mozilla.org/firefox/downloads/latest/473878/addon-473878-latest.xpi #RandomAgentSpoofer
wget https://addons.mozilla.org/firefox/downloads/latest/229918/addon-229918-latest.xpi #HTTPS Everywhere
wget https://addons.mozilla.org/en-US/firefox/downloads/latest/2109/addon-2109-latest.xpi #FEBE Backups
#wget https://addons.mozilla.org/firefox/downloads/latest/363974/addon-363974-latest.xpi #Lightbeam
wget https://addons.mozilla.org/firefox/downloads/latest/409964/addon-409964-latest.xpi #VideoDownloadHelper
wget https://addons.mozilla.org/firefox/downloads/latest/export-to-csv/addon-364467-latest.xpi #Export Table to CSV
wget https://addons.mozilla.org/firefox/downloads/latest/tabletools2/addon-296783-latest.xpi #TableTools2
wget https://addons.mozilla.org/firefox/downloads/latest/748/addon-748-latest.xpi #Greasemonkey
wget https://addons.mozilla.org/firefox/downloads/latest/7447/addon-7447-latest.xpi #NetVideoHunter
wget https://addons.mozilla.org/firefox/downloads/latest/1237/addon-1237-latest.xpi #QuickJava
wget https://addons.mozilla.org/firefox/downloads/latest/3497/addon-3497-latest.xpi #EnglishUSDict
wget https://addons.mozilla.org/firefox/downloads/file/502726/colorfultabs-31.0.8-fx+sm.xpi #ColorfulTabs
wget https://addons.mozilla.org/firefox/downloads/latest/193270/addon-193270-latest.xpi #PrintEdit
wget https://addons.mozilla.org/firefox/downloads/latest/5791/addon-5791-latest.xpi #Flagfox
wget https://addons.mozilla.org/firefox/downloads/file/342774/tineye_reverse_image_search-1.2.1-fx.xpi #TinyEye Reverse ImageSearch
wget https://addons.mozilla.org/firefox/downloads/latest/355192/addon-355192-latest.xpi #MindTheTime
wget https://addons.mozilla.org/firefox/downloads/latest/1843/addon-1843-latest.xpi #Firebug
wget https://addons.mozilla.org/firefox/downloads/latest/161670/addon-161670-latest.xpi #FlashFirebug
wget https://addons.mozilla.org/firefox/downloads/latest/tab-groups-panorama/addon-671381-latest.xpi #Tabgroups
wget https://addons.mozilla.org/firefox/downloads/latest/532/addon-532-latest.xpi #LinkChecker
wget https://addons.mozilla.org/firefox/downloads/latest/5523/addon-5523-latest.xpi #gui:config extraoptions
wget https://addons.mozilla.org/firefox/downloads/file/413865/mutetab-0.0.2-fx.xpi #mutetab
wget https://addons.mozilla.org/firefox/downloads/latest/10586/addon-10586-latest.xpi #URL Shortener
wget https://addons.mozilla.org/firefox/downloads/file/387220/text_to_voice-1.15-fx.xpi #TextToVoice
wget https://addons.mozilla.org/firefox/downloads/latest/8661/addon-8661-latest.xpi #WorldIP
wget https://addons.mozilla.org/firefox/downloads/latest/3829/addon-3829-latest.xpi #liveHTTPHeaders
wget https://addons.mozilla.org/firefox/downloads/file/373868/soundcloud_downloader_soundgrab-0.98-fx.xpi #Soundcloud
wget https://addons.mozilla.org/firefox/downloads/latest/695840/addon-695840-latest.xpi #FlashDebugger
wget https://addons.mozilla.org/firefox/downloads/latest/video-downloadhelper/addon-3006-latest.xpi #VideoDownloadHelper
wget https://addons.mozilla.org/firefox/downloads/latest/390151/addon-390151-latest.xpi #TOS
wget https://addons.mozilla.org/firefox/downloads/latest/3456/addon-3456-latest.xpi #WOT
wget https://addons.mozilla.org/firefox/downloads/latest/certificate-patrol/addon-6415-latest.xpi #certificate patrol
#wget https://addons.mozilla.org/firefox/downloads/latest/perspectives/addon-7974-latest.xpi #perspectivenetworknotaries
wget https://www.roboform.com/dist/roboform-firefox.xpi
mkdir moretools
wget https://addons.mozilla.org/firefox/downloads/file/140447/cryptofox-2.2-fx.xpi #CryptoFox
wget https://addons.mozilla.org/firefox/downloads/latest/copy-as-plain-text/addon-344925-latest.xpi #Copy as Plain Text
wget https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/addon-534930-latest.xpi #Avoid HTML5 Canvas
wget https://addons.mozilla.org/firefox/downloads/file/229626/sql_inject_me-0.4.7-fx.xpi #SQL Inject Me
wget https://addons.mozilla.org/firefox/downloads/file/215802/rightclickxss-0.2.1-fx.xpi #Right Click XSS
wget https://addons.mozilla.org/firefox/downloads/latest/3899/addon-3899-latest.xpi #HackBar
wget https://addons.mozilla.org/firefox/downloads/latest/wappalyzer/addon-10229-latest.xpi #Wappanalyzer
wget https://addons.mozilla.org/firefox/downloads/latest/6196/addon-6196-latest.xpi #PassiveRecon
wget https://addons.mozilla.org/firefox/downloads/latest/344927/addon-344927-latest.xpi #CookieExportImport
wet https://addons.mozilla.org/firefox/downloads/file/204186/fireforce-2.2-fx.xpi #Fireforce
wget https://addons.mozilla.org/firefox/downloads/file/224182/csrf_finder-1.2-fx.xpi #CSRF-Finder
wget https://addons.mozilla.org/firefox/downloads/file/345004/live_http_headers_fixed_by_danyialshahid-0.17.1-signed-sm+fx.xpi #Live HTTP Headers
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

read -p 'If you are upgrading, build a temp file with all of your old packages.
tmp <- installed.packages()
installedpkgs <- as.vector(tmp[is.na(tmp[,"Priority"]), 1])
save(installedpkgs, file="installed_old.rda")
click ENTER when ready'

wget https://cran.r-project.org/src/base-prerelease/R-latest.tar.gz
tar -xvzf R-latest.tar.gz Rfolder
rm -r -f R-latest.tar.gz
cd Rfolder

PCRE2VERSION=10.30
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-$PCRE2VERSION.tar.bz2
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-$PCRE2VERSION.tar.bz2.sig
gpg --verify pcre2-$PCRE2VERSION.tar.bz2.sig pcre**bz2
sudo bzip2 -d pcre**bz2
sudo tar -xvf pcre**tar
sudo rm pcre2-$PCRE2VERSION.tar.bz22 pcre2-$PCRE2VERSION.tar.bz2.sig
cd pcre2-$PCRE2VERSION
./configure --prefix=$HOME/$USER/R**
make -j3
sudo make install
cd ..
./configure --prefix=$HOME/$USER/Rfolder '--with-cairo' \
 '--with-jpeglib' '--with-readline' '--with-tcltk' \
 '--with-blas' '--with-lapack' '--enable-R-profiling' \
 '--enable-R-shlib' \
 '--enable-memory-profiling'
make
sudo make install
cd

MPFRVERSION=3.1.6
wget http://www.mpfr.org/mpfr-current/mpfr-$MPFRVERSION.zip
wget http://www.mpfr.org/mpfr-current/mpfr-$MPFRVERSION.tar.xz.asc
gpg --recv-keys 98C3739D
gpg --verify mpfr-$MPFRVERSION.asc
sudo unzip mpfr-$MPFRVERSION.zip
sudo rm -r -f mpfr-$MPFRVERSION.zip
sudo rm -r -f mpfr-$MPFRVERSION.asc
cd mpfr-$MPFRVERSION
./configure
make
sudo make install
sudo apt-get install libssl-dev -y #for devtools

read -p ' *****************
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
Install those packages in R. To exit type quit()

Once you have got the new version up and running, write those lines to reload the saved packages in case and update them from CRAN.
tmp <- installed.packages()
installedpkgs.new <- as.vector(tmp[is.na(tmp[,"Priority"]), 1])
missing <- setdiff(installedpkgs, installedpkgs.new)
install.packages(missing)
update.packages(ask = FALSE, checkBuilt = TRUE)
click ENTER when ready'

echo "install Geth if you want to see EthR working"
echo "Try http://muxviz.net/download.php"
echo "Try http://gecon.r-forge.r-project.org/doc.html"
echo "alias Rlistpackages=echo 'pkgs <- as.data.frame(installed.packages(), stringsAsFactors = FALSE, row.names = FALSE)' && echo 'pkgs[, c("Package", "Version", "Built")]'" | sudo tee -a ~/.bashrc
echo "alias Rupdatepackages=echo 'update.packages(ask = FALSE, checkBuilt = TRUE)'" | sudo tee -a ~/.bashrc

#Rstudio
RSTUDIOVERSION=xenial-1.1.383-amd64
wget https://download1.rstudio.org/rstudio-$RSTUDIOVERSION.deb
echo "fccec7cbf773c3464ea6cbb91fc2ec28" >> rstudio-$RSTUDIOVERSION.deb.md5
md5sum rstudio-$RSTUDIOVERSION.deb
if [ $? -eq 0 ]
then
echo "GOOD MD5"
else
echo "BAD MD5"
exit
fi
sudo dpkg -i rstudio-$RSTUDIOVERSION.deb
rm rstudio-$RSTUDIOVERSION.deb.md5
rm rstudio-$RSTUDIOVERSION.deb

#rkward
sudo apt-get -f install -y
sudo apt-get install rkward -y

##Nodejs & NPM 
cd /usr/local
sudo apt-get purge npm nodejs -y
sudo apt-get build-dep nodejs -y
sudo npm build-dep npm -g
versionnpm=v6.11.2
sudo wget $(echo "https://nodejs.org/dist/"$versionnpm"/node-$versionnpm-linux-x64.tar.xz")
gpg --keyserver pool.sks-keyservers.net --recv-keys DD8F2338BAE7501E3DD5AC78C273792F7D83545D
sudo wget $(echo "https://nodejs.org/dist/"$versionnpm"/SHASUMS256.txt.asc")
gpg --verify SHASUMS256.txt.asc
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
sudo apt-get install libreoffice-gnome -y
sudo apt-get install nano gedit -y
SUBLIMEVERSION=3_build_3126_x64
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text -y
sudo apt-get install libgstreamer-plugins-base0.10-0 -y #for scrivener requirements libgstapp-0.10.so.0
SCRIVENERVERSION=1.9.0.1-amd64
wget http://www.literatureandlatte.com/scrivenerforlinux/scrivener-$SCRIVENERVERSION.deb
sudo dpkg -i scrivener-$SCRIVENERVERSION.deb
sudo rm scrivener-$SCRIVENERVERSION.deb

##Vim##
sudo apt-get install vim -y
git clone https://github.com/amix/vimrc.git ~/.vim
sh ~/.vim/install_awesome_vimrc.sh
cd .vim
mkdir bundle
cd bundle
git clone git://github.com/tpope/vim-fugitive.git
vim -u NONE -c "helptags vim-fugitive/doc" -c q
autocmd QuickFixCmdPost *grep* cwindow
#Youcompleteme for C C# (if Mono)  Rust Go Javascript (if NPM Nodejs)
sudo apt-get install build-essential cmake
sudo apt-get install python-dev python3-dev
git clone https://github.com/valloric/youcompleteme
cd ~/.vim/bundle/youcompleteme
./install.py --all
cd ..
#VimRails
git clone https://github.com/tpope/vim-rails.git
vim -u NONE -c "helptags vim-rails/doc" -c q
git clone https://github.com/plasticboy/vim-markdown.git
git clone https://github.com/elzr/vim-json
git clone --recursive https://github.com/davidhalter/jedi-vim.git
git clone https://github.com/mxw/vim-jsx.git ~/.vim/bundle/vim-jsx
git clone https://github.com/othree/html5.vim
#VimSEnsible: 
# 'backspace': Backspace through anything in insert mode.
#'incsearch': Start searching before pressing enter.
#'listchars': Makes :set list (visible whitespace) prettier.
#'scrolloff': Always show at least one line above/below the cursor.
#'autoread': Autoload file changes. You can undo by pressing u.
#runtime! macros/matchit.vim: Load the version of matchit.vim that ships with Vim
git clone git://github.com/tpope/vim-sensible.git
#VimTEsts
#Use :! and :Dispatch :makegreen terminal...
#Provides texts with
#Language 	Frameworks 	Identifiers
#C# 	.NET 	dotnettest
# Clojure 	Fireplace.vim 	fireplacetest
#Crystal 	Crystal 	crystalspec
#Elixir 	ESpec, ExUnit 	espec, exunit
#Elm 	elm-test 	elmtest
#Erlang 	CommonTest 	commontest
#Go 	Ginkgo, Go 	ginkgo, gotest
#Java 	Maven 	maventest
#JavaScript 	Intern, Jasmine, Jest, Karma, Lab, Mocha, TAP, 	intern, jasmine, jest, karma, lab, mocha, tap
#Lua 	Busted 	busted
#PHP 	Behat, Codeception, Kahlan, Peridot, PHPUnit, PHPSpec, Dusk 	behat, codeception, kahlan, peridot, phpunit, phpspec, dusk
#Perl 	Prove 	prove
#Python 	Django, Nose, Nose2, PyTest, PyUnit 	djangotest, djangonose nose, nose2, pytest, pyunit
#Racket 	RackUnit 	rackunit
#Ruby 	Cucumber, M, Minitest, Rails, RSpec 	cucumber, m, minitest, rails, rspec
#Rust 	Cargo 	cargotest
#Shell 	Bats 	bats
#Swift 	Swift Package Manager 	swiftpm
#VimScript 	Vader.vim, VSpec 	vader, vspec"
git clone https://github.com/janko-m/vim-test
git clone https://github.com/StanAngeloff/php.vim.git
git clone https://github.com/vim-scripts/grep.vim
git clone https://github.com/chrisbra/csv.vim
git clone https://github.com/sirver/ultisnips
#Vimpolyglot
#ansible (syntax, indent, ftplugin)apiblueprint (syntax)applescript (syntax)arduino (syntax, indent)asciidoc (syntax)blade (syntax, indent, ftplugin)c++11 (syntax)c/c++ (syntax)caddyfile (syntax, indent, ftplugin)cjsx (syntax, ftplugin)clojure (syntax, indent, autoload, ftplugin)coffee-script (syntax, indent, compiler, autoload, ftplugin)cql (syntax)cryptol (syntax, compiler, ftplugin)crystal (syntax, indent, autoload, ftplugin)css (syntax)cucumber (syntax, indent, compiler, ftplugin)dart (syntax, indent, autoload, ftplugin)dockerfile (syntax)elixir (syntax, indent, compiler, autoload, ftplugin)elm (syntax, indent, autoload, ftplugin)emberscript (syntax, indent, ftplugin)emblem (syntax, indent, ftplugin)erlang (syntax, indent)fish (syntax, indent, compiler, autoload, ftplugin)git (syntax, indent, ftplugin)glsl (syntax, indent)gnuplot (syntax)go (syntax, compiler, indent)graphql (syntax, ftplugin)groovy (syntax)haml (syntax, indent, compiler, ftplugin)handlebars (syntax, indent, ftplugin)haskell (syntax, indent, ftplugin)haxe (syntax)html5 (syntax, indent, autoload, ftplugin)i3 (syntax, ftplugin)jasmine (syntax)javascript (syntax, indent, compiler, ftplugin, extras)json (syntax, indent, ftplugin)jst (syntax, indent)jsx (after)julia (syntax, indent)kotlin (syntax, indent)latex (syntax, indent, ftplugin)less (syntax, indent, ftplugin)liquid (syntax, indent, ftplugin)livescript (syntax, indent, compiler, ftplugin)lua (syntax, indent)mako (syntax, indent, ftplugin)markdown (syntax)mathematica (syntax, ftplugin)nginx (syntax, indent, ftplugin)nim (syntax, compiler, indent)nix (syntax, ftplugin)objc (ftplugin, syntax, indent)ocaml (syntax, indent, ftplugin)octave (syntax)opencl (syntax, indent, ftplugin)perl (syntax, indent, ftplugin)pgsql (syntax)php (syntax)plantuml (syntax, indent, ftplugin)powershell (syntax, indent, ftplugin)protobuf (syntax, indent)pug (syntax, indent, ftplugin)puppet (syntax, indent, ftplugin)purescript (syntax, indent, ftplugin)python-compiler (compiler, autoload)python (syntax, indent)qml (syntax, indent, ftplugin)r-lang (syntax, ftplugin)racket (syntax, indent, autoload, ftplugin)ragel (syntax)raml (syntax, ftplugin)rspec (syntax)ruby (syntax, indent, compiler, autoload, ftplugin)rust (syntax, indent, compiler, autoload, ftplugin)sbt (syntax)scala (syntax, indent, compiler, ftplugin)scss (syntax, autoload, ftplugin)slim (syntax, indent, ftplugin)solidity (syntax, indent)stylus (syntax, indent, ftplugin)swift (syntax, indent, ftplugin)sxhkd (syntax)systemd (syntax)terraform (syntax, indent, ftplugin)textile (syntax, ftplugin)thrift (syntax)tmux (syntax, ftplugin)tomdoc (syntax)toml (syntax, ftplugin)twig (syntax, indent, ftplugin)typescript (syntax, indent, compiler, ftplugin)vala (syntax, indent)vbnet (syntax)vcl (syntax)vm (syntax, indent)vue (syntax, indent, ftplugin)xls (syntax)yaml (syntax, ftplugin)yard (syntax)
git clone https://github.com/sheerun/vim-polyglot
git clone https://github.com/tomlion/vim-solidity.git ~/.vim/bundle/vim-solidity
#Vimux for tmux
wget https://github.com/benmills/vimux/tarball/master -O benmill-vimux.tar.gz
tar -xf benmill-vimux.tar.gz
rm benmill-vimux.tar.gz
cd
mv ~/.vim/autoload/plug.vim ~/.vim/autoload/plug-backup.vim
wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O ~/.vim/autoload/plug.vim
mkdir -p ~/.vim/vim-snippets
cd ~/.vim/vim-snippets
sh -c "curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh"
echo "installed vimcr"
wget https://raw.githubusercontent.com/Russell91/sshrc/master/sshrc && sudo chmod -R 600 sshrc && chmod +x sshrc && sudo mv sshrc /usr/local/bin
echo "ssh bashcr vimcr portability installed"
cd
echo ":nnoremap <C-B> <C-V>" | sudo tee -a /usr/share/vim/vimrc
echo ":nnoremap <C-O> o<Esc>" | sudo tee -a /usr/share/vim/vimrc
#echo ":command! Vb exe "norm! \<C-V>" | sudo tee -a /usr/share/vim/vimrc

##Python 2.7 & 3 + readthedocs + saltpack + jupiter + scipy/numpy + anaconda
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

sudo -H  python3 -m pip install jupyter
sudo -H  python -m pip install jupyter
echo "alias jupyter='jupyter notebook'" | sudo tee -a ~/.bashrc

sudo -H pip3 install numpy
sudo -H pip3 install scipy

sudo -H pip3 install ggplot ggpy mgplottools ppgplot pygg pyggplot rugplot svgplotlib

#CHECK gnuoctave mathematica

sudo -E apt-add-repository -y ppa:aims/sagemath
sudo -E apt-get update
sudo -E apt-get install sagemath-upstream-binary

ANACONDAVERSION=3-5.0.1-Linux-x86_64
wget https://repo.continuum.io/archive/Anaconda$ANACONDAVERSION.sh
bash Anaconda$ANACONDAVERSION.sh
rm Anaconda$ANACONDAVERSION.sh

#CHECK https://bioconda.github.io/

##Matlab
MATLABVERSION=R2017b
MATLABTYPE=glnxa64
wget http://ssd.mathworks.com/supportfiles/downloads/"$MATLABVERSION"/deployment_files/"$MATLABVERSION"/installers/"$MATLABTYPE"/MCR_"$MATLABVERSION"_"$MATLABTYPE"_installer.zip
unzip MCR_"$MATLABVERSION"_"$MATLABTYPE"_installer.zip
rm MCR_"$MATLABVERSION"_"$MATLABTYPE"_installer.zip
sudo ./install

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
gpg --verify ryep**.asc
cd ..
echo "alias coldstorage = 'cd /home/$USER/ethaddress.org && firefox -new-tab -url index.html'"
git clone https://github.com/pointbiz/bitaddress.org
cd bitaddress.org
gpg --verify CHANGE**.asc
cd ..
git clone https://github.com/litecoin-project/liteaddress.org
cd liteaddress.org
gpg --verify CHANGE**.asc
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
sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -O https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer
curl -O https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer.asc
sudo gpg --verify rvm-installer.asc 
sudo curl -sSL https://rvm.io/mpapis.asc | gpg --import -
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
/bin/iron/./chrome https://chrome.google.com/webstore/detail/librarian-for-arxiv-ferma/ddoflfjcbemgfgpgbnlmaedfkpkfffbm

wget https://ftp.gnu.org/gnu/icecat/38.8.0-gnu2/icecat-38.8.0.en-US.linux-x86_64.tar.bz2
wget https://ftp.gnu.org/gnu/icecat/38.8.0-gnu2/icecat-38.8.0.en-US.linux-x86_64.tar.bz2.sig
gpg --output icecat**tar.bz2 --decrypt icecat**tar.bz2.sig
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
gpg --keyserver pgpkeys.mit.edu --recv-key 3C0E751C
gpg --with-fingerprint vsftpd**.asc
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


##Coq##
COQVERSION=8.6
sudo apt-get install ocaml ocaml-native-compilers camlp5 liblablgtk2-ocaml-dev liblablgtksourceview2-ocaml-dev libgtk2.0-dev -y
#sudo apt-get install coq coqide -y
wget https://coq.inria.fr/distrib/V$COQVERSION/files/coq-$COQVERSION.tar.gz
tar -xvzf coq-$COQVERSION.tar.gz
cd coq-$COQVERSION
./configure -prefix /usr/local
make
sudo make install
rm coq-$COQVERSION.tar.gz
rm -r coq-$COQVERSION
echo "Coq test"
coqc -v
echo "Write down Check True to test coqide"
coqide &
git clone https://bitbucket.org/Peter_Sewell/lem.git
cd lem
make && make coq-libs
#for OCaml   : make ocaml-libs
#for HOL 4   : make hol-libs
#for Isabelle: make isa-libs
#for Coq     : make coq-libs
#If you just want to generate the input which Lem gives to these tools, please run make libs.
echo "Run as ~/coq-$COQVERSION/lem./lem -coq" 
cd ..
cd ..


##Dyagrams/Knowledge/Concepts/Ontology
mkdir know
#MySQLWorkbench
sudo apt-get remove iodbc -y
sudo apt-get install build-essential cmake cmake-data autoconf automake pkg-config libtool libzip-dev libxml2-dev libsigc++-2.0-dev libglade2-dev libgtkmm-2.4-dev libglu1-mesa-dev libgl1-mesa-glx mesa-common-dev libmysqlclient-dev libmysqlcppconn-dev uuid-dev libpixman-1-dev libpcre3-dev \libgnome2-dev libgnome-keyring-dev libgtk2.0-dev libpango1.0-dev libcairo2-dev python-dev libboost-dev libctemplate-dev mysql-client python-pysqlite2 libsqlite3-dev \swig libvsqlitepp-dev libgdal-dev -y
sudo apt-get install mysql-workbench-community -y
echo "filetype: mwb|sql"
#sqlitebrowser
sudo apt-get install sqlitebrowser -y
echo "filetype: csv|db"
#dia
sudo apt-get install dia dia2code -y
echo "filetype: dia"
#uml
sudo apt-get install umbrello
echo "filetype: xmi mdl zargo"
sudo apt-get install umlet
echo "filetype:uxf"
#owl
wget http://www.modelfutures.com/file_download/1/OwlEditor.zip
unzip OwlEditor.zip
rm OwlEditor.zip
#algos
wget http://ankara.lti.cs.cmu.edu/thtools/TagHelperTools2.zip
unzip TagHelperTools2.zip
rm TagHelperTools2.zip
cd TagHelper*
sudo chmod +x runtht.sh
sudo chmod +x portal.sh
echo "alias algos='/home/$USER/./runtht.sh'" | tee -a ~/.bashrc
echo "Run algos"
cd ..
#Hozo ont
read -p "Introduce test mail: " YML
read -p "Introduce password: " PZZ
wget http://download.hozo.jp/downloadfile.php?username=$YML&password=$PZZ&filename=oe55en.zip
unzip oe55en.zip
rm oe55en.zip
mv -r oe55en ontolotool
cd ontolotool
sudo chmod +x me4.jar
sudo chmod +x oe5.jar
echo "alias ontolotool='java -jar /home/$USER/ontolotool/me4.jar & java -jar /home/$USER/ontolotool/ONSETv1.2.jar'" | tee -a ~/.bashrc
wget http://www.meteck.org/files/onset/ONSETv1.2.jar
cd ..

sudo apt-get install wikipedia2text -y

#Gephi Network
GEPHIVERSION=0.9.1
wget https://github.com/gephi/gephi/releases/download/v0.9.1/gephi-$GEPHIVERSION-linux.tar.gz
tar -xf gephi-$GEPHIVERSION-linux.tar.gz
rm gephi-$GEPHIVERSION-linux.tar.gz
echo "alias gephi='/home/$USER/gephi-$GEPHIVERSION/bin/./gephi'" | sudo tee -a /home/$USER/.bashrc 

#Distributed systems
firefox --new-tab http://www.swirlds.com/download/
mv ~/Downloads/Swirlds*.zip ~/Swirlds.zip
unzip ~/Swirlds.zip
rm ~/Swirlds.zip


wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/shs/lit.sh
bash lit.sh
rm lit.sh


EOF
