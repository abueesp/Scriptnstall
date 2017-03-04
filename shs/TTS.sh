 sudo apt-get install espeak speech-dispatcher  gnustep-gui-runtime -y
 sudo apt-get install festival festvox-ellpc11k festvox-italp16k festvox-itapc16k -y
 wget http://paquetes.canaima.softwarelibre.gob.ve/pool/main/f/festvox-palpc16k/festvox-palpc16k_1.0-1_all.deb
 sudo dpkg -i festvox-palpc**
 rm festvox-palpc**
 wget http://paquetes.canaima.softwarelibre.gob.ve/pool/main/f/festvox-sflpc16k/festvox-sflpc16k_1.0-1_all.deb
 sudo dpkg -i festvox-sflpc**
 rm festvox-sflpc**
 echo "say"
 say "Hello friend! How are you?"
 echo "festival"
 echo "Hello friend! How are you?" | festival --tts
 echo "espeak"
 espeak "Hello friend! How are you?"
 echo "spd-say"
 spd-say "Hello friend! How are you?"
 
 echo "say"
 say "¡Hola amigo! ¿Cómo estás?"
 echo "festival"
 echo "¡Hola amigo! ¿Cómo estás?" | festival --tts --language castillian_spanish
 echo "espeak"
 espeak -v spanish "¡Hola amigo! ¿Cómo estás?"
 echo "spd-say"
 spd-say -l es -t child_female "¡Hola amigo! ¿Cómo estás?"
