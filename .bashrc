### Default Editor ###
EDITOR=vi
FCEDIT=vi
#stty -ixon #deactivate f.i. C-S and C-Q
#stty -ixoff #activate f.i. C-S and C-Q

###For bc
#export BC_ENV_ARGS=$HOME/.bc #start it with bc -l ~/.bc

### History ###
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL=ignoredups
export HISTCONTROL=ignorespace
alias rmhist="history -c"
alias anonhist="export HISTSIZE=0"
alias hist="export HISTSIZE=1"
alias shis="history | grep"

## Welcome Screen & fColors ###
color_def="~/.colorrc"

if [[ -f $color_def ]]; then
   . $color_def
else
   # color definitions
   black="$(tput setaf 0)"
   darkgrey="$(tput bold ; tput setaf 0)"
   lightgrey="$(tput setaf 7)"
   white="$(tput bold ; tput setaf 7)"
   red="$(tput bold ; tput setaf 1)"
   lightred="$(tput setaf 1)"
   green="$(tput bold ; tput setaf 2)"
   lightgreen="$( tput setaf 2)"
   yellow="$(tput setaf 3)"
   blue="$(tput bold ;tput setaf 4)"
   lightblue="$(tput setaf 4)"
   purple="$(tput bold ;tput setaf 5)"
   pink="$(tput setaf 5)"
   cyan="$(tput bold ;tput setaf 6)"
   lightcyan="$(tput setaf 6)"
   nc="$(tput sgr0)" # no color
fi
export darkgrey lightgreywhite red lightred green lightgreen yellow blue
export lightblue purple pink cyan lightcyan nc
if [[ ! $level_color ]]; then
   level_color=$cyan
fi
if [[ ! $script_color ]]; then
   script_color=$yellow
fi
if [[ ! $linenum_color ]]; then
   linenum_color=$red
fi
if [[ ! $funcname_color ]]; then
   funcname_color=$green
fi
if [[ ! $command_color ]]; then
   command_color=$white
fi
export script_color linenum_color funcname_color
 
reset_screen() {
 
   echo $nc
}
reset_screen
 
#Other colors options are: ${lightred}light red, ${lightgreen}light green, ${blue}blue, ${purple}purple
echo "
${darkgrey} A better command line 
${script_color} Coding for good - $USER command line $(tty) $nc
${command_color}  Ƀe ℋuman, be κinđ, be ωise $nc

Colors legend and some notes:
${linenum_color}- line number: red$nc ${lightred} - debugbash debuglog debugdump grc percol $nc
${funcname_color}- function name: green$nc ${lightgreen} - vim completion: C-n C-p words, C-x C-l lines, C-x C-k dictionaries $nc
${level_color}- shell level color:cyan$nc ${lightcyan} - C-x ! | C-x $ | M-x / | M-x @ | C-x C-e | fc -lnr | !! $nc
${script_color}- script name: yellow$nc ${lightblue} - updatebash geditbash vibash | wai $nc
${command_color}- command executed: white$nc ${lightgrey} - help usage <tab> alias | cleanall cleanmem cleanexcept $nc
${pink} - neton netoff | web browsers: lynx netrik fxf chm iron opera icecat | tmuxts full $nc
${purple} - sysmon appmon netmon portmon usermon vpnmon webmon hardmon $nc

"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\$PWD} '
else
#    PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;33m\]\h:\[\033[1;32m\]$PWD/\[\033[1;31m\]❤\[\033[1;00m\] ΞTH: '
    PS1='\[\033[1;36m\]\u\[\033[1;31m\]@\[\033[1;33m\]\h:\[\033[1;32m\]$PWD/\[\033[1;00m\] '
fi
force_color_prompt=yes
ls --color=always
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33'
# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

#enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ] && [ ! -e "$HOME/.hushlogin" ] ; then
    case " $(groups) " in *\ admin\ *)
    if [ -x /usr/bin/sudo ]; then
	cat <<-EOF
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.

	EOF
    fi
    esac
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
		   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
		else
		   printf "%s: command not found\n" "$1" >&2
		   return 127
		fi
	}
fi

if [ -f /etc/bash_preexec ]; then
    # source preexec and precmd hook functions for Bash
	# If you have anything that's using the Debug Trap or PROMPT_COMMAND
	# change it to use preexec or precmd
	# See also https://github.com/rcaloras/bash-preexec
    . /etc/bash_preexec
fi


##For GPG2 libgcrypt 1.7
LD_LIBRARY_PATH=/usr/local/lib
export LD_LIBRARY_PATH

### GPG Functions ###
alias gpgnewkey="sudo gpg2 --expert --full-gen-key"

gpgverify() {
read -p "0. Introduce the name of the file" $file
read -p "1. Introduce the name of the signature (.asc .sign)" $sign
read -p "1. Import the ID from server (f.i. 0x36839494...)." $ID
read -p "2. Specify the server (pool.sks-keyservers.net by default)." $server pool.sks-keyservers.net
gpg2 --keyserver $server --recv-keys $ID
gpg2 -v --verify $sign $file
read "To ultimately trust it, it will introduce fpr / trust / 5 / y / q. Ctrl+C not to do it." PAUSE
gpg2 --edit-key $ID -c "fpr && trust && 5 && y && q"
gpg2 -v --verify $sign $file
}

gpgexport() {
mkdir gpgexport
cd gpgexport
gpg2 --list-keys --list-options show-photos
read -p "Introduce the key username to export: " USN
sudo gpg2 --fingerprint -a $USN | sudo tee -a fingerprint
sudo gpg2 --export -a $USN > public.key
sudo gpg2 --export-secret-key -a $USN > private.key
sudo chown 700 *
sudo chown 700 .
echo "Here you are your public.key, private.key and fingerprint" 
echo "Fingerprint"
sudo cat fingerprint
echo "Public key"
sudo cat public.key
echo "To see you private key, write cat private.key"
}

gpgimport() {
gpg2 --list-keys --show-photos
read -p "This will import a key from file. Rename as public.key and private.key. Then, introduce the key username: " USN
gpg2 --import $public.key -a $USN
gpg2 --import-secret-key private.key -a $USN
echo "Your public and private keys have been imported. Remember to secure delete your private.key" 
gpg2 --list-keys
}

gpgdelete() {
gpg2 --list-keys --list-options show-photos
read -p "Introduce the key username to delete: " USN
gpg2 --delete-secret-and-public-keys $USN
echo "Your public key and private have been deleted" 
gpg2 --list-keys --list-options show-photos
}

gpglist() {
echo "fingerprints"
gpg2 --fingerprint
echo "pubkeys"
gpg2 --list-keys --list-options show-photos
read -p "privkeys" PAUSE
gpg2 --list-secret-keys
}

gpgeditkey() {
read -p "Introduce ID (see options with help): " ID
gpg2 --edit-key $ID
}

gpgencrypt() {
gpg2 --list-secret-keys
read -p "enter sender username: " USNs
gpg2 --list-keys --list-options show-photos
read -p "enter receiver username: " USNr
PS3='Are you encrypting files (1) or a mere plaintext (2)? '
options=("1" "2")
select opt in "${options[@]}"
do
    case $opt in
        "1")
		read -p "Introduce the route of the files, click ENTER and you will encrypt them as cipherfile: " ROUTEFILE
		gpg2 --armor --cipher-algo AES256 --output "cipherfile" -u $USNs -r $USNr --sign --encrypt $ROUTEFILE
            ;;
        "2")
		read -p "Write down your plaintext, click ENTER and you will encrypt them as ciphertext.txt: " TEXT
		echo "$TEXT" | gpg2 --armor --cipher-algo AES256 --output "ciphertext.txt" --display-charset -u $USNs -r $USNr --sign --encrypt
            ;;
        *) echo "invalid option";;
    esac
done 
}

gpgencryptwithpass() {
gpg2 --list-secret-keys
read -p "Enter receiver username: " USNs
gpg2 --list-keys --list-options show-photos
read -p "Enter sender username: " USNr
read -p 'Write down the paraphrasse' $PAZZ
PS3='Are you encrypting a file (1) or a mere plaintext (2)?'
options=("1" "2")
select opt in "${options[@]}"
do
    case $opt in
        "1")
		read -p "Write down the route of the file, click ENTER and you will encrypt them as cipherfile." ROUTEFILE
		gpg2 --encrypt --passphrase-file "$PAZZ" --symmetric --cipher-algo AES256 --armor --sign --output "cipherfile" --multifile "$ROUTEFILE" -u $USNs -r $USNr
            ;;
        "2")
		read -p "Write down your plaintext, click ENTER and you will encrypt them as ciphertext.txt: " TEXT
		echo "$TEXT" | gpg2 --passphrase-file "$PAZZ" --symmetric --armor --output "ciphertext.txt" --display-charset -u $USNs -r $USNr --sign --encrypt
            ;;
        *) echo "invalid option";;
    esac
done
}

gpgdecrypt() {
gpg2 --list-secret-keys
read -p "Enter receiver username: " USNs
gpg2 --list-keys --list-options show-photos
read -p "Enter sender username: " USNr
read -p "Write down the route of the file, click ENTER and you will decrypt them: " ROUTEFILE
gpg2 -u $USNs -r $USNr --decrypt "$ROUTEFILE"
}

gpgdecryptwithpass() {
read -p 'Write down the paraphrasse' $PAZZ
read -p "Introduce the files, click ENTER and you will decrypt them." ROUTEFILE
gpg2 --decrypt --multifile --symmetric --passphrase-file "$PAZZ" "$ROUTEFILE"
}


### Git functions ###
gitnew() {
###INTRODUCE EMAIL
  read -p "Introduce tu email o pulsa ENTER si ya lo hiciste: " _email
   if [ -z "$_email" ]
     then
	_email=$(git config --global user.email)
##verif
 if [ "$_email" = "" ]; then
 echo "Could not find email, run 'git config --global github.email <email>'"
 invalid_credentials=1
else
echo "Your current email set is $_email"
 fi
     else
	 git config --global user.email $_email
	_email=$(git config --global user.email)
##verif
 if [ "$_email" = "" ]; then
 echo "Could not find email, run 'git config --global github.email <email>'"
 invalid_credentials=1
else
echo "Your current email set is $_email"
 fi

####INTRODUCE USERNAME
fi 
  read -p "Introduce tu username o pulsa ENTER si ya lo hiciste: " _username
    if [ -z "$_username" ]
     then
	_username=$(git config --global user.name)
##verif
 if [ "$_username" = "" ]; then
 echo "Could not find username, run 'git config --global github.user <username>'"
 invalid_credentials=1
else
echo "Your current username set is $_username"
 fi 
     else
	 git config --global user.name $_username
	_username=$(git config --global user.name)
##verif
 if [ "$_username" = "" ]; then
 echo "Could not find username, run 'git config --global github.user <username>'"
 invalid_credentials=1
else
echo "Your current username set is $_username"
 fi 
fi

####INTRODUCE TOKEN
  read -p "Introduce tu token o pulsa ENTER si ya lo hiciste: " _token
    if [ -z "$_token" ]
     then
	_token=$(git config --global user.token)
##verif
 if [ "$_token" = "" ]; then
 echo "Could not find token, run 'git config --global github.token <token>'"
 invalid_credentials=1
else
echo "Your current token set is $_token"
 fi 
     else
	 git config --global user.token $_token
	_token=$(git config --global user.token)
##verif
 if [ "$_token" = "" ]; then
 echo "Could not find token, run 'git config --global github.token <token> and check https://help.github.com/articles/creating-an-access-token-for-command-line-use/'"
 invalid_credentials=1 
else
echo "Your current token set is $_token"
 fi 
fi
 

 if [ "$invalid_credentials" == "1" ]; then
 echo "There was a credentials error. Please introduce your credentials"
 exit
 fi


 repo_name=$1

 dir_name='basename $(pwd)'

 if [ "$repo_name" = "" ]; then
 echo "Introduce el nombre del repositorio o pulsa ENTER si quieres llamarlo  '$dir_name'. En principio debería de ser un nombre correlativo al repositorio de destino creado en Github en https://github.com/$_username?tab=repositories"
 read repo_name
 fi
 if [ "$repo_name" = "" ]; then
 repo_name=$dir_name
 fi
 
 echo -n "Creating Github repository '$repo_name' ..."
 curl -u "$_username:$token" https://api.github.com/user/repos -d '{"name":"'$repo_name'"}' > /dev/null 2>&1
 git init
 echo " done."
}

gitupload() {
  
###INTRODUCE EMAIL
  read -p "Introduce tu email o pulsa ENTER si ya lo hiciste: " _email
   if [ -z "$_email" ]
     then
	_email=$(git config --global user.email)
##verif
 if [ "$_email" = "" ]; then
 echo "Could not find email, run 'git config --global github.email <email>'"
 invalid_credentials=1
else
echo "Your current email set is $_email"
 fi
     else
	 git config --global user.email $_email
	_email=$(git config --global user.email)
##verif
 if [ "$_email" = "" ]; then
 echo "Could not find email, run 'git config --global github.email <email>'"
 invalid_credentials=1
else
echo "Your current email set is $_email"
 fi

####INTRODUCE USERNAME
fi 
  read -p "Introduce tu username o pulsa ENTER si ya lo hiciste: " _username
    if [ -z "$_username" ]
     then
	_username=$(git config --global user.name)
##verif
 if [ "$_username" = "" ]; then
 echo "Could not find username, run 'git config --global github.user <username>'"
 invalid_credentials=1
else
echo "Your current username set is $_username"
 fi 
     else
	 git config --global user.name $_username
	_username=$(git config --global user.name)
##verif
 if [ "$_username" = "" ]; then
 echo "Could not find username, run 'git config --global github.user <username>'"
 invalid_credentials=1
else
echo "Your current username set is $_username"
 fi 
fi

####INTRODUCE TOKEN
  read -p "Introduce tu token o pulsa ENTER si ya lo hiciste: " _token
    if [ -z "$_token" ]
     then
	_token=$(git config --global user.token)
##verif
 if [ "$_token" = "" ]; then
 echo "Could not find token, run 'git config --global github.token <token>'"
 invalid_credentials=1
else
echo "Your current token set is $_token"
 fi 
     else
	 git config --global user.token $_token
	_token=$(git config --global user.token)
##verif
 if [ "$_token" = "" ]; then
 echo "Could not find token, run 'git config --global github.token <token> and check https://help.github.com/articles/creating-an-access-token-for-command-line-use/'"
 invalid_credentials=1 
else
echo "Your current token set is $_token"
 fi 
fi
 
 if [ "$invalid_credentials" == "1" ]; then
 echo "There was a credentials error. Please introduce your credentials"
 exit
 fi

 repo_name=$1
 dir_name='basename $(pwd)'
 if [ "$repo_name" = "" ]; then
 echo "Introduce el nombre del repositorio o pulsa ENTER si quieres llamarlo  '$dir_name' y asegúrate de que tienes un repositorio creado en Github con el mismo nombre en https://github.com/$_username?tab=repositories"
 read repo_name
 fi
 if [ "$repo_name" = "" ]; then
 repo_name=$dir_name
 fi
 
 ###CHOOSE AND UPLOAD FILES
  read -p "Introduce los archivos a subir separados por espacios o escribe ** si son todos los de la carpeta en la que estás: " _files
  git add $_files  #FROM WORKSPACE TO INDEX
 
  ##commit title
   titlecommit=$1
 titledefault="This is my commit"
 if [ "$titlecommit" = "" ]; then
 echo "Introduce un título para el commit o pulsa ENTER si quieres que sea 'This is my commit'"
 read titlecommit
 fi
 if [ "$titlecommit" = "" ]; then
 titlecommit=$titledefault
 fi
 
  git commit -m "$titlecommit" $_files #FROM INDEX TO LOCAL REPOSITORY
  url="https://www.github.com/$_username/$repo_name"
  git push origin master #FROM LOCAL REPOSITORY TO REMOTE REPOSITORY
}

usbro() { 
sudo fdisk -l
read -p "Introduce the usb unit designation (f.i. sdb1): " UNIT
echo "The usb unit $UNIT is: "
sudo hdparm -r /dev/sdb
echo 'SUBSYSTEM=="block",ATTRS{removable}=="1",RUN{program}="/sbin/blockdev --setro %N"' | sudo tee -a  /etc/udev/rules.d/80-readonly-removables.rules
sudo udevadm trigger
sudo udevadm control --reload
echo "Now your system will only be able to mount usbs on read-only mode. Deactivate usbro with usbrwo."
read -p "If you want to make the usb read-only persistently click enter. Otherwise click Ctrl+C." 
sudo umount /dev/$UNIT
sudo hdparm -r /dev/sdb
sudo mount -o remount,r /dev/$UNIT
}

usbrwo() { 
sudo fdisk -l
read -p "Introduce the usb unit designation (f.i. sdb1): " UNIT
echo "The usb unit $UNIT is: "
sudo hdparm -r /dev/sdb
sudo rm /etc/udev/rules.d/80-readonly-removables.rules
sudo udevadm trigger
sudo udevadm control --reload
sudo umount /dev/$UNIT
sudo hdparm -r0 /dev/$UNIT
sudo mount -o remount,rw /dev/$UNIT
echo "Now your usb is persistently allowed to read and write, and your system is enabled to write it. Activate read-only with usbro." 
}


leeme() {
if command pico2wave >/dev/null 2>&1
then
	sudo apt-get install libttspico-utils -y
fi
read -p "Hola amig@ :) Introduce el texto que quieres que te lea: " ezte
read -p "Introduce el idioma del texto (en-EN, fr-FR, pt-PT... por defecto es-ES): " lang 
lang="${lang:=es-ES}"
PS3='Desea solo leer (1) o guardar como lectura.wav (2): '
options=("1" "2")
select opt in "${options[@]}"
do
    case $opt in
        "1")
            pico2wave -l=es-ES -w=/tmp/test.wav "$(cat $ezte)"
	    aplay /tmp/test.wav
            rm /tmp/test.wav
            ;;
        "2")
            pico2wave -l=es-ES -w=/home/$USER/lectura.wav "$(cat $ezte)"
	    aplay /home/$USER/lectura.wav
            ;;
        *) echo "Intenta otra vez o pulsa Ctrl+C para salir";;
    esac
done
}


ssign(){
read -p "Message to sign (~/message by default): " -e messg
messg="${messg:=~/message}"
saltpack sign --message $messg | tee ~/signed_message
echo "The signed message was saved as signed_message"
}

sverify(){
read -p "Message to verify (~/signedmessage by default): " -e messg 
messg="${messg:=~/signedmessage}"
saltpack verify $messg
}

sencrypt(){
read -p "Message to encrypt (~/message by default): " -e messg
messg="${messg:=~/message}"
MESIG=$(cat $messg)
saltpack encrypt --message $MESIG | tee ~/encrypted_message
echo "The encrypted message was saved as ~/encrypted_message"
}

sdecrypt(){
read -p "Message to decrypt (~/encrypted_message by default): " -e messg
messg="${messg:=~/message}"
MESIG=$(cat $messg)
saltpack decrypt < MESIG
}

wgetall(){
read -p "Write the file formats to download (pdf,doc,docx,zip,rar,jpg...): " formatt
formattt=$formatt^^+","+$formatt # as accept is case sensitive
read -p "Write the website: " flinkkk
wget --accept $formattt --mirror --adjust-extension --convert-links --backup-converted --no-parent $flinkkk
}

delbefore() {
  a=()
  read -p "How many minutes back from now? " minutes
  for target in *; do
    inode=$(ls -di "${target}" | cut -d ' ' -f 1)
    fs=$(df "${target}"  | tail -1 | awk '{print $1}')
    crtime=$(sudo debugfs -R 'stat <'"${inode}"'>' "${fs}" 2>/dev/null | 
    grep -oP 'crtime.*--\s*\K.*')
    printf "%s\t%s\n" "${crtime}" "${target}"
    datus=$(date --date '-'$minutes'min')
    if [[ $(date -d"${crtime}" +%s) > $(date -d"${datus}" +%s) ]]; then
	a+=("${target}")
	echo ${target}' was recently created'
    fi
  done
  read -p "Delete all files created before $datus? (y/n) FILES LIST: ${a[*]} " yn
    case $yn in
        [Yy]* ) for i in "${a[@]}"; do
			rm $i 
			echo "$i was deleted"
		done;;
        [Nn]* ) echo "No files were deleted";;
        * ) echo "Please answer yes or no.";;
    esac
}
 
securedelete() {
  read -p "DANGER VAS A BORRAR DE FORMA SEGURA TODO. INTRODUCE LA RUTA DE LA CARPETA O EL ARCHIVO SIN EQUIVOCARTE      -->" route
  rin="$route""/**"
  sudo shred -uvzn 3 $route
  sudo shred -uvzn 3 $rin
  sudo srm -vrzd $route
  }
  
tmuxts() {
echo 'C-b is the magic key'
tmux new-session -s 'MyTS' -d 'vim'
tmux rename-window 'Vim'
tmux split-window -v -d 'weechat'
tmux rename-window 'Weechat'
tmux select-pane -t '0:0'
tmux split-window -h -d 'bash'
tmux rename-window 'Bash0'
tmux new-window -n -t 'lynx https://encrypted.google.com' 
tmux send-keys 'n n n n n n n' 'C-m'
tmux rename-window 'Lynx'
tmux split-window -h -d 'bash'
tmux rename-window 'Bash1'
tmux send-keys 'ls'
tmux -2 attach-session -t 'MyTS'
tmux select-window -t 'Bash0'
}

docsthemagic() {
  read -p "vas a crear las copias, luego armonizar los nombres y finalmente limpiar los metadatos de todos los archivos ubicados en esta carpeta. Introduce los documentos. recuerda que si quieres hacer un backup puedes usar mat -b" docs
  sudo unoconv --format=txt $docs
  sudo unoconv --format=pdf $docs
  sudo unoconv --format=doc $docs
  sudo unoconv --format=docx $docs
  sudo unoconv --format=odt $docs
  sudo unoconv --format=html $docs
  sudo pandoc -f html -t markdown -o $docs+".md" $docs
  sudo detox -r **
  for file in *.html.pdf; do
    sudo mv "$file" "'basename $file .html.pdf'.pdf"
    done
  for file in *.html.epub; do
    sudo mv "$file" "'basename $file .html.pdf'.epub"
    done
  for file in *.html.wiki; do
    sudo mv "$file" "'basename $file .html.wiki'.wiki"
    done
  for file in *.html.txt; do
    sudo mv "$file" "'basename $file .html.txt'.txt"
    done
 for file in *.html.md; do
    sudo mv "$file" "'basename $file .html.md'.md"
    done
  for file in *.html.odt; do
    sudo mv "$file" "'basename $file .html.odt'.odt"
    done
  sudo mat -c **
  sudo mat **
}

updateallbash() {
sudo rm ~/.bashrc-bu
sudo rm /etc/.bashrc-bu
sudo cp ~/.bashrc /etc/.bashrc-bu
sudo wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/.bashrc-d
sudo cp /etc/.bashrc /etc/.bashrc-bu
sudo rm /etc/.bashrc
mv .bashrc-d ~/.bashrc
sudo cp ~/.bashrc /etc/bash.bashrc
}

updatebash() {
sudo cp ~/.bashrc ~/.bashrc-bu
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/.bashrc -O ~/.bashrc-d
sudo rm ~/.bashrc
mv ~/.bashrc-d ~/.bashrc
}

updatetmux() {
sudo rm ~/tmux.conf~
cp ~/tmux.conf ~/tmux.conf~
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/tmux.conf -O ~/tmux.conf
tmux source-file ~/tmux.conf
}

getsh() {
sudo wget https://github.com/abueesp/Scriptnstall/edit/master/reinstall.sh
sudo wget https://github.com/abueesp/Scriptnstall/edit/master/work.sh
sudo wget https://github.com/abueesp/Scriptnstall/blob/master/dnie.sh
}

she() {
echo "Please introduce a word start: "
read W
echo "Please enter the file route: "
read filon
bash <(sed -n '5,$W p' $filon)
}

mysqlconnect(){
read -p "Introduce usuario: " sqlu
read -p "Introduce IP del host o pulsa ENTER si es localhost: " sqlh
firefox -new-tab https://www.thegeekstuff.com/2010/01/awk-introduction-tutorial-7-awk-print-examples/; mysql -u $sqlu -p -h $sqlh
}

apt-history(){
case "$1" in
	install)
		returned=$(cat /var/log/dpkg.log | grep "$1 ")
		echo $returned;;
	upgrade|purge)
		returned=$(cat /var/log/dpkg.log | grep $1)
		echo $returned;;
	*)
		echo 'Select: apt-history install|upgrade|purge'
		return;;
esac
}

#Maintenance and monitoring
antivirus(){
sudo /usr/sbin/./chkrootkit -x
sudo /usr/sbin/./chkrootkit
sudo apt-get install rkhunter -y
sudo rkhunter --propupd
sudo rkhunter --update
rkhunter --check --rwo --vl -x
}
processmon(){
read -p "introduce el nombre del proceso o aplicacion: " app
pid=$(pidof $app)
if [ -z "$pid" ]; then
    echo "Ese programa no estaba corriendo o el proceso no fue identificado"
    exit
fi
apt-cache show $app
sudo ps ax | grep $app
sudo lsof -i -n -P | grep $app
read -p "Introduce el PID de $app: " pid
sudo chrt -p $pid 
sudo pstree -p $pid
}
filemon(){
read -p "introduce la ruta del archivo" ruta
$ruta
sudo systemctl status 
sudo strings $ruta
sudo stat $ruta
clamscan -r --bell -i $ruta
read -p "para salir use Ctrl+C. para ejecutar el archivo y leer las trazas pulse intro" intro
strace $ruta
}
alias usermon="ls -l /bin/su; loginctl; sudo dmidecode -s system-serial-number; sudo loginctl; uptime; sudo id; sudo users; sudo groups; sudo w; sudo who -a; sudo ipcs -m -c; pwd; sudo finger; sudo finger -lmps; sudo chfn; sudo last; read -p 'Do you want to see the processes of a user? Introduce username:' -p $regus; ps -LF -u $regus; echo 'Pure honey. Now all your bases belong to us' | pv -qL 20 > wall"
alias sysmon="sudo dmidecode; lsb_release -a; uname -a; id; sudo id; sudo lshw; lscpu; watch -n 2 free -m; logname; hostname; ipcs -m -c; sudo logname; sudo ipcs; sudo initctl list; systemctl status; cat /proc/uptime; sudo df -h;  sudo dmesg | less; ipcs -u; sudo service --status-all; sudo htop; sudo w -i; sudo dmidecode; sudo ps -efH | more; sudo lsof | wc -l; sudo lsof; ps aux | sort -nk +4 | tail; sudo pstree -p -s -S -u -Z -g -h; sudo ss; sudo dpkg -l; sudo dstat -a -f; systemctl list-units | grep service"
alias netmon="ifconfig -a; nmcli dev show; read -p 'Introduce interface to know with whom you are sharing the local network: ' INTER; sudo arp-scan -R --interface=$INTER --localnet; rfkill list; nmcli general; nmcli device; nmcli connection; curl ipinfo.io; sudo netstat -tulpn; sudo vnstat; sudo netstat -ie | more -s  -l -d -f; sudo netstat -s | more -s  -l -d -f; sudo sudo netstat -pt | more -s  -l -d -f; sudo tcpstat -i wlan0 -l -a; sudo iptables -S; sudo w -i; sudo ipcs -u; sudo tcpdump -i wlan0; sudo iotop; sudo ps; sudo netstat -r; dig google.com; dig duckduckgo.com; echo 'Traceroute google.com'; traceroute google.com; echo 'Traceroute duckduckgo.com'; traceroute duckduckgo.com; echo 'En router ir a Básica -> Estado -> Listado de equipos; nmtui'; sudo ufw status verbose"
alias portmon="sudo nc -l -6 -4 -u; sudo ss -o state established; sudo ss -l; sudo netstat -avnp -e; sudo netstat -pan -A inet,inet6"
alias vpnmon="firefox --new-tab https://www.dnsleaktest.com/results.html --new-tab http://www.nothingprivate.ml --new-tab http://ipmagnet.services.cbcdn.com/ --new-tab https://whoer.net/#extended --new-tab https://ipleak.net/ --new-tab https://ipx.ac/run"
alias webmon="firefox --new-tab https://who.is/ && firefox --new-tab https://searchdns.netcraft.com/ && firefox -new-tab https://www.shodan.io/ && firefox -new-tab web.archive.org && firefox -new-tab https://validator.w3.org/ && firefox -new-tab https://geekflare.com/online-scan-website-security-vulnerabilities/"
alias hardmon="sudo lshw; cat /proc/cpuinfo; sudo lsusb; sudo udevadm info --export-db"
alias ccleaner="sudo apt-get install bleachbit -y; bleachbit -list; read -p 'Write the name of what you want to clean (f.i. firefox -e chromium.history -e password...)' CLEANN; bleachbit --list | grep -E "[a-z]+\.[a-z]+" | grep -e CLEANN | xargs sudo bleachbit --clean; sudo apt-get purge bleachbit -y"
alias cleanall="echo 'Cleaning temp, presets, browsers data, memory, cache and so forth'; sudo sh -c $(which echo) 3 > sudo /proc/sys/vm/drop_caches; sudo apt-get install bleachbit -y; bleachbit --list | grep -E '[a-z]+\.[a-z]+' | xargs sudo bleachbit --clean; sudo apt-get purge bleachbit -y"
alias clenexcept="sudo apt-get install bleachbit -y; bleachbit -list; read -p 'Write the name of what you DO NOT want to clean (f.i. firefox -e chromium.history -e password...)' UNCLEANN; bleachbit --list | grep -E "[a-z]+\.[a-z]+" | grep -v -e UNCLEANN | xargs sudo bleachbit --clean; sudo apt-get purge bleachbit -y"
alias cleanmem="echo 'Cleaning memory, cache and swap'; sudo sh -c $(which echo) 3 > sudo /proc/sys/vm/drop_caches; sudo free"

### Aliases ###
alias handmath="firefox --new-tab http://webdemo.myscript.com/views/math.html"
alias visiblemodeon="sudo hciconfig hci0 piscan"
alias visiblemodeoff="sudo hciconfig hci0 noscan"
alias flightmodeon="nmcli networking off"
alias neton=flightmodeon
alias flightmodeoff="nmcli networking on"
alias netoff=flightmodeoff
alias voip="firefox -new-tab https://www.appear.in"
alias anotherskype="skype --dbpath=~/.Skype2 &"
alias Trash="cd .local/share/Trash/files"
alias closesudo="read -p 'Write down the path/route/file to access: ' APP && sudo chown root:root $APP && sudo chmod 700 $APP"
alias opensudo="read -p 'Write down the path/route/file to open permissions: ' APP; sudo chmod ugo+rwx -R $APP && echo 'try also with sudo -i ' $APP" 
alias skill="sudo kill -9"
alias nmapp="sudo nmap -v -A --reason -O -sV -PO -sU -sX -f -Pn --spoof-mac 0"
alias nmap100="sudo nmap -F -v -A --reason -O -sV -PO -sU -sX -f -Pn --spoof-mac 0"
alias lsd="ls -ld && sudo du -sh && ls -i1 -latr  -FGAhp --color=auto" # ltr sort by date
alias lss="ls -ld && sudo du -sh && ls -i1 -laSr  -FGAhp --color=auto" # lSr sort by size
alias lsall="ls -ld && sudo du -sh && ls -i1 -latr -lSr -FGAhp --color=auto -t -a -al -lR" # recursive ls
alias la="ls -ld && ls --color=auto -t -atr" #la is the new ls
function lgo(){ cd "$@" && la; } #lgo is the new cd + ls
alias lbk="cd .. && la" #lbk is the new cd .. + ls (lback!)
function cdn(){ for i in 'seq $1'; do cd ..; done;}
alias lssh="ls -al ~/.ssh"
alias verifykey="gpg --keyid-format long --import"
alias verifyfile="gpg --keyid-format long --verify"
alias dt='date "+%F %T"'
alias pdf2txt='ls * | sudo xargs -n1 pdftotext'
alias bashrc='~./bashrc'
function lowercase(){
read -p 'lowercase what? ' LOWW ; 
echo $LOWW | tr '[:upper:]' '[:lower:]'
}
function uppercase(){
read -p 'uppercase what? ' UPPP ; 
echo $UPPP | tr '[:lower:]' '[:upper:]'
}
alias whereami='curl ipinfo.io/country'
alias geditbash='sudo gedit ~/.bashrc'
alias vimbash='sudo vim ~./bashrc'
alias atombash='sudo atom ~/.bashrc'
alias nanobash='sudo nano ~/.bashrc'
alias busca='sudo find / -iname'
alias wtfhappened='sudo find / -cmin 1'
alias whatchanged='sudo find / -mtime'
alias wai="nmcli dev show && curl ipinfo.io/country && wget http://ipinfo.io/ip -qO - && echo 'For deeper testing visit http://ip-check.info/'"
alias myip=wai
alias whatip="dig"
alias cpc='cp -i -r'
alias mvm='mv -i -u'
alias rmr='sudo rm -irv -rf'
alias delete="rmr"
alias remove="rmr"
alias restorefxftabs="cp ~/.mozilla/firefox/*.default/sessionstore.jsonlz4 ~/.mozilla/firefox/*.default/sessionstore.jsonlz4.old && cp ~/.mozilla/firefox/*.default/sessionstore-backups/previous.jsonlz4 ~/.mozilla/firefox/*.default/sessionstore.jsonlz4"
alias event="evtest"
alias fakeid="wget 'http://randomprofile.com/api/api.php?&countries=CHN,JPN,KOR,GBR&fromAge=20&toAge=60&format=xml&fullChildren=1' -O seres.xml; rig >> fids && echo '------------------------' >> fids && date '+%H:%M:%S   %d/%m/%y' >> fids && cat seres.xml >> fidxmls && echo '------------------------' >> fidxmls && echo '------------------------' >> fidxmls && echo '------------------------' >> fidxmls && date '+%H:%M:%S   %d/%m/%y' >> fidxmls; cat fids; cat fidxmls; firefox -new-tab http://www.fakenamegenerator.com/advanced.php -new-tab protonmail.com -new-tab https://app.tutanota.com/#register -new-tab https://service.mail.com/registration.html -new-tab https://signup.live.com/"
alias now="date '+%H:%M:%S   %d/%m/%y'"
alias keepasss="sudo mono /home/$USER/KeePass/KeePass.exe"
alias keepass="mono /home/$USER/KeePass/KeePass.exe"
alias df='df -h'
alias ytb='youtube-dl --prefer-ffmpeg --ignore-errors --yes-playlist'
alias ytbmp3='youtube-dl --audio-format mp3 --audio-quality 0 --extract-audio  --prefer-ffmpeg --ignore-errors --yes-playlist'
alias y2mp3=ytbmp3
alias aptup='sudo apt-get update && sudo apt-get upgrade && sudo apt-get clean'
alias mkdirr='mkdir -p -v'
alias downweb='wget --mirror -p --convert-links -P .'
alias lvim="vim -c \"normal '0\'" # open vim editor with last edited file
alias grepp='grep --color=auto -r -H'
alias egrepp='egrep --color=auto -r -w'
alias fgrepp='fgrep --color=auto'
alias aptclean='sudo apt-get autoremove'
alias aptinstall='sudo apt-get install'
alias aptreinstall='sudo apt-get install --reinstall'
alias aptpurge='sudo apt-get purge'
alias aptdel=aptpurge
alias aptsearch='apt-cache search'
alias aptfind=aptsearch
alias aptcache=aptsearch
alias aptlog='less /var/log/apt/history.log'
alias aptinstalled='apt list | grep installed'
alias rename='mv'
alias readfiles='sudo tail -vn +1 $(find . -maxdepth 1 -not -type d)'
alias catall=readfiles
alias catwithlines='cat -n'
alias tmuxkillall="tmux ls | grep : | cut -d. -f1 | awk '{print substr($1, 0, length($1)-1)}' | xargs kill"
alias gitlist='git remote -v'
alias diferencia='echo "Puedes usar tambien vi -d o kompare"; colordiff -ystFpr'
alias compara='diff -y -r'
alias adbconnect="mtpfs -o allow_other /mnt/mobile"
alias adbdisconnect="fusermount -u /mnt/mobile"
alias androidsdk="sh ~/android-studio**/bin/studio.sh"
alias decompileapk="java -jar ~/android-studio**/bin/apktool.jar $1"
alias signapk="java -jar ~/android-studio**/bin/sign.jar $2"
alias shist="history | grep"
alias vectorize="xargs"
alias cuenta=count
alias countlines="awk '/a/{++cnt} END {print \"Count = \", cnt}'"
alias startlocalserver='python3 -m http.server 8000'
alias createtags='!ctags -R && echo "Remember: Ctrl+] go to tag; g+Ctrl+] ambiguous tags and enter number; Ctrl+t last tag; Ctrl+X+Ctrl+] Autocomplete with tags"'
alias rng='expr $RANDOM % 9223372036854775807 && od -N 4 -t uL -An /dev/urandom | tr -d " " && openssl rand 4 | od -DAn && uuidgen; echo $RANDOM | sudo hashalot -x -s 2 sha512; echo $RANDOM | sudo hashalot -x -s 2 sha384; echo $RANDOM | sudo hashalot -x -s 2 sha256; echo $RANDOM | sudo hashalot -x -s 2 rmd160compat; echo $RANDOM | sudo hashalot -x -s 2 rmd160; echo $RANDOM | sudo hashalot -x -s 2 ripemd160'
alias noise='sudo cat /dev/urandom | aplay -f dat'
alias diskusage="df -h && sudo baobab"
alias whoiswithme="ifconfig -a; read -p 'Introduce interface with whom are you sharing the local network: ' INTER; sudo arp-scan -R --interface=$INTER --localnet"
alias qrthis="read -p 'What do you want to QR?: ' QRSTRING; printf '$QRSTRING' | curl -F-=\<- qrenco.de"
alias emacstex="\usepackage[utf8]{inputenc}"
alias vimsubs="echo '
Go To line 1889 and write at the beginning
sudo vi -c \":1889\" -c \"s/^/extension=mcrypt.so/\" /etc/php/7.0/fpm/php.ini

To find a search string \"hi\" and append string \" everyone\" on line 3:
vim -c \"3 s/\(hi\)/\1 everyone/\" -c \"wq\" file.txt

To find a search string \"hi\" and prepend a string \"say \" on line 3:
vim -c \"3 s/\(hi\)/say \1/\" -c \"wq\" file.txt

In case the line number is not known, To append first occurrences of string \"hi\" on every line with \" all\":
vim -c \"1,$ s/\(hi\)/\1 all/\" -c \"wq\" file.txt

To append all occurrences of string \"hi\" on every line with \" all\":
vim -c \"1,$ s/\(hi\)/\1 all/g\" -c \"wq\" file.txt 

For more info about substitutions:
vim -c \"help substitute\"
'"
rrng(){
echo "Your random numbers are" 
echo $(expr $RANDOM % 9223372036854775807)
echo $(od -N 4 -t uL -An /dev/urandom | tr -d " ")
echo $(openssl rand 4 | od -DAn)
echo ""
echo "Your random uuid is"
echo $(uuidgen -r)
echo ""
echo "Your random 160bits hexadecimal hashes are"
echo $(echo $RANDOM | sudo hashalot -x -s 2 rmd160)
echo $(echo $RANDOM | sudo hashalot -x -s 2 ripemd160)
echo $(echo $RANDOM | sudo hashalot -x -s 2 rmd160compat)
echo ""
echo "Your random 256bits hexadecimal hash is"
echo $(echo $RANDOM | sudo hashalot -x -s 2 sha256)
echo ""
echo "Your random 384bits hexadecimal hash is"
echo $(echo $RANDOM | sudo hashalot -x -s 2 sha384)
echo ""
echo "Your random 512bits hexadecimal hash is"
echo $(echo $RANDOM | sudo hashalot -x -s 2 sha512)
}

count() {
echo "The options below may be used to select which counts are printed, always in
the following order: newline, word, character, byte, maximum line length.
  -c, --bytes            print the byte counts
  -m, --chars            print the character counts
  -l, --lines            print the newline counts
      --files0-from=F    read input from the files specified by
                           NUL-terminated names in file F;
                           If F is - then read names from standard input
  -L, --max-line-length  print the maximum display width
  -w, --words            print the word counts
      --help     display this help and exit
      --version  output version information and exit"
echo "If you want to count a file, exit using Ctrl+C and use 'wc' with the adequate parameter"
read -p "If you want to count a string, what may I count? (-w, -l, -m, -c, -L): " PARAMETER
read -p "Write down the string: " STRING
echo $STRING > COUNTFILE
wc $PARAMETER COUNTFILE
rm COUNTFILE
}

### Browser aliases ###
alias securefirefox="firejail --private --dns=8.8.8.8 --dns=8.8.4.4 firefox -no-remote"
alias fxf=securefirefox
alias securechrome="firejail --private --dns=8.8.8.8 --dns=8.8.4.4 chromium-browser"
alias chm=securechrome
alias iron="/opt/iron/./chrome"
alias icecat="firejail /opt/icecat/./icecat --profile /opt/icecat/profiles"
alias offline="firejail --net=none"

### Conversion Aliases ###
asciibin () {
read -p "Introduce ascii string: " ASC
echo $ASCII | perl -lpe '$_=join " ", unpack"(B8)*"'
echo $ASC >> ASCII
xxd -b ASCII
rm ASCII
}
alias asciioct='read -p "Introduce ascii string: " ASC; echo $ASC >> ASCII; echo "ibase=16;obase=8; $(xxd -ps -u ASCII)" | bc; rm ASCII'
alias asciihex='read -p "Introduce ascii string: " ASC; echo $ASC >> ASCII; xxd -ps -u ASCII; rm ASCII'
alias asciic='read -p "Introduce ascii string: " ASC; echo $ASC >> ASCII; xxd -i ASCII; rm ASCII'
alias decbin='read -p "Introduce dec number: " DEC; echo "obase=2; $DEC" | bc'
alias decoct='read -p "Introduce dec number: " DEC; echo "obase=8; $DEC" | bc'
alias dechex='read -p "Introduce dec number: " DEC; echo "obase=16; $DEC" | bc'
binascii () {
read -p "Introduce bin number: " BIN; 
echo $BIN | perl -lape '$_=pack"(B8)*",@F'
}
alias bindec='read -p "Introduce bin number: " BIN; echo "ibase=2; $BIN | bc'
alias binoct='read -p "Introduce bin number: " BIN; echo "ibase=2;obase=8; $BIN" | bc'
alias binhex='read -p "Introduce bin number: " BIN; echo "ibase=2;obase=16; $BIN" | bc'

alias octascii='read -p "Introduce oct number: " OCT; echo "ibase=8;obase=16; $OCT" >> OCTY; xxd -r -p $OCTY; rm OCTY' 
alias octbin='read -p "Introduce oct number: " OCT; echo "ibase=8;obase=2; $OCT" | bc'
alias octdec='read -p "Introduce oct number: " OCT; echo "ibase=8; $OCT" | bc'
alias octhex='read -p "Introduce oct number: " OCT; echo "ibase=8;obase=16; $OCT" | bc'

alias hexascii='read -p "Introduce hex number: " HEX; echo $HEX >> HEXY; xxd -r -p HEXY; rm HEXY' 
alias hexdec='read -p "Introduce hex number: " HEX; echo "ibase=16; $HEX" | bc'
alias hexbin='read -p "Introduce hex number: " HEX; echo "ibase=16;obase=2; $HEX" | bc; echo $((0x$HEX))'
alias hexoct='read -p "Introduce hex number: " HEX; echo "ibase=16;obase=8; $HEX" | bc'

### Ethereum Aliases ###
routegeth="/home/$USER/linux/geth**"
alias ethertweet="firefox -new-tab -url https://github.com/yep/eth-tweet -new-tab -url https://ethertweet.net/ui && geth --rpc --rpccorsdomain='http://ethertweet.net'"
alias ethwallet='cd /home/$USER/linux && ./Ethereum-Wallet'
alias mist='cd $routegeth && ./Mist'
alias geth='cd $routegeth && ./geth'
alias blockchain='cd ~/.ethereum/chaindata'
alias gethminer='cd $routegeth && ./geth --mine --minergpus --autodag --minerthreads 8 console'
alias ethminer='ethminer -G --opencl-device 0'
alias gethtest='cd $routegeth && ./geth --testnet console'
alias gethupgrade='cd $routegeth && ./geth upgradedb --fast console'
alias gethsheet="https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options"
alias ethstats="sudo pm2 start /home/$USER/eth-net-intelligence-api/app.json && firefox -new-tab https://ethstats.net/ && parity --max-peers 100 --peers 100 --min-peers 100"
alias meteor="firefox -new-tab -url http://localhost:3000 && cd /home/$USER/linux && ./geth --rpc --rpccorsdomain='http://localhost:3000'"

### Some cheatsheets ###
alias subst='echo "vi filename.txt -c \":Ubuntu%s/\<tmux\>/Linux/gIc \" -c \":wq \" meaning (:code) (tres after the first apparition of Ubuntu) (% make changes in all lines, use {START-n},{END-n} instead) (s/ search) (\<\> exact word) (UNIX/ old word) (Linux/ new word) (g global – each occurrence in the line is changed, rather than just the first) (I case sensitive) (c confirm signal)"'
alias androidsheet="firefox --new-tab https://developer.android.com/design/index.html && firefox -new-tab https://developer.android.com/studio/intro/keyboard-shortcuts.html"
alias adbsheet="firefox -new-tab http://www.movilzona.es/tutoriales/android/root/principales-comandos-para-adb-y-fastboot-guia-basica/"
alias distrosheet="echo 'centos (redhat, scientific and enterprise), openbsd (more usability freebsd, security and multiplatform), archbang(arch, control by complex simplicity), coreos (chromium os, cloud), qubeos (Xen security), tor-ramdisk/tails (Debian/GNULinux, privacy), salixos (Slackware, neutrality), sabayon (gentoo, diversity)'"
alias emacssheet="echo 'SPC h l Layers'; echo 'Alt-x list-packages /package INTRO I n n N I x y Install packages', echo 'SPC b w' read-only mode; echo 'SPC tilde Terminal'; echo 'SPC f e d Configuration File init.el'; echo 'SPC T s Themes'; firefox -new-tab https://spacemacs.org/doc/VIMUSERS.html && firefox -new-tab http://www.stephenwalker.com/notes/aquamacsemacs-key-binding-list/ && firefox -new-tab https://www.emacswiki.org/ && firefox -new-tab http://www.ling.ohio-state.edu/~kyoon/tts/unix-help/LaTeX/emacs-cheatsheet-2-of-2.jpg && firefox -new-tab http://www.muylinux.com/wp-content/uploads/2010/11/Emacs-Cheatsheet-wallpaper.jpg && firefox -new-tab https://github.com/emacs-tw/awesome-emacs && firefox -new-tab http://es.tldp.org/Tutoriales/doc-tutorial-emacs/intro_emacs.pdf"
alias electrumsheet="firefox --new-tab https://docs.electrum.org/en/latest/"
alias electricalsheet="firefox --new-tab http://www.rapidtables.com/electric/electrical_symbols.htm"
alias shsheet="firefox --new-tab https://www.tldp.org/LDP/abs/html/index.html --new-tab https://explainshell.com/" 
alias gethsheet="https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options"
alias gpgsheet="firefox --new-tab http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/gpg-cs.html"
alias bitcoinsheet="firefox --new-tab  https://en.bitcoin.it/wiki/Script#Words"
alias rubysheet="firefox --new-tab -url https://cheat.errtheblog.com/s/rvm --new-tab http://spacemacs.org/layers/+frameworks/ruby-on-rails/README.html --new-tab -url https://rvm.io/ -new-tab -url http://bundler.io/"
alias tmuxsheet="tmux list-keys; tmux list-commands; firefox --new-tab https://leanpub.com/the-tao-of-tmux/read; echo 'https://gist.github.com/MohamedAlaa/2961058 There are sessions, windows, panels \
tmux new -s myname | tmux ls | tmux a -t myname | tmux kill-session -t myname | Ctrl+Shift++ Zoom in | Ctrl+- Zoom out\
ctrl+b & c create window | ctrl+b & w list windows | ctrl+b & n  next window | ctrl+b & p  previous window | ctrl+b & f  find window | ctrl+b & ,  name window | ctrl+b & d detach window | ctrl+b & & kill window \
ctrl+b & :set synchronize-panes on/off a/synchronize all panels of the window | ctrl+b & % vertical split | ctrl+b & \"  horizontal split | ctrl+b & q  show panel numbers | ctrl+b & x  kill pane | ctrl+b & spacebar change layout | ctrl+b & {} Move the current pane leftright | ctrl+b & z Zoom in zoom out panel | ctrl+b + :resize-pane -U/D/L/R 20 add 20 cells up/down/left/right to that panel'"
alias ubuntusheet="firefox --new-tab  https://slashbox.org/index.php/Ubuntu#Cheat_Sheet && firefox -new-tab https://slashbox.org/index.php/Ubuntu#Cheat_Sheet" 
alias vimsheet="echo ':h vimtex, :help i_C^M, :help e_<Esc>, :help c_<Del>, move with [], createtags, nnoremap, SNIPPETS (ctrl-n, ctrl-p word completion, ctrl-x ctrl-l line completion, ctrl-x ctrl-k dictionary completion, ctrl-w erase word, ctrl-u erases line, addsnippet)'; firefox -new-tab  http://michael.peopleofhonoronly.com/vim/vim_cheat_sheet_for_programmers_screen.png && firefox -new-tab https://cdn.shopify.com/s/files/1/0165/4168/files/digital-preview-letter.png && firefox -new-tab https://michael.peopleofhonoronly.com/vim/vim_cheat_sheet_for_programmers_screen.png && firefox -new-tab https://cdn.shopify.com/s/files/1/0165/4168/files/digital-preview-letter.png"
alias wgetsheet="firefox --new-tab https://www.thegeekstuff.com/2009/09/the-ultimate-wget-download-guide-with-15-awesome-examples/"
alias soliditysheet="firefox --new-tab https://solidity.readthedocs.io/en/latest/units-and-global-variables.html"
alias chsheet="echo 'chmod: Change the file modes/attributes/permissions | chown: Change the file ownership | chgrp: Change the file group ownership'"
alias datasheet="firefox --new-tab https://cheatsheets.quantecon.org/"

aptsheet(){
echo "
find / -name example.file
apt-cache pkgnames #see all pkgs installed

apt-cache search word #synaptics
apt-cache show pkgname #pkg information
apt-get install 'word' #Install Several Packages using Wildcard
apt-get install pkgname=2.3.5-3ubuntu1 #specific version
apt-cache showpkg pkgname #show dependencies
apt-get purge pkgname #better than remove, also conf files

apt-cache stats #overall stats
apt-get update #sources
apt-get upgrade #packages
apt-get install packageName --only-upgrade
apt-get --simulate upgrade
apt-get --simulate install packageName

#With source you unpack and download, but you can say --download-only.
You can also download, unpack and compile the source code at the same time, using option ‘–compile‘ as shown below.
sudo apt-get --compile source goaccess

sudo apt-get clean
sudo apt-get autoclean

for python modules
pip show module #module version

for yum search for apt2yum txt"
}
yumsheet=aptsheet

#Docker Alias and sheet
alias dockersheet="echo '#Crea el droplet en DO con Docker \
create Droplet on DO con docker \
#Conecta al Droplet \
ssh root@IP  \
#Suponiendo que tienes un dockefile\
FROM	Define the base image, which contains a minimal operating system (f.i.python:2.7) :: ADD	Copy downloads or data into the image (use cURL/wget with https and cheksum instead or simply /route/code/run.py) :: COPY	Copy data into the image \
CMD Define default command to run (usually the service CMD f.i. python app.py) :: RUN	Execute a command or script (f.i.pip install -r requirements.txt) \
ENV	Define an environment variable (ENV PATH /usr/local/yourpackage/bin:$PATH):: EXPOSE	Makes a port available for incoming traffic to the container :: MAINTAINER	Maintainer of the image \
VOLUME	Make directory available (e.g. for access, backup) :: WORKDIR	Change the current work directory (f.i. /route/code)\
Add this to your Dockerfile: \
RUN find / -perm +6000 -type f -exec chmod a-s {} \; \|| true\
RUN groupadd -r user && useradd -r -g user $USER\
USER $USER\
#Puedes también añadir un DockerCompose.yml file para abrir puertos de servicios determinados \
version: “2“  services:    web:      build: .     ports:      - “5000:5000“     volumes:      - .:/code     depends_on:      - redis   redis:     image: redis\
#Crea la imagen de docker usando Compose y un Dockerfile \
Docker build -t imagenameapp:versionapp nameofimage dockerfile. \
docker-compose up -d \
##O si no, descárgala y verifícala\
https://access.redhat.com/search/#/container-images\
docker pull debian@sha256:shastring\
#See current images \
docker images    \
docker-compose ps\
#Check your secure profiles\
cd /etc/apparmor.d/ && ls\
Choose a profile and introduce the use–secutity-opt=”apparmor:YOURPROFILE” whenever you run docker\
DO NOT USE SUDO TO RUN THE CONTAINER, BUT SSH OR PASSWORDS INSIDE EITHER\
#Run a image on a container \
docker run  -it --name myappimageforcontainer -d -p 1337:80 –lxc-conf /usr/share/lxc/config/common.seccomp -lxc-conf=”lxc.id_map = u 0 100000 65536″ -lxc-conf=”lxc.id_map = g 0 100000 65536″ –cap-drop=fsetid –cap-drop=fowner –cap-drop=mkdnod –cap-drop=net_raw –cap-drop=setgid –cap-drop=setuid –cap-drop=setfcap –cap-drop=setpcap –cap-drop=net_bin_service –cap-drop=sys_chroot –cap-drop=audit_write –cap-drop=audit_control –cap-drop=chown –cap-drop=audit_write –cap-drop=mac_admin –cap-drop=mac_override –cap-drop=mknod –cap-drop=setfcap setpcap –cap-drop=sys_admin –cap-drop=sys_boot –cap-drop=sys_module –cap-drop=sys_nice –cap-drop=sys_pacct –cap-drop=sys_rawio –cap-drop=sys_resource –cap-drop=sys_time –cap-drop=sys_tty_config \
 docker-compose run web env \
 \
puedes añadir las instrucciones para balance como -c 512 (normal es cpu 1024) o -m 512m, para conectar containers --icc=false --iptables y sus namespaces --pid=host --net=host --ipc=host , o -read-only\
 \
#Visita tu webapp \
go to IP:1337 and there it is \
#Audit \
Audit using lynis audit dockerfile filename\
    SELinux/AppApparmor support – limit processes what resources they can access \
    Capabilities support – limit the maximum level a functions (or “roles”) a process can achieve within the container\
    Auditd/Seccomp support – allow/disallow what system calls can be used by processes\
    docker exec – no more SSH in containers for just management\
    docker exec $INSTANCE_ID rpm -qa to OR docker exec $INSTANCE_ID dpkg -l, to see what packages are installed in a container.\
' && 'firefox -new-tab  https://www.cheatography.com/storage/thumb/aabs_docker-and-friends.600.jpg && firefox -new-tab https://container-solutions.com/content/uploads/2015/06/15.06.15_DockerCheatSheet_A2.pdf"



### Functions ###

addsnippet(){
read -p "Name of the snippet: " $SNIPPET
read -p "Route of the snippet: " $ROUTESNIPPET
echo "nnoremap ,$SNIPPET :-lread $ROUTESNIPPET<CR>5jwf>a"
}

freethis(){
  sudo chmod 777 $1 $2
}

whatis(){
apt-cache search $1
apropos $1
$1 --version
$1 --help
}

imprime(){
echo "List of prints available. With  lp -d you can also choose a printer lp -d myprinter -E -m -q 100 -o media=legal -o fit-to-page -n 1" 
sudo lpstat
read -p "Introduce la ruta del archivo a imprimir" imprimf
sudo lpd
sudo lpr $imprimf
sudo lpq
echo "Lee la cola de impresión con lpq."
}

selectelements() {
read -p "Print from element number: " first
read -p "Print to element number: " second
read -p "Introduce the file of vectors: " vect
awk '/a/ {print $first "\t" $second} $vect'
awk 'BEGIN {print "Arguments =", ARGC}' $vect
awk 'BEGIN { 
   for (i = 0; i < ARGC - 1; ++i) { 
      printf "ARGV[%d] = %s\n", i, ARGV[i] 
   }'
}


arreglarenglones() {
read -p "Introduce name of the file" thisis
read -p "Introduce name of the new fixed copy" thatone
sed 'N; s/\n / /; P; D' $thisis >> interm.trans
uniq interm.trans >> $thatone
sudo rm interm.trans
cat $thatone
}

allin1line() {
read -p "After click ENTER, write down your text, save, and exit." ENTER
if hash gedit 2>/dev/null; then
	gedit multiplelines
else
	vi multiplelines
fi
cat multiplelines | tr "\n" " " >> 1line
rm multiplelines
cat 1line
rm 1line
}

debugbash(){
	echo " Debugging options: bash FLAGS route_of_file"
	echo "List of flags to set:"
	echo "-f	noglob	 Disable file name generation using metacharacters (globbing)."
	echo "-e 	errexit  Abort on errors (nonzero exit code)."
	echo "-u 	undetvar Detect unset variable usages"
	echo "-o 	onpipes  Detect errors within pipes"
	echo "-v	verbose	 Prints shell input lines as they are read."
	echo "-x	xtrace	 Print command traces before executing command."
	echo "-n        noexec   Debug without executing."
	echo "If you want to debug just a part insert"
	echo "set -xveuo			# activate debugging from here"
	echo "..."
	echo "set +xveuo			# stop debugging from here"
	FLAGS=-xveuon
	PS4="${level_color}+${script_color}"'(${BASH_SOURCE##*/}:${linenum_color}${LINENO}${script_color}):'" ${funcname_color}"
	export PS4
	read -p "By default the flags are -xveuon. If you want to continue debugging write the route of the script: " route_of_file
}


debuglog(){
read -p "First let's execute the file and read the traces. Write down the route of the file and push enter when ready." ENTER
echo "Now let's go deeper into the logs"
echo "CACHES"
ls /var/cache
echo "CRASHES"
ls /var/crash
echo "LOGS"
ls /var/log
read -p "Introduce what you want check specifying if it is a /cache/file, a /crash/file or a /log/file:" FILE
sudo apt-get install grc cat -y
grc cat -n /var/$FILE
read -p "You can search for a concrete word or line using percol" ENTER
sudo -H pip install percol
percol  /var/$FILE
echo "You can retrace a dump crash using debugdump"
}

debugdump(){
sudo apt-get install apport-retrace python-problem-report python-apport -y
apropos apport
apropos apport-retrace
read -p 'Write the name of the process: ' PROCESS
echo $PROCESS
echo 'These are you crash logs routes related to that process'
ROUTECRASH=$(echo /var/crash/$(sudo ls /var/crash | grep $PROCESS))
echo $ROUTECRASH
echo 'if you only see /var/crash then there is no crash file related to that process'
read -p 'Copy the route of your log crash file: ' ROUTECRASH
ROUTEDUMP=/var/dump/$PROCESS
echo $ROUTEDUMP
sudo mkdir -p $ROUTEDUMP
sudo apport-unpack $ROUTECRASH $ROUTEDUMP
sudo apport-retrace --rebuild-package-info --confirm --timestamps --dynamic-origins  --verbose  --output $ROUTEDUMP/$PROCESS.crash $ROUTECRASH
}


install(){
  sudo apt-get install -y $1
}

uninstall(){
  sudo apt-get remove --purge -y $1
}

### SSH Functions ###

sshdelete(){
sudo chmod -R 750 ~/.ssh 
sudo ls -al -R ~/.ssh/
read -p 'These are your ssh keys. Choose one: ' MYSSHKEY
sudo rm ~/.ssh/$MYSSHKEY
sudo ls -al -R ~/.ssh
echo "Those are your ssh current keys: "
sudo chmod -R 600 ~/.ssh
}

sshupload(){
sudo ls -al -R ~/.ssh/
read -p 'These are your ssh keys. Choose one: ' MYSSHKEY
read -p "introduce the user@server to upload id_rsa.pubs to the server where they will be stored on ~/.ssh/authorized_keys folder" SERV
ssh-copy-id -i ~/.ssh/$MYSSHKEY $SERV
}

sshlist(){
sudo chmod -R 750 ~/.ssh 
sudo ls -al -R ~/.ssh
echo "Those are your ssh current keys: "
read -p 'These are your ssh keys. Choose one: ' MYSSHKEY
cat ~/.ssh/$MYSSHKEY | xclip -selection clipboard
sudo chmod -R 600 ~/.ssh
echo "Now you may have your ssh key on your clipboard. If you have already set your app global configuration, now you should go to Settings -> New SSH key and paste it there"
}

sshnewkey(){
sudo mkdir -p ~/.ssh
sudo chmod -R 750 ~/.ssh 
sudo ls -al -R ~/.ssh
echo "Those are your ssh current keys: "
read -p "Please, introduce 'youremail@server.com'" emai
echo "Use a password longer or equal to 5 caractheres"
ssh-keygen -t rsa -b 4096 -C $emai
eval "$(ssh-agent -s)" 
sudo ssh-add ~/.ssh/id_rsa**
sudo chmod -R 600 ~/.ssh
}

### Bash Completion ###
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

commit() {
  git add $1 && git commit -m $2 && git push origin $3
}

function cl(){ cd "$@" && la; }
alias back="cd .."
function cdn(){ for i in 'seq $1'; do cd ..; done;}

nospaces (){
read -p "Introduce the string to remove whitespaces: " STRIN
echo ${STRIN//[[:blank:]]/}
}

nomultiplespaces (){
read -p "Introduce the string to remove whitespaces: " STRIN
echo $STRIN | tr [A-Z] [a-z]|sed -e "s/\ \ */\ /g"
}

### Extract Archives ###
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjvf $1    ;;
      *.tar.gz)    tar xzvf $1    ;;
      *.bz2)       bzip2 -d $1    ;;
      *.rar)       unrar2dir $1    ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1    ;;
      *.tgz)       tar xzf $1    ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1    ;;
      *.7z)        7z x $1    ;;
      *.ace)       unace x $1    ;;
      *)           echo "'$1' cannot be extracted via extract()"   ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


desmonta(){
sudo ls /mnt
read -p "Introduce el disco a desmontar (sda5, sdb1...): " sdjoh
sudo umount /dev/$sdjoh
if [ "$(ls -A /mnt/$sdjoh)" ]; then
     echo "¡Cuidado! ¡La celda /mnt/$sdjoh no está vacía! Contiene los siguientes archivos todavía:"
     cd /mnt/$sdjoh
     sudo ls /mnt/$sdjoh
     sudo findmnt
else
    sudo rm -r /mnt/$sdjoh
    echo "Borrando celda..."
    sudo findmnt
fi
sudo blockdev --setro /dev/$sdjoh
}


monta(){ 
sudo lsblk
#sudo blkid
sudo fdisk -l 
read -p "Introduce el disco a montar (sda5, sdb1...): " sdjah
sudo blockdev --getsz --getsize --getbsz --getss --getpbsz --getiomin --getdiscardzeroes --getioopt --getalignoff --getsize64 --getmaxsect --getra --setrw /dev/$sdjah
sudo blkid /dev/$sdjah 
sudo mkdir -p /mnt/$sdjah
echo "Cell /mnt/$sdjah created"
sudo mount /dev/$sdjah /mnt/$sdjah
##OPEN IT
read -p 'Your disk '$sdjah' was mounted on /mnt/'$sdjah'. Do you want to open it with sudo or without? 1=Sudo 2=Notsudo 3=Goterminal; Q=Do nothing: ' opt
    case $opt in
        "1")
            echo "You were sudo"; findmnt; sudo nemo /mnt/$sdjah || sudo /mnt/nautilus $sdjah || sudo pantheon-files /mnt/$sdjah; exit;;
        "2")
            echo "You were not sudo"; findmnt; nemo /mnt/$sdjah || /mnt/nautilus $sdjah || pantheon-files /mnt/$sdjah; exit;;
        "3")
            findmnt; cd /mnt/$sdjah && ls;;
        "Q")
            exit;;
        *) echo "invalid option";;
    esac
}

recordiso(){
read -p "Write down the whole path of the ISO file: " isofile
sudo fdisk -l
read -p "Write down the /dev/sd* of the unit: " usbsda
read -p "Write down a speed (by default 2048 bytes blocksize, you can select 1k or even 4M): " blocksize
blocksize=$"{blocksize:=2048}"
sudo dd bs=$blocksize conv=noerror,sync if=$isofile of=$usbsda status=progress
}

createisolinux(){
read -p "Write down the whole path of the files you want to iso (by default CD_root): " CD_root
CD_root=$"{CD_root:=CD_root}"
read -p "Write down the whole path where you want to create the ISO file (by default /home/$USER/output.iso): " isofile
isofile=$"{isofile:=home/$USER/output.iso}"
tree CD_root
read -p "Write down the path of the boot.cat file. Remember not to include the first / (by default isolinux/boot.cat): " bootcat
bootcat=$"{bootcat:=isolinux/boot.cat}"
read -p "Write down the path of the isolinux.bin file. Remember not to include the first / (by default isolinux/isolinux.bin): " isolinuxbin
isolinuxbin=$"{isolinuxbin:=isolinux/isolinux.bin}"
read -p "Write down the path of the boot.cat file. Remember not to include the first / (by default isolinux/isolinux.bin): " efiboot
efiboot=$"{efiboot:=EFI/archiso/efiboot.img}"
genisoimage -o $isofile -c $bootcat -b $isolinuxbin -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e $efiboot -no-emul-boot $CD_root
}

#buf - Back Up a file. Usage buf filename.txt
buf() {
  cp $1 ${1}-'date +%d-%m-%Y..%H-%M'.backup
}

backup() {
read -p "Enter route to backup: " routeu
read -p "Enter user ssh: " usuu
read -p "Enter port ssh: " portu
read -p "Enter ip ssh: " ipu
read -p "Enteder directory ssh: " directoryu
cd roteu
touch ${roteu}-'date +%d-%m-%Y..%H-%M'
rsync -avtogh -force -progress –delete -e 'ssh -p $portu' $routeu $usuu@$ipu:$directoryu
}

# use DNS to query wikipedia (wiki QUERY)
wiki() { dig +short txt $1.wp.dg.cx; }

# mount an ISO file. (mountiso FILE)
mountiso() {
  name='basename "$1" .iso'
  mkdir "/tmp/$name" 2>/dev/null
  sudo mount -o loop "$1" "/tmp/$name"
  echo "mounted iso on /tmp/$name"
}

#rename multiple files
rname() {
echo introduce from .extension
read iext
echo introduce to .extension
read text
for file in *$iext; do
    sudo mv "$file" "'basename $file $iext'$text"
done
}


# search inside pdf
searchpdf() {
  echo "introduce text to search"
  read text
  echo "introduce pdf filename"
  read pdf
  pdftotext $pdf - | grep '$text'
}

#wine in and out
weneedwine() {
read -p "file to wine: " filewine
sudo dpkg --add-architecture i386
sudo add-apt-repository ppa:wine/wine-builds
sudo apt-get update
sudo apt-get install winehq-staging -y
#wget https://www.battle.net/download/getInstallerForGame?os=win&locale=enUS&version=LIVE&gameProgram=BATTLENET_APP -O Battle.net-Setup.exe
winecfg
wine $filewine
sudo apt-get purge winehq-staging 
}

changemymac(){
ifconfig -a | grep HWaddr
read -p "Those are your macs. Choose the ethernet interface (eth, wlan...) you want to change. It will be sustitued by a random MAC, so write before in case it could have been mac filtering whitelisted : " wlan
RANGE=255
#set integer ceiling
number=$RANDOM
numbera=$RANDOM
numberb=$RANDOM
numberc=$RANDOM
numberd=$RANDOM
numbere=$RANDOM
#generate random numbers
let "number %= $RANGE"
let "numbera %= $RANGE"
let "numberb %= $RANGE"
let "numberc %= $RANGE"
let "numberd %= $RANGE"
let "numbere %= $RANGE"
#ensure they are less than ceiling
#octets='64:60:2F' if you want to set a triple fix set of octets then #comment 3 octets
#set mac stem
octet=`echo "obase=16;$number" | bc`
octeta=`echo "obase=16;$numbera" | bc`
octetb=`echo "obase=16;$numberb" | bc`
octetc=`echo "obase=16;$numberc" | bc`
octetd=`echo "obase=16;$numberd" | bc`
octete=`echo "obase=16;$numbere" | bc`
#use a command line tool to change int to hex(bc is pretty standard) they are not really octets.  just sections.
firstdigit=${octet:0:1}
while :; do
	if [ $((firstdigit%2)) -eq 0 ];
		then exit
	else
		number=$RANDOM
		let "number %= $RANGE"
		octet=`echo "obase=16;$number" | bc`
		firstdigit=${octet:0:1}
	fi
done
#assure first digit is even
macadd="${octet}:${octeta}:${octetb}:${octetc}:${octetd}:${octete}"
#concatenate values and add dashes
macaddr=$(echo $macadd)
sudo ifconfig $wlan down
sudo ifconfig $wlan hw ether $macaddr
sudo ifconfig $wlan up
read -p "Those are your new macs:"
ifconfig -a | grep HWaddr
mcookie
echo "Enjoy!"
}

zeitlogeist(){
PS3='Please enter your choice: '
options=("Copy log files" "Delete log files" "Smile" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Copy log files")
            sudo apt-get install sqlitebrowser
	    sudo zip -r /var/logs ~/.local/share/zeitgeist
            sudo apt-get install sqlitebrowser
            ;;
        "Delete log files")
            echo "you chose choice 2"
            sudo rm -r /var/logs/**
            sudo rm -r ~/.local/share/zeitgeist/**
            ;;
        "Smile")
            echo "Hi, this is a joke. Smile ! :)"
            ;;
        "Quit")
	    echo 'Good bye!'
            exit
            ;;
        *) echo "invalid option";;
    esac
done

}

killmycam() {
  if sudo fuser /dev/video0; then 
  
  read -p "Este es tu proceso de camara. Introduce el numero m del proceso. " camm
  ps axl | grep $camm
  while true; do
    read -p "Tu cámara está siendo usada por este proceso. ¿Quieres acabar con él? Introduce 'y' si quieres acabar con él o 'n' si no" yn
    case $yn in
        [Yy]* ) sudo kill -9 $camm; sudo pkill $camm; echo "Proceso eliminado";break;;
        [Nn]* ) echo "Proceso mantenido";break;;
        * ) echo "Por favor, responda y (sí) o n (no)";;
    esac
  done
  else
  echo "You cam is not being used by any process."
  exit 
  fi
}

#autostart, send text to init.d
startwith(){
read -p "Introduce the name of the program: " nameofp
read -p "Introduce the command you want to include on init.d: " commandito
sudo sh -c "echo $commandito >> /etc/init.d/$nameofp"
sudo ls /etc/init.d | grep $nameofp
sudo cat /etc/init.d/$nameofp
}

#anota algo en algún lado
anota(){
read -p "Dígame, le escucho: " textito
read -p "¿Dónde guardo esta nota?: " testroute 
testroute="${testroute:=/home/$USER}"
read -p "¿Nombre de la nota?: " nameofnote
nameofnote="${nameofnote:=$now - nota.txt}"
sudo sh -c "echo $textito >> $testroute/$nameofnote"
sudo ls $testroute | grep $nameofnote
sudo cat $testroute/$nameofnote
}

#Keyfixer
changekey(){
echo "Keyboardfixer Changekey: One key at a time"
echo "Now you are going to see all the keys of your keyboard: "
sudo apt-get install xmodmap -y
sudo xmodmap -pke
echo "This is the whole list of keys"
read -p "Introduce the your CURRENT KEY: " scukey
sudo xmodmap -pke | grep $scukey
read -p "Introduce CURRENT KEY SPACE: keycode 66 (which is BloqMayus key), keycode 25 or keysym q (which is q Q key), keycode 50 (which is Shift_L)...: " keyby
read -p "Introduce what is your NEW KEY: " snewkey
sudo xmodmap -pke | grep $snewkey
read -p "Introduce NEW KEY FUNCTION: Shift_L, Shift_R, Control_L,  Control_R, Alt_L,  Meta_L, Num_Lock, Super_L, Super_R, Hyper_L, BloqMayus, q Q, w W, a W...: " keyfor
sudo xmodmap -e "${keyby} = ${keyfor}"
while true; do
    read -p "The key fix has been done. Do you want to install it permanently in order to mantain it after reboot?" yn
    case $yn in
        [Yy]* ) sudo sh -c "echo #!/bin/bash >> /etc/init.d/autoshiftfixer"; sudo sh -c "echo sudo xmodmap -e '$keyby = $keyfor' >> /etc/init.d/autoshiftfixer"; sudo ls /etc/init.d | grep autoshiftfixer; sudo cat /etc/init.d/autoshiftfixer; break;;
        [Nn]* ) echo "Enjoy!"; break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}

graphvalues(){
read "Introduce 2D coordenates separated by spaces" values
read "Introduce a graph label" glabel
read "Introduce X axis label" xlabel
read "Introduce Y axis label" ylabel
echo $values | graph -T svg -l x -L $glabel -X $xlabel -Y $ylabel  > plot.svg
firefox -new-tab plot.svg
}

wakealarm(){
read -p "how long from shutdown you want this pc become awake?" hourz
minuz=$(expr $hourz*60)
sh -c "echo 0 > /sys/class/rtc/rtc0/wakealarm" 
dat=$(date +%s)
newdat=$dat+$minuz
sh -c "echo $newdat > /sys/class/rtc/rtc0/wakealarm"
}

checkgmail() {
read -p "Which one is you user gmail user?" $1
curl -u $1@gmail.com --silent "https://mail.google.com/mail/feed/atom" | perl -ne 'print "\t" if //; print "$2\n" if /<(title|name)>(.*)<\/\1>/;'
}

checkport() {
read -e -p "Port Range: Enter your starting port (80 by default): " PORTZS
PORTZS="${PORTZS:=80}"
read -e -p "Port Range: Enter your last port (8080 by default): " PORTZF
PORTZF="${PORTZF:=8080}"
read -e -p "Enter your IP (localhost by default): " IPZ
IPZ="${IPZ:=localhost}"
for i in $(seq $PORTZS $PORTZF); do nc -zv $IPZ $i; done
read -p "Do you want to test which process is listening to that port (only for host system)? If so, write down the port: " PORTZC
lsof -iTCP:$PORTZC -sTCP:LISTEN
}

##Create your shortcut
alias icon='shortcut'
shortcut(){
read -p "Name of the program: " NAMECUT
sudo find -iname $NAMECUT
read -p "Write the whole program fileroute: " ROUTECUT
echo $ROUTECUT >> routecut
echo $grep -oP '/\K.*' $(rev routecut) >> tucetuor
rm routecut
rev tucetuor >> routecut
rm tucetor
NEWROUTECUT=$(cat routecut)
read -p "Write the route for the icon image ($NEWROUTECUT/icon.png by default): " -i "$NEWROUTECUT/icon.png" ICONROUTE
rm routecut
echo "Introduce a description (blank for none): " DESCCUT
echo "[Desktop Entry]" >> ~/Desktop/$NAMECUT.desktop
echo "Encoding=UTF-8" | tee -a ~/Desktop/$NAMECUT.desktop
echo "Name=$NAMECUT" | tee -a ~/Desktop/$NAMECUT.desktop
echo "Comment=$DESCCUT" | tee -a ~/Desktop/$NAMECUT.desktop
echo "Exec=gnome-terminal -e sh '$ROUTECUT'" | tee -a ~/Desktop/$NAMECUT.desktop
echo "Icon=$ICONROUTE" | tee -a ~/Desktop/$NAMECUT.desktop
echo "Type=Application" | tee -a ~/Desktop/$NAMECUT.desktop
echo "DESKTOP SHORTCUT ICON CREATED. YOU CAN ALSO CREATE A SYMBOLIC LINK USIN 'LN $ROUTECUT'. ENJOY!"
}

searchtorrent(){
read -p "Write a torrent description to query: " QUERY
firefox -new-tab https://www.skytorrents.in/search/all/ed/1/?q=$QUERY
firefox -new-tab https://extratorrent.unblockall.xyz/search/?search=$QUERY&new=1&x=0&y=0 
firefox -new-tab https://pirateproxy.tf/s/?q=$QUERY&page=0&orderby=99 
firefox -new-tab https://kickasstorrents.to/search.php?q=$QUERY 
firefox -new-tab https://www.torlock.com/all/torrents/$QUERY.html 
}

creationtime() {
  a=()
  for target in "${@}"; do
    inode=$(ls -di "${target}" | cut -d ' ' -f 1)
    fs=$(df "${target}"  | tail -1 | awk '{print $1}')
    crtime=$(sudo debugfs -R 'stat <'"${inode}"'>' "${fs}" 2>/dev/null | 
    grep -oP 'crtime.*--\s*\K.*')
    printf "%s\t%s\n" "${crtime}" "${target}"
  done
}

### Linux container set: lxc functions ###
alias lxcinstall='sudo apt-get install lxc lxd lxcfs openssh-server -y; newgrp lxd; sudo lxd init; mkdir ~/.config/lxc; cp /etc/lxc/default.conf ~/.config/lxc/default.conf; echo "lxc.id_map = u 0 100000 65536" >> ~/.config/lxc/default.conf; echo "lxc.id_map = g 0 100000 65536" >> ~/.config/lxc/default.conf; sudo chmod +x /home/$USER/.local/; sudo chmod +x /home/$USER/.local/share; echo "root veth lxcbr0 10" >> sudo tee -e /etc/lxc/lxc-usernet; echo "$USER veth lxcbr0 10" >> sudo tee -e /etc/lxc/lxc-usernet; printf "Current LXC uses the following kernel features to contain processes: 1. Kernel namespaces (ipc, uts, mount, pid, network and user) \n 2. Apparmor and SELinux profiles \n 3. Seccomp policies \n 4. Chroots (using pivot_root) \n 5. Kernel capabilities \n 6. CGroups (control groups)\n";'
alias lxcpurge='sudo apt-get purge lxc lxd lxcfs -y; sudo lxd init; mkdir ~/.config/lxc; cp /etc/lxc/default.conf ~/.config/lxc/default.conf; echo "lxc.id_map = u 0 100000 65536" >> ~/.config/lxc/default.conf; echo "lxc.id_map = g 0 100000 65536" >> ~/.config/lxc/default.conf; sudo chmod +x /home/$USER/.local/; sudo chmod +x /home/$USER/.local/share; echo "root veth lxcbr0 10" >> sudo tee -e /etc/lxc/lxc-usernet; echo "$USER veth lxcbr0 10" >> sudo tee -e /etc/lxc/lxc-usernet; printf "Current LXC uses the following kernel features to contain processes: 1. Kernel namespaces (ipc, uts, mount, pid, network and user) \n 2. Apparmor and SELinux profiles \n 3. Seccomp policies \n 4. Chroots (using pivot_root) \n 5. Kernel capabilities \n 6. CGroups (control groups)\n";'
alias lxcc='echo "You can check the distinct OS distro waves with distrosheet"; read -e -p "Name of the container (MYC by default): " -i "MYC" namecont; lxc-create -t download -n $namecont && wget https://github.com/abueesp/Scriptnstall/raw/master/securelxc.sh && bash securelxc.sh && rm securelxc.sh && echo "Secured and monitoring in $namecont-debug.out"'
alias lxcs='read -e -p "Name of the container (MYC by default): " -i MYC namecont; lxc-start -n $namecont -F -l debug -o $namecont-debug.out && cat var/lib/lxc/$namecont/config && echo "Monitoring in $namecont-debug.out"; echo "or run -lxc launch images:centos/6/amd64 my_container- or -lxc launch loadedimage my_container"'
alias lxci='lxc-info -n' 
alias lxcls='lxc-ls -f' 
alias lxca='echo "you can also execute -lxc exec my_container -- /bin/bash-"; lxc-attach -n' 
alias lxckill='echo "you can also execute -lxc stop my_container-"; lxc-stop -n' 
alias lxcrm='echo "you can also execute -lxc delete mycontainer-"; lxc-destroy -n' 
alias lxcload='lxc image --alias loadedimage import'
alias lxcimport='lxc image list images; echo "Select images and run -lxc remote add images 1.2.3.4- and then -lxc launch images:image-name your-container-"'
alias lxcrun='read -e -p "Name of the container (MYC by default): " -i MYC namecont; lxc exec $namecont --'
alias lxcpull='echo "Remember that your source route -> destination route may be something like -my_container/route .-"; lxc file pull'
alias lxcpush='echo "Remember that your destination route -> source route may be  something like  -hosts my_container/route-"; lxc file push'

alias BCE='curl http://api.fixer.io/latest?base=EUR'
cconv() {
echo '"shortname": "EUR",
        "longname": "Euro",
        "users":  "Austria,Belgium,Cyprus,Finland,Helsinki,France,Paris,Germany,Berlin,Greece,Athens,Ireland,Dublin,Italy,Rome,Milan,Pisa,Luxembourg,Malta,Netherlands,Portugal,Slovenia,Spain,Madrid,Barcelona,Mayotte,Monaco,Saint Pierre and Miquelon,San Marino,Vatican City,Akrotiri and Dhekelia,Andorra,Kosovo,Montenegro,Saint-Martin,Crete,Rhodes,Corfu,Kefalonia,Cefalonia,Kos,Lefkas,Myonos,Santorini,Skiathos,Zante,Zakynthos,Aegina,Andros,Ios,Kalymnos,Lesvos,Naxos,Paros,Samos,Thassos,Alonissos,Leros,Lipsi,Patmos,Paxos,Skopelos,Symi,Angistri,Hydra,Ikaria,Ithaca,Skyros,La Palma,Tenerife,Lanzarote,Fuerteventure,Grand Canaria,Mallorca,Menorca,Minorca,Ibiza",
		"alternatives": "ewro,evro",
        "symbol": "€",

        "shortname": "GBP",
        "longname": "British Pound",
        "users":  "United Kingdom,UK,England,Britain,Great Britain,Northern Ireland,Wales,Scotland,UK,Isle of Man,Jersey,Guernsey,Tristan da Cunha,South Georgia and the South Sandwich Islands",
        "alternatives": "Quid,Pound Sterling,Sterling,London,Cardiff,Edinburgh,Belfast",
        "symbol": "£",

        "shortname": "USD",
        "longname": "United States Dollar",
        "users":  "United States of America,East Timor,British Virgin Islands (U.K.),Ecuador,El Salvador,Marshall Islands,Federated States of Micronesia,Palau,Panama,Turks and Caicos Islands (U.K.),Bermuda,US,USA,America,Alabama,Montgomery,Alaska,Juneau,Arizona,Phoenix,Arkansas,Little Rock,California,Sacramento,Colorado,Denver,Connecticut,Hartford,Delaware,Dover,Florida,Tallahassee,Georgia,Atlanta,Hawaii,Honolulu,Idaho,Boise,Indiana,Indianapolis,Iowa,Des Moines,Kansas,Topeka,Kentucky,Frankfort,Louisiana,Baton Rouge,Maine,Augusta,Maryland,Annapolis,Massachusetts,Boston,Michigan,Lansing,Minnesota,Saint Paul,Mississippi,Jackson,Missouri,Jefferson City,Montana,Helena,Nebraska,Lincoln,Nevada,Carson City,New Hampshire,Concord,New Jersey,Trenton,New Mexico,Santa Fe,New York,Albany (New York),North Carolina,Raleigh,North Dakota,Bismarck,Ohio,Columbus,Oklahoma,Oklahoma City,Oregon,Salem,Pennsylvania,Harrisburg,Rhode Island,Providence,South Carolina,Columbia,South Dakota,Pierre,Tennessee,Nashville,Texas,Austin,Utah,Salt Lake City,Vermont,Montpelier,Virginia,Richmond,Washington,Olympia,West Virginia,Charleston,Wisconsin,Madison,Wyoming,Cheyenne,Los Angeles",
        "alternatives": "Buck,Green,Greenback",
        "symbol": "$",

        "shortname": "BTC",
        "longname": "Bitcoin",
        "users":  ""
		"alternatives": "XBT, Cryptocurrency",
        "symbol": "Ƀ",

        "shortname": "AUD",
        "longname": "Australian Dollar",
        "users":  "Australia,Sydney,Melbourne,Perth,Kiribati,Nauru,Tuvalu,Christmas Island,Cocos (Keeling) Islands,Norfolk Island",
        "alternatives": "",
        "symbol": "$",

        "shortname": "CAD",
        "longname": "Canadian Dollar",
        "users":  "Canada",
        "alternatives": "loonie,buck,huard,piastre",
        "symbol": "C$",

        "shortname": "CHF",
        "longname": "Swiss Franc",
        "users":  "Switzerland,Liechtenstein",
        "alternatives": "Schweizer Franken,franc suisse,franco svizzero franc svizzer",
        "symbol": "CHF",        

        "shortname": "CNY",
        "longname": "Chinese Yuan",
        "users":  "China,Hong Kong,Macau,Shanghai,Beijing,Tianjin,Guangzhou,Wuhan,Chongqing,Shenyang,Yuan",
        "alternatives": "jiao",
        "symbol": "¥",        

        "shortname": "HKD",
        "longname": "Hong Kong Dollar",
        "users":  "China,Hong Kong,Macau",
        "alternatives": "",
        "symbol": "HK$",

        "shortname": "IDR",
        "longname": "Indonesian Rupiah",
        "users":  "Indonesia,Jakarta",
        "alternatives": "",
        "symbol": "Rp"        

        "shortname": "INR",
        "longname": "Indian Rupee",
        "users":  "Bhutan,India,Bangalore,Mumbai,Delhi,Kolkata,Chennai,Hyderabad,Ahmedabad",
        "alternatives": "roopayi,rupaye,rubai",
        "symbol": "Rs."        

        "shortname": "JPY",
        "longname": "Japanese Yen",
        "users":  "Japan,Tokyo,Yokohama,Nihon-koku,日本",
        "alternatives": "A.U.U.",
        "symbol": "¥",

        "shortname": "THB",
        "longname": "Thai Baht",
        "users":  "Thailand,Bangkok",
        "alternatives": "baht",
        "symbol": "฿" ,        

        "shortname":"ALL",
        "longname": "Albanian Lek",
        "users":  "Albania,Tirana,Republic of Albania,Republika e Shqipris",
        "alternatives": "",
        "symbol": "ALL"       

        "shortname": "DZD",
        "longname": "Algerian Dinar",
        "users":  "Algeria,Algiers,Peoples Democratic Republic of Algeria,République algérienne démocratique et populaire,ad-Dīmuqrāţiyya ash Shabiyya,al Jumhuriyya al Jazāiriyya",
        "alternatives": "",
        "symbol": "دج"       

        "shortname": "XAL",
        "longname": "Aluminium Ounces",
        "users": "",
        "alternatives": "",
        "symbol": ""       

        "shortname": "ARS",
        "longname": "Argentine Peso",
        "users":  "Argentina,Buenos Aires,Argentine Republic,Repblica Argentina",
        "alternatives": "",
        "symbol": "$"       

        "shortname": "AWG",
        "longname": "Aruba Florin",
        "users":  "Aruba,Oranjestad",
        "alternatives": "",
        "symbol": "ƒ"       

        "shortname": "BSD",
        "longname": "Bahamian Dollar",
        "users":  "Bahamas,The Bahamas,The Commonwealth of The Bahamas",
        "alternatives": "",
        "symbol": "B$"       

        "shortname": "BHD",
        "longname": "Bahraini Dinar",
        "users":  "Bahrain,Manama,Kingdom of Bahrain",
        "alternatives": "",
        "symbol": ".د.ب"       

        "shortname": "BDT",
        "longname": "Bangladesh Taka",
        "users":  "Bangladesh,Dhaka,Peoples Republic of Bangladesh,Go.noprojatontri Bangladesh",
        "alternatives": "",
        "symbol": "Tk"       

        "shortname": "BBD",
        "longname": "Barbados Dollar",
        "users":  "Barbados,Bridgetown",
        "alternatives": "",
        "symbol": "BBD"       

        "shortname": "BYR",
        "longname": "Belarus Ruble",
        "users":  "Belarus,Minsk,Republic of Belarus",
        "alternatives": "",
        "symbol": "Br"       

        "shortname": "BZD",
        "longname": "Belize Dollar",
        "users":  "Belize,Belmopan",
        "alternatives": "",
        "symbol": "BZ$"       

        "shortname": "BMD",
        "longname": "Bermuda Dollar",
        "users":  "Bermuda,Hamilton",
        "alternatives": "",
        "symbol": "BD$"       

        "shortname": "BTN",
        "longname": "Bhutan Ngultrum",
        "users":  "Bhutan,Thimphu,Kingdom of Bhutan,Dru Gäkhap,Brug rGyal-Khab",
        "alternatives": "",
        "symbol": "Nu."       

        "shortname": "BOB",
        "longname": "Bolivian Boliviano",
        "users":  "Bolivia,Sucre",
        "alternatives": "",
        "symbol": "Bs"       

        "shortname": "BWP",
        "longname": "Botswana Pula",
        "users":  "Botswana,Gaborone",
        "alternatives": "",
        "symbol": "P"       

        "shortname": "BRL",
        "longname": "Brazilian Real",
        "users":  "Brazil,Rio de Janeiro,São Paulo,Sao Paulo,Federative Republic of Brazil,Republica Federativa do Brasil",
        "alternatives": "",
        "symbol": "R$"       

        "shortname": "BND",
        "longname": "Brunei Dollar",
        "users":  "Brunei,Bandar Seri Begawan,Singapore,State of Brunei,Abode of Peace,Negara Brunei Darussalam",
        "alternatives": "",
        "symbol": "B$"       

        "shortname": "BGN",
        "longname": "Bulgarian Lev",
        "users":  "Bulgaria,Sofia,Republic of Bulgaria,Republika Balgariya",
        "alternatives": "",
        "symbol": "лв"       

        "shortname": "BIF",
        "longname": "Burundi Franc",
        "users":  "Burundi,Bujumbura,Republic of Burundi,République du Burundi,Republika yu Burundi",
        "alternatives": "",
        "symbol": "FBu"       

        "shortname": "KHR",
        "longname": "Cambodia Riel",
        "users":  "Cambodia,Phnom Penh,Kingdom of Cambodia,Royaume du Cambodge,Preăh Réachéa Nachâk Kâmpŭchéa",
        "alternatives": "",
        "symbol": "៛"       

        "shortname": "CVE",
        "longname": "Cape Verde Escudo",
        "users":  "Cape Verde,Praia,Republic of Cape Verde,Republica de Cabo Verde",
        "alternatives": "",
        "symbol": "Esc"       

        "shortname": "KYD",
        "longname": "Cayman Islands Dollar",
        "users":  "Cayman Islands,Grand Cayman,Cayman Brac,Little Cayman,George Town",
        "alternatives": "",
        "symbol": "$"       

        "shortname": "XOF",
        "longname": "CFA Franc (BCEAO)",
        "users":  "Côte dIvoire,Yamoussoukro,Abidjan,Republic of Côte dIvoire,Ivory Coast,Benin,Burkina Faso,Guinea-Bissau,Mali,Niger,Senegal,Togo",
		"alternatives": "cefa,franc,West African CFA franc",
        "symbol": "XOF"       

        "shortname": "XAF",
        "longname": "CFA Franc (BEAC)",
        "users":  "Cameroon,Central African Republic,Chad,Republic of the Congo,Equatorial Guinea,Gabon",
		"alternatives": "cefa,franc,Central African CFA franc",
        "symbol": "XAF"       

        "shortname": "CLP",
        "longname": "Chilean Peso",
        "users":  "Chile,Santiago",
        "alternatives": "",
        "symbol": "$"       

        "shortname": "COP",
        "longname": "Colombian Peso",
        "users":  "Columbia,Bogota,Republica de Colombia,Republic of Colombia",
        "alternatives": "",
        "symbol": "$"       

        "shortname": "KMF",
        "longname": "Comoros Franc",
        "users":  "Comoros,Union des Comores,Udzima wa Komorid, Al-Qumuriyy,Union of the Comoros,Moroni",
		"alternatives": "Comorian franc",
        "symbol": "KMF"       

        "shortname": "XCP",
        "longname": "Copper Pounds",
        "users": "",
        "alternatives": "",
        "symbol": ""       

        "shortname": "CRC",
        "longname": "Costa Rica Colon",
        "users":  "Costa Rica,San Jose,San Jose,Republica de Costa Rica,Republic of Costa Rica",
        "alternatives": "",
        "symbol": "₡"       

        "shortname": "HRK",
        "longname": "Croatian Kuna",
        "users":  "Croatia,Zagreb,Republika Hrvatska,Republic of Croatia",
        "alternatives": "",
        "symbol": "kn"       

        "shortname": "CUP",
        "longname": "Cuban Peso",
        "users":  "Cuba,Havana,Republica de Cuba,Republic of Cuba",
        "alternatives": "",
        "symbol": "$MN"       

        "shortname": "CZK",
        "longname": "Czech Koruna",
        "users":  "Czech Republic,Prague",
		"alternatives": "CSK",
        "symbol": "Kč"       

        "shortname": "DKK",
        "longname": "Danish Krone",
        "users":  "Denmark,Copenhagen,Greenland,Faroe Islands",
		"alternatives": "DKR",
        "symbol": "kr"       

        "shortname": "DJF",
        "longname": "Dijibouti Franc",
        "users":  "Djibouti,Republic of Djibouti,République de Djibouti,Jamhuuriyadda Jabuuti,Jumhūriyyat Jībūtī",
        "alternatives": "",
        "symbol": "Fdj"       

        "shortname": "DOP",
        "longname": "Dominican Peso",
        "users":  "Dominican Republic,Republica Dominicana,Hispaniola,Greater Antilles",
        "alternatives": "",
        "symbol": "RD$"       

        "shortname": "XCD",
        "longname": "East Caribbean Dollar",
        "users":  "Anguilla,Antigua and Barbuda,Dominica,Grenada,Montserrat,Saint Kitts and Nevis,Saint Lucia,Saint Vincent,The Grenadines",
        "alternatives": "",
        "symbol": "EC$"       

        "shortname": "ECS",
        "longname": "Ecuador Sucre",
        "users":  "Ecuador,Quito,Republica del Ecuador,Galapagos Islands,Guayaquil",
        "alternatives": "",
        "symbol": "S/."       

        "shortname": "EGP",
        "longname": "Egyptian Pound",
        "users":  "Egypt,Cairo,Alexandria,Arab Republic of Egypt",
        "alternatives": "",
        "symbol": "ج.م"       

        "shortname": "SVC",
        "longname": "El Salvador Colon",
        "users":  "El Salvador,San Salvador,Republica de El Salvador",
        "alternatives": "",
        "symbol": "₡"       

        "shortname": "ERN",
        "longname": "Eritrea Nakfa",
        "users":  "Eritrea,Asmara,State of Eritrea",
        "alternatives": "",
        "symbol": "Nfk"       

        "shortname": "EEK",
        "longname": "Estonian Kroon",
        "users":  "Estonia,Republic of Estonia,Tallinn,Eesti,Eesti Vabariik",
        "alternatives": "",
        "symbol": "EEK"       

        "shortname": "ETB",
        "longname": "Ethiopian Birr",
        "users":  "Ethiopia,Addis Ababa,Federal Democratic Republic of Ethiopia",
        "alternatives": "",
        "symbol": "Br"       

        "shortname": "FKP",
        "longname": "Falkland Islands Pound",
        "users":  "Falkland Islands,Malvinas,Islas Malvinas,Stanley",
        "alternatives": "",
        "symbol": "£"       

        "shortname": "FJD",
        "longname": "Fiji Dollar",
        "users":  "Fiji,Republic of the Fiji Islands,Suva",
        "alternatives": "",
        "symbol": "FJ$"       

        "shortname": "GMD",
        "longname": "Gambian Dalasi",
        "users":  "The Gambia,Gambia,Banjul,Republic of The Gambia",
        "alternatives": "",
        "symbol": "D"       

        "shortname": "GHC",
        "longname": "Ghanian Cedi",
        "users":  "Ghana,Republic of Ghana,Accra",
		"alternatives": "DKR",
        "symbol": "₵"       

        "shortname": "GIP",
        "longname": "Gibraltar Pound",
        "users":  "Gibraltar,Gib,The Rock",
        "alternatives": "",
        "symbol": "£"       

        "shortname": "XAU",
        "longname": "Gold Ounces",
        "users": "",
        "alternatives": "",
        "symbol": ""       

        "shortname": "GTQ",
        "longname": "Guatemala Quetzal",
        "users":  "Guatemala,Guatemala City,Republica de Guatemala",
        "alternatives": "",
        "symbol": "Q"       

        "shortname": "GNF",
        "longname": "Guinea Franc",
        "users":  "Guinea,Conakry,Republic of Guinea,République de Guinée",
        "alternatives": "",
        "symbol": "FG"       

        "shortname": "GYD",
        "longname": "Guyana Dollar",
        "users":  "Guyana,Co-operative Republic of Guyana,Georgetown",
        "alternatives": "",
        "symbol": "GY$"       

        "shortname": "HTG",
        "longname": "Haiti Gourde",
        "users": "",
        "alternatives": "",
        "symbol": ""       

        "shortname": "HNL",
        "longname": "Honduras Lempira",
        "users":  "Honduras,Tegucigalpa,Republica de Honduras,Republic of Honduras",
        "alternatives": "",
        "symbol": "L"       

        "shortname": "HUF",
        "longname": "Hungarian Forint",
        "users":  "Hungary,Budapest,Magyar Köztársaság,Republic of Hungary",
        "alternatives": "",
        "symbol": "Ft"       

        "shortname": "ISK",
        "longname": "Iceland Krona",
        "users":  "Iceland,Reykjavik,Ísland,Republic of Iceland",
        "alternatives": "",
        "symbol": "kr"       

        "shortname": "IRR",
        "longname": "Iran Rial",
        "users":  "Iran,Tehran,Islamic Republic of Iran,Jomhuri-ye Eslāmi-ye Irān",
        "alternatives": "",
        "symbol": "﷼"       

        "shortname": "IQD",
        "longname": "Iraqi Dinar",
        "users":  "Iraq,Baghdad,Republic of Iraq,Komara Îraqê,Jumhūriyat Al-Irāq",
        "alternatives": "",
        "symbol": "ع.د"       

        "shortname": "ILS",
        "longname": "Israeli Shekel",
        "users":  "Israel,Palestinian territories,The West Bank,Gaza Strip,Jerusalem",
        "alternatives": "",
        "symbol": "₪"       

        "shortname": "JMD",
        "longname": "Jamaican Dollar",
        "users":  "Jamaica,Kingston",
        "alternatives": "",
        "symbol": "$"       

        "shortname": "JOD",
        "longname": "Jordanian Dinar",
        "users":  "Jordan,West Bank,Al-Mamlakah al-Urdunniyyah al-Hāšimiyyah,The Hashemite Kingdom of Jordan,Amman",
        "alternatives": "",
        "symbol": "JOD"       

        "shortname": "KZT",
        "longname": "Kazakhstan Tenge",
        "users":  "Kazakhstan,Republic of Kazakhstan,Qazaqstan Respublïkası,Astana",
        "alternatives": "",
        "symbol": "KZT"       

        "shortname": "KES",
        "longname": "Kenyan Shilling",
        "users":  "Kenya,Nairobi,Jamhuri ya Kenya,Republic of Kenya",
        "alternatives": "",
        "symbol": "KSh"       

        "shortname": "KRW",
        "longname": "South Korean Won",
        "users":  "South Korea,Daehanminguk,Republic of Korea,Seoul",
        "alternatives": "",
        "symbol": "₩",

        "shortname": "KWD",
        "longname": "Kuwaiti Dinar",
        "users":  "Kuwait,Dawlat al-Kuwayt,State of Kuwait",
        "alternatives": "",
        "symbol": "د.ك"       

        "shortname": "LAK",
        "longname": "Lao Kip",
        "users":  "Laos,Lao Peoples Democratic Republic,Sathalanalat Paxathipatai Paxaxon Lao,Vientiane",
        "alternatives": "",
        "symbol": "₭"       

        "shortname": "LVL",
        "longname": "Latvian Lat",
        "users":  "Latvia,Republic of Latvia,Latvijas Republika",
        "alternatives": "",
        "symbol": "Ls"       

        "shortname": "LBP",
        "longname": "Lebanese Pound",
        "users":  "Lebanon,Lebanese Republic,al-Jumhūrīyah al-Lubnānīyah,Beirut",
        "alternatives": "",
        "symbol": "ل.ل"       

        "shortname": "LSL",
        "longname": "Lesotho Loti",
        "users":  "Lesotho,Kingdom of Lesotho,Muso oa Lesotho,Maseru",
        "alternatives": "",
        "symbol": "L"       

        "shortname": "LRD",
        "longname": "Liberian Dollar",
        "users":  "Liberia,Republic of Liberia,Monrovia",
        "alternatives": "",
        "symbol": "L$"       

        "shortname": "LYD",
        "longname": "Libyan Dinar",
        "users":  "Libya,Great Socialist Peoples Libyan Arab Republic",
        "alternatives": "",
        "symbol": "ل.د"       

        "shortname": "LTL",
        "longname": "Lithuanian Lita",
        "users":  "Lithuania,Lietuvos Respublika,Republic of Lithuania",
        "alternatives": "",
        "symbol": "Lt"       

        "shortname": "MOP",
        "longname": "Macau Pataca",
        "users":  "Macau,Macau Special Administrative Region,Região Administrativa Especial de Macau",
        "alternatives": "",
        "symbol": "$"       

        "shortname": "MKD",
        "longname": "Macedonian Denar",
        "users":  "Republic of Macedonia,Macedonia,Republika Makedonija",
        "alternatives": "",
        "symbol": "MKD"       

        "shortname": "MWK",
        "longname": "Malawi Kwacha",
        "users":  "Malawi,Lilongwe",
        "alternatives": "",
        "symbol": "MK"       

        "shortname": "MYR",
        "longname": "Malaysian Ringgit",
        "users":  "Malaysia,Kuala Lumpur",
        "alternatives": "",
        "symbol": "RM"       

        "shortname": "MVR",
        "longname": "Maldives Rufiyaa",
        "users":  "Maldives,Male,Divehi Rājjey ge Jumhuriyyā,Republic of Maldives",
        "alternatives": "",
        "symbol": "Rf"       

        "shortname": "MTL",
        "longname": "Maltese Lira",
        "users":  "Malta,Repubblika ta Malta,Republic of Malta,Valletta,Birkirkara",
        "alternatives": "",
        "symbol": "Lm"       

        "shortname": "MRO",
        "longname": "Mauritania Ougulya",
        "users":  "Mauritania,Al-Jumhūriyyah al-Islāmiyyah al-Mūrītāniyyah,République Islamique de Mauritanie,Islamic Republic of Mauritania,Nouakchott",
        "alternatives": "",
        "symbol": "UM"       

        "shortname": "MUR",
        "longname": "Mauritius Rupee",
        "users":  "Mauritius,Port Louis,Republic of Mauritius,République de Maurice",
        "alternatives": "",
        "symbol": "₨"       

        "shortname": "MXN",
        "longname": "Mexican Peso",
        "users":  "Mexico,Mexico City",
        "alternatives": "",
        "symbol": "$"       

        "shortname": "MDL",
        "longname": "Moldovan Leu",
        "users":  "Moldova,Republica Moldova,Republic of Moldova,Chisinau",
        "alternatives": "",
        "symbol": "MDL"       

        "shortname": "MNT",
        "longname": "Mongolian Tugrik",
        "users":  "Mongolia,Mongol uls,Ulan Bator",
        "alternatives": "",
        "symbol": "₮"       

        "shortname": "MAD",
        "longname": "Moroccan Dirham",
        "users":  "Morocco,Western Sahara,Al-Mamlaka al-Maghribiyya,Kingdom of Morocco,Rabat,al-Harbiyyah,Sahara Occidental,Western Sahara,El Aaiun,Laayoune",
        "alternatives": "",
        "symbol": "د.م."       

        "shortname": "MMK",
        "longname": "Myanmar Kyat",
        "users":  "Burma,Naypyidaw,Union of Myanmar,Pyi-daung-zu Myan-ma Naing-ngan-daw",
        "alternatives": "",
        "symbol": "K"       

        "shortname": "NAD",
        "longname": "Namibian Dollar",
        "users":  "Namibia,Republic of Namibia,Windhoek",
        "alternatives": "",
        "symbol": "N$"       

        "shortname": "NPR",
        "longname": "Nepalese Rupee",
        "users":  "Nepal,Kathmandu,Sanghiya Loktāntrik Ganatantra Nepāl,Federal Democratic Republic of Nepal",
        "alternatives": "",
        "symbol": "₨"       

        "shortname": "ANG",
        "longname": "Neth Antilles Guilder",
        "users":  "Netherlands Antilles,Willemstad,Nederlandse Antillen,Antia Ulandes,Antia Hulandes",
        "alternatives": "",
        "symbol": "NAƒ"       

        "shortname": "TRY",
        "longname": "Turkish Lira",
        "users":  "Turkey,Istanbul,Ankara,Northern Cyprus,Türkiye Cumhuriyeti,Turkish Republic of Northern Cyprus,Nicosia,Lefkosa",
        "alternatives": "",
        "symbol": "YTL"       

        "shortname": "NZD",
        "longname": "New Zealand Dollar",
        "users":  "New Zealand,Wellington",
        "alternatives": "",
        "symbol": "$" ,      

        "shortname": "NIO",
        "longname": "Nicaragua Cordoba",
        "users":  "Nicaragua,Managua,Republica de Nicaragua,Republic of Nicaragua",
        "alternatives": "",
        "symbol": "C$"       

        "shortname": "NGN",
        "longname": "Nigerian Naira",
        "users":  "Nigeria,Lagos",
        "alternatives": "",
        "symbol": "₦"       

        "shortname": "KPW",
        "longname": "North Korean Won",
        "users":  "North Korea,Pyongyang",
        "alternatives": "",
        "symbol": "₩"       

        "shortname": "NOK",
        "longname": "Norwegian Krone",
        "users":  "Norway,Oslo",
        "alternatives": "",
        "symbol": "kr"       

        "shortname": "OMR",
        "longname": "Omani Rial",
        "users":  "Oman,Muscat",
        "alternatives": "",
        "symbol": "ر.ع."       

        "shortname": "XPF",
        "longname": "Pacific Franc",
        "users":  "French Polynesia,New Caledonia,Wallis and Futuna",
        "alternatives": "",
        "symbol": "F"       

        "shortname": "PKR",
        "longname": "Pakistani Rupee",
        "users":  "Pakistan,Islamabad,Karachi,Lahore",
        "alternatives": "",
        "symbol": "Rs."       

        "shortname": "XPD",
        "longname": "Palladium Ounces",
        "users": "",
        "alternatives": "",
        "symbol": ""       

        "shortname": "PAB",
        "longname": "Panama Balboa",
        "users":  "Panama,Panama City,Republica de Panama,Republic of Panama",
        "alternatives": "",
        "symbol": "B"       

        "shortname": "PGK",
        "longname": "Papua New Guinea Kina",
        "users":  "Papua New Guinea,Port Moresby",
        "alternatives": "",
        "symbol": "K"       

        "shortname": "PYG",
        "longname": "Paraguayan Guarani",
        "users":  "Paraguay,Asuncion",
        "alternatives": "",
        "symbol": "₲"       

        "shortname": "PEN",
        "longname": "Peruvian Nuevo Sol",
        "users":  "Peru,Lima",
        "alternatives": "",
        "symbol": "S/."       

        "shortname": "PHP",
        "longname": "Philippine Peso",
        "users":  "Philippines,Manila",
        "alternatives": "",
        "symbol": "₱"       

        "shortname": "XPT",
        "longname": "Platinum Ounces",
        "users": "",
        "alternatives": "",
        "symbol": ""       

        "shortname": "PLN",
        "longname": "Polish Zloty",
        "users":  "Poland,Warsaw,Republic of Poland",
		"alternatives": "z.oty",
        "symbol": "zł"       

        "shortname": "QAR",
        "longname": "Qatar Rial",
        "users":  "Qatar,Doha,State of Qatar",
		"alternatives": "Qatari riyal",
        "symbol": "ر.ق"       

        "shortname": "RON",
        "longname": "Romanian New Leu",
        "users":  "Romania,Bucharest",
        "alternatives": "",
        "symbol": "L"       

        "shortname": "RUB",
        "longname": "Russian Rouble",
        "users":  "Russia,Moscow,Saint Petersburg,St Petersburg",
        "alternatives": "",
        "symbol": "руб"       

        "shortname": "RWF",
        "longname": "Rwanda Franc",
        "users":  "Rwanda,Kigali,Repubulika yu Rwanda,République du Rwanda",
        "alternatives": "",
        "symbol": "RF"       

        "shortname": "WST",
        "longname": "Samoa Tala",
        "users":  "Samoa,Apia",
        "alternatives": "",
        "symbol": "WS$"       

        "shortname": "STD",
        "longname": "Sao Tome Dobra",
        "users":  "Sao Tome,São Tomé,Principe",
        "alternatives": "",
        "symbol": "Db"       

        "shortname": "SAR",
        "longname": "Saudi Arabian Riyal",
        "users":  "Saudi Arabia,Riyadh",
        "alternatives": "",
        "symbol": "ر.س"       

        "shortname": "SCR",
        "longname": "Seychelles Rupee",
        "users":  "Seychelles,Victoria,Republic of Seychelles",
        "alternatives": "",
        "symbol": "SR"       

        "shortname": "SLL",
        "longname": "Sierra Leone Leone",
        "users":  "Sierra Leone,Freetown",
        "alternatives": "",
        "symbol": "Le"       

        "shortname": "XAG",
        "longname": "Silver Ounces",
        "users": "",
        "alternatives": "",
        "symbol": ""       

        "shortname": "SGD",
        "longname": "Singapore Dollar",
        "users":  "Singapore",
        "alternatives": "",
        "symbol": "S$",
	"highlight": ""       

        "shortname": "SKK",
        "longname": "Slovak Koruna",
        "users":  "Slovakia,Bratislava",
        "alternatives": "",
        "symbol": "Sk"       

        "shortname": "SIT",
        "longname": "Slovenian Tolar",
        "users":  "Slovenia,Ljubljana",
        "alternatives": "",
        "symbol": "SIT"       

        "shortname": "SBD",
        "longname": "Solomon Islands Dollar",
        "users":  "Solomon Islands,Honiara",
        "alternatives": "",
        "symbol": "SI$"       

        "shortname": "SOS",
        "longname": "Somali Shilling",
        "users":  "Somalia,Mogadishu",
        "alternatives": "",
        "symbol": "So."       

        "shortname": "ZAR",
        "longname": "South African Rand",
        "users":  "South Africa,Republic of South Africa,Pretoria,Bloemfontein,Cape Town,Johannesburg",
        "alternatives": "",
        "symbol": "R"       

        "shortname": "LKR",
        "longname": "Sri Lanka Rupee",
        "users":  "Sri Lanka,Sri Jayawardenapura-Kotte",
        "alternatives": "",
        "symbol": "₨"       

        "shortname": "SHP",
        "longname": "St Helena Pound",
        "users":  "St Helena,Jamestown",
        "alternatives": "",
        "symbol": "£"       

        "shortname": "SDG",
        "longname": "Sudanese Pound",
        "users":  "Sudan",
        "alternatives": "",
        "symbol": "SDG"       

        "shortname": "SZL",
        "longname": "Swaziland Lilageni",
        "users":  "Swaziland",
        "alternatives": "",
        "symbol": "SZL"       

        "shortname": "SEK",
        "longname": "Swedish Krona",
        "users":  "Sweden,Stockholm",
        "alternatives": "",
        "symbol": "kr"       

        "shortname": "SYP",
        "longname": "Syrian Pound",
        "users":  "Syria",
        "alternatives": "",
        "symbol": "SYP"       

        "shortname": "TWD",
        "longname": "Taiwan Dollar",
        "users":  "Taiwan,Taipei",
        "alternatives": "",
        "symbol": "NT$",       

        "shortname": "TZS",
        "longname": "Tanzanian Shilling",
        "users":  "Tanzania",
        "alternatives": "",
        "symbol": "x"       

        "shortname": "TOP",
        "longname": "Tonga Paang",
        "users":  "Tonga",
        "alternatives": "",
        "symbol": "T$"       

        "shortname": "TTD",
        "longname": "Trinidad & Tobago Dollar",
        "users":  "Trinidad and Tobago,Trinidad,Tobago,Port of Spain",
		"alternatives": "TT$",
        "symbol": ""       

        "shortname": "TND",
        "longname": "Tunisian Dinar",
        "users":  "Tunisia,Tunis",
        "alternatives": "",
        "symbol": "د.ت"       

        "shortname": "AED",
        "longname": "UAE Dirham",
        "users":  "United Arab Emirates,UAE,Dubai",
        "alternatives": "",
        "symbol": "د.إ"       

        "shortname": "UGX",
        "longname": "Ugandan Shilling",
        "users":  "Uganda,Kampala",
        "alternatives": "",
        "symbol": "USh"       

        "shortname": "UAH",
        "longname": "Ukraine Hryvnia",
        "users":  "Ukraine",
        "alternatives": "",
        "symbol": "₴"       

        "shortname": "UYU",
        "longname": "Uruguayan New Peso",
        "users":  "Uruguay",
	"alternatives": "$",
        "symbol": ""       

        "shortname": "VUV",
        "longname": "Vanuatu Vatu",
        "users":  "Vanuatu,Port Vila",
		"alternatives": "Vt",
        "symbol": "Vt"       

        "shortname": "VEF",
        "longname": "Venezuelan Bolivar Fuerte",
        "users":  "Venezuela",
        "alternatives": "",
        "symbol": "Bs"       

        "shortname": "VND",
        "longname": "Vietnam Dong",
        "users":  "Vietnam,Ho Chi Minh City",
        "alternatives": "",
        "symbol": "₫"       

        "shortname": "YER",
        "longname": "Yemen Riyal",
        "users":  "Yemen",
		"alternatives": "Yemeni rial",
        "symbol": "YER"       

        "shortname": "ZMK",
        "longname": "Zambian Kwacha",
        "users":  "Zambia",
        "alternatives": "",
        "symbol": "ZMK"       

        "shortname": "ZWD",
        "longname": "Zimbabwe dollar",
        "users":  "Zimbabwe",
        "alternatives": "",
        "symbol": "Z$"'
echo "Usage: cconv AMOUNT FROMC TOC"
  wget -qO- "https://finance.google.com/finance/converter?a=$1&from=$2&to=$3" | sed '/res/!d;s/<[^>]*>//g';
}

cmkcap() {
curl https://api.coinmarketcap.com/v1/ticker/$1/?convert=EUR
}

## IRC aliases ##
alias newircchannel='read -p "Introduce name of channel: " CHANN && read -p "Introduce description of channel: " DESCCHAN && weechat -r "/msg ChanServ REGISTER #$CHANN #DESCCHAN" FloodServ on"'
alias killircghost='read -p "User: " IRCUSER && read -p "Password: " IRCPASS && weechat -r "/msg NickServ GHOST $IRCUSER $IRCPASS"'
alias recoverircuser='read -p "User: " IRCUSER && read -p "Password: " IRCPASS && weechat -r "/msg NickServ RECOVER $IRCUSER $IRCPASS" -r "/msg NickServ REGAIN $IRCUSER $IRCPASS" -r "/nickserv release $IRCUSER $IRCPASS" -r "/msg NickServ IDENTIFY $IRCUSER $IRCPASS" -r "/msg nickserv set enforce on" -r "/msg nickserv set secure on"'
alias identifyirc='read -p "User: " IRCUSER && read -p "Password: " IRCPASS && weechat -r "/user $IRCUSER" -r "/msg NickServ IDENTIFY $IRCUSER $IRCPASS" -r "/msg nickserv set enforce on" -r "/msg nickserv set secure on"'
newircuser(){ 
read -p "User: " IRCUSER
read -p "Password: " IRCPASS
read -p "Email (to create new account): " IRCMAIL
weechat -r "/msg NickServ IDENTIFY $IRCUSER" -r "/msg NickServ REGISTER $IRCPASS $IRCMAIL" -r "/quit"
read -p "Go to email and introduce code: " IRCAUTH
weechat -r "/msg NickServ AUTH $IRCAUTH"
weechat -r "/msg NickServ IDENTIFY $IRCUSER $IRCPASS"
}
alias changeircpass='read -p "User: " IRCUSER && weechat -r "/msg NickServ SENDPASS $IRCUSER" && read -p "Go to email and introduce key: " IRCKEY && read -p "New password: " IRCNEWPASS &&  weechat -r "/msg NickServ SETPASS $IRCUSER $IRCKEY $IRCNEWPASS"'

rotate(){
# All credits to: https://gist.githubusercontent.com/mildmojo/48e9025070a2ba40795c/raw/e9ca16e9ce472f642db2a13e72f79d3b99931773/rotate_desktop.sh
# Configure these to match your hardware (names taken from `xinput` output).
if [ $1 -eq 0 ]; then
  echo "Missing orientation."
  echo "Usage: $0 [d|u|l|r] [revert_seconds]"
  echo "u up d down l left r right - time in seconds"
fi
if [ $1 -eq up ]; then
  $1=inverted
fi

if [ $1 -eq down ]; then
  $1=normal
fi
xrandr --output $1 
}
rotatescreen=rotate
