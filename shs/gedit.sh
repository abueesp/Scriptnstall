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
cd gedit-markdown-master
sudo ./gedit-markdown.sh install
cd ..
rm master.zip
sudo rm -r gedit-markdown-master
sudo chmod 750 /usr/share/gedit/plugins/snippets
cd /usr/share/gedit/plugins/snippets
git clone https://github.com/Kilian/gedit-jshint
cd gedit-jshint
git clean -xdf
cd ..
git clone https://github.com/fenrrir/geditpycompletion
cd geditpycompletion
git clean -xdf
cd
##Dicts
sudo chmod 750 /usr/share/gtksourceview-3.0/language-specs
cd /usr/share/gtksourceview-3.0/language-specs
wget https://gist.githubusercontent.com/shamansir/1164574/raw/28e2795966fea04b850b5c93712246afbc70ff56/lisp.lang.xml -O lisp.lang
cd

