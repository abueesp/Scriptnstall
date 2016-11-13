#!/bin/bash
#TCP flood mitigation
echo "net.ipv4.tcp_challenge_ack_limit = 999999999" >> sudo /etc/sysctl.conf
sudo sysctl -p
# My first script for dnie environment
sudo apt-get autoremove -y
#Bluetooth
sudo sed -i 's/InitiallyPowered = true/InitiallyPowered = false/g' /etc/bluetooth/main.conf
rfkill block bluetooth
#Prntscreensound
sudo mv /usr/share/sounds/freedesktop/stereo/camera-shutter.oga /usr/share/sounds/freedesktop/stereo/camera-shutter-disabled.oga
#Sudo on Files Eos
echo "[Contractor Entry]\nName=Open folder as root\nIcon=gksu-root-terminal\nDescription=Open folder as root\nMimeType=inode;application/x-sh;application/x-executable;\nExec=gksudo pantheon-files -d %U\nGettext-Domain=pantheon-files" >> Open_as_admin.contract
sudo mv Open_as_admin.contract /usr/share/contractor/Open_as_admin.contract
rm Open_as_admin.contract

#mirror
sudo sed -i 's|http://us.archive.ubuntu.com/ubuntu|http://ubuntu.uc3m.es/ubuntu|g' /etc/apt/sources.list
sudo apt-get update -y
sudo apt-get upgrade -y
#SSH
sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/gnome-keyring-ssh.desktop
sudo sed -i 's/PermitRootLogin without password/PermitRootLogin no/' /etc/ssh/sshd_config #noroot
sudo sed -i 's/Port 22/Port 1022/' /etc/ssh/sshd_config #SSH PORT OTHER THAN 22, SET 1022
sudo /etc/init.d/ssh stop
sudo chown -R $USER:$USER .ssh
sudo chmod -R 600 .ssh
sudo chmod +x .ssh
#UFW
sudo apt-get install gufw -y
sudo ufw enable
#sudo ufw allow 1022/tcp
sudo iptables -F
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#sudo iptables -A INPUT -p tcp --dport 1022 -j ACCEPT
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT ACCEPT ##If you are a server change this to DROP OUTPUT connections by default too
sudo iptables -P FORWARD DROP
sudo iptables restart
sudo service avahi-daemon stop ##This is for when DHCP does not work. Otherwise ps ax | grep dhclient && sudo kill -9 [pid]
sudo cupsctl -E --no-remote-any
sudo service cups-browsed stop
#Minus
sudo apt-get purge imagemagick fontforge geary -y
##psad
service psad stop
sudo apt-get -y install libcarp-clan-perl libdate-calc-perl libiptables-chainmgr-perl libiptables-parse-perl libnetwork-ipv4addr-perl libunix-syslog-perl libbit-vector-perl gcc wget -y
wget https://cipherdyne.org/psad/download/psad-2.4.3.tar.gz
wget https://cipherdyne.org/psad/download/psad-2.4.3.tar.gz.asc
gpg --verify psad**.asc
md5 = $(md5sum **tar.gz)
if [ $md5 "5aa0d22f0bea3ba32e3b9730f78157cf" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
tar xvf psad**.gz
cd psad**
sudo ./install.pl
cd
sudo rm -r psad**
service psad start

#fwsnort
wget http://cipherdyne.org/fwsnort/download/fwsnort-1.6.5.tar.gz
wget https://cipherdyne.org/fwsnort/download/fwsnort-1.6.5.tar.gz.asc
gpg --verify fwsnort**.asc
md5 = $(md5sum **tar.gz)
if [ $md5 "76552f820e125e97e4dfdd1ce6e3ead6" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
tar xvf fwsnort**.gz
cd fwsnort**
./configure
sudo make
sudo make install
sudo rm -r fwsnort**

#Some tools
sudo apt-get install secure-delete
sudo apt-get install duplicity deja-dup -y
sudo apt-get install iotop htop -y
sudo apt-get install vnstat -y
sudo apt-get install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
echo "Please write down an email to send you notifications when someone is attacking your ports: "
read email
echo "You entered: $email"
sudo sed "s/destemail = your_email@domain.com/destemail = $email/g" /etc/fail2ban/jail.local
sudo sed "s/action = %(action_)s/action = %(action_mw)s/g" /etc/fail2ban/jail.local
sudo sed -e "s/enabled  = false/enabled  = true/g" /etc/fail2ban/jail.local
sudo apt-get install logcheck logcheck-database -y
logcheck -p -u -m -h $email
sudo apt-get install firefox -y
sudo apt-get install subversion -y

##GNUPG
sudo apt-get install libgtk2.0-dev -y
sudo mkdir gpg
cd gpg
sudo wget https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.22.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.22.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "c40015ed88bf5f50fa58d02252d75cf20b858951" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd libgp**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo rm -r libgp**

sudo wget https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.7.0.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.7.0.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "f840b737faafded451a084ae143285ad68bbfb01" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd libgcr**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo rm -r libgcr**

sudo wget https://www.gnupg.org/ftp/gcrypt/libksba/libksba-1.3.4.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/libksba/libksba-1.3.4.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "bc84945400bd1cabfd7b8ba4e20e71082f32bcc9" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd libks**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo rm -r libks**

sudo wget https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-2.4.2.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-2.4.2.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "ac1047f9764fd4a4db7dafe47640643164394db9" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd libas**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo rm -r libas**

sudo wget https://www.gnupg.org/ftp/gcrypt/npth/npth-1.2.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/npth/npth-1.2.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "3bfa2a2d7521d6481850e8a611efe5bf5ed75200" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd npth**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo npth**

sudo wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.1.12.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.1.12.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "3b01a35ac04277ea31cc01b4ac4e230e54b5480c" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd gnupg**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo rm -r gnupg**

sudo wget https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.6.0.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.6.0.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "f840b737faafded451a084ae143285ad68bbfb01" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd gpgm**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo rm -r gpgm**

sudo wget https://www.gnupg.org/ftp/gcrypt/gpa/gpa-0.9.9.tar.bz2
sudo wget https://www.gnupg.org/ftp/gcrypt/gpa/gpa-0.9.9.tar.bz2.sig
sha1 = $(sha1sum **tar.bz2)
if [ $sha1 "1cf86c9e38aa553fdb880c55cbc6755901ad21a4" ]
then
    echo "PACKAGE VERIFIED"
else
    echo "PACKAGE NOT VERIFIED"
    break
fi
gpg --verify **.sig **.bz2
sudo tar xvjf **.tar.bz2
cd gpa**
./configure
sudo make
sudo make install
cd ..
sudo rm **.bz2 && sudo rm **.sig && sudo rm -r gpa**

cd ..
sudo rm -r gpg

##DNIe (at last)
sudo apt-get install opensc libccid pcscd libacr38u pinentry-gtk2 pcsc-tools libpcsclite1 libpcsclite-dev libreadline6 libreadline-dev coolkey libnss3-tools -y
sudo apt-get install autoconf subversion libpcsclite-dev libreadline6 libreadline-dev openssl libssl-dev libtool libltdl-dev libccid pinentry-gtk2 build-essential autoconf subversion openssl libssl-dev libtool libltdl-dev pkg-config -y
sudo apt-get autoremove opensc -y
sudo svn list https://forja.cenatic.es/svn/opendnie/opensc-opendnie/trunk
sudo cp /home/$USER/.mozilla/firefox/**.default/cert8.db /etc/firefox-3.0/profile/cert8.db
sudo dpkg-reconfigure ca-certificates
sudo update-ca-certificates
sudo svn checkout --trust-server-cert --no-auth-cache --username anonsvn --pass anonsvn https://forja.cenatic.es/svn/opendnie/opensc-opendnie/trunk
sudo mkdir -p .openscDNIe
cd trunk
sudo sed -i 's:(top_builddir)/src/libopensc/libopensc.la:(top_builddir)/src/libopensc/libopensc.la \ "'$(sudo find / -name libltdl.la)'":g' src/tools/Makefile.am
cd trunk
./bootstrap
./configure --prefix=/usr --sysconfdir=/etc/opensc
make
sudo make install
sudo modutil -add module -libfile /usr/lib/opensc-pkcs11.so -force
sudo sed "s:# enable_pinpad = false;:enable_pinpad = false;:g" $(sudo find / -name opensc.conf)
sudo find / -samefile /home/node/.mozilla/firefox/**.default/prefs.js
##Autoridad de Validación AV DNIE FNMT
wget http://www.dnielectronico.es/descargas/certificados/OCSP_VA_DNIE_FNMT_SHA2.zip
sudo unzip OCSP**
sudo rm OCSP**.zip
sudo mv OCSP**.cer OCSP**.crt
sudo cp OCSP**.crt /usr/share/ca-certificates/OCSP**.crt
sudo cp -rvf OCSP**.crt /usr/share/ca-certificates/mozilla/OCSP**.crt
sudo rm OCSP**.crt
sudo dpkg-reconfigure ca-certificates
sudo update-ca-certificates
## Autoridad de Certificación Raíz del DNIe 
sudo apt-get install cabextract -y
wget http://www.dnielectronico.es/ZIP/ACRAIZ-SHA2.CAB
sudo cabextract ACRAIZ**
sudo rm ACRAIZ**.CAB
sudo mv ACRAIZ**.cer ACRAIZ**.crt
sudo cp ACRAIZ**.crt /usr/share/ca-certificates/ACRAIZ**.crt
sudo cp -rvf ACRAIZ**.crt /usr/share/ca-certificates/mozilla/ACRAIZ**.crt
sudo rm ACRAIZ**.crt
sudo dpkg-reconfigure ca-certificates
sudo apt-get purge cabextract -y
sudo cp /home/$USER/.mozilla/firefox/**.default/cert8.db /etc/firefox-3.0/profile
sudo update-ca-certificates
sudo modutil -add module -libfile /usr/lib/opensc-pkcs11.so
sudo apt-get autoremove -y
echo "HEY! CHECK IF YOU HAVE CORRECTED INSTALLED THE 2 CERTIFICATES!! If so, your 2 CA Certicates from Spanish Admin and DNIe tools have been installed. Write *** lsusb *** to check which usb is dnie connected and *** pcsc_scan *** to check its data. Pulse ENTER TO DO IT." 
read $ENTER 
sudo lsusb

##CC
echo "descargando Lector SCR 3310 ICAS"
sudo apt-get install libccid libpcsclite1 pcscd pcsc-tools pcsc-lite -y
sudo apt-get install libusb-dev -y
sudo /etc/init.d/pcscd restart
sudo lsusb
sudo wget --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3" http://www.abogacia.es/repositorio/acadescarga/SCR_3310_Linux.zip
#Old drivers
#wget http://www.abogacia.es/wp-content/uploads/2012/09/scmccid_linux_32bit_driver_V5.0.21.tar.gz
sudo tar -xzvf scmccid**
sudo wget --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3" http://www.abogacia.es/repositorio/acadescarga/SCR_3310_Linux.zip
sudo unzip SCR**.zip 
sudo rm SCR**.zip
cd scmccid**
sudo  ./install
cd ..
sudo rm -r scmccid**
echo "write 'sudo pcsc_scan' to check usb reader"

echo descargando MiniLector ACA EU
sudo apt-get install libccid libpcsclite1 pcscd pcsc-tools pcsc-lite -y
sudo wget --no-check-certificate --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3" https://documentacion.redabogacia.org/docushare/dsweb/Get/Document-4902898/Kit_Bit4id_Linux_1.2.16.1.zip
sudo unzip Kit**.zip
sudo rm Kit**.zip
sudo rm -r 32
cd 64
cd pkcs11
sudo cp * /usr/lib
sudo ldconfig
cd ..
cd ..
sudo rm -r 64
sudo wget --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3" http://www.abogacia.es/wp-content/uploads/2012/09/ACR38_PKG_Lnx_1.0.4_P.zip
sudo unzip ACR**.zip
cd ACR**
cd acs**
cd ubuntu
cd quantal
sudo dpkg -i **amd64.deb
cd ..
cd ..
cd ..
cd ..
sudo rm -r ACR38**
sudo /etc/init.d/pcscd restart
sudo lsusb
sudo wget --no-check-certificate https://documentacion.redabogacia.org/docushare/dsweb/Get/Document-4902917/safesign_3.0.zip
sudo unzip safesign**.zip
sudo dpkg -i safesign**.deb
sudo rm -r safesign**
echo "write 'sudo pcsc_scan' to check usb reader"

echo descargando todos los certificados ACA
firefox http://www.abogacia.es/repositorio/acadescarga/ACA_certs_todos.zip
sudo mv Downloads/**todos.zip /home/$USER/
sudo unzip **todos.zip && rm **todos.zip
sudo cp **.crt /usr/share/ca-certificates/
sudo cp -rvf **.crt /usr/share/ca-certificates/mozilla/
sudo rm **.crt
sudo dpkg-reconfigure ca-certificates
sudo cp /home/$USER/.mozilla/firefox/**.default/cert8.db /etc/firefox-3.0/profile
sudo update-ca-certificates

sudo wget --no-check-certificate https://documentacion.redabogacia.org/docushare/dsweb/Get/Document-28008980/CPS_ACA_014.0.pdf
sudo wget --no-check-certificate https://administracionelectronica.gob.es/ctt/resources/Soluciones/201/Area%20descargas/TSA--Firma-Guia-de-Uso-del-Sello-de-Tiempo-y-Marca-de-Tiempo.pdf
sudo wget --no-check-certificate https://administracionelectronica.gob.es/ctt/resources/Soluciones/201/descargas/TSA--Firma-Servicios.pdf
sudo wget --no-check-certificate https://documentacion.redabogacia.org/docushare/dsweb/Get/Document-3343898/Manual%20-BURO%20MAIL-V_4_1.pdf
sudo wget --no-check-certificate https://documentacion.redabogacia.org/docushare/dsweb/Get/Document-3348303/Tarifas%20Mi%20cuenta_2.pdf
sudo wget --no-check-certificate https://administracionelectronica.gob.es/ctt/resources/Soluciones/190/Area%20descargas/TSA--Firma-Guia-de-Uso-del-Sello-de-Tiempo-y-Marca-de-Tiempo.pdf
sudo wget --no-check-certificate https://documentacion.redabogacia.org/docushare/dsweb/Get/Document-4448750/Manual%20de%20Usuario%20LexnetAbogado%20v2..pdf


##bash
echo "alias gpgcard='gpg --card-status'" >> sudo /etc/bash.bashrc
echo "alias troubleshoot='firefox -new-tab -url https://valide.redsara.es/valide/ 
-new-tab -url https://av-dnie.cert.fnmt.es/compruebacert/compruebacert
-new-tab -url https://formacion.lexnetabogacia.es/lexnetabogacia/v1/security/start?idParameter=formacion
-new-tab -url https://wiki.redabogacia.org/index.php/Tarjeta_ACA_en_Linux_2048#Certificados_Ra.C3.ADz 
-new-tab -url https://documentacion.redabogacia.org/docushare/dsweb/View/Collection-851 
-new-tab -url https://documentacion.redabogacia.org/docushare/dsweb/Get/Document-13900/Comprobador_Certificado.htm
-new-tab -url https://administracionelectronica.gob.es/pae_Home/pae_Estrategias/pae_Identidad_y_firmaelectronica.html
-new-tab -url https://www.administraciondejusticia.gob.es/verificadorInfolexnet/compruebaNavegador.html
-new-tab -url https://www.administraciondejusticia.gob.es/paj/publico/ciudadano/informacion_institucional/modernizacion/modernizacion_tecnologica/infolexnet/faqs/tecnicas/
-new-tab -url https://www.sede.fnmt.gob.es/certificados/persona-fisica/obtener-certificado-software' && sudo lsusb && sudo pcsc_scan" >> sudo /etc/bash.bashrc

echo "alias AGE='firefox -new-tab -url https://administracion.gob.es/ 
new-tab -url https://administracionelectronica.gob.es/pae_Home/pae_Estrategias/Racionaliza_y_Comparte/catalogo-servicios-admon-digital.html 
new-tab -url https://cambiodomicilio.redsara.es/pcd/ 
new-tab -url http://administracionelectronica.gob.es/ctt/buscadorSoluciones.htm 
new-tab -url https://contrataciondelestado.es/wps/portal/plataforma 
new-tab -url https://www.agenciatributaria.gob.es/AEAT.sede/Inicio/Inicio.shtml
new-tab -url https://www.abogacia.es/servicios-abogacia/
new-tab -url https://www.ventanillaunicaabogados.org/vup/index.jsp'" >> sudo /etc/bash.bashrc

echo "alias abogado='firefox -new-tab -url http://www.abogacia.es/
new-tab -url https://www.redabogacia.org/
new-tab -url https://mail.icasevilla.org/
new-tab -url https://mail.icasevilla.org/pronto/
new-tab -url https://lexnet.justicia.es
new-tab -url https://www.icas.es/ 
new-tab -url https://www.ventanillaunicaabogados.org/vup/index.jsp'">> sudo /etc/bash.bashrc

echo "alias JA='firefox -new-tab -url https://transparencia.dipusevilla.es/es/busqueda/index.html 
new-tab -url https://ws024.juntadeandalucia.es/ae/ 
new-tab -url https://administracionelectronica.gob.es/ctt/buscadorSoluciones.htm
new-tab -url https://www.juntadeandalucia.es/haciendayadministracionpublica/ciudadania/
new-tab -url http://www.abogacia.es/servicios-abogacia/
new-tab -url http://www.juntadeandalucia.es/repositorio/usuario/listado/fichacompleta.jsf'" >> sudo /etc/bash.bashrc

echo "alias EU='firefox -new-tab -url https://www.apertium.org/index.eng.html?dir=eng-spa#translation'" >> sudo /etc/bash.bashrc

echo "alias Empresa='firefox -new-tab -url https://ssweb.seap.minhap.es/tramitesEE3/es new-tab -url https://eugo.es/portalEugo/buscarConsultaGuias.htm new-tab -url https://eugo.es/portalEugo/verAsociacionesAsistencia.htm'" >> sudo /etc/bash.bashrc

wget http://api4mini.webmoney.ru/download/mywm_linux_amd64.sh
sh mywm**.sh
sudo rm mywm**.sh

wget http://www.sinadura.net/documents/18043/217945/sinadura-ce-4.2.0-unix64-installer.jar?version=1.0
