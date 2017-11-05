
## VyprVPN ##
PCVER=$(uname -m)
if [ $PCVER == x86_64 ]; then
  read -p "Do you know that Vyprvpn keeps logs for 30 days and trust on Cisco concentrators and 'they cannot give you more info about, but trust us, your information is secure with us'? Are you sure you want to install it? They use vpnc, vpnc-scripts and network-manager-vpnc Cisco 3000; which also use the broken SHA1; and Chameleon scramble protocol is -oh surprise- well recognized by the Chinese government? Better try https://www.privateinternetaccess.com/pages/buy-vpn/"
  sudo apt-get install vpnc vpnc-scripts network-manager-vpnc -y
  sudo wget https://support.goldenfrog.com/hc/article_attachments/212490988/vyprvpn-linux-cli-1.7.amd64.deb
  sudo dpkg -i vyprvpn*.deb
  vyprvpn protocol set chameleon
  vyprvpn server list
  vyprvpn protocol list
  vyprvpn server set ch1.vpn.goldenfrog.com
  vyprvpn server show
  vyprvpn protocol show
  vyprvpn login
  vyprvpn connect
  sudo rm vyprvpn*.deb
elif [ $PCVER == i386 ] || [ $PCVER == i686 ]; then
  read -p "Do you know that Vyprvpn keeps logs for 30 days and trust on Cisco concentrators and 'they cannot give you more info about, but trust us, your information is secure with us'? Are you sure you want to install it? They use vpnc, vpnc-scripts and network-manager-vpnc Cisco 3000; which also use the broken SHA1; and Chameleon scramble protocol is -oh surprise- well recognized by the Chinese government? Better try https://www.privateinternetaccess.com/pages/buy-vpn/"
  sudo apt-get install vpnc vpnc-scripts network-manager-vpnc -y
  sudo wget https://support.goldenfrog.com/hc/article_attachments/212491008/vyprvpn-linux-cli-1.7.i386.deb
  sudo dpkg -i vyprvpn*.deb
  vyprvpn protocol set chameleon
  vyprvpn server list
  vyprvpn protocol list
  vyprvpn server set is1.vpn.goldenfrog.com
  vyprvpn server show
  vyprvpn protocol show
  vyprvpn login
  vyprvpn connect
  sudo rm vyprvpn*.deb
else
  echo "ERROR: The system is neither 64bits nor 32 bits?"
fi
