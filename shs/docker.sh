#Docker 
sudo cat /boot/config-`uname -r` | grep CONFIG_SECCOMP=
sudo wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker $USER
sudo apt-get purge apparmor -y
sudo rm -rf /etc/apparmor.d/
sudo rm -rf /etc/apparmor
mkdir docker
cd docker

#SSH
sudo apt-get install ssh -y
newsshkey
sudo sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/gnome-keyring-ssh.desktop
sudo sed -i 's/PermitRootLogin without password/PermitRootLogin no/' /etc/ssh/sshd_config #noroot
sudo sed -i 's/Port **/Port 1022/' /etc/ssh/sshd_config #SSH PORT OTHER THAN 22, SET 1022
sudo /etc/init.d/ssh restart
sudo chown -R $USER:$USER .ssh
sudo chmod -R 700 .ssh 
sudo chmod +x .ssh

#extra-tools
sudo apt-get install go -y
export GOPATH="$HOME/$USER/docker"
go get github.com/vbatts/docker-utils/cmd/docker-fetch
go get github.com/vbatts/docker-utils/cmd/dockertarsum

git clone https://github.com/docker/docker-bench-security.git
cd docker-bench-security
docker-compose run --rm docker-bench-security

#Securing the server
git clone https://github.com/konstruktoid/hardening.git
cd hardening
sudo gedit ubuntu.cfg
sudo bash ubuntu.sh

#Auditing
mkdir Auditing
cd Auditing
git clone https://github.com/CISOfy/lynis
cd lynis
echo "use ./lynis"
cd ..
git clone https://github.com/zuBux/drydock.git
cd drydock
pip install -r requirements.txt
echo "use -- python drydock.py -d 10.0.0.2:2736 -c /home/$USER/cert/cert.pem -k /home/$USER/cert/cert.key -p conf/myprofile.json -o /home/$USER/Auditing/drydock/audit_remote.json -f json -v 2 --,  being -v 1 for onoly errors and -v 3 for debug"
cd ..
cd ..

#Securing 
sudo wget https://raw.githubusercontent.com/abueesp/master/apparmor.sh
sudo sh apparmor.sh
sudo apt-get install lxc -y # –lxc-conf /usr/share/lxc/config/common.seccomp
sudo iptables -F
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 1022 -j ACCEPT
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT ACCEPT ##If you are a server change this to DROP OUTPUT connections by default too
sudo iptables -P FORWARD DROP
sudo iptables restart
cd /etc/apparmor.d/ && ls
echo "Disable IPv6. Use dockersheet for a short guide and security recommendations"


#DockerComposer
read "Do you want to install Docker Composer?"
curl -L https://github.com/docker/compose/releases/download/1.8.0/run.sh > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

#Aliasheet
alias dockersheet="echo '#Crea el droplet en DO con Docker \
create Droplet on DO con docker \
#Conecta al Droplet \
ssh root@IP  \

#Suponiendo que tienes un dockefile\
FROM	Define the base image, which contains a minimal operating system (f.i.python:2.7) :: ADD	Copy downloads or data into the image (use cURL/wget with https and cheksum instead or simply /route/code/run.py) :: COPY	Copy data into the image \
CMD Define default command to run (usually the service CMD f.i. python app.py) :: RUN	Execute a command or script (f.i.pip install -r requirements.txt) \
ENV	Define an environment variable (ENV PATH /usr/local/yourpackage/bin:$PATH):: EXPOSE	Makes a port available for incoming traffic to the container :: MAINTAINER	Maintainer of the image \
VOLUME	Make directory available (e.g. for access, backup) :: WORKDIR	Change the current work directory (f.i. /route/code)\

Add this to your Dockerfile: \
RUN find / -perm +6000 -type f -exec chmod a-s {} \; \|| true\
RUN groupadd -r user && useradd -r -g user $USER\
USER $USER\

#Puedes también añadir un DockerCompose.yml file para abrir puertos de servicios determinados \
version: “2“  services:    web:      build: .     ports:      - “5000:5000“     volumes:      - .:/code     depends_on:      - redis   redis:     image: redis\

#Crea la imagen de docker usando Compose y un Dockerfile \
Docker build -t imagenameapp:versionapp nameofimage dockerfile. \
docker-compose up -d \

##O si no, descárgala y verifícala\
https://access.redhat.com/search/#/container-images\
docker pull debian@sha256:shastring\

#See current images \
docker images    \
docker-compose ps\

#Check your secure profiles\
cd /etc/apparmor.d/ && ls\
Choose a profile and introduce the use–secutity-opt=”apparmor:YOURPROFILE” whenever you run docker\
DO NOT USE SUDO TO RUN THE CONTAINER, BUT SSH OR PASSWORDS INSIDE EITHER\

#Run a image on a container \
docker run  -it --name myappimageforcontainer -d -p 1337:80 –lxc-conf /usr/share/lxc/config/common.seccomp -lxc-conf=”lxc.id_map = u 0 100000 65536″ -lxc-conf=”lxc.id_map = g 0 100000 65536″ –cap-drop=fsetid –cap-drop=fowner –cap-drop=mkdnod –cap-drop=net_raw –cap-drop=setgid –cap-drop=setuid –cap-drop=setfcap –cap-drop=setpcap –cap-drop=net_bin_service –cap-drop=sys_chroot –cap-drop=audit_write –cap-drop=audit_control –cap-drop=chown –cap-drop=audit_write –cap-drop=mac_admin –cap-drop=mac_override –cap-drop=mknod –cap-drop=setfcap setpcap –cap-drop=sys_admin –cap-drop=sys_boot –cap-drop=sys_module –cap-drop=sys_nice –cap-drop=sys_pacct –cap-drop=sys_rawio –cap-drop=sys_resource –cap-drop=sys_time –cap-drop=sys_tty_config \
 docker-compose run web env \
 \
puedes añadir las instrucciones para balance como -c 512 (normal es cpu 1024) o -m 512m, para conectar containers --icc=false --iptables y sus namespaces --pid=host --net=host --ipc=host , o -read-only\
 \
#Visita tu webapp \
go to IP:1337 and there it is \
#Audit \
Audit using lynis audit dockerfile filename\
    SELinux/AppApparmor support – limit processes what resources they can access \
    Capabilities support – limit the maximum level a functions (or “roles”) a process can achieve within the container\
    Auditd/Seccomp support – allow/disallow what system calls can be used by processes\
    docker exec – no more SSH in containers for just management\
    docker exec $INSTANCE_ID rpm -qa to OR docker exec $INSTANCE_ID dpkg -l, to see what packages are installed in a container.\
' && 'firefox -new-tab  https://www.cheatography.com/storage/thumb/aabs_docker-and-friends.600.jpg && firefox -new-tab https://container-solutions.com/content/uploads/2015/06/15.06.15_DockerCheatSheet_A2.pdf"


#Extra

#UFW
sudo apt-get install gufw -y
sudo ufw enable
sudo ufw allow 1022/tcp
sudo iptables -F
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 1022 -j ACCEPT
sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT ACCEPT ##If you are a server change this to DROP OUTPUT connections by default too
sudo iptables -P FORWARD DROP
sudo iptables restart
sudo service avahi-daemon stop
sudo cupsctl -E --no-remote-any
sudo service cups-browsed stop

##psad
service psad stop
sudo apt-get -y install libc--clan-perl libdate-calc-perl libiptables-chainmgr-perl libiptables-parse-perl libnetwork-ipv4addr-perl libunix-syslog-perl libbit-vector-perl gcc wget -y
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
cd
sudo rm -r fwsnort**
