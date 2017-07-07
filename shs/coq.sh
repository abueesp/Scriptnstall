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
