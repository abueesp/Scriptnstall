sudo apt-get install GTK+ GtkSourceView libpeas gspell python3-gi
wget https://download.gnome.org/sources/gedit/3.20/gedit-3.20.2.tar.xz
wget https://download.gnome.org/sources/gedit/3.20/gedit-3.20.2.tar.xz.sha256sum
sha256sum -c **.tar.gz.sha256
tar Jxf gedit-**.tar.xz			# unpack the sources
cd gedit-**				# change to the toplevel directory
./configure					# run the `configure' script
sudo make					# build gedit
sudo make install
cd ..
sudo rm -r gedit**
##Snippets	
sudo apt-get install python3-markdown gir1.2-webkit-3.0
wget https://github.com/jpfleury/gedit-markdown/archive/master.zip
sudo unzip master.zip
cd master 
sudo ./gedit-markdown.sh install
cd ..
sudo rm -r master**
cd  /usr/lib/x86_64-linux-gnu/gedit/plugins/snippets
git clone https://github.com/Kilian/gedit-jshint
git clone https://github.com/fenrrir/geditpycompletion
for (( ${1:i = 0}; ${2:i < 10}; ${3:i++} )); do
done
for ((${g**:i++})); do 
        cd && git clean -xdf cd.. && cd ..
done
##Dicts
cd /usr/share/gtksourceview-3.0/language-specs
wget https://gist.githubusercontent.com/shamansir/1164574/raw/28e2795966fea04b850b5c93712246afbc70ff56/lisp.lang.xml
cd

