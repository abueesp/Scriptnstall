echo "deb https://riot.im/packages/debian/ stretch main" | sudo tee -a /etc/apt/sources.list
echo "deb https://riot.im/packages/debian/ stretch main" | sudo tee /etc/apt/sources.list.d/riot.list
curl -s https://riot.im/packages/debian/repo-key.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install riot-web
riot-web
