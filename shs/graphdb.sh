read -p "Choose your Linux version: 17, 16, 14, 12" VERSION

#ARANGODB3
ARANGODBVERSION=3.2.8
sudo curl -O https://download.arangodb.com/arangodb32/xUbuntu_$VERSION.04/Release.key
sudo apt-key add - < Release.key
sudo rm -r Release.key
echo 'deb https://download.arangodb.com/arangodb32/xUbuntu_$VERSION.04/ /' | sudo tee /etc/apt/sources.list.d/arangodb.list
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install arangodb3=$ARANGODBVERSION
sudo apt-get install arangodb3-dbg=$ARANGODBVERSION
sudo chown -R $USER:$USER /var/log/arangodb3/
sudo chown -R $USER:$USER /var/lib/arangodb3/
sudo rm -r /var/lib/arangodb3/LOCK
sudo vi -c "%s/uid/#uid/g" -c ":wq" /etc/arangodb3/arangod.conf
sudo arango-secure-installation
echo "Start the daemon with arangod, and use the terminal with arangosh"


#VIRTUOSO
sudo apt-get install libaio1 libaio-dev

sudo apt-get install  virtuoso-opensource virtuoso-server  virtuoso-vad-demo virtuoso-vad-isparql virtuoso-vad-rdfmappers virtuoso-vad-sparqldemo virtuoso-vad-tutorial virtuoso-vsp-startpage virtuoso-vad-syncml virtuoso-vad-ods virtuoso-vad-conductor virtuoso-vad-bpel -y

VIRTUOSOVERSION=8.0
wget http://download3.openlinksw.com/uda/virtuoso/$VIRTUOSOVERSION/x86_64-generic-linux-glibc25-64/lovcz2zz.tar
tar -xvf lovcz2zz.tar
bash install.sh
rm lovcz2zz.tar
rm install.sh
rm client-kit.taz
wget http://download3.openlinksw.com/uda/virtuoso/$VIRTUOSOVERSION/x86_64-generic-linux-glibc25-64/lovpz2zz.tar
tar -xvf lovpz2zz.tar
bash install.sh
sudo mkdir /usr/share/virtuoso-opensource-$VIRTUOSOVERSION
sudo cp -r ./vad /usr/share/virtuoso-opensource-$VIRTUOSOVERSION/
sudo cp -r ./vsp /usr/share/virtuoso-opensource-$VIRTUOSOVERSION/
sudo cp -r ./database /usr/share/virtuoso-opensource-$VIRTUOSOVERSION/db
rm -r install vsp
rm -r install vad
rm -r database
rm virtuoso-environment.sh
rm virtuoso-environment.csh
for file in ./bin/*; do
	namefile=${file:5:-1}
	if [[ $namefile == *[.]* ]]
	then
		mv "$file" "${file%.*}$VIRTUOSOVERSION.${file##*.}"
	else
		mv $file $file$VIRTUOSOVERSION
	fi
done
sudo mv ./bin/* /bin/
rm -r ./bin
sudo mv ./lib/* /lib/
rm -r lib
rm universal-server.taz
rm lovpz2zz.tar
echo "Default user is dba"


#MONGODB ENTERPRISE WITH MONGOOSE
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu precise/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
if [ $VERSION -eq 12 ]
then
	echo "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu precise/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
elif [ $VERSION -eq 14 ]
then
	echo "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
elif [ $VERSION -eq 16 ]
then
	echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
else
	echo "OS not detected. MongoDB installation break."
	break
fi
sudo apt-get update
sudo apt-get install mongodb-enterprise -y
echo "alias startmongo='sudo service mongod start'" | sudo tee -a ~/.bashrc
echo "alias stopmongo='sudo service mongod stop'" | sudo tee -a ~/.bashrc


##Nodejs & NPM 
cd /usr/local
sudo apt-get purge npm nodejs -y
sudo apt-get build-dep nodejs -y
sudo npm build-dep npm -g
versionnpm=v6.11.2
wget $(echo "https://nodejs.org/dist/"$versionnpm"/node-$versionnpm-linux-x64.tar.xz")
gpg --keyserver pool.sks-keyservers.net --recv-keys DD8F2338BAE7501E3DD5AC78C273792F7D83545D
wget $(echo "https://nodejs.org/dist/"$versionnpm"/SHASUMS256.txt.asc")
gpg --verify SHASUMS256.txt.asc
sudo rm SHASUM**
tar --strip-components 1 -xf /usr/local/node**.tar.xz
npm init -y
cd
npm init -y
npm install error-stack-parser lodash minimatch graceful-fs secp256k1 fs-extra

npm install mongoose
npm i -S mongoose-schema-to-graphql
