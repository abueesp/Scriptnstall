sudo pip install selenium-webdriver
##Java http://selenium-release.storage.googleapis.com/3.0-beta4/selenium-java-3.0.0-beta4.zip
sudo npm install selenium-webdriver ##JS
sudo gem install selenium-webdriver #RoR 


#driver for mozilla and chrome
cd bin
sudo wget https://github.com/mozilla/geckodriver/releases/download/v0.11.1/geckodriver-v0.11.1-linux64.tar.gz
sudo tar -zxvf geckodriver**.tar.gz
sudo wget http://chromedriver.storage.googleapis.com/2.24/chromedriver_linux64.zip
sudo unzip chromedriver**.zip
sudo su
export PATH=$PATH:/bin/chromedriver
echo 'export PATH=$PATH:/bin/chromedriver' >> /etc/bash.bashrc
export PATH=$PATH:/bin/geckodriver
echo 'export PATH=$PATH:/bin/geckodriver' >> /etc/bash.bashrc
exit
sudo rm geckodriver**.tar.gz
sudo rm chromedriver**.zip

