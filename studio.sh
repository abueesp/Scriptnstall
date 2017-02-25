#!/bin/bash
#Minus
sudo apt-get purge imagemagick fontforge geary -y

#More
sudo apt-get install exfat-fuse exfat-utils -y


#audio
sudo apt-get install pulseaudio-module-gconf pulseaudio pulseaudio-module-x11 aconnectgui alsa-tools alsa-tools-gui audacity audacious  ardour bitscope denemo timemachine gtick hydrogen jackd jackeq jack-rack jack-tools jamin jdelay lilypond lilypond-data meterbridge muse patchage vkeybd qjackctl puredata rosegarden timidity seq24 sooperlooper swami csound freqtweak mixxx terminatorx zynaddsubfx fluidsynth bristol freebirth qsynth tk707 ubuntustudio-controls -y
#plugins
sudo apt-get install aeolus blop caps cmt hexter fil-plugins ladspa-sdk mcp-plugins omins swh-plugins tap-plugins vcf dssi-example-plugins dssi-host-jack fluidsynth-dssi xsynth-dssi dssi-utils-y
# graphics
sudo apt-get install inkscape blender gimp gimp-data-extras gimp-gap gimp-ufraw gimp-plugin-registry f-spot scribus fontforge gnome-raw-thumbnailer xsane wacom-tools hugin agave yafray synfigstudio  -y
#video
sudo apt-get install openshot kdenlive ffmpeg ffmpeg2theora kino stopmotion dvgrabgtk-recordmydesktop recordmydesktop -y
##video Natron
sudo apt-get install libegl1-mesa -y 
firefox --new-tab http://natron.fr/login?os=Linux&file=https://downloads.natron.fr/Linux/releases/64bit/files/natron_2.1.9_amd64.deb
cd Downloads
sudo dpkg -i natron**.deb
sudo rm natron**.deb
cd ..
#guitar
sudo apt install tuxguitar tuxguitar-alsa tuxguitar-jsa tuxguitar-oss
echo "Tools -> Settings -> MIDI Port -> Gervill" 


#download 
sudo apt-get install qbittorrent
echo "check also `music` command"


##DEEPDREAMER
sudo apt-get install build-essential git ipython ipython-notebook -y
cd ~
git clone https://github.com/BVLC/caffe.git
sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev python python-dev python-scipy python-setuptools python-numpy python-pip libgflags-dev libgoogle-glog-dev liblmdb-dev protobuf-compiler libatlas-dev libatlas-base-dev libatlas3-base libatlas-test -y
sudo apt-get install --no-install-recommends libboost-all-dev -y
sudo pip install --upgrade pip
sudo pip install --upgrade numpy
cd ~/caffe
cp Makefile.config.example Makefile.config
echo " If you're not using CUDA, then you'll want CPU only mode. Edit Makefile.config and uncomment LINE8: CPU_ONLY := 1 LINE 37: BLAS_INCLUDE := /opt/intel/composer_xe_2011_sp1.10.319/mkl/include LINE 38: BLAS_LIB := /opt/intel/composer_xe_2011_sp1.10.319/mkl/lib/intel64" 
gedit Makefile.config
make all -j$(nproc)
make test -j$(nproc)
make runtest -j$(nproc)
make pycaffe -j$(nproc)
cd ~
git clone https://github.com/google/deepdream.git
wget -P ~/caffe/models/bvlc_googlenet http://dl.caffe.berkeleyvision.org/bvlc_googlenet.caffemodel
cd ~/deepdream
ipython notebook ./dream.ipynb
