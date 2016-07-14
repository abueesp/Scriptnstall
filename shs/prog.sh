
sudo apt-get install autojump -y
sudo apt-get install zsh -y 
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sudo sed -ir 's/ZSH_THEME="robbyrussell"/ZSH_THEME="norm"/g' ~/.oh-my-zsh #noroot
sudo apt-get install byobu -y

#Text Edition Tools
sudo add-apt-repository ppa:webupd8team/sublime-text-3 -y 
sudo apt-get update -y
sudo apt-get install vim vim-scripts -y
git clone https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
sudo apt-get install sublime-text-installer -y



##Emacs
sudo rm -r /usr/local/stow
set -e
readonly version="24.5"
# install dependencies
sudo apt-get install -y stow build-essential libx11-dev xaw3dg-dev libjpeg-dev libpng12-dev libgif-dev libtiff5-dev libncurses5-dev libxft-dev librsvg2-dev libmagickcore-dev libmagick++-dev libxml2-dev libgpm-dev libghc-gconf-dev libotf-dev libm17n-dev  libgnutls-dev -y
# download source package
wget http://ftp.gnu.org/gnu/emacs/emacs-"$version".tar.xz
tar xvf emacs-"$version".tar.xz
# build and install
sudo mkdir -p /usr/local/stow
cd emacs-"$version"
./configure \
    --with-xft \
    --with-x-toolkit=lucid
make
sudo rm -r /usr/local/stow
sudo make install prefix=/usr/local/stow/emacs-"$version" && cd /usr/local/stow
sudo rm /usr/local/share/info/dir
sudo stow emacs-"$version" 
cd ..
#spacemacs
sudo git clone http://github.com/syl20bnr/spacemacs ~/.emacs.d
##plugins
#org-mode
chmod ##

cd ~/.emacs.d/elpa/
mkdir ##
sudo apt-get install texinfo -y
wget http://orgmode.org/org-8.3.4.zip
unzip org**
cd org**
sudo make
sudo make install
cd ..
sudo rm -r org**
cd ..
