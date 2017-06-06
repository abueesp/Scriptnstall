
### OpenSSL ###
#OPENSSLVERSION=1.1.0f #Not compatible with OpenSSH till 2.5
OPENSSLVERSION=openssl-1.0.2l.tar.gz
wget https://www.openssl.org/source/openssl-$OPENSSLVERSION.tar.gz
wget https://www.openssl.org/source/openssl-$OPENSSLVERSION.tar.gz.asc
gpg --keyserver hkp://keys.gnupg.net --recv-keys 8657ABB260F056B1E5190839D9C4D26D0E604491 #Matt Caswell
gpg --keyserver hkp://keys.gnupg.net --recv-keys 5B2545DAB21995F4088CEFAA36CEE4DEB00CFE33 #Mark J. Cox
#Viktor Dukhovni (no PGP)
gpg --keyserver hkp://keys.gnupg.net --recv-keys 62605AA4334AF9F0DDE5D349D3577507FA40E9E2 #Dr. Stephen Henson
gpg --keyserver hkp://keys.gnupg.net --recv-keys C1F33DD8CE1D4CC613AF14DA9195C48241FBF7DD #Tim Hudson
gpg --keyserver hkp://keys.gnupg.net --recv-keys 0A77335AADE74E6BB36CAD8ADFAB592ABDD52F1C #Lutz Jänicke	
#Emilia Käsper (no PGP)
gpg --keyserver hkp://keys.gnupg.net --recv-keys 765655DE62E396FF2587EB6C4F6DE1562118CF83 #Ben Laurie
gpg --keyserver hkp://keys.gnupg.net --recv-keys FEAB1FB2653717429B0B894F431711F76D1892F5 #Steve Marquess
gpg --keyserver hkp://keys.gnupg.net --recv-keys 7953AC1FBC3DC8B3B292393ED5E9E43F7DF9EE8C #Richard Levitte
gpg --keyserver hkp://keys.gnupg.net --recv-keys 0xAA589DAC5A6A9B85 #Bodo Möller
gpg --keyserver hkp://keys.gnupg.net --recv-keys B652F27F2B8D1B8DA78D7061BA6CDA461FE8E023 #Andy Polyakov
gpg --keyserver hkp://keys.gnupg.net --recv-keys E5E52560DD91C556DDBDA5D02064C53641C25E5D #Kurt Roeckx
gpg --keyserver hkp://keys.gnupg.net --recv-keys D099684DC7C21E02E14A8AFEF23479455C51B27C #Rich Salz
gpg --keyserver hkp://keys.gnupg.net --recv-keys 1B3DF808C221D2A5ED74172F0833F510E18C1C32 #Geoff Thorpe

gpg --verify openssl-$OPENSSLVERSION.tar.gz.asc openssl-$OPENSSLVERSION.tar.gz
if [ $? -eq 0 ]
then
    echo "GOOD SIGNATURE"
    gpg --delete-secret-and-public-keys --batch --yes 8657ABB260F056B1E5190839D9C4D26D0E604491
    gpg --delete-secret-and-public-keys --batch --yes 5B2545DAB21995F4088CEFAA36CEE4DEB00CFE33
    gpg --delete-secret-and-public-keys --batch --yes 62605AA4334AF9F0DDE5D349D3577507FA40E9E2
    gpg --delete-secret-and-public-keys --batch --yes C1F33DD8CE1D4CC613AF14DA9195C48241FBF7DD
    gpg --delete-secret-and-public-keys --batch --yes 0A77335AADE74E6BB36CAD8ADFAB592ABDD52F1C
    gpg --delete-secret-and-public-keys --batch --yes 765655DE62E396FF2587EB6C4F6DE1562118CF83
    gpg --delete-secret-and-public-keys --batch --yes FEAB1FB2653717429B0B894F431711F76D1892F5
    gpg --delete-secret-and-public-keys --batch --yes 7953AC1FBC3DC8B3B292393ED5E9E43F7DF9EE8C
    gpg --delete-secret-and-public-keys --batch --yes 0xAA589DAC5A6A9B85
    gpg --delete-secret-and-public-keys --batch --yes B652F27F2B8D1B8DA78D7061BA6CDA461FE8E023
    gpg --delete-secret-and-public-keys --batch --yes E5E52560DD91C556DDBDA5D02064C53641C25E5D
    gpg --delete-secret-and-public-keys --batch --yes D099684DC7C21E02E14A8AFEF23479455C51B27C
    gpg --delete-secret-and-public-keys --batch --yes 1B3DF808C221D2A5ED74172F0833F510E18C1C32
else
    echo "BAD SIGNATURE"
    exit
fi
rm openssl-$OPENSSLVERSION.tar.gz.asc
tar -xvzf openssl-$OPENSSLVERSION.tar.gz
rm openssl-$OPENSSLVERSION.tar.gz
cd openssl-$OPENSSLVERSION
./config
make
make test
sudo make install
cd ..
rm -r openssl-$OPENSSLVERSION
