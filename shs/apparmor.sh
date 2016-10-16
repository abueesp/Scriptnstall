#AppArmor 
sudo rm -r /etc/apparmorprofiles
sudo apt-get install apparmor apparmor-utils auditd policycorutils -y ##con Auditd y Policycoreutils (SELinux)
sudo apparmor_status
sudo git clone git://git.launchpad.net/apparmor-profiles
uname -a
cd apparmor-profiles
cd ubuntu && ls
read -p "Select your version: " version
cd $version
sudo mkdir /etc/apparmor.d/cache
sudo cp apparmor-profiles/ubuntu/$version/** /etc/apparmor.d/
sudo cp -r apparmor-profiles/ubuntu/$version/**/abstractions /etc/apparmor.d/abstractions
sudo /etc/init.d/apparmor restart
sudo aa-enforce  /etc/apparmor.d/* #enforce mode log, report and auditd
#sudo aa-complain /usr/sbin/mysqld #complain mode only log
sudo auditd -s enable
sudo rm -r apparmor-profiles
sudo invoke-rc.d apparmor start
sudo apparmor_status
#disableprofile
#sudo ln -s /etc/apparmor.d/bin.ping /etc/apparmor.d/disable/
#sudo apparmor_parser -R /etc/apparmor.d/bin.ping

#enableprofile
#sudo rm /etc/apparmor.d/disable/profile.name
#sudo apparmor_parser -r /etc/apparmor.d/profile.name
