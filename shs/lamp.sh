#Apache
read -p "Write IP of your server (localhost by default): " IPSERVER
IPSERVER="${IPSERVER:=localhost}"
sudo apt-get install apache2 apache2-dbg apache2-utils -y
echo "ServerName $IPSERVER" | sudo tee -a /etc/apache2/apache2.conf
sudo apache2ctl configtest
sudo systemctl restart apache2

#Firewall
sudo ufw app list
sudo ufw app info "Apache Full"
if [[ "$IPSERVER" != "localhost" ]] || [[ "$IPSERVER" != "127.0.0.1" ]]
	then
	sudo ufw allow in "Apache Full"
fi

#Mysql
VERSIONMYSQL=5.7
sudo apt-get install libmysqlclient20 libmysqlclient-dev dbconfig-mysql mysql-common mysql-server-core-5.7 mysql-server-$VERSIONMYSQL mysql-client-core-$VERSIONMYSQL mysql-server mysql-client mysql-utilities mysql-workbench mysql-sandbox -y
sudo mysql_secure_installation

#PHP
sudo apt-get install php libapache2-mod-php php-mcrypt php-mysql dbconfig-common php-seclib php-memcached php-sql-formatter phpmyadmin -y
sudo vi -c "s/index.html index.cgi/index.html index.cgi index.php/g" -c ":wq" /etc/apache2/mods-enabled/dir.conf
echo "Include /etc/phpmyadmin/apache.conf" | sudo tee -a sudo nano /etc/apache2/apache2.conf

#Securing phpmyadmin
sudo vi -c "s/DirectoryIndex index.php/DirectoryIndex index.php\nAllowOverride All/g" -c ":wq" /etc/phpmyadmin/apache.conf 
echo "AuthType Basic
AuthName 'Restricted Files'
AuthUserFile /etc/apache2/.phpmyadmin.htpasswd
Require valid-user" | sudo tee -a /usr/share/phpmyadmin/.htaccess

read -p "Create your user (sqluser by default): " USERR
USERR="${USERR:=sqluser}"
sudo htpasswd -c /etc/apache2/.phpmyadmin.htpasswd $USERR
sudo systemctl restart apache2
sudo systemctl status apache2

mysql -u $USERR -p -h $IPSERVER -e "SHOW GRANTS;"
mysql -u $USERR -p -h $IPSERVER -e "FLUSH PRIVILEGES;"

mysql -u $USERR -p -h $IPSERVER -e "CREATE USER $USERR@$IPSERVER IDENTIFIED BY '$PAZZ';"

mysql -u $USERR -p -h $IPSERVER -e "SHOW DATABASES"
read -p "Create your database (mydb by default): " DATABASENAME
DATEBASENAME="${DATEBASENAME:=mydb}"
mysql -u $USERR -p -h $IPSERVER -e "CREATE DATABASE $DATABASENAME;"
mysql -u $USERR -p -h $IPSERVER -e "SHOW DATABASES"

mysql -u $USERR -p -h $IPSERVER -e "GRANT ALL PRIVILEGES ON $DATABASENAME.* TO $USERR@$IPSERVER;"
mysql -u $USERR -p -h $IPSERVER -e "FLUSH PRIVILEGES;"

#delete db
#DROP DATABASE $DATABASENAME;

#create table
#CREATE TABLE $TABLENAME (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, 
#name VARCHAR(20),
#food VARCHAR(30),
#confirmed CHAR(1), 
#signup_date DATE); 

#SHOW TABLES

#DESCRIBE $TABLENAME;

#insert data into table
#INSERT INTO `$TABLENAME` (`id`,`name`,`food`,`confirmed`,`signup_date`) VALUES (NULL, "John", "Casserole","Y", '2012-04-11');

#update value
#UPDATE `$TABLENAME` 
#SET 
#`confirmed` = 'Y' 
#WHERE `$TABLENAME`.`name` ='Sandy';

#columns
#ALTER TABLE $TABLENAME ADD email VARCHAR(40);
#ALTER TABLE $TABLENAME DROP email;

#rows
#DELETE from $TABLENAME where name=Sandy;


read -p "Install extra general php packages (y/n)?: " GENERALPACK
if [[ "$GENERALPACK" == "y" ]]
	then
	sudo apt-get install php-cgi php-cli php-curl php-dev 
	sudo apt-get install phpmyinfo phpsysinfo phpreports phpqrcode php-gnupg php-crypt-gpg php-crypt-chap php-crypt-cbc php-crypt-blowfish php-zip php-uuid php-text-languagedetect php-text-captcha php-mime-type php-markdown php-log php-json php-json-patch php-json-schema php-jmespath php-intl php-fshl php-dompdf php-codesniffer php-cas php-auth php-auth-http php-google-auth php-google-api-php-client php-pspell -y
fi
read -p "Install extra xml php packages (y/n)?: " XMLPACK
if [[ "$XMLPACK" == "y" ]]
	then
	sudo apt-get install php-xml php-xml-htmlsax3 php-xml-parser php-xml-rpc2 php-xml-serializer php-xml-svg php-fxsl php-xmlrpc -y
fi
read -p "Install Wordpress (y/n)?: " WORDPRESSPACK
if [[ "$GENERALPACK" == "y" ]]
	then
	#Installing
	wget http://wordpress.org/latest.tar.gz
	tar xzvf latest.tar.gz
	rm latest.tar.gz
	sudo apt-get install php5-gd libssh2-php
	cd wordpress
	cp wp-config-sample.php wp-config.php
	curl -s https://api.wordpress.org/secret-key/1.1/salt/
	echo "Reemplaze the dummy #lines with these values"
	gedit wp-config.php
	#DB
	read -p "Create your Wordpress user (wpuser by default): " WPUSERR
	WPUSERR="${WPUSERR:=wpuser}"
	read -p "Write your password: " WPPAZZ
	mysql -u root -p -h $IPSERVER -e "CREATE USER $WPUSERR@$IPSERVER IDENTIFIED BY '$WPPAZZ';"
	
	mysql -u root -p -h $IPSERVER -e "SHOW DATABASES"
	read -p "Create your database (wpdb by default): " WPDATABASENAME
	WPDATABASENAME="${WPDATABASENAME:=wpdb}"
	mysql -u root -p -h $IPSERVER -e "CREATE DATABASE $WPDATABASENAME;"
	mysql -u root -p -h $IPSERVER -e "SHOW DATABASES"
	
	mysql -u root -p -h $IPSERVER -e "GRANT ALL PRIVILEGES ON $WPDATABASENAME.* TO $WPUSERR@$IPSERVER;"
	mysql -u root -p -h $IPSERVER -e "FLUSH PRIVILEGES;"
	
	vi -c "s/define('DB_NAME', '(.*)');/define('DB_NAME', '$WPDATABASENAME');/g" -c ":wq" wp-config.php
	vi -c "s/define('DB_USER', '(.*)');/define('DB_USER', '$WPUSERR');/g" -c ":wq" wp-config.php
	vi -c "s/define('DB_PASSWORD', '(.*)');/define('DB_PASSWORD', '$WPPAZZ');/g" -c ":wq" wp-config.php
	cd..
	#ACTIVATING MULTIPLE SITES
	echo "/* Multisite */
define('WP_ALLOW_MULTISITE', true);" | tee -a /var/www/wp-config.php
	sudo a2enmod rewrite
	sudo service apache2 restart
	#SECURING
	sudo rsync -avP wordpress /var/www/html/
	sudo chown -R $USER:www-data /var/www/html/
	mkdir /var/www/html/wp-content/uploads
	sudo chown -R $USER:www-data /var/www/html/wp-content/
	sudo chown -R $USER:www-data /var/www/html/wp-content/uploads
	sudo vi -c "s/ServerName/ServerName $IPSERVER\n<Directory /var/www/html/>\n    AllowOverride All\n</Directory>/g" -c ":wq" /etc/apache2/sites-available/000-default.conf
	sudo a2enmod rewrite
	sudo service apache2 restart
	touch /var/www/html/.htaccess
	sudo chown $USER:www-data /var/www/html/.htaccess
	chmod 664 /var/www/html/.htaccess
	chmod 644 /var/www/html/.htaccess
	#WPSCAN FOR PLUGIN VULNERABILITIES
	sudo apt-get install git -y
	sudo apt-get install libcurl4-gnutls-dev libopenssl-ruby libxml2 libxml2-dev libxslt1-dev ruby-dev ruby1.9.3 -y
	git clone https://github.com/wpscanteam/wpscan.git
	cd wpscan
	sudo gem install bundler && bundle install --without test development
	read -p "Write the website domain: " DOMAIN
	date  >> wpscan.log
	echo "ALL THE PLUGINS" >> wpscan.log
	ruby wpscan.rb --url $DOMAIN --enumerate p  >> wpscan.log
	echo "ALL THE VULNERABLE PLUGINS"  >> wpscan.log
	ruby wpscan.rb --url $DOMAIN --enumerate vp  >> wpscan.log
	echo "ALL THE THEMES"  >> wpscan.log
        ruby wpscan.rb --url $DOMAIN --enumerate t  >> wpscan.log
        echo "ALL THE VULNERABLE THEMES"  >> wpscan.log
        ruby wpscan.rb --url $DOMAIN --enumerate vt  >> wpscan.log
	echo "ALL THE VULNERABLE TIMTUMBS"  >> wpscan.log
	ruby wpscan.rb --url $DOMAIN --enumerate tt  >> wpscan.log
	ruby wpscan.rb --update
	cd ..
	#SSH
	sudo mkdir /$USER/wp_rsa
	sudo su - $USER
	echo "Store your keys in /home/$USER/wp_rsa"
	ssh-keygen -t rsa -b 4096
	exit
	sudo chown $USER:www-data /home/$USER/wp_rsa*
	sudo chmod 640 /home/$USER/wp_rsa*
	sudo mkdir /home/$USER/.ssh
	sudo chown $USER:$USER /home/$USER/.ssh/
	sudo chmod 640 /home/$USER/.ssh
	sudo cp /home/$USER/wp_rsa.pub /home/$USER/.ssh/authorized_keys
	sudo chown $USER:$USER /home/$USER/.ssh/authorized_keys
	sudo vi -c "s/from=(.*) ssh-rsa/from='$IPSERVER' ssh-rsa/g" -c ":wq" /home/$USER/.ssh/authorized_keys
	sudo apt-get install php5-dev libssh2-1-dev libssh2-php
	echo "define('FTP_PUBKEY','/home/$USER/wp_rsa.pub');" | tee -a /var/www/html/wp-config.php
	echo "define('FTP_PRIKEY','/home/$USER/wp_rsa');" | tee -a 
        echo "define('FTP_USER','$WPUSERR');" | tee -a /var/www/html/wp-config.php
        echo "define('FTP_PASS','');" | tee -a /var/www/html/wp-config.php
        echo "define('FTP_HOST','$IPSERVER:22');" | tee -a /var/www/html/wp-config.php
	sudo service apache2 restart
	#CONFIGURING A SECOND SITE
	echo "Your first site is on /var/www/wp-content/uploads"
	echo "For more sites:"
	echo "1. Go to Tools on Wordpress Dashboard and create a Network of Wordpress Sites"
	echo "2. Create a new folder on sudo mkdir /var/www/wp-content/YOURSITE"
	echo "3. sudo chown -R $USER:www-data /var/www/html/wp-content/YOURSITE"
	echo "4. Paste this below here /var/www/wp-config.php:"
	echo "define('MULTISITE', true);
define('SUBDOMAIN_INSTALL', false);
$base = '/';
define('DOMAIN_CURRENT_SITE', 'YOUR IP ADDRESS HERE');
define('PATH_CURRENT_SITE', '/');
define('SITE_ID_CURRENT_SITE', 1);
define('BLOG_ID_CURRENT_SITE', 1);"
	echo "5. Paste this below here /var/www/.htaccess:"
	echo "RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]

# uploaded files
RewriteRule ^([_0-9a-zA-Z-]+/)?files/(.+) wp-includes/ms-files.php?file=$2 [L]

# add a trailing slash to /wp-admin
RewriteRule ^([_0-9a-zA-Z-]+/)?wp-admin$ $1wp-admin/ [R=301,L]

RewriteCond %{REQUEST_FILENAME} -f [OR]
RewriteCond %{REQUEST_FILENAME} -d
RewriteRule ^ - [L]
RewriteRule  ^[_0-9a-zA-Z-]+/(wp-(content|admin|includes).*) $1 [L]
RewriteRule  ^[_0-9a-zA-Z-]+/(.*\.php)$ $1 [L]
RewriteRule . index.php [L]"
	echo "6. Setup your new site"
	echo "For extra plugins visit https://wordpress.org/plugins/"
fi
read -p "Install extra api php packages (y/n)?: " APIPACK
if [[ "$APIPACK" == "y" ]]
	then
	sudo apt-get install php-apigen php-apigen-theme-bootstrap php-apigen-theme-default -y
fi
read -p "Install extra mail php packages? It requires to have installed general pack previously. (y/n): " MAILPACK
if [[ "$MAILPACK" == "y" ]]
	then
	sudo apt-get install php-mail php-mail-mbox php-mail-mime php-mail-mimedecode php-imap -y
fi
read -p "Install musica php package? It takes a lot of time. (y/n): " MUSICPACK
if [[ "$MUSICPACK" == "y" ]]
	then
        sudo apt-get install musica -y
fi
read -p "Install sphinxsearch? It takes a lot of time. (y/n): " SPHINXPACK
if [[ "$SPHINXPACK" == "y" ]]
        then
        sudo apt-get install sphinxsearch -y
fi
read -p "Install horde php packages? It takes a lot of time. (y/n): " HORDEPACK
if [[ "$HORDEPACK" == "y" ]]
	then
	sudo apt-get install php-horde* -y
fi
read -p "Install Mediawiki? (y/n): " WIKIPACK
if [[ "$WIKIPACK" == "y" ]]
	then
	sudo apt-get install apache2 mysql-server php php-mysql libapache2-mod-php php-xml php-mbstring -y
	sudo apt-get install php-wikidiff2 php-text-wiki mediawiki2latex mediawiki2latexguipyqt  -y
	wget https://releases.wikimedia.org/mediawiki/1.29/mediawiki-1.29.2.tar.gz
	tar -xvzf /pathtofile/mediawiki-*.tar.gz
	sudo mkdir /var/lib/mediawiki
	sudo mv mediawiki-*/* /var/lib/mediawiki
	sudo mv LocalSettings.php /var/lib/mediawiki/
	mysql_secure_installation
	sudo vi -c "s/upload_max_filesize = (.*)M/upload_max_filesize = 20M/g" -c ":wq"  /etc/php/7.0/apache2/php.ini
	sudo vi -c "s/memory_limit = (.*)M/memory_limit = 128M/g" -c ":wq"  /etc/php/7.0/apache2/php.ini
	cd /var/www/html
	sudo ln -s /var/lib/mediawiki mediawiki
	sudo phpenmod mbstring
	sudo phpenmod xml
	sudo systemctl restart apache2.service
	cat /etc/apache2/conf-enabled/mediawiki.conf
	cat /var/lib/mediawiki/LocalSettings.php
	echo "Edit conf file at /var/lib/mediawiki/LocalSettings.php and /etc/apache2/conf-enabled/mediawiki.conf"
	echo "Extra extensions at https://www.mediawiki.org/wiki/Manual:Extensions#Installing_an_extension" 
fi

#sudo apt-get install mongodb-server
#sudo apt-get install php-mongodb
