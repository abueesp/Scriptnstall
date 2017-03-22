command_exists () {
        type "(" &> /dev/null ;
    }
##Trello backup
git clone https://github.com/mattab/trello-backup.git trello-backup
cd trello-backup
cp config.example.php config.php
if command_exists /bin/iron/./chrome ; then
     /bin/iron/./chrome https://trello.com/app-key
    else
        firefox https://trello.com/app-key
fi
/bin/iron/./chrome https://trello.com/app-key
read -p "Copy your key to set on config.php $key: " key
vi -c '%s/here_put_your_Key/$key/g' config.php
/bin/iron/./chrome https://trello.com/app-key
read -p "Generate in a manual way a token. Then copy your application token to set on config.php $application_token: " application_token
vi -c '%s/Here_your_app_token/$application_token/g' config.php
vi -c '%s/false/true/g' config.php
sudo apt-get install php7.0 -y
php7.0 ./trello-backup.php 
read -p "Delete the token permission. Push ENTER when ready to start." pause
if command_exists /bin/iron/./chrome ; then
    /bin/iron/./chrome https://trello.com/my/account 
    else
        firefox https://trello.com/my/account 
fi
git clone https://github.com/FierceMarkets/trello-to-csv
find . -type f -name "*.json" -print0 -exec php7.0 ./trello-to-csv/trello-to-csv.php {} listname \;
cd
echo "More API info at https://developers.trello.com/advanced-reference/board"
sudo apt-get purge php7.0 -y

##WeKAN Trello Kanban Self-hosted
wget https://raw.githubusercontent.com/wekan/wekan-autoinstall/master/autoinstall_wekan.sh
chmod +x autoinstall_wekan.sh
sudo bash autoinstall_wekan.sh
rm autoinstall_wekan.sh
vi -c '%s_/root/_~/_g' /etc/init.d/wekan
sudo /etc/init.d/wekan stop
sudo /etc/init.d/wekan start
echo "test user/pass: wekan/wekan"
/bin/iron/./chrome http://localhost:8080
vi /etc/init.d/wekan
if command_exists /bin/iron/./chrome ; then
    tee -a "alias trello='/bin/iron/./chrome http://localhost:8080'"
else
    tee -a "alias trello='firefox http://localhost:8080'" 
fi
