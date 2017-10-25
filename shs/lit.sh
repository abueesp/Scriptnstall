#Bloom for book translation and multilingual
wget -qO - http://packages.sil.org/sil.gpg | sudo apt-key add -
sudo add-apt-repository "deb http://packages.sil.org/ubuntu xenial-experimental main"
sudo apt-get update
sudo apt-get install bloom-desktop-beta -y
cp -i /usr/share/applications/bloom-beta.desktop ~/Desktop
sudo chmod +x ~/Desktop/bloom-beta.desktop
#Fieldworks for dictionaries
sudo add-apt-repository "deb http://packages.sil.org/ubuntu trusty main"
sudo add-apt-repository "deb http://packages.sil.org/ubuntu trusty-experimental main"
sudo apt-get update
sudo apt-get install fieldworks -y
mkdir fieldworks_pathway
wget http://downloads.sil.org/FieldWorks/8.3.9/Sena%203%202017-07-27%201102.fwbackup
wget http://downloads.sil.org/FieldWorks/8.3.9/Lela-Teli%203%202017-01-25%201211.fwbackup
wget https://software.sil.org/downloads/r/pathway/pathway_1.16.0_all.deb #to export results on different formats pdf epub etc
sudo dpkg -i pathway_1.16.0_all.deb -y
rm pathway_1.16.0_all.deb
#WeSay for dictionaries
sudo add-apt-repository "deb http://packages.sil.org/ubuntu trusty main"
sudo add-apt-repository "deb http://packages.sil.org/ubuntu trusty-experimental main"
sudo apt-get update
sudo apt-get install wesay-beta -y

#Saymore for audio transcription and Speech analyzer
wget https://software.sil.org/downloads/r/saymore/SayMoreInstaller.3.1.4.msi
wget http://downloads.sil.org/Speech%20Analyzer/Corporate%20Release/3.1/SpeechAnalyzer3.1.msi
sudo apt-get install playonlinux -y
echo "Install SayMoreInstaller"
playonlinux
#Ashenika Syllable Parser
wget https://software.sil.org/downloads/r/asheninka/asheninka-syllable-parser-64bit-0.4.0.0.deb
sudo dpkg -i asheninka-syllable-parser-64bit-0.4.0.0.deb
rm asheninka-syllable-parser-64bit-0.4.0.0.deb
#Dictionary app builder
echo "it needs Java Development Kit (JDK), the Android Software Development Kit (SDK) first"
sudo add-apt-repository "deb http://packages.sil.org/ubuntu trusty main"
sudo add-apt-repository "deb http://packages.sil.org/ubuntu trusty-experimental main"
sudo apt-get update
sudo apt-get install dictionary-app-builder -y
