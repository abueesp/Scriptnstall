
##GNUPG
sudo apt-get install libgtk2.0-dev -y
mkdir gpg2
cd gpg2
gpg2 --recv-key D8692123C4065DEA5E0F3AB5249B39D24F25E3B6
gpg2 --recv-key 46CC730865BB5C78EBABADCF04376F3EE0856959
gpg2 --recv-key 031EC2536E580D8EA286A9F22071B08A33BD3F06
gpg2 --recv-key D238EA65D64C67ED4C3073F28A861B1C7EFD60D9

LIBGPGVERSION=1.27
wget https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-$LIBGPGVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-$LIBGPGVERSION.tar.bz2.sig
gpg2 --verify libgpg-error-$LIBGPGVERSION.tar.bz2.sig libgpg-error-$LIBGPGVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf libgpg-error-$LIBGPGVERSION.tar.bz2
cd libgpg-error-$LIBGPGVERSION
./configure
make
sudo make install
cd ..
sudo rm libgpg-error-$LIBGPGVERSION.tar.bz2 && sudo rm libgpg-error-$LIBGPGVERSION.tar.bz2.sig && sudo rm -r libgpg-error-$LIBGPGVERSION

LIBGCRYPTVERSION=1.7.6
wget https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-$LIBGCRYPTVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-$LIBGCRYPTVERSION.tar.bz2.sig
gpg2 --verify libgcrypt-$LIBGCRYPTVERSION.tar.bz2.sig libgcrypt-$LIBGCRYPTVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf libgcrypt-$LIBGCRYPTVERSION.tar.bz2
cd libgcrypt-$LIBGCRYPTVERSION
./configure
make
sudo make install
cd ..
rm libgcrypt-$LIBGCRYPTVERSION.tar.bz2 && rm libgcrypt-$LIBGCRYPTVERSION.tar.bz2.sig && sudo rm -r libgcrypt-$LIBGCRYPTVERSION

LIBKSBAVERSION=1.3.5
wget https://www.gnupg.org/ftp/gcrypt/libksba/libksba-$LIBKSBAVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/libksba/libksba-$LIBKSBAVERSION.tar.bz2.sig
gpg2 --verify libksba-$LIBKSBAVERSION.tar.bz2.sig libksba-$LIBKSBAVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf libksba-$LIBKSBAVERSION.tar.bz2
cd libksba-$LIBKSBAVERSION
./configure
make
sudo make install
cd ..
rm libksba-$LIBKSBAVERSION.tar.bz2 && rm libksba-$LIBKSBAVERSION.tar.bz2.sig && sudo rm -r libksba-$LIBKSBAVERSION

LIBASSUANVERSION=2.4.3
wget https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-$LIBASSUANVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-$LIBASSUANVERSION.tar.bz2.sig
gpg2 --verify libassuan-$LIBASSUANVERSION.tar.bz2.sig libassuan-$LIBASSUANVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf libassuan-$LIBASSUANVERSION.tar.bz2
cd libassuan-$LIBASSUANVERSION
./configure
make
sudo make install
cd ..
rm libassuan-$LIBASSUANVERSION.tar.bz2 && rm libassuan-$LIBASSUANVERSION.tar.bz2.sig && sudo rm -r libassuan-$LIBASSUANVERSION

NPTHVERSION=1.4
wget https://www.gnupg.org/ftp/gcrypt/npth/npth-$NPTHVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/npth/npth-$NPTHVERSION.tar.bz2.sig
gpg2 --verify npth-$NPTHVERSION.tar.bz2.sig npth-$NPTHVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf npth-$NPTHVERSION.tar.bz2
cd npth-$NPTHVERSION
./configure
make
sudo make install
cd ..
rm npth-$NPTHVERSION.tar.bz2 && rm npth-$NPTHVERSION.tar.bz2.sig && sudo rm -r npth-$NPTHVERSION

GNUPGVERSION=2.1.21
wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPGVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPGVERSION.tar.bz2.sig
gpg2 --verify gnupg-$GNUPGVERSION.tar.bz2.sig gnupg-$GNUPGVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf gnupg-$GNUPGVERSION.tar.bz2
cd gnupg-$GNUPGVERSION
./configure
make
sudo make install
cd ..
rm gnupg-$GNUPGVERSION.tar.bz2 && rm gnupg-$GNUPGVERSION.tar.bz2.sig && sudo rm -r gnupg-$GNUPGVERSION

GPGMEVERSION=1.9.0
wget https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-$GPGMEVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-$GPGMEVERSION.tar.bz2.sig
gpg2 --verify gpgme-$GPGMEVERSION.tar.bz2.sig gpgme-$GPGMEVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf gpgme-$GPGMEVERSION.tar.bz2
cd gpgme-$GPGMEVERSION
./configure
make
sudo make install
cd ..
rm gpgme-$GPGMEVERSION.tar.bz2 && rm gpgme-$GPGMEVERSION.tar.bz2.sig && sudo rm -r gpgme-$GPGMEVERSION

GPAVERSION=0.9.10
sudo wget https://www.gnupg.org/ftp/gcrypt/gpa/gpa-$GPAVERSION.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/gpa/gpa-$GPAVERSION.tar.bz2.sig
gpg2 --verify gpa-$GPAVERSION.tar.bz2.sig gpa-$GPAVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
tar xvjf gpa-$GPAVERSION.tar.bz2
cd gpa-$GPAVERSION
./configure
sudo make
sudo make install
cd ..
rm gpa-$GPAVERSION.tar.bz2 && rm gpa-$GPAVERSION.tar.bz2.sig && sudo rm -r gpa-$GPAVERSION

GNUPGVERSION=2.1.16
wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPGVERSION.tar.bz2
wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-$GNUPGVERSION.tar.bz2.sig
gpg2 --verify gnupg-$GNUPGVERSION.tar.bz2.sig gnupg-$GNUPGVERSION.tar.bz2
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
else
    echo "BAD SIGNATURE"
    break
fi
sudo sh -c "echo 'gpg-agent --daemon --verbose --sh --enable-ssh-support --no-allow-external-cache --no-allow-loopback-pinentry --allow-emacs-pinentry --log-file \"~/.gpg-agent-info\"' >> /etc/init.d/gpg-agent" #add gpg-agent with steroids
tar xvjf gnupg-$GNUPGVERSION.tar.bz2
cd gnupg-$GNUPGVERSION
./configure
make
sudo make install
sudo cp /usr/bin/pinentry /usr/local/bin/pinentry #a new copy of pinentry (to introduce passwords) to local
cd ..
rm gnupg-$GNUPGVERSION.tar.bz2 && rm gnupg-$GNUPGVERSION.tar.bz2.sig && sudo rm -r gnupg-$GNUPGVERSION
gpg-agent --daemon --verbose --sh --enable-ssh-support --pinentry-program pinentry-tty --no-allow-external-cache --no-allow-loopback-pinentry --allow-emacs-pinentry --log-file \"~/.gpg-agent-info\"

cd ..
sudo rm -r gpg2
gpg2 --delete-secret-and-public-keys --batch --yes D8692123C4065DEA5E0F3AB5249B39D24F25E3B6
gpg2 --delete-secret-and-public-keys --batch --yes 46CC730865BB5C78EBABADCF04376F3EE0856959
gpg2 --delete-secret-and-public-keys --batch --yes 031EC2536E580D8EA286A9F22071B08A33BD3F06
gpg2 --delete-secret-and-public-keys --batch --yes D238EA65D64C67ED4C3073F28A861B1C7EFD60D9
gpg2 --version
gpgconf --list-components
cd ..
