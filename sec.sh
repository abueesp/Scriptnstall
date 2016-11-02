#!/bin/bash
sudo apt-get update -y
#TCP flood mitigation
echo "net.ipv4.tcp_challenge_ack_limit = 999999999" >> /etc/sysctl.conf
sudo sysctl -p
#mirror
sudo wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/bash.bashrc
sudo cp bash.bashrc /etc/bash.bashrc
sudo apt-get install build-essential pkg-config libgtest-dev libc6-dev m4 autoconf libtool ncurses-dev unzip git python zlib1g-dev wget bsdmainutils automake aptitude -y
sudo aptitude install g++ g++-multilib -y


#Some tools
sudo apt-get install secure-delete -y
sudo apt-get install duplicity deja-dup pyrenamer -y
sudo apt-get install iotop htop -y
sudo apt-get install vnstat -y
sudo apt-get install fail2ban -y
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
echo "Please write down an email to send you notifications when someone is attacking your ports: "
read email
echo "You entered: $email"
sudo sed "s/destemail = your_email@domain.com/destemail = $email/g" /etc/fail2ban/jail.local
sudo sed "s/action = %(action_)s/action = %(action_mw)s/g" /etc/fail2ban/jail.local
sudo sed -e "s/enabled  = false/enabled  = true/g" /etc/fail2ban/jail.local
sudo apt-get install git tmux -y

echo "Installing nheq"
sudo apt-get install cmake build-essential libboost-all-dev git -y
git clone -b Linux https://github.com/nicehash/nheqminer.git
cd nheqminer/cpu_xenoncat/Linux/asm/ && sh assemble.sh && cd ../../../Linux_cmake/nheqminer_cpu && cmake . && make
~/nheqminer/nheqminer/build/./nheqminer
cd
wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.44-1_amd64.deb




read -p "Do you want to create aliases for miners [yn]?" answer
if [[ $answer == "y" ]] ; then
read -p "Write pool server:port ( zec.suprnova.cc:2142 ): " serverr
read -p "Write pool address user: " addd
read -p "Write pool worker name: " workk
read -p "Write pool worker pass: " pazz
echo "alias trompminer='~/zcash/./src/zcashd -alerts -alertnotify=$alertnotify -blocknotify=$alertnotify -daemon -par=0 -debug -gen=1 -genproclimit=-1 -equihashsolver=\"~/equihash/./eq14451\"'" | sudo tee -a /etc/bash.bashrc #Trompminer
echo "alias zminer='~/zcash/./src/zcashd -alerts -alertnotify=$alertnotify -blocknotify=$alertnotify  -daemon -par=0 -debug -gen=1  -genproclimit=-1 -equihashsolver=\"~/zmine/./a.out\"'" | sudo tee -a /etc/bash.bashrc #Zminer
echo "alias xenon1miner='~/zcash/./src/zcashd -alerts -alertnotify=$alertnotify -blocknotify=$alertnotify  -daemon -par=0 -debug -gen=1  -genproclimit=-1 -equihashsolver=\"~/equihash-xenon/Linux/blake2b/./solver**avx1\"'" | sudo tee -a /etc/bash.bashrc #XenonCatMiner1
echo "alias xenon2miner='~/zcash/./src/zcashd -alerts -alertnotify=$alertnotify -blocknotify=$alertnotify -daemon -par=0 -debug -gen=1  -genproclimit=-1 -equihashsolver=\"~/equihash-xenon/Linux/blake2b/./solver**avx2\"'" | sudo tee -a /etc/bash.bashrc  #XenonCatMiner2
echo "alias zogminer='./src/zcash-miner -G -alerts -alertnotify=$alertnotify -blocknotify=$alertnotify  -daemon -par=0 -debug -gen=1  -genproclimit=-1'" | sudo tee -a /etc/bash.bashrc #ZogMiner
echo "alias nheqminer='~/nheqminer/Linux_cmake/nheqminer_cpu/./nheqminer** -l $serverr -u $addd.$workk -p $pazz -t $(nproc)'" | sudo tee -a /etc/bash.bashrc #Nheqminer
echo "alias knheqminer='~/nheqminer/nheqminer/build/./nheq** -l $serverr -u $addd.$workk -p $pazz -t $(nproc)'" | sudo tee -a /etc/bash.bashrc #Kosh nheqminer
echo "alias silentminer='~/zcash/./src/zcashd -alerts -alertnotify=$alertnotify -blocknotify=$alertnotify -daemon -par=0 -debug -gen=1  -genproclimit=-1 -equihashsolver=\"SILENTMINEEEEEEEEEERRRRRR\"'" | sudo tee -a /etc/bash.bashrc #Mbevand SilentArmy 
fi
