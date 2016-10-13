#Docker 
sudo wget -qO- https://get.docker.com/ | sh
sudo usermod -aG docker $USER
sudo apt-get purge apparmor -y
sudo rm -rf /etc/apparmor.d/
sudo rm -rf /etc/apparmor
mkdir docker
git clone https://github.com/CISOfy/lynis
git clone https://github.com/konstruktoid/hardening.git
cd hardening
sudo gedit ubuntu.cfg
sudo bash ubuntu.sh

