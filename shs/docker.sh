#Docker 
sudo cat /boot/config-`uname -r` | grep CONFIG_SECCOMP=
sudo wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker $USER
sudo apt-get purge apparmor -y
sudo rm -rf /etc/apparmor.d/
sudo rm -rf /etc/apparmor
mkdir docker
cd docker

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


#Aliasheet

alias dockersheet="echo '#Crea el droplet en DO con Docker \
create Droplet on DO con docker \
#Conecta al Droplet \
ssh root@IP  \
#Crea la imagen de docker \
Docker build -t imagenameapp:versionapp dockerfile  \
ADD	Copy downloads or data into the image (use cURL/wget with https and cheksum instead) :: COPY	Copy data into the image \
CMD Define default command to run (usually the service CMD [“lynis”, “-c”, “-Q”]) :: RUN	Execute a command or script \
ENV	Define an environment variable (ENV PATH /usr/local/yourpackage/bin:$PATH):: EXPOSE	Makes a port available for incoming traffic to the container :: MAINTAINER	Maintainer of the image \
FROM	Define the base image, which contains a minimal operating system :: VOLUME	Make directory available (e.g. for access, backup) :: WORKDIR	Change the current work directory\
#See docker images \
docker images    \
#Haz correr la app \
docker run  -it --name myappcontainer -d -p 1337:80  \
#Visita tu webapp \
go to IP:1337 and there it is \
#Audit \
Audit using lynis audit dockerfile $filename\
    SELinux/AppApparmor support – limit processes what resources they can access \
    Capabilities support – limit the maximum level a functions (or “roles”) a process can achieve within the container\
    Seccomp support – allow/disallow what system calls can be used by processes\
    docker exec – no more SSH in containers for just management\
' && 'firefox -new-tab  https://www.cheatography.com/storage/thumb/aabs_docker-and-friends.600.jpg && firefox -new-tab https://container-solutions.com/content/uploads/2015/06/15.06.15_DockerCheatSheet_A2.pdf"
