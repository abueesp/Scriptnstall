#!/bin/bash
# My first script for dnie environment
sudo apt-get autoremove -y
#Bluetooth
sudo sed -i 's/InitiallyPowered = true/InitiallyPowered = false/g' /etc/bluetooth/main.conf
rfkill block bluetooth

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

#Some tools
sudo apt-get install iotop -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
echo "Please write down an email to send you notifications when someone is attacking your ports: "
read email
echo "You entered: $email"
sed "s/destemail = your_email@domain.com/destemail = $email/g" /etc/fail2ban/jail.local
sed "s/action = %(action_)s/action = %(action_mw)s/g" /etc/fail2ban/jail.local
sed -e "s/enabled  = false/enabled  = true/g" /etc/fail2ban/jail.local
sudo apt-get install firefox -y
sudo apt-get install subversion -y

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
echo descargando Lector SCR 3310 ICAS
sudo apt-get install libccid libpcsclite1 pcscd pcsc-tools pcsc-lite -y
sudo apt-get install libusb-dev -y
sudo /etc/init.d/pcscd restart
sudo lsusb
http://www.abogacia.es/repositorio/acadescarga/SCR_3310_Linux.zip
#Old drivers
#wget http://www.abogacia.es/wp-content/uploads/2012/09/scmccid_linux_32bit_driver_V5.0.21.tar.gz
#tar -xzvf scmccid**
wget -qO- -O tmp.zip http://www.abogacia.es/repositorio/acadescarga/SCR_3310_Linux.zip && unzip tmp.zip && rm tmp.zip
cd scmccid**
sudo  ./install
cd ..
rm scmccid**
echo "write 'sudo pcsc_scan' to check usb reader"

echo descargando MiniLector ACA EU
sudo apt-get install libccid libpcsclite1 pcscd pcsc-tools pcsc-lite -y
wget -qO- -O tmp.zip https://documentacion.redabogacia.org/docushare/dsweb/Get/Document-4902898/Kit_Bit4id_Linux_1.2.16.1.zip && unzip tmp.zip && rm tmp.zip
rm 32
cd 64
cd pkcs11
sudo cp * /usr/lib
sudo ldconfig
cd ..
cd ..
rm 64
wget -qO- -O tmp.zip http://www.abogacia.es/wp-content/uploads/2012/09/ACR38_PKG_Lnx_1.0.4_P.zip && unzip tmp.zip && rm tmp.zip
sudo dpkg -i /ACR38_PKG_Lnx_104_P/acsccid_linux_bin-1.0.4/ubuntu/quantal/libacsccid1_1.0.4-1_amd64.deb
rm ACR38**
/etc/init.d/pcscd restart
sudo lsusb
wget -qO- -O tmp.zip https://documentacion.redabogacia.org/docushare/dsweb/Get/Document-4902917/safesign_3.0.zip && unzip tmp.zip && rm tmp.zip
sudo dpkg -i safesign_3.0.deb
rm safesign_3.0.deb
echo "write 'sudo pcsc_scan' to check usb reader"

echo descargando todos los certificados ACA
firefox http://www.abogacia.es/repositorio/acadescarga/ACA_certs_todos.zip
mv Downloads/ACA_certs_todos.zip /home/$USER/
unzip **todos.zip && rm **todos.zip
sudo cp **.crt /usr/share/ca-certificates/**
sudo cp -rvf **.crt /usr/share/ca-certificates/mozilla/**
sudo rm **.crt
sudo dpkg-reconfigure ca-certificates
sudo cp /home/$USER/.mozilla/firefox/**.default/cert8.db /etc/firefox-3.0/profile
sudo update-ca-certificates
wget --no-check-certificate https://documentacion.redabogacia.org/docushare/dsweb/Get/Document-28008980/CPS_ACA_014.0.pdf
wget https://administracionelectronica.gob.es/ctt/resources/Soluciones/201/Area%20descargas/TSA--Firma-Guia-de-Uso-del-Sello-de-Tiempo-y-Marca-de-Tiempo.pdf
wget https://administracionelectronica.gob.es/ctt/resources/Soluciones/201/descargas/TSA--Firma-Servicios.pdf
wget https://documentacion.redabogacia.org/docushare/dsweb/Get/Document-3343898/Manual%20-BURO%20MAIL-V_4_1.pdf
wget https://documentacion.redabogacia.org/docushare/dsweb/Get/Document-3348303/Tarifas%20Mi%20cuenta_2.pdf
wget https://administracionelectronica.gob.es/ctt/resources/Soluciones/190/Area%20descargas/TSA--Firma-Guia-de-Uso-del-Sello-de-Tiempo-y-Marca-de-Tiempo.pdf
wget https://documentacion.redab ogacia.org/docushare/dsweb/Get/Document-4448750/Manual de Usuario LexnetAbogado v2..pdf
echo descargando Reunete
wget https://login-reunete.redsara.es//comun/download/SpontaniaUpdater_1.0.1.11.dmg
sudo dpkg -i SpontaniaUpdater**
rm SpontaniaUpdater**


##bash
sudo echo "alias gpgcard='gpg --card-status'" >> /etc/bash.bashrc

sudo echo "alias troubleshoot='firefox -new-tab -url https://valide.redsara.es/valide/ 
-new-tab -url https://av-dnie.cert.fnmt.es/compruebacert/compruebacert
-new-tab -url https://formacion.lexnetabogacia.es/lexnetabogacia/v1/security/start?idParameter=formacion
-new-tab -url https://wiki.redabogacia.org/index.php/Tarjeta_ACA_en_Linux_2048#Certificados_Ra.C3.ADz 
-new-tab -url https://documentacion.redabogacia.org/docushare/dsweb/View/Collection-851 
-new-tab -url https://documentacion.redabogacia.org/docushare/dsweb/Get/Document-13900/Comprobador_Certificado.htm
-new-tab -url https://administracionelectronica.gob.es/pae_Home/pae_Estrategias/pae_Identidad_y_firmaelectronica.html
-new-tab -url https://www.administraciondejusticia.gob.es/verificadorInfolexnet/compruebaNavegador.html
-new-tab -url https://www.administraciondejusticia.gob.es/paj/publico/ciudadano/informacion_institucional/modernizacion/modernizacion_tecnologica/infolexnet/faqs/tecnicas/
-new-tab -url https://www.sede.fnmt.gob.es/certificados/persona-fisica/obtener-certificado-software' && sudo lsusb && sudo pcsc_scan" >> /etc/bash.bashrc

sudo echo "alias AGE='firefox -new-tab -url https://administracion.gob.es/ 
new-tab -url https://administracionelectronica.gob.es/pae_Home/pae_Estrategias/Racionaliza_y_Comparte/catalogo-servicios-admon-digital.html 
new-tab -url https://cambiodomicilio.redsara.es/pcd/ 
new-tab -url http://administracionelectronica.gob.es/ctt/buscadorSoluciones.htm 
new-tab -url https://contrataciondelestado.es/wps/portal/plataforma 
new-tab -url https://www.agenciatributaria.gob.es/AEAT.sede/Inicio/Inicio.shtml
new-tab -url https://www.abogacia.es/servicios-abogacia/
new-tab -url https://www.https://www.ventanillaunicaabogados.org/vup/index.jsp'" >> /etc/bash.bashrc

sudo echo "alias abogado='firefox -new-tab -url http://www.abogacia.es/
new-tab -url https://www.redabogacia.org/
new-tab -url https://mail.icasevilla.org/
new-tab -url https://mail.icasevilla.org/pronto/
new-tab -url https://lexnet.justicia.es
new-tab -url https://www.icas.es/ 
new-tab -url https://www.ventanillaunicaabogados.org/vup/index.jsp'">> /etc/bash.bashrc

sudo echo "alias JA='firefox -new-tab -url https://transparencia.dipusevilla.es/es/busqueda/index.html 
new-tab -url https://ws024.juntadeandalucia.es/ae/ 
new-tab -url https://administracionelectronica.gob.es/ctt/buscadorSoluciones.htm
new-tab -url https://www.juntadeandalucia.es/haciendayadministracionpublica/ciudadania/
new-tab -url http://www.abogacia.es/servicios-abogacia/" >> /etc/bash.bashrc

sudo echo "alias EU='firefox -new-tab -url https://www.apertium.org/index.eng.html?dir=eng-spa#translation'" >> /etc/bash.bashrc

sudo echo "alias Empresa='firefox -new-tab -url https://ssweb.seap.minhap.es/tramitesEE3/es new-tab -url https://eugo.es/portalEugo/buscarConsultaGuias.htm new-tab -url https://eugo.es/portalEugo/verAsociacionesAsistencia.htm'" >> /etc/bash.bashrc
