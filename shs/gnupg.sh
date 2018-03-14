
##GNUPG2
sudo apt-get install libgtk2.0-dev -y
mkdir gpg
cd gpg

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
#SHA=a98385734a0c3f5b713198e8d6e6e4aeb0b76fde
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

gpg --delete-keys 4F25E3B6
gpg --delete-keys 33BD3F06

cd ..
sudo rm -r gpg
