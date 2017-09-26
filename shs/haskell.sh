sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:hvr/ghc
sudo apt-get update
sudo apt-get install haskell-platform -y
sudo apt-get install cabal-install ghc -y
cabal install cabal-install
sudo su
export PATH=~/.cabal/bin:/opt/cabal/*/bin:/opt/ghc/*/bin:$PATH
export PATH=$HOME/.cabal/bin:/opt/cabal/*/bin:/opt/ghc/*/bin:$PATH
echo 'export PATH=$HOME/.cabal/bin:/opt/cabal/*/bin:/opt/ghc/*/bin:$PATH' >> sudo /etc/bash.bashrc
echo 'export PATH=~/.cabal/bin:/opt/cabal/*/bin:/opt/ghc/*/bin:$PATH' >> sudo /etc/bash.bashrc
exit
cabal update
cabal install webdriver

