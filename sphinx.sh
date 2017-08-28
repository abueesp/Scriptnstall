PHPVERSION=7.1.8
wget http://se2.php.net/get/php-$PHPVERSION.tar.gz/from/this/mirror -O php-$PHPVERSION.tar.gz
wget http://se2.php.net/get/php-7.1.8.tar.gz.asc/from/this/mirror -O php-$PHPVERSION.tar.gz.asc
gpg2 --verify php-$PHPVERSION.tar.gz hp-$PHPVERSION.tar.gz.asc
tar -xf php-$PHPVERSION.tar.gz
./configure --with-pdo-mysql --with-mysql-sock=/var/mysql/mysql.sock
make
mate test
sudo make install

read -p "HOST: " HST
read -p "USER: " USR
read -p "PASSWORD: " PSS
read -p "DATABASE: " DB
read -p "PORT: " PRT
SERVR=$USR:$PSS@$HST:PRT
mysqlgrants --server=$SERVR 


cd /home/$USER/public_html/sphider 
echo "write 'CREATE DATABASE $DB;' without quotes"
echo "write 'CREATE DATABASE sphider;' without quotes and then exit"
mysql -u $USR -p $PSS 

sudo sed -i 's/$mysql_host/$HST/g' /home/$USER/sphider/settings/database.php
sudo sed -i 's$mysql_user/$USR/g' /home/$USER/sphider/settings/database.php
sudo sed -i 's/$mysql_password/$PSS/g' /home/$USER/sphider/settings/database.php
sudo sed -i 's/$database/$DB/g' /home/$USER/sphider/settings/database.php

<<'COMMENT'
 This package provides the following utilities:
  mysqlauditadmin  : maintain the audit log
  mysqlauditgrep   : search an audit log
  mysqlbinlogmove  : move binlog files to a different location
  mysqldbcompare   : check two databases and identify any differences
  mysqldbcopy      : copy databases from one MySQL server to another
  mysqldbexport    : export a list of databases in a variety of formats
  mysqldbimport    : import object definitions or data into a database
  mysqldiff        : identify differences among database objects
  mysqldiskusage   : show disk usage for one or more databases
  mysqlfabric      : server farm management framework
  mysqlfailover    : automatic replication health monitoring and failover
  mysqlfrm         : show CREATE TABLE from .frm files
  mysqlgrants      : privilege display utility
  mysqlindexcheck  : check for redundant or duplicate indexes
  mysqlmetagrep    : search MySQL servers for objects matching a pattern
  mysqlprocgrep    : search MySQL servers for processes matching a pattern
  mysqlreplicate   : setup replication among two MySQL servers
  mysqlrpladmin    : administration utility for MySQL replication
  mysqlrplcheck    : check prerequisities for replication
  mysqlrplms       : establish a multi-source replication topology
  mysqlrplshow     : show slaves attached to a master
  mysqlrplsync     : check the data consistency between master and slaves
  mysqlserverclone : start a new instance of an existing MySQL server
  mysqlserverinfo  : display common diagnostic information from a server
  mysqluc          : command line client for running MySQL Utilities
  mysqluserclone   : copy a MySQL user to new user(s) on another server
COMMENT
