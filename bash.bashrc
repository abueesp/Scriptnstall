# System-wide .bashrc file for interactive bash(1) shells.
# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

##Normal Ctrl+C Ctrl+V
gconftool-2 -t str -s /apps/gnome-terminal/keybindings/copy "<Control>c"
gconftool-2 -t str -s /apps/gnome-terminal/keybindings/paste "<Control>v"

##History
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL=ignoredups
export HISTCONTROL=ignorespace
alias rmhist="history -c"
alias deletehist="history -c"
alias anonhist="export HISTSIZE=0"
alias hist="export HISTSIZE=1"
alias shis="history | grep"
alias searchhist="history | grep"

##Colors
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
 
usage()
{

cat <<EOF
Default colors are:
${level_color}- shell level color:cyan$nc
${script_color}- script name: yellow$nc
${linenum_color}- line number: red$nc
${funcname_color}- function name: green$nc
${command_color}- command executed: white$nc
- Other colors options are: ${darkgrey}darkgrey$nc, ${lightgrey}light grey$nc, ${lightred}light red,${lightgreen}light green, ${blue}blue, ${lightblue}light blue, ${purple}purple, ${pink}pink, ${lightcyan}light cyan$nc.

Usage: debug 
- help|usage: print this screen
- verbose: sets -xv flags
- noexec: sets -xvn flags
- no parameter sets -x flags
 
${script_color} coding for good - node command line $nc 
${command_color} Ƀe ℋuman, be κinđ, be ωise $nc

EOF
}
 
 
debug_cmd()
{
   trap reset_screen INT
   /bin/bash $FLAGS $SCRIPT
}
 
if [ $# -gt 0 ]; then
   case "$1" in
         "verbose")
            FLAGS=-xv
            SCRIPT=$2
         ;;
         "noexec")
            FLAGS=-xvn
            SCRIPT=$2
         ;;
         "help"|"usage")
            usage
            exit 3
         ;;
         *)
            FLAGS=-x
            PS4="${level_color}+${script_color}"'(${BASH_SOURCE##*/}:${linenum_color}${LINENO}${script_color}):'" ${funcname_color}"
            export PS4
            SCRIPT=$1
         ;;
   esac
   debug_cmd
else
   usage
fi

gpgverify() {
echo "FIRST. IMPORT THE SERVER KEY. COPY AND PASTE SOMETHING LIKE gpg --keyserver pool.sks-keyservers.net --recv-keys 0x427F11FD0FAA4B080123F01CDDFA1A3E36879494"
read command
$command
gpg --import ./**.asc
echo "introduce un valor 0x para gpg --edit-key 0x36879494 and then, in order to ultimately trust it, introduce: fpr / trust / 5 / y / q "
read masterkey
gpg --edit-key $masterkey -c "fpr && trust && 5 && y && q"
gpg -v --verify **.asc **.iso
gpg -v --verify **.DIGESTS
}

gpgexport() {
sudo mkdir gpgexport
cd gpgexport
read -p "introduce the key username to export: " USN
sudo gpg --export -a $USN > public.key
sudo gpg --export-secret-key -a $USN > private.key
sudo gpg --fingerprint -a $USN > fingerprint
echo "here you are your public.key, private.key and fingerprint" 
}

gpgimport() {
read -p "Go to the folder. Rename as public.key and private.key; as well as introduce the key username: " USN
sudo gpg --import -a $USN > $public.key
sudo gpg --import-secret-key -a $USN > private.key
echo "your public key and private have been imported as public.key and private.key" 
}

gpgdelete() {
read -p "introduce the key username to delete Usernameprivate.key and/or Usernamepublic.key: " USN
sudo gpg --delete -a $USN
sudo gpg --deleete-secret-key -a $USN
echo "your public key and private have been deleted as public.key and private.key" 
}

gpglist() {
echo "pubkeys list"
sudo gpg --list-keys
echo "privkeys list"
sudo gpg --list-secret-keys
echo "fingerprints"
sudo gpg --fingerprint
}

gpgencrypt() {
read -p "enter your gpg username (sender username): " USNs
read -p "enter your gpg username (receiver username): " USNr
read -p "enter the route of the file" filegpge
sudo gpg -e -u $USNs -r $USNr $filegpge
}

gpgdecrypt() {
read -p "enter file.gpg to decrypt: " filegpgd
sudo gpg -o $filegpg[-4] -d $filegpgd
}

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
 force_color_prompt=yes
# set a fancy prompt (non-color, overwrite the one in /etc/profile)
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi

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


## Create a repo on git (not Github)
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
 break
 fi


 repo_name=$1

 dir_name=`basename $(pwd)`

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

gitupload () {
  
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
 break
 fi

 repo_name=$1
 dir_name=`basename $(pwd)`
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


securedelete () {
  read -p "DANGER VAS A BORRAR DE FORMA SEGURA TODO. INTRODUCE LA RUTA DE LA CARPETA O EL ARCHIVO SIN EQUIVOCARTE      -->" route
  rin="$route""/**"
  sudo shred -uvzn 3 $route
  sudo shred -uvzn 3 $rin
  sudo srm -vrzd $route
  }
  
tmuxts () {
tmux new-session -s 'MyTS' -n 'w1' -d 'vim'
tmux split-window -v -t 'w1' -d 'python'
tmux split-window -h -t 'w1' -c '/home/$USER'
tmux new-window -n 'w2' -t 'MyTS' -c '/home/$USER/devcon/'
tmux split-window -h -t 'w2' 'watch free'
tmux split-window -v -t 'w2'
tmux send-keys 'tmux list-sessions && tmux list-windows && tmux list-panes && stop'  C-m
tmux -2 attach-session -t 'MyTS'
tmux select-window -t 'w1'
tmux select-pane -t 'w2:2'
  }
  

docsthemagic () {
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
    sudo mv "$file" "`basename $file .html.pdf`.pdf"
    done
  for file in *.html.epub; do
    sudo mv "$file" "`basename $file .html.pdf`.epub"
    done
  for file in *.html.wiki; do
    sudo mv "$file" "`basename $file .html.wiki`.wiki"
    done
  for file in *.html.txt; do
    sudo mv "$file" "`basename $file .html.txt`.txt"
    done
 for file in *.html.md; do
    sudo mv "$file" "`basename $file .html.md`.md"
    done
  for file in *.html.odt; do
    sudo mv "$file" "`basename $file .html.odt`.odt"
    done
  sudo mat -c **
  sudo mat **
}

updatebash() {
sudo wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/bash.bashrc
sudo rm /etc/bash.bashrc~
sudo cp /etc/bash.bashrc /etc/bash.bashrc~
sudo rm /etc/bash.bashrc
sudo mv bash.bashrc /etc/bash.bashrc
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
echo "introduce usuario"
$sqlu
echo "introduce IP del host o pulsa ENTER si es localhost"
$sqlh
firefox -new-tab https://www.thegeekstuff.com/2010/01/awk-introduction-tutorial-7-awk-print-examples/ && mysql -u $sqlu -p -h $sqlh
}

debugg(){
read -p "insert the name of the file \n" file
sed -i '1i-set' $file
sed -b "\$a-set" $file
}

music(){
read -p "(1) Musicovery (2) Soundcloud (3) EveryNoise (4) Freemp3 (5) Spotify (6) Discogs " music $music
if [ $music = "1" ]; then
  firefox -new-tab https://musicovery.com
elif [ $music = "2" ]; then
  firefox -new-tab https://soundcloud.com/realdoesntmeanroyal
elif [ $music = "3" ]; then
  firefox -new-tab https://everynoise.com
elif [ $music = "4" ]; then
  firefox -new-tab https://my-free-mp3.com
elif [ $music = "5" ]; then
  firefox -new-tab https://play.spotify.com/
elif [ $music = "6" ]; then
  firefox -new-tab https://www.discogs.com/
else
  echo "¡ music & naranjas !"
fi
}


##Monitoring
appmon(){
read -p "introduce el nombre del proceso" app
sudo lsof -i -n -P | grep $app
sudo ps ax | grep $app 
sudo initctl list 
sudo systemctl status 
}
alias usermon="uptime; sudo users; sudo w; sudo who -a; sudo ipcs -m -c"
alias sys="lsb_release -a; uname -a; watch -n 2 free -m; sudo initctl list; systemctl status; cat /proc/uptime; sudo df -h;  sudo dmesg | less; ipcs -u; sudo ipcs -m -c; sudo service --status-all; sudo htop; sudo w -i; sudo lshw; sudo dmidecode; sudo ps -efH | more; sudo lsof | wc -l; sudo lsof; ps aux | sort -nk +4 | tail"
alias netmon="sudo vnstat; sudo netstat -ie; sudo netstat -s; sudo sudo netstat -pt; sudo tcpstat -i wlan0 -l -a; sudo iptables -S; sudo w -i; sudo ipcs -u; sudo tcpdump -i wlan0; sudo iotop; sudo ps; sudo netstat -r; echo 'En router ir a Básica -> Estado -> Listado de equipos'"
alias portmon="sudo nc -l -6 -4 -u; sudo ss -o state established; sudo ss -l; sudo netstat -avnp -e"
alias vpnmon="firefox -new-tab dimage.kali.org && firefox -new-tab https://www.dnsleaktest.com/results.html"
alias webmon="firefox -new-tab https://who.is/ && firefox -new-tab https://searchdns.netcraft.com/ && firefox -new-tab https://www.shodan.io/ && firefox -new-tab web.archive.org && firefox -new-tab https://validator.w3.org/ && firefox -new-tab https://geekflare.com/online-scan-website-security-vulnerabilities/"
#Aliases
alias voip="firefox -new-tab https://www.appear.in"
alias anotherskype="skype --dbpath=~/.Skype2 &"
alias Trash="cd .local/share/Trash/files"
alias whoneedssudo="sudo find . -xdev -user root -perm -u+w && echo 'maybe you wanted to add -type and -exec to specify f or d or to execute a command such as chmod, lss or cpc. You can also use -name or -size to specify the name or +100 mb; or -mmin -60 and -atime -1 for modified last hour or accessed last day. You can also use -cmin -60 for files changed last hour or -newer FILE for those modified after FILE or -anewer/-cnewer FILE if accessed/changed'"
alias calc="let calc"
alias skill="sudo kill -9"
alias wline="sudo grep -n"
alias nmapp="sudo nmap -v -A --reason -O -sV -PO -sU -sX -f -PN --spoof-mac 0"
alias nmap100="sudo nmap -F -v -A --reason -O -sV -PO -sU -sX -f -PN --spoof-mac 0"
alias lss="ls -ld && sudo du -sh && ls -i1 -latr -lSr -FGAhp --color=auto -t -a -al"  # lSr sort by size ltr sort by date
alias lk='ls -lSr --color=auto -FGAhp'        # lSr sort by size ltr sort by date
alias lsall='ls -ld && sudo du -sh && ls -i1 -latr -lSr -FGAhp --color=auto -t -a -al -lR'        # recursive ls
alias verifykey="gpg --keyid-format long --import"
alias verifyfile="gpg --keyid-format long --verify"
alias secfirefox="firejail --dns=8.8.8.8 --dns=8.8.4.4 firefox"
alias lssh="ls -al ~/.ssh"
alias dt='date "+%F %T"'
alias pdf2txt='ls * | sudo xargs -n1 pdftotext'
alias bashrc='/etc/bash.bashrc'
alias geditbash='sudo gedit /etc/bash.bashrc'
alias vimbash='sudo vim /etc/bash.bashrc'
alias atombash='sudo atom /etc/bash.bashrc'
alias nanobash='sudo nano /etc/bash.bashrc'
alias find='sudo find / | grep'
alias myip="dig +short http://myip.opendns.com @http://resolver1.opendns.com"
alias cpc='cp -i -r'
alias mvm='mv -i -u'
alias rmr='sudo rm -irv -rf'
alias delete=rmr
alias remove=rmr
alias keepasss="sudo mono /home/$USER/KeePass/KeePass.exe"
alias keepass="mono /home/$USER/KeePass/KeePass.exe"
alias df='df -h'
alias ytb='youtube-dl --prefer-ffmpeg --ignore-errors'
alias aptup='sudo apt-get update && sudo apt-get upgrade && sudo apt-get clean'
alias mkdirr='mkdir -p -v'
alias downweb='wget --mirror -p --convert-links -P .'
alias lvim="vim -c \"normal '0\"" # open vim editor with last edited file
alias grepp='grep --color=auto -r -H'
alias egrepp='egrep --color=auto -r -w'
alias fgrepp='fgrep --color=auto'
alias aptclean='sudo apt-get autoremove'
alias rename='mv'
alias tmuxkillall="tmux ls | grep : | cut -d. -f1 | awk '{print substr($1, 0, length($1)-1)}' | xargs kill"
alias gitlist='git remote -v'
alias adbconnect="mtpfs -o allow_other /mnt/mobile"
alias adbdisconnect="fusermount -u /mnt/mobile"
alias newgpg="sudo gpg --gen-key"
alias androidsdk="sh ~/android-studio**/bin/studio.sh"
alias decompileapk="java -jar ~/android-studio**/bin/apktool.jar $1"
alias signapk="java -jar ~/android-studio**/bin/sign.jar $2"

### Some cheatsheets###
alias androidsheet="firefox -new-tab https://developer.android.com/design/index.html && firefox -new-tab https://developer.android.com/studio/intro/keyboard-shortcuts.html"
alias adbsheet="firefox -new-tab http://www.movilzona.es/tutoriales/android/root/principales-comandos-para-adb-y-fastboot-guia-basica/"
alias emacssheet="firefox -new-tab https://www.emacswiki.org/ && firefox -new-tab http://www.ling.ohio-state.edu/~kyoon/tts/unix-help/LaTeX/emacs-cheatsheet-2-of-2.jpg && firefox -new-tab http://www.muylinux.com/wp-content/uploads/2010/11/Emacs-Cheatsheet-wallpaper.jpg && firefox -new-tab https://github.com/emacs-tw/awesome-emacs#markdown && firefox -new-tab http://es.tldp.org/Tutoriales/doc-tutorial-emacs/intro_emacs.pdf"
alias electrumsheet="firefox -new-tab https://docs.electrum.org/en/latest/"
alias shsheet="firefox -new-tab https://www.tldp.org/LDP/abs/html/index.html" 
alias gethsheet="https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options"
alias gpgsheet="firefox -new-tab http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/gpg-cs.html"
alias bitcoinsheet="firefox -new-tab  https://en.bitcoin.it/wiki/Script#Words"
alias rubysheet="firefox -new-tab -url https://cheat.errtheblog.com/s/rvm -new-tab -url https://rvm.io/ -new-tab -url http://bundler.io/"
alias tmuxsheet="echo 'There are sessions, windows, panels \
tmux new -s myname | tmux ls | tmux a -t myname | tmux kill-session -t myname | Ctrl+Shift++ Zoom in | Ctrl+- Zoom out\
ctrl+b & c create window | ctrl+b & w list windows | ctrl+b & n  next window | ctrl+b & p  previous window | ctrl+b & f  find window | ctrl+b & ,  name window | ctrl+b & d detach window | ctrl+b & & kill window \
ctrl+b & :set synchronize-panes on/off a/synchronize all panels of the window | ctrl+b & % vertical split | ctrl+b & "  horizontal split | ctrl+b & q  show panel numbers | ctrl+b & x  kill pane | ctrl+b & spacebar change layout | ctrl+b & {} Move the current pane leftright | ctrl+b & z Zoom in zoom out panel | ctrl+b + :resize-pane -U/D/L/R 20 add 20 cells up/down/left/right to that panel"
alias dockersheet="echo '#Crea el droplet en DO con Docker \
create Droplet on DO con docker \
#Conecta al Droplet \
ssh root@IP  \
#Crea la imagen de docker \
Docker build -t imagenameapp:versionapp dockerfile  \
ADD	Copy downloads or data into the image (use cURL/wget with https and cheksum instead) :: COPY	Copy data into the image \
CMD Define default command to run (usually the service CMD [“lynis”, “-c”, “-Q”]) :: RUN	Execute a command or script \
ENV	Define an environment variable (ENV PATH /usr/local/yourpackage/bin:$PATH):: EXPOSE	Makes a port available for incoming traffic to the container :: MAINTAINER	Maintainer of the image \
FROM	Define the base image, which contains a minimal operating system :: VOLUME	Make directory available (e.g. for access, backup) :: WORKDIR	Change the current work directory\
#See docker images 
\
docker images    \
#Haz correr la app \
docker run  -it --name myappcontainer -d -p 1337:80  \
#Visita tu webapp \
go to IP:1337 and there it is \
#Audit
Audit using 'lynis audit dockerfile $filename'\
    SELinux/AppApparmor support – limit processes what resources they can access \
    Capabilities support – limit the maximum level a functions (or “roles”) a process can achieve within the container\
    Seccomp support – allow/disallow what system calls can be used by processes\
    docker exec – no more SSH in containers for just management\
' && 'firefox -new-tab  https://www.cheatography.com/storage/thumb/aabs_docker-and-friends.600.jpg && firefox -new-tab https://container-solutions.com/content/uploads/2015/06/15.06.15_DockerCheatSheet_A2.pdf"
alias nmapsheet="firefox -new-tab  https://4.bp.blogspot.com/-lCguW2iNKi4/UgmjCu1UNfI/AAAAAAAABuI/35Px0VIOuIg/s1600/Screen+Shot+2556-08-13+at+10.06.38+AM.png"
alias gitsheet="firefox -new-tab  https://developer.exoplatform.org/docs/scm/git/cheatsheet/ && firefox -new-tab https://github.com/tiimgreen/github-cheat-sheet && echo 'Warning: Never git add, commit, or push sensitive information to a remote repository. Sensitive information can include, but is not limited to:
    Passwords
    SSH keys
    AWS access keys
    API keys
    Credit card numbers
    PIN numbers'"
alias ubuntusheet="firefox -new-tab  https://slashbox.org/index.php/Ubuntu#Cheat_Sheet && firefox -new-tab https://slashbox.org/index.php/Ubuntu#Cheat_Sheet" 
alias vimsheet="firefox -new-tab  http://michael.peopleofhonoronly.com/vim/vim_cheat_sheet_for_programmers_screen.png && firefox -new-tab https://cdn.shopify.com/s/files/1/0165/4168/files/digital-preview-letter.png && firefox -new-tab https://michael.peopleofhonoronly.com/vim/vim_cheat_sheet_for_programmers_screen.png && firefox -new-tab https://cdn.shopify.com/s/files/1/0165/4168/files/digital-preview-letter.png"
alias wgetsheet="firefox -new-tab https://www.thegeekstuff.com/2009/09/the-ultimate-wget-download-guide-with-15-awesome-examples/"
alias soliditysheet="firefox -new-tab https://solidity.readthedocs.io/en/latest/units-and-global-variables.html"
### Functions ###

freethis(){
  sudo chmod 777 $1 $2
}

install(){
  sudo apt-get install -y $1
}

uninstall(){
  sudo apt-get remove --purge -y $1
}

mysshkey(){
sudo chmod -R 755 ~/.ssh
sudo chmod +x ~/.ssh 
sudo apt-get install xclip
sudo xclip -sel clip ~/.ssh/id_rsa.pub
echo 'those are your keys up to now, id_rsa.pub is the default.'
sudo ls -al -R ~/.ssh/
echo "Now you may have your ssh key on your clipboard. If you have already set your app global configuration, now you should go to Settings -> New SSH key and paste it there"
sudo chmod -R 600 ~/.ssh
}

mylastsshkey(){
sudo chown -R $USER:$USER ~/.ssh
sudo chmod -R 755 ~/.ssh
sudo apt-get install xclip
sudo chmod +x ~/.ssh  
read -p "Introduce the ssh last key number (0 is the first)" numerossh 
xclip -sel clip < ~/.ssh/lastid_rsa$numerossh.pub
echo 'this is your last key, lastid_rsa'$numerossh'.pub is the default.'
ls -al -R ~/.ssh
echo "Now you may have your last ssh key on your clipboard. If you have already set your app global configuration, now you should go to Settings -> New SSH key and paste it there"
sudo chmod -R 600 ~/.ssh
}


newsshkey(){
sudo chown -R $USER:$USER ~/.ssh
sudo chmod -R 755 ~/.ssh
sudo chmod +x ~/.ssh 
numberssh = 0
if [$1]
    then
    while [ ! -f lastid_rsa$numberssh ] ;
        do
             numberssh++
        done
    while [ ! -f lastid_rsa$numberssh ] ;
        do
             numberssh1 = $numberssh+1
             sudo mv ~/.ssh/$1 ~/.ssh/lastid_rsa$numberssh ~/.ssh/lastid_rsa$numberssh1
             sudo mv ~/.ssh/$1 ~/.ssh/lastid_rsa$numberssh.pub ~/.ssh/lastid_rsa$numberssh1.pub
             numberssh--
        done 
    echo "-------------> Your last key is now lastid_rsa (priv) and lastid_rsa0.pub (pub). If you want to create a new one type mysshkey. If you want to copy the last one type mylastsshkey"
    sudo mv ~/.ssh/$1 ~/.ssh/id_rsa ~/.ssh/lastid_rsa0
    sudo mv ~/.ssh/$1 ~/.ssh/id_rsa.pub ~/.ssh/lastid_rsa0.pub
    else
    echo "-------------> Those are your current keys: "
    ls -al -R ~/.ssh
fi
$emai = emai
sudo mkdir ~/.ssh
echo "-------------> Those are your keys up to now"
sudo ls -al -R ~/.ssh # Lists the files in your .ssh directory, if they exist
echo "Please, introduce 'youremail@server.com'"
read emai
echo "------------->Introduce this /home/$USER/.ssh/id_rsa as file, OTHERWISE YOU WONT BE ABLE TO USE MYSSHKEY AND THE REST OF SSH MANAGEMENT COMMANDS, and a password longer or equal to 5 caractheres"
ssh-keygen -t rsa -b 4096 -C $emai
eval "$(ssh-agent -s)" 
sudo ssh-add ~/.ssh/id_rsa**
sudo chmod -R 600 ~/.ssh
}

# mkmv - creates a new directory and moves the file into it, in 1 step
# Usage: mkmv <file> <directory>
mkmv() {
  mkdir "$2"
  mv "$1" "$2"
}

### Bash Completion ###
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

commit() {
  git add $1 && git commit -m $2 && git push origin $3
}

#la is the new cd + ls
alias la='ls -lah $LS_COLOR'
function cl(){ cd "$@" && la; }
alias back="cd .."
function cdn(){ for i in `seq $1`; do cd ..; done;}


### Extract Archives ###
extract () {
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
      *.zip)       unzip2dir $1     ;;
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
else
    sudo rm -r /mnt/$sdjoh
    echo "Borrando celda..."
fi
}


monta(){ 
sudo fdisk -l 
read -p "Introduce el disco a montar (sda5, sdb1...): " sdjah
sudo mkdir -p /mnt/$sdjah
echo "Cell /mnt/$sdjah created"
sudo mount /dev/$sdjah /mnt/$sdjah

##OPEN IT
read -p 'Your disk '$sdjah' was mounted on /mnt/'$sdjah'. Do you want to open it with sudo or without? 1=Sudo 2=Notsudo 3=Goterminal; Q=Do nothing: ' opt
    case $opt in
        "1")
            echo "You were sudo"; sudo pantheon-files /mnt/$sdjah || sudo nemo /mnt/$sdjah || sudo /mnt/nautilus $sdjah; break;;
        "2")
            echo "You were not sudo"; pantheon-files /mnt/$sdjah || nemo /mnt/$sdjah || /mnt/nautilus $sdjah; break;;
        "3")
            cd /mnt/$sdjah && ls;;
        "Q")
            break;;
        *) echo invalid option;;
    esac
}


#buf - Back Up a file. Usage "bu filename.txt"
bu () {
  cp $1 ${1}-`date +%Y%m%d%H%M`.backup;
}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting



# use DNS to query wikipedia (wiki QUERY)
wiki () { dig +short txt $1.wp.dg.cx; }

# mount an ISO file. (mountiso FILE)
mountiso () {
  name=`basename "$1" .iso`
  mkdir "/tmp/$name" 2>/dev/null
  sudo mount -o loop "$1" "/tmp/$name"
  echo "mounted iso on /tmp/$name"
}

#rename multiple files
rname () {
echo introduce from .extension
read iext
echo introduce to .extension
read text
for file in *$iext; do
    sudo mv "$file" "`basename $file $iext`$text"
done
}


# search inside pdf
searchpdf () {
  echo "introduce text to search"
  read text
  echo "introduce pdf filename"
  read pdf
  pdftotext $pdf - | grep '$text'
}

#wine in and out
  weneedwine () {
  read -p "file to wine" filewine
  wget http://dl.winehq.org/wine/source/1.8/wine-1.8.2.tar.bz2
  tar -jxvf wine**.bz2
  cd wine**
  sudo apt-get build-dep wine1.6
  ./configure --enable-win64
  make
  sudo make install
  sudo wine64 cmd $filewine
  sudo make uninstall
  sudo apt-get purge bison comerr-dev docbook docbook-dsssl docbook-to-man docbook-utils docbook-xsl execstack flex fontforge fontforge-common gir1.2-gst-plugins-base-0.10 gir1.2-gstreamer-0.10 jadetex krb5-multidev libasound2-dev libavahi-client-dev libavahi-common-dev libbison-dev libcapi20-3 libcapi20-dev libcups2-dev libdrm-amdgpu1 libdrm-dev libfl-dev libfontforge1 libgdraw4 libgl1-mesa-dev libglu1-mesa-dev libgphoto2-dev libgsm1-dev libgssrpc4 libgstreamer-plugins-base0.10-dev libgstreamer0.10-dev libieee1284-3-dev libkadm5clnt-mit9 libkadm5srv-mit9 libkdb5-7 libkrb5-dev libldap2-dev libmpg123-dev libodbc1 libopenal-dev libosmesa6 libosmesa6-dev libosp5 libostyle1c2 libptexenc1 libpulse-dev libsane-dev libsgmls-perl libsp1c2 libspiro0 libuninameslist0 libusb-1.0-0-dev libv4l-dev libv4l2rds0 libx11-xcb-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-glx0-dev libxcb-present-dev libxcb-randr0 libxcb-randr0-dev libxcb-shape0-dev libxcb-sync-dev libxcb-xfixes0-dev libxshmfence-dev libxslt1-dev libxxf86vm-dev luatex lynx lynx-cur m4 mesa-common-dev ocl-icd-libopencl1 odbcinst odbcinst1debian2 opencl-headers openjade oss4-dev prelink sgml-data sgmlspl sp tex-common texlive-base texlive-binaries texlive-fonts-recommended texlive-generic-recommended texlive-latex-base texlive-latex-recommended tipa unixodbc unixodbc-dev valgrind x11proto-dri2-dev x11proto-gl-dev x11proto-xf86vidmode-dev
}

changemymac(){
ifconfig -a | grep HWaddr
read -p "Those are your macs. Choose the ethernet interface (eth, wlan...) you want to change. It will be sustitued by a random MAC, so write before in case it could have been mac filtering whitelisted : " wlan
macaddr=$(echo $FQDN|md5sum|sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/02:\1:\2:\3:\4:\5/')
sudo ifconfig $wlan down
sudo ifconfig $wlan hw ether $macaddr
sudo ifconfig $wlan up
read -p "Those are your new macs:"
ifconfig -a | grep HWaddr
read -p "Enjoy!"
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
            break
            ;;
        *) echo invalid option;;
    esac
done

}

killmycam () {
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
  break 
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
read -p "¿Dónde guardo esta nota? (Por ejemplo, /home/$USER): " testroute
read -p "¿Nombre de la nota? (Por ejemplo, nota.txt): " nameoftest
sudo sh -c "echo $textito >> $testroute/$nameoftest"
sudo ls $testroute | grep $nameoftest
sudo cat $testroute/$nameoftest
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


#alias Ethereum
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
alias ethstats="sudo pm2 start /home/$USER/eth-net-intelligence-api/app.json && firefox --new-tab https://ethstats.net/ && parity --max-peers 100 --peers 100 --min-peers 100"
alias meteor="firefox -new-tab -url http://localhost:3000 && cd /home/$USER/linux && ./geth --rpc --rpccorsdomain='http://localhost:3000'"
