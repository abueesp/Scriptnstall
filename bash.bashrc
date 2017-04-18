# System-wide .bashrc file for interactive bash(1) shells.
# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

##Normal Ctrl+C Ctrl+V
gconftool-2 -t str -s /apps/gnome-terminal/keybindings/copy "<Control>c"
gconftool-2 -t str -s /apps/gnome-terminal/keybindings/paste "<Control>v"

##EDITOR
EDITOR=vi
FCEDIT=vi

##History
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL=ignoredups
export HISTCONTROL=ignorespace
alias rmhist="history -c"
alias anonhist="export HISTSIZE=0"
alias hist="export HISTSIZE=1"
alias shis="history | grep"
alias whatis="apropos"

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
if [[ ! $level_color ]]; then# System-wide .bashrc file for interactive bash(1) shells.
# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

##Normal Ctrl+C Ctrl+V
gconftool-2 -t str -s /apps/gnome-terminal/keybindings/copy "<Control>c"
gconftool-2 -t str -s /apps/gnome-terminal/keybindings/paste "<Control>v"

##EDITOR
EDITOR=vi
FCEDIT=vi

##History
export HISTTIMEFORMAT='%F %T '
export HISTCONTROL=ignoredups
export HISTCONTROL=ignorespace
alias rmhist="history -c"
alias anonhist="export HISTSIZE=0"
alias hist="export HISTSIZE=1"
alias shis="history | grep"
alias whatis="apropos"

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
${lightgrey} - help|usage: print this screen
${pink} - lynx web browser
${lightred} - verbose: sets -xv flags
${lightgreen} - noexec: sets -xvn flags
${lightcyan} - no parameter sets -x flags | C-x ! | C-x $ | M-x / | M-x @ | C-x C-e | fc -lnr | !!
${lightblue} - nanobash|geditbash
${blue} - alias powered
${purple} - tmuxts full

${script_color} coding for good - node command line $nc 
${command_color} Ƀe ℋuman, be κinđ, be ωise $nc

EOF
tty
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
gpg2 --export -a $USN > public.key
gpg2 --export-secret-key -a $USN > private.key
gpg2 --fingerprint -a $USN > fingerprint
echo "Here you are your public.key, private.key and fingerprint" 
echo "Fingerprint"
cat fingerprint
echo "Public key"
cat public.key
echo "To see you private key, write cat private.key"
}

gpgimport() {
read -p "Go to the folder. Rename as public.key and private.key; as well as introduce the key username: " USN
gpg2 --import -a $USN > $public.key
gpg2 --import-secret-key -a $USN > private.key
echo "your public key and private have been imported as public.key and private.key" 
}

gpgdelete() {
read -p "introduce the key username to delete Usernameprivate.key and/or Usernamepublic.key: " USN
gpg2 --delete -a $USN
gpg2 --delete-secret-key -a $USN
echo "your public key and private have been deleted as public.key and private.key" 
}

gpglist() {
echo "pubkeys list"
gpg2 --list-keys
echo "privkeys list"
gpg2 --list-secret-keys
echo "fingerprints"
gpg2 --fingerprint
}

gpgnew() {
gpg2 --gen-key 
}

gpg2new() {
gpg2 --full-gen-key
}

gpgeditkey() {
read -p "Introduce key: " keyy
gpg2 --edit-key 0x$keyy
}

gpgencrypt() {
read -p "Rename the key as key.txt and the message as message.txt. Then put both on this folder. Then, push ENTER and you will see your encrypted message as ciphertext.txt." Done
#read -p "enter your gpg username (sender username): " USNs
#read -p "enter your gpg username (receiver username): " USNr
#read -p "enter the route of the file" filegpge
#gpg -e -u $USNs -r $USNr $filegpge
gpg2 --batch --yes --passphrase-file "key.txt" -z 0 --cipher-algo AES256 --armor --output "ciphertext.txt" --symmetric "message.txt"
}

gpgdecrypt() {
read -p "Rename the key as key.txt and the ciphertext as ciphertext.txt. Then put both on this folder. Then, push ENTER and you will see your decrypted message as message.txt." Done
#read -p "enter file.gpg to decrypt: " filegpgd
#gpg -o $filegpg[-4] -d $filegpgd
gpg2 --batch --yes --passphrase-file "key.txt" --output "message.txt" --decrypt "cp.txt"
}


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
 break
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


securedelete() {
  read -p "DANGER VAS A BORRAR DE FORMA SEGURA TODO. INTRODUCE LA RUTA DE LA CARPETA O EL ARCHIVO SIN EQUIVOCARTE      -->" route
  rin="$route""/**"
  sudo shred -uvzn 3 $route
  sudo shred -uvzn 3 $rin
  sudo srm -vrzd $route
  }
  
tmuxts() {
tmux new-session -s 'MyTS' -n 'w1' -d 'vim'
tmux split-window -v -t 'w1' -d 'python'
tmux split-window -h -t 'w1' -c '/home/$USER'
tmux new-window -n 'w2' -t 'MyTS' 'lynx https://encrypted.google.com' 
tmux send-keys 'n n n n n n n' C-m
tmux split-window -h -t 'w2'
tmux send-keys 'tmux list-sessions && tmux list-windows && tmux list-panes && stop'  C-m
tmux split-window -v -t 'w2' -c '/home/$USER/devcon/'
tmux -2 attach-session -t 'MyTS'
tmux select-pane -t 'w2:1'
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
sudo wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/bash.bashrc
sudo rm /etc/bash.bashrc~
sudo cp /etc/bash.bashrc /etc/bash.bashrc~
sudo rm /etc/bash.bashrc
sudo mv bash.bashrc /etc/bash.bashrc
}

updatebash() {
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/bash.bashrc -O ~/.bashrc
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
read -p "introduce usuario" sqlu
read -p "introduce IP del host o pulsa ENTER si es localhost" sqlh
firefox -new-tab https://www.thegeekstuff.com/2010/01/awk-introduction-tutorial-7-awk-print-examples/; mysql -u $sqlu -p -h $sqlh
}

debugg(){
read -p "insert the name of the file: " file
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
}
alias usermon="loginctl; sudo loginctl; uptime; sudo id; sudo users; sudo groups; sudo w; sudo who -a; sudo ipcs -m -c; pwd; sudo finger; sudo finger -lmps; sudo chfn; sudo last; read -p 'Do you want to see the processes of a user? Introduce username:' -p $regus; ps -LF -u $regus; echo 'Pure honey. Now all your bases belong to us' | pv -qL 20 > wall"
alias sysmon="sudo dmidecode; lsb_release -a; uname -a; id; sudo id; sudo lshw; lscpu; watch -n 2 free -m; logname; hostname; ipcs -m -c; sudo logname; sudo ipcs; sudo initctl list; systemctl status; cat /proc/uptime; sudo df -h;  sudo dmesg | less; ipcs -u; sudo service --status-all; sudo htop; sudo w -i; sudo dmidecode; sudo ps -efH | more; sudo lsof | wc -l; sudo lsof; ps aux | sort -nk +4 | tail; sudo pstree; sudo ss; sudo dpkg -l; sudo dstat -a -f"
alias netmon="rfkill list; nmcli general; nmcli device; nmcli connection; curl ipinfo.io; sudo netstat -tulpn; sudo vnstat; sudo netstat -ie | more -s  -l -d -f; sudo netstat -s | more -s  -l -d -f; sudo sudo netstat -pt | more -s  -l -d -f; sudo tcpstat -i wlan0 -l -a; sudo iptables -S; sudo w -i; sudo ipcs -u; sudo tcpdump -i wlan0; sudo iotop; sudo ps; sudo netstat -r; echo 'En router ir a Básica -> Estado -> Listado de equipos; nmtui'"
alias portmon="sudo nc -l -6 -4 -u; sudo ss -o state established; sudo ss -l; sudo netstat -avnp -e"
alias vpnmon="firefox -new-tab dimage.kali.org && firefox -new-tab https://www.dnsleaktest.com/results.html"
alias webmon="firefox -new-tab https://who.is/ && firefox -new-tab https://searchdns.netcraft.com/ && firefox -new-tab https://www.shodan.io/ && firefox -new-tab web.archive.org && firefox -new-tab https://validator.w3.org/ && firefox -new-tab https://geekflare.com/online-scan-website-security-vulnerabilities/"
alias hardwaremon="sudo lshw; cat /proc/cpuinfo"
alias debug="sudo apt-get install apport-retrace apython-problem-report python-apport -y; apropos apport; apropos apport-retrace; read -p 'Write process name: ' PROCESSCRASH; sudo find /var | grep $PROCESSCRASH; ls /var/crash; read -p 'Copy the route of your log crash file: ' ROUTECRASH; sudo mkdir /var/dump$PROCESSNAME; apport-unpack $ROUTECRASH /var/dump$PROCESSNAME; apport-retrace $ROUTECRASH; cat /var/dump$PROCESSNAME; sudo apt-get purge apport-retrace python-problem-report python-apport"
alias ccleaner="sudo apt-get install bleachbit -y; bleachbit -list; read -p 'Write the name of what you want to clean (f.i. firefox -e chromium.history -e password...)' CLEANN; bleachbit --list | grep -E "[a-z]+\.[a-z]+" | grep -e CLEANN | xargs sudo bleachbit --clean; sudo apt-get purge bleachbit -y"
alias cleanall="echo 'Cleaning temp, presets, browsers data, memory, cache and so forth'; sudo sh -c $(which echo) 3 > sudo /proc/sys/vm/drop_caches; sudo apt-get install bleachbit -y; bleachbit --list | grep -E '[a-z]+\.[a-z]+' | xargs sudo bleachbit --clean; sudo apt-get purge bleachbit -y"
alias clenexcept="sudo apt-get install bleachbit -y; bleachbit -list; read -p 'Write the name of what you DO NOT want to clean (f.i. firefox -e chromium.history -e password...)' UNCLEANN; bleachbit --list | grep -E "[a-z]+\.[a-z]+" | grep -v -e UNCLEANN | xargs sudo bleachbit --clean; sudo apt-get purge bleachbit -y"
alias cleanmem="echo 'Cleaning memory, cache and swap'; sudo sh -c $(which echo) 3 > sudo /proc/sys/vm/drop_caches; sudo free"

#General Aliases
alias flightmodeon="nmcli networking off"
alias flightmodeoff="nmcli networking on"
alias voip="firefox -new-tab https://www.appear.in"
alias anotherskype="skype --dbpath=~/.Skype2 &"
alias Trash="cd .local/share/Trash/files"
alias closesudo="read -p 'Write down the path/route/file to access: ' APP && sudo chown root:root $APP && sudo chmod 700 $APP"
alias opensudo="read -p 'Write down the path/route/file to open permissions: ' APP; sudo chmod ugo+rwx -R $APP && echo 'try also with sudo -i ' $APP" 
alias calc="let calc"
alias skill="sudo kill -9"
alias wline="sudo grep -n"
alias nmapp="sudo nmap -v -A --reason -O -sV -PO -sU -sX -f -PN --spoof-mac 0"
alias nmap100="sudo nmap -F -v -A --reason -O -sV -PO -sU -sX -f -PN --spoof-mac 0"
alias lss="ls -ld && sudo du -sh && ls -i1 -latr -lSr -FGAhp --color=auto -t -a -al"  # lSr sort by size ltr sort by date
alias dirr="dir -a --color=auto -g -s -S -t -Z"
alias lk='ls -lSr --color=auto -FGAhp'        # lSr sort by size ltr sort by date
alias lsall='ls -ld && sudo du -sh && ls -i1 -latr -lSr -FGAhp --color=auto -t -a -al -lR'        # recursive ls
alias verifykey="gpg --keyid-format long --import"
alias verifyfile="gpg --keyid-format long --verify"
alias secfirefox="firejail --dns=8.8.8.8 --dns=8.8.4.4 firefox"
alias lssh="ls -al ~/.ssh"
alias dt='date "+%F %T"'
alias pdf2txt='ls * | sudo xargs -n1 pdftotext'
alias bashrc='~./bashrc'
alias geditbash='sudo gedit ~/.bashrc'
alias vimbash='sudo vim ~./bashrc'
alias atombash='sudo atom ~/.bashrc'
alias nanobash='sudo nano ~/.bashrc'
alias busca='sudo find / -iname'
alias wtfhappened='sudo find / -cmin 1'
alias whatchanged='sudo find / -mtime'
alias myip="wget http://ipinfo.io/ip -qO -"
alias theirip="dig"
alias cpc='cp -i -r'
alias mvm='mv -i -u'
alias rmr='sudo rm -irv -rf'
alias delete="rmr"
alias remove="rmr"
alias event="evtest"
alias fid="wget 'http://randomprofile.com/api/api.php?&countries=CHN,JPN,KOR,GBR&fromAge=20&toAge=60&format=xml&fullChildren=1' -O seres.xml; rig >> fids; echo '------------------------' >> fids; date '+%H:%M:%S   %d/%m/%y' >> fids; cat seres.xml >> fidxmls; echo '------------------------' >> fidxmls; echo '------------------------' >> fidxmls; echo '------------------------' >> fidxmls; date '+%H:%M:%S   %d/%m/%y' >> fidxmls"
alias now="date '+%H:%M:%S   %d/%m/%y'"
alias keepasss="sudo mono /home/$USER/KeePass/KeePass.exe"
alias keepass="mono /home/$USER/KeePass/KeePass.exe"
alias df='df -h'
alias ytb='youtube-dl --prefer-ffmpeg --ignore-errors'
alias ytmp3='youtube-dl --audio-format mp3 --audio-quality 0 --extract-audio  --prefer-ffmpeg --ignore-errors'
alias aptup='sudo apt-get update && sudo apt-get upgrade && sudo apt-get clean'
alias mkdirr='mkdir -p -v'
alias downweb='wget --mirror -p --convert-links -P .'
alias lvim="vim -c \"normal '0\'" # open vim editor with last edited file
alias grepp='grep --color=auto -r -H'
alias egrepp='egrep --color=auto -r -w'
alias fgrepp='fgrep --color=auto'
alias aptclean='sudo apt-get autoremove'
alias aptinstall='sudo apt-get install'
alias aptlog='less /var/log/apt/history.log'
alias aptinstalled='apt list | grep installed'
alias BCE='curl http://api.fixer.io/latest?base=EUR'
alias rename='mv'
alias tmuxkillall="tmux ls | grep : | cut -d. -f1 | awk '{print substr($1, 0, length($1)-1)}' | xargs kill"
alias gitlist='git remote -v'
alias diferencia='echo "Puedes usar tambien vi -d o kompare"; colordiff -ystFpr'
alias compara='diff -y -r'
alias adbconnect="mtpfs -o allow_other /mnt/mobile"
alias adbdisconnect="fusermount -u /mnt/mobile"
alias newgpg="sudo gpg --gen-key"
alias androidsdk="sh ~/android-studio**/bin/studio.sh"
alias decompileapk="java -jar ~/android-studio**/bin/apktool.jar $1"
alias signapk="java -jar ~/android-studio**/bin/sign.jar $2"
alias shist="history | grep"
alias vectorize="xargs"
alias cuenta="wc"
alias countlines="awk '/a/{++cnt} END {print \"Count = \", cnt}'"
alias iron="/bin/iron/./chrome"
#check alias chrome --> iron
alias ffx='/home/$USER/icecat/./icecat'
alias rctty='script -t 2>rctty.timing rctty'
alias mtty='more rctty'
alias rptty='replayscript rctty.timing rctty'
alias rpttyfast='replayscript -d 3 rctty.timing rctty'
alias logg='tailf'
alias createtags='!ctags -R && echo "Remember: Ctrl+] go to tag; g+Ctrl+] ambiguous tags and enter number; Ctrl+t last tag; Ctrl+X+Ctrl+] Autocomplete with tags"'

imprime (){
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

selectline() {
read -p "Write first line: " fline
read -p "Write last line: " lline
read -p "Introduce the file with lines: " lined
cat $lined | sed -n '$fline,$llinep'
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
read -p "Introduce name of the file" thisis
read -p "Introduce name of the new fixed copy" thatone
cat $thisis | tr "\n" " " >> $thatone
cat $thatone
}

### Some cheatsheets ###
alias subst='echo "vi filename.txt -c \":Ubuntu%s/\<tmux\>/Linux/gIc \" -c \":wq \" meaning (:code) (tres after the first apparition of Ubuntu) (% make changes in all lines, use {START-n},{END-n} instead) (s/ search) (\<\> exact word) (UNIX/ old word) (Linux/ new word) (g global – each occurrence in the line is changed, rather than just the first) (I case sensitive) (c confirm signal)"'
alias androidsheet="firefox -new-tab https://developer.android.com/design/index.html && firefox -new-tab https://developer.android.com/studio/intro/keyboard-shortcuts.html"
alias adbsheet="firefox -new-tab http://www.movilzona.es/tutoriales/android/root/principales-comandos-para-adb-y-fastboot-guia-basica/"
alias distrosheet="echo 'centos (redhat, scientific and enterprise), openbsd (more usability freebsd, security and multiplatform), archbang(arch, control by complex simplicity), coreos (chromium os, cloud), qubeos (Xen security), tor-ramdisk/tails (Debian/GNULinux, privacy), salixos (Slackware, neutrality), sabayon (gentoo, diversity)'"
alias emacssheet="firefox -new-tab https://spacemacs.org/doc/VIMUSERS.html && firefox -new-tab http://www.stephenwalker.com/notes/aquamacsemacs-key-binding-list/ && firefox -new-tab https://www.emacswiki.org/ && firefox -new-tab http://www.ling.ohio-state.edu/~kyoon/tts/unix-help/LaTeX/emacs-cheatsheet-2-of-2.jpg && firefox -new-tab http://www.muylinux.com/wp-content/uploads/2010/11/Emacs-Cheatsheet-wallpaper.jpg && firefox -new-tab https://github.com/emacs-tw/awesome-emacs && firefox -new-tab http://es.tldp.org/Tutoriales/doc-tutorial-emacs/intro_emacs.pdf"
alias electrumsheet="firefox -new-tab https://docs.electrum.org/en/latest/"
alias shsheet="firefox -new-tab https://www.tldp.org/LDP/abs/html/index.html -new-tab https://explainshell.com/" 
alias gethsheet="https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options"
alias gpgsheet="firefox -new-tab http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/gpg-cs.html"
alias bitcoinsheet="firefox -new-tab  https://en.bitcoin.it/wiki/Script#Words"
alias rubysheet="firefox -new-tab -url https://cheat.errtheblog.com/s/rvm -new-tab http://spacemacs.org/layers/+frameworks/ruby-on-rails/README.html -new-tab -url https://rvm.io/ -new-tab -url http://bundler.io/"
alias tmuxsheet="tmux list-keys; tmux list-commands; echo 'https://gist.github.com/MohamedAlaa/2961058 There are sessions, windows, panels \
tmux new -s myname | tmux ls | tmux a -t myname | tmux kill-session -t myname | Ctrl+Shift++ Zoom in | Ctrl+- Zoom out\
ctrl+b & c create window | ctrl+b & w list windows | ctrl+b & n  next window | ctrl+b & p  previous window | ctrl+b & f  find window | ctrl+b & ,  name window | ctrl+b & d detach window | ctrl+b & & kill window \
ctrl+b & :set synchronize-panes on/off a/synchronize all panels of the window | ctrl+b & % vertical split | ctrl+b & \"  horizontal split | ctrl+b & q  show panel numbers | ctrl+b & x  kill pane | ctrl+b & spacebar change layout | ctrl+b & {} Move the current pane leftright | ctrl+b & z Zoom in zoom out panel | ctrl+b + :resize-pane -U/D/L/R 20 add 20 cells up/down/left/right to that panel'"
alias ubuntusheet="firefox -new-tab  https://slashbox.org/index.php/Ubuntu#Cheat_Sheet && firefox -new-tab https://slashbox.org/index.php/Ubuntu#Cheat_Sheet" 
alias vimsheet="echo ':h vimtex, :help i_C^M, :help e_<Esc>, :help c_<Del>, move with [], createtags, nnoremap, addsnippet'; firefox -new-tab  http://michael.peopleofhonoronly.com/vim/vim_cheat_sheet_for_programmers_screen.png && firefox -new-tab https://cdn.shopify.com/s/files/1/0165/4168/files/digital-preview-letter.png && firefox -new-tab https://michael.peopleofhonoronly.com/vim/vim_cheat_sheet_for_programmers_screen.png && firefox -new-tab https://cdn.shopify.com/s/files/1/0165/4168/files/digital-preview-letter.png"
alias wgetsheet="firefox -new-tab https://www.thegeekstuff.com/2009/09/the-ultimate-wget-download-guide-with-15-awesome-examples/"
alias soliditysheet="firefox -new-tab https://solidity.readthedocs.io/en/latest/units-and-global-variables.html"
alias chsheet="echo 'chmod: Change the file modes/attributes/permissions | chown: Change the file ownership | chgrp: Change the file group ownership'"

#APT PIP YUM 
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

#Docker Aliasheet
#Aliasheet
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
function cdn(){ for i in 'seq $1'; do cd ..; done;}


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
}


monta(){ 
sudo lsblk
sudo blkid
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
            echo "You were sudo"; findmnt; sudo pantheon-files /mnt/$sdjah || sudo nemo /mnt/$sdjah || sudo /mnt/nautilus $sdjah; break;;
        "2")
            echo "You were not sudo"; findmnt; pantheon-files /mnt/$sdjah || nemo /mnt/$sdjah || /mnt/nautilus $sdjah; break;;
        "3")
            findmnt; cd /mnt/$sdjah && ls;;
        "Q")
            break;;
        *) echo invalid option;;
    esac
}



#buf - Back Up a file. Usage "buf filename.txt"
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
  weneedwine () {
  read -p "file to wine" filewine
  wget http://dl.winehq.org/wine/source/1.9/wine-1.9.0.tar.bz2
  wget http://dl.winehq.org/wine/source/1.9/wine-1.9.0.tar.bz2.sign
  gpg --verify **.sign **.bz2
  tar -jxvf wine**.bz2
  cd wine**
  sudo apt-get build-dep wine1.6
  ./configure --enable-win64
  make
  sudo make install
  sudo wine64 cmd $filewine
  sudo rm wine**.tar.bz2
  sudo rm wine**.tar.bz2.sign
  sudo make uninstall
  sudo apt-get purge bison comerr-dev docbook docbook-dsssl docbook-to-man docbook-utils docbook-xsl execstack flex fontforge fontforge-common gir1.2-gst-plugins-base-0.10 gir1.2-gstreamer-0.10 jadetex krb5-multidev libasound2-dev libavahi-client-dev libavahi-common-dev libbison-dev libcapi20-3 libcapi20-dev libcups2-dev libdrm-amdgpu1 libdrm-dev libfl-dev libfontforge1 libgdraw4 libgl1-mesa-dev libglu1-mesa-dev libgphoto2-dev libgsm1-dev libgssrpc4 libgstreamer-plugins-base0.10-dev libgstreamer0.10-dev libieee1284-3-dev libkadm5clnt-mit9 libkadm5srv-mit9 libkdb5-7 libkrb5-dev libldap2-dev libmpg123-dev libodbc1 libopenal-dev libosmesa6 libosmesa6-dev libosp5 libostyle1c2 libptexenc1 libpulse-dev libsane-dev libsgmls-perl libsp1c2 libspiro0 libuninameslist0 libusb-1.0-0-dev libv4l-dev libv4l2rds0 libx11-xcb-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-glx0-dev libxcb-present-dev libxcb-randr0 libxcb-randr0-dev libxcb-shape0-dev libxcb-sync-dev libxcb-xfixes0-dev libxshmfence-dev libxslt1-dev libxxf86vm-dev luatex lynx lynx-cur m4 mesa-common-dev ocl-icd-libopencl1 odbcinst odbcinst1debian2 opencl-headers openjade oss4-dev prelink sgml-data sgmlspl sp tex-common texlive-base texlive-binaries texlive-fonts-recommended texlive-generic-recommended texlive-latex-base texlive-latex-recommended tipa unixodbc unixodbc-dev valgrind x11proto-dri2-dev x11proto-gl-dev x11proto-xf86vidmode-dev
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
		then break
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
            break
            ;;
        *) echo invalid option;;
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
alias ethstats="sudo pm2 start /home/$USER/eth-net-intelligence-api/app.json && firefox -new-tab https://ethstats.net/ && parity --max-peers 100 --peers 100 --min-peers 100"
alias meteor="firefox -new-tab -url http://localhost:3000 && cd /home/$USER/linux && ./geth --rpc --rpccorsdomain='http://localhost:3000'"

#3 random numbers & uuid
alias rng='expr $RANDOM % 9223372036854775807 && od -N 4 -t uL -An /dev/random | tr -d " " && openssl rand 4 | od -DAn && uuidgen'

alias diskusage="df -h && sudo baobab"

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
read -p "Which one is you user gmail user?" $uzer
curl -u $uzer@gmail.com --silent "https://mail.google.com/mail/feed/atom" | perl -ne 'print "\t" if //; print "$2\n" if /<(title|name)>(.*)<\/\1>/;'
}

checkport() {
read -e -p "Port Range: Enter your starting port (80 by default): " -i "80" PORTZS
read -e -p "Port Range: Enter your last port (8080 by default): " -i "8080" PORTZF
read -e -p "Enter your IP (localhost by default): " -i "localhost" IPZ
for i in $(seq $PORTZS $PORTZF); do nc -zv $IPZ $i; done
read -p "Do you want to test which process is listening to that port (only for host system)? If so, write down the port: " PORTZC
lsof -iTCP:$PORTZC -sTCP:LISTEN
}

leeme() {
read -p "Hola amigo :) Introduce el nombre del archivo que quieres que te lea: " ezte
read -p "Introduce el idioma del texto (en-EN, fr-FR, pt-PT... por defecto es-ES)" -i "es-ES" lang
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
        *) echo opcion no reconocida;;
    esac
done
}


ssign(){
read -p "Message to sign (~/message by default): " -i ~/message -e messg
saltpack sign --message $messg | tee ~/signed_message
echo "The signed message was saved as signed_message"
}

sverify(){
read -p "Message to verify (~/signedmessage by default): " -i ~/signedmessage -e messg 
saltpack verify $messg
}

sencrypt(){
read -p "Message to encrypt (~/message by default): " -i ~/message -e messg
MESIG=$(cat $messg)
saltpack encrypt --message $MESIG | tee ~/encrypted_message
echo "The encrypted message was saved as ~/encrypted_message"
}

sdecrypt(){
read -p "Message to decrypt (~/encrypted_message by default): " -i ~/message -e messg
MESIG=$(cat $messg)
saltpack decrypt < MESIG
}

wgetall(){
read -p "Write the file formats to download (pdf,doc,docx,zip,rar,jpg...): " formatt
formattt=$formatt^^+","+$formatt # as accept is case sensitive
read -p "Write the website: " flinkkk
wget --accept $formattt --mirror --adjust-extension --convert-links --backup-converted --no-parent $flinkkk
}


##Linux container set
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

alias emacstex="\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}"

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


crtime() {
  a=()
  for target in "${@}"; do
    inode=$(ls -di "${target}" | cut -d ' ' -f 1)
    fs=$(df "${target}"  | tail -1 | awk '{print $1}')
    crtime=$(sudo debugfs -R 'stat <'"${inode}"'>' "${fs}" 2>/dev/null | 
    grep -oP 'crtime.*--\s*\K.*')
    printf "%s\t%s\n" "${crtime}" "${target}"
  done
}

delnew() {
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
${lightgrey} - help|usage: print this screen
${pink} - lynx web browser
${lightred} - verbose: sets -xv flags
${lightgreen} - noexec: sets -xvn flags
${lightcyan} - no parameter sets -x flags | C-x ! | C-x $ | M-x / | M-x @ | C-x C-e | fc -lnr | !!
${lightblue} - nanobash|geditbash
${blue} - alias powered
${purple} - tmuxts full

${script_color} coding for good - node command line $nc 
${command_color} Ƀe ℋuman, be κinđ, be ωise $nc

EOF
tty
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
gpg2 --export -a $USN > public.key
gpg2 --export-secret-key -a $USN > private.key
gpg2 --fingerprint -a $USN > fingerprint
echo "Here you are your public.key, private.key and fingerprint" 
echo "Fingerprint"
cat fingerprint
echo "Public key"
cat public.key
echo "To see you private key, write cat private.key"
}

gpgimport() {
read -p "Go to the folder. Rename as public.key and private.key; as well as introduce the key username: " USN
gpg2 --import -a $USN > $public.key
gpg2 --import-secret-key -a $USN > private.key
echo "your public key and private have been imported as public.key and private.key" 
}

gpgdelete() {
read -p "introduce the key username to delete Usernameprivate.key and/or Usernamepublic.key: " USN
gpg2 --delete -a $USN
gpg2 --delete-secret-key -a $USN
echo "your public key and private have been deleted as public.key and private.key" 
}

gpglist() {
echo "pubkeys list"
gpg2 --list-keys
echo "privkeys list"
gpg2 --list-secret-keys
echo "fingerprints"
gpg2 --fingerprint
}

gpgnew() {
gpg2 --gen-key 
}

gpg2new() {
gpg2 --full-gen-key
}

gpgeditkey() {
read -p "Introduce key: " keyy
gpg2 --edit-key 0x$keyy
}

gpgencrypt() {
read -p "Rename the key as key.txt and the message as message.txt. Then put both on this folder. Then, push ENTER and you will see your encrypted message as ciphertext.txt." Done
#read -p "enter your gpg username (sender username): " USNs
#read -p "enter your gpg username (receiver username): " USNr
#read -p "enter the route of the file" filegpge
#gpg -e -u $USNs -r $USNr $filegpge
gpg2 --batch --yes --passphrase-file "key.txt" -z 0 --cipher-algo AES256 --armor --output "ciphertext.txt" --symmetric "message.txt"
}

gpgdecrypt() {
read -p "Rename the key as key.txt and the ciphertext as ciphertext.txt. Then put both on this folder. Then, push ENTER and you will see your decrypted message as message.txt." Done
#read -p "enter file.gpg to decrypt: " filegpgd
#gpg -o $filegpg[-4] -d $filegpgd
gpg2 --batch --yes --passphrase-file "key.txt" --output "message.txt" --decrypt "cp.txt"
}


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
 break
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


securedelete() {
  read -p "DANGER VAS A BORRAR DE FORMA SEGURA TODO. INTRODUCE LA RUTA DE LA CARPETA O EL ARCHIVO SIN EQUIVOCARTE      -->" route
  rin="$route""/**"
  sudo shred -uvzn 3 $route
  sudo shred -uvzn 3 $rin
  sudo srm -vrzd $route
  }
  
tmuxts() {
tmux new-session -s 'MyTS' -n 'w1' -d 'vim'
tmux split-window -v -t 'w1' -d 'python'
tmux split-window -h -t 'w1' -c '/home/$USER'
tmux new-window -n 'w2' -t 'MyTS' 'lynx https://encrypted.google.com' 
tmux send-keys 'n n n n n n n' C-m
tmux split-window -h -t 'w2'
tmux send-keys 'tmux list-sessions && tmux list-windows && tmux list-panes && stop'  C-m
tmux split-window -v -t 'w2' -c '/home/$USER/devcon/'
tmux -2 attach-session -t 'MyTS'
tmux select-pane -t 'w2:1'
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
sudo wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/bash.bashrc
sudo rm /etc/bash.bashrc~
sudo cp /etc/bash.bashrc /etc/bash.bashrc~
sudo rm /etc/bash.bashrc
sudo mv bash.bashrc /etc/bash.bashrc
}

updatebash() {
wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/bash.bashrc -O ~/.bashrc
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
read -p "introduce usuario" sqlu
read -p "introduce IP del host o pulsa ENTER si es localhost" sqlh
firefox -new-tab https://www.thegeekstuff.com/2010/01/awk-introduction-tutorial-7-awk-print-examples/; mysql -u $sqlu -p -h $sqlh
}

debugg(){
read -p "insert the name of the file: " file
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
}
alias usermon="loginctl; sudo loginctl; uptime; sudo id; sudo users; sudo groups; sudo w; sudo who -a; sudo ipcs -m -c; pwd; sudo finger; sudo finger -lmps; sudo chfn; sudo last; read -p 'Do you want to see the processes of a user? Introduce username:' -p $regus; ps -LF -u $regus; echo 'Pure honey. Now all your bases belong to us' | pv -qL 20 > wall"
alias sysmon="sudo dmidecode; lsb_release -a; uname -a; id; sudo id; sudo lshw; lscpu; watch -n 2 free -m; logname; hostname; ipcs -m -c; sudo logname; sudo ipcs; sudo initctl list; systemctl status; cat /proc/uptime; sudo df -h;  sudo dmesg | less; ipcs -u; sudo service --status-all; sudo htop; sudo w -i; sudo dmidecode; sudo ps -efH | more; sudo lsof | wc -l; sudo lsof; ps aux | sort -nk +4 | tail; sudo pstree; sudo ss; sudo dpkg -l; sudo dstat -a -f"
alias netmon="rfkill list; nmcli general; nmcli device; nmcli connection; curl ipinfo.io; sudo netstat -tulpn; sudo vnstat; sudo netstat -ie | more -s  -l -d -f; sudo netstat -s | more -s  -l -d -f; sudo sudo netstat -pt | more -s  -l -d -f; sudo tcpstat -i wlan0 -l -a; sudo iptables -S; sudo w -i; sudo ipcs -u; sudo tcpdump -i wlan0; sudo iotop; sudo ps; sudo netstat -r; echo 'En router ir a Básica -> Estado -> Listado de equipos; nmtui'"
alias portmon="sudo nc -l -6 -4 -u; sudo ss -o state established; sudo ss -l; sudo netstat -avnp -e"
alias vpnmon="firefox -new-tab dimage.kali.org && firefox -new-tab https://www.dnsleaktest.com/results.html"
alias webmon="firefox -new-tab https://who.is/ && firefox -new-tab https://searchdns.netcraft.com/ && firefox -new-tab https://www.shodan.io/ && firefox -new-tab web.archive.org && firefox -new-tab https://validator.w3.org/ && firefox -new-tab https://geekflare.com/online-scan-website-security-vulnerabilities/"
alias hardwaremon="sudo lshw; cat /proc/cpuinfo"
alias debug="sudo apt-get install apport-retrace apython-problem-report python-apport -y; apropos apport; apropos apport-retrace; read -p 'Write process name: ' PROCESSCRASH; sudo find /var | grep $PROCESSCRASH; ls /var/crash; read -p 'Copy the route of your log crash file: ' ROUTECRASH; sudo mkdir /var/dump$PROCESSNAME; apport-unpack $ROUTECRASH /var/dump$PROCESSNAME; apport-retrace $ROUTECRASH; cat /var/dump$PROCESSNAME; sudo apt-get purge apport-retrace python-problem-report python-apport"
alias ccleaner="sudo apt-get install bleachbit -y; bleachbit -list; read -p 'Write the name of what you want to clean (f.i. firefox -e chromium.history -e password...)' CLEANN; bleachbit --list | grep -E "[a-z]+\.[a-z]+" | grep -e CLEANN | xargs sudo bleachbit --clean; sudo apt-get purge bleachbit -y"
alias cleanall="echo 'Cleaning temp, presets, browsers data, memory, cache and so forth'; sudo sh -c $(which echo) 3 > sudo /proc/sys/vm/drop_caches; sudo apt-get install bleachbit -y; bleachbit --list | grep -E '[a-z]+\.[a-z]+' | xargs sudo bleachbit --clean; sudo apt-get purge bleachbit -y"
alias clenexcept="sudo apt-get install bleachbit -y; bleachbit -list; read -p 'Write the name of what you DO NOT want to clean (f.i. firefox -e chromium.history -e password...)' UNCLEANN; bleachbit --list | grep -E "[a-z]+\.[a-z]+" | grep -v -e UNCLEANN | xargs sudo bleachbit --clean; sudo apt-get purge bleachbit -y"
alias cleanmem="echo 'Cleaning memory, cache and swap'; sudo sh -c $(which echo) 3 > sudo /proc/sys/vm/drop_caches; sudo free"

#General Aliases
alias flightmodeon="nmcli networking off"
alias flightmodeoff="nmcli networking on"
alias voip="firefox -new-tab https://www.appear.in"
alias anotherskype="skype --dbpath=~/.Skype2 &"
alias Trash="cd .local/share/Trash/files"
alias closesudo="read -p 'Write down the path/route/file to access: ' APP && sudo chown root:root $APP && sudo chmod 700 $APP"
alias opensudo="read -p 'Write down the path/route/file to open permissions: ' APP; sudo chmod ugo+rwx -R $APP && echo 'try also with sudo -i ' $APP" 
alias calc="let calc"
alias skill="sudo kill -9"
alias wline="sudo grep -n"
alias nmapp="sudo nmap -v -A --reason -O -sV -PO -sU -sX -f -PN --spoof-mac 0"
alias nmap100="sudo nmap -F -v -A --reason -O -sV -PO -sU -sX -f -PN --spoof-mac 0"
alias lss="ls -ld && sudo du -sh && ls -i1 -latr -lSr -FGAhp --color=auto -t -a -al"  # lSr sort by size ltr sort by date
alias dirr="dir -a --color=auto -g -s -S -t -Z"
alias lk='ls -lSr --color=auto -FGAhp'        # lSr sort by size ltr sort by date
alias lsall='ls -ld && sudo du -sh && ls -i1 -latr -lSr -FGAhp --color=auto -t -a -al -lR'        # recursive ls
alias verifykey="gpg --keyid-format long --import"
alias verifyfile="gpg --keyid-format long --verify"
alias secfirefox="firejail --dns=8.8.8.8 --dns=8.8.4.4 firefox"
alias lssh="ls -al ~/.ssh"
alias dt='date "+%F %T"'
alias pdf2txt='ls * | sudo xargs -n1 pdftotext'
alias bashrc='~./bashrc'
alias geditbash='sudo gedit ~/.bashrc'
alias vimbash='sudo vim ~./bashrc'
alias atombash='sudo atom ~/.bashrc'
alias nanobash='sudo nano ~/.bashrc'
alias busca='sudo find / -iname'
alias wtfhappened='sudo find / -cmin 1'
alias whatchanged='sudo find / -mtime'
alias myip="wget http://ipinfo.io/ip -qO -"
alias theirip="dig"
alias cpc='cp -i -r'
alias mvm='mv -i -u'
alias rmr='sudo rm -irv -rf'
alias delete="rmr"
alias remove="rmr"
alias event="evtest"
alias fid="iron chrome-extension://bnjjngeaknajbdcgpfkgnonkmififhfo/options.html#/backup; wget 'http://randomprofile.com/api/api.php?&countries=CHN,JPN,KOR,GBR&fromAge=20&toAge=60&format=xml&fullChildren=1' -O seres.xml; rig >> fids; echo '------------------------' >> fids; date '+%H:%M:%S   %d/%m/%y' >> fids; cat seres.xml >> fidxmls; echo '------------------------' >> fidxmls; echo '------------------------' >> fidxmls; echo '------------------------' >> fidxmls; date '+%H:%M:%S   %d/%m/%y' >> fidxmls"
alias now="date '+%H:%M:%S   %d/%m/%y'"
alias keepasss="sudo mono /home/$USER/KeePass/KeePass.exe"
alias keepass="mono /home/$USER/KeePass/KeePass.exe"
alias df='df -h'
alias ytb='youtube-dl --prefer-ffmpeg --ignore-errors'
alias ytmp3='youtube-dl --audio-format mp3 --audio-quality 0 --extract-audio  --prefer-ffmpeg --ignore-errors'
alias aptup='sudo apt-get update && sudo apt-get upgrade && sudo apt-get clean'
alias mkdirr='mkdir -p -v'
alias downweb='wget --mirror -p --convert-links -P .'
alias lvim="vim -c \"normal '0\'" # open vim editor with last edited file
alias grepp='grep --color=auto -r -H'
alias egrepp='egrep --color=auto -r -w'
alias fgrepp='fgrep --color=auto'
alias aptclean='sudo apt-get autoremove'
alias aptinstall='sudo apt-get install'
alias aptlog='less /var/log/apt/history.log'
alias aptinstalled='apt list | grep installed'
alias BCE='curl http://api.fixer.io/latest?base=EUR'
alias rename='mv'
alias tmuxkillall="tmux ls | grep : | cut -d. -f1 | awk '{print substr($1, 0, length($1)-1)}' | xargs kill"
alias gitlist='git remote -v'
alias diferencia='echo "Puedes usar tambien vi -d o kompare"; colordiff -ystFpr'
alias compara='diff -y -r'
alias adbconnect="mtpfs -o allow_other /mnt/mobile"
alias adbdisconnect="fusermount -u /mnt/mobile"
alias newgpg="sudo gpg --gen-key"
alias androidsdk="sh ~/android-studio**/bin/studio.sh"
alias decompileapk="java -jar ~/android-studio**/bin/apktool.jar $1"
alias signapk="java -jar ~/android-studio**/bin/sign.jar $2"
alias shist="history | grep"
alias vectorize="xargs"
alias cuenta="wc"
alias countlines="awk '/a/{++cnt} END {print \"Count = \", cnt}'"
alias iron="/bin/iron/./chrome"
#check alias chrome --> iron
alias ffx='/home/$USER/icecat/./icecat'
alias rctty='script -t 2>rctty.timing rctty'
alias mtty='more rctty'
alias rptty='replayscript rctty.timing rctty'
alias rpttyfast='replayscript -d 3 rctty.timing rctty'
alias logg='tailf'
alias createtags='!ctags -R && echo "Remember: Ctrl+] go to tag; g+Ctrl+] ambiguous tags and enter number; Ctrl+t last tag; Ctrl+X+Ctrl+] Autocomplete with tags"'

imprime (){
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

selectline() {
read -p "Write first line: " fline
read -p "Write last line: " lline
read -p "Introduce the file with lines: " lined
cat $lined | sed -n '$fline,$llinep'
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
read -p "Introduce name of the file" thisis
read -p "Introduce name of the new fixed copy" thatone
cat $thisis | tr "\n" " " >> $thatone
cat $thatone
}

### Some cheatsheets ###
alias subst='echo "vi filename.txt -c \":Ubuntu%s/\<tmux\>/Linux/gIc \" -c \":wq \" meaning (:code) (tres after the first apparition of Ubuntu) (% make changes in all lines, use {START-n},{END-n} instead) (s/ search) (\<\> exact word) (UNIX/ old word) (Linux/ new word) (g global – each occurrence in the line is changed, rather than just the first) (I case sensitive) (c confirm signal)"'
alias androidsheet="firefox -new-tab https://developer.android.com/design/index.html && firefox -new-tab https://developer.android.com/studio/intro/keyboard-shortcuts.html"
alias adbsheet="firefox -new-tab http://www.movilzona.es/tutoriales/android/root/principales-comandos-para-adb-y-fastboot-guia-basica/"
alias distrosheet="echo 'centos (redhat, scientific and enterprise), openbsd (more usability freebsd, security and multiplatform), archbang(arch, control by complex simplicity), coreos (chromium os, cloud), qubeos (Xen security), tor-ramdisk/tails (Debian/GNULinux, privacy), salixos (Slackware, neutrality), sabayon (gentoo, diversity)'"
alias emacssheet="firefox -new-tab https://spacemacs.org/doc/VIMUSERS.html && firefox -new-tab http://www.stephenwalker.com/notes/aquamacsemacs-key-binding-list/ && firefox -new-tab https://www.emacswiki.org/ && firefox -new-tab http://www.ling.ohio-state.edu/~kyoon/tts/unix-help/LaTeX/emacs-cheatsheet-2-of-2.jpg && firefox -new-tab http://www.muylinux.com/wp-content/uploads/2010/11/Emacs-Cheatsheet-wallpaper.jpg && firefox -new-tab https://github.com/emacs-tw/awesome-emacs && firefox -new-tab http://es.tldp.org/Tutoriales/doc-tutorial-emacs/intro_emacs.pdf"
alias electrumsheet="firefox -new-tab https://docs.electrum.org/en/latest/"
alias shsheet="firefox -new-tab https://www.tldp.org/LDP/abs/html/index.html -new-tab https://explainshell.com/" 
alias gethsheet="https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options"
alias gpgsheet="firefox -new-tab http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/gpg-cs.html"
alias bitcoinsheet="firefox -new-tab  https://en.bitcoin.it/wiki/Script#Words"
alias rubysheet="firefox -new-tab -url https://cheat.errtheblog.com/s/rvm -new-tab http://spacemacs.org/layers/+frameworks/ruby-on-rails/README.html -new-tab -url https://rvm.io/ -new-tab -url http://bundler.io/"
alias tmuxsheet="tmux list-keys; tmux list-commands; echo 'https://gist.github.com/MohamedAlaa/2961058 There are sessions, windows, panels \
tmux new -s myname | tmux ls | tmux a -t myname | tmux kill-session -t myname | Ctrl+Shift++ Zoom in | Ctrl+- Zoom out\
ctrl+b & c create window | ctrl+b & w list windows | ctrl+b & n  next window | ctrl+b & p  previous window | ctrl+b & f  find window | ctrl+b & ,  name window | ctrl+b & d detach window | ctrl+b & & kill window \
ctrl+b & :set synchronize-panes on/off a/synchronize all panels of the window | ctrl+b & % vertical split | ctrl+b & \"  horizontal split | ctrl+b & q  show panel numbers | ctrl+b & x  kill pane | ctrl+b & spacebar change layout | ctrl+b & {} Move the current pane leftright | ctrl+b & z Zoom in zoom out panel | ctrl+b + :resize-pane -U/D/L/R 20 add 20 cells up/down/left/right to that panel'"
alias ubuntusheet="firefox -new-tab  https://slashbox.org/index.php/Ubuntu#Cheat_Sheet && firefox -new-tab https://slashbox.org/index.php/Ubuntu#Cheat_Sheet" 
alias vimsheet="echo ':h vimtex, :help i_C^M, :help e_<Esc>, :help c_<Del>, move with [], createtags, nnoremap, addsnippet'; firefox -new-tab  http://michael.peopleofhonoronly.com/vim/vim_cheat_sheet_for_programmers_screen.png && firefox -new-tab https://cdn.shopify.com/s/files/1/0165/4168/files/digital-preview-letter.png && firefox -new-tab https://michael.peopleofhonoronly.com/vim/vim_cheat_sheet_for_programmers_screen.png && firefox -new-tab https://cdn.shopify.com/s/files/1/0165/4168/files/digital-preview-letter.png"
alias wgetsheet="firefox -new-tab https://www.thegeekstuff.com/2009/09/the-ultimate-wget-download-guide-with-15-awesome-examples/"
alias soliditysheet="firefox -new-tab https://solidity.readthedocs.io/en/latest/units-and-global-variables.html"
alias chsheet="echo 'chmod: Change the file modes/attributes/permissions | chown: Change the file ownership | chgrp: Change the file group ownership'"

#APT PIP YUM 
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

#Docker Aliasheet
#Aliasheet
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
function cdn(){ for i in 'seq $1'; do cd ..; done;}


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
}


monta(){ 
sudo lsblk
sudo blkid
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
            echo "You were sudo"; findmnt; sudo pantheon-files /mnt/$sdjah || sudo nemo /mnt/$sdjah || sudo /mnt/nautilus $sdjah; break;;
        "2")
            echo "You were not sudo"; findmnt; pantheon-files /mnt/$sdjah || nemo /mnt/$sdjah || /mnt/nautilus $sdjah; break;;
        "3")
            findmnt; cd /mnt/$sdjah && ls;;
        "Q")
            break;;
        *) echo invalid option;;
    esac
}



#buf - Back Up a file. Usage "buf filename.txt"
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
  weneedwine () {
  read -p "file to wine" filewine
  wget http://dl.winehq.org/wine/source/1.9/wine-1.9.0.tar.bz2
  wget http://dl.winehq.org/wine/source/1.9/wine-1.9.0.tar.bz2.sign
  gpg --verify **.sign **.bz2
  tar -jxvf wine**.bz2
  cd wine**
  sudo apt-get build-dep wine1.6
  ./configure --enable-win64
  make
  sudo make install
  sudo wine64 cmd $filewine
  sudo rm wine**.tar.bz2
  sudo rm wine**.tar.bz2.sign
  sudo make uninstall
  sudo apt-get purge bison comerr-dev docbook docbook-dsssl docbook-to-man docbook-utils docbook-xsl execstack flex fontforge fontforge-common gir1.2-gst-plugins-base-0.10 gir1.2-gstreamer-0.10 jadetex krb5-multidev libasound2-dev libavahi-client-dev libavahi-common-dev libbison-dev libcapi20-3 libcapi20-dev libcups2-dev libdrm-amdgpu1 libdrm-dev libfl-dev libfontforge1 libgdraw4 libgl1-mesa-dev libglu1-mesa-dev libgphoto2-dev libgsm1-dev libgssrpc4 libgstreamer-plugins-base0.10-dev libgstreamer0.10-dev libieee1284-3-dev libkadm5clnt-mit9 libkadm5srv-mit9 libkdb5-7 libkrb5-dev libldap2-dev libmpg123-dev libodbc1 libopenal-dev libosmesa6 libosmesa6-dev libosp5 libostyle1c2 libptexenc1 libpulse-dev libsane-dev libsgmls-perl libsp1c2 libspiro0 libuninameslist0 libusb-1.0-0-dev libv4l-dev libv4l2rds0 libx11-xcb-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-glx0-dev libxcb-present-dev libxcb-randr0 libxcb-randr0-dev libxcb-shape0-dev libxcb-sync-dev libxcb-xfixes0-dev libxshmfence-dev libxslt1-dev libxxf86vm-dev luatex lynx lynx-cur m4 mesa-common-dev ocl-icd-libopencl1 odbcinst odbcinst1debian2 opencl-headers openjade oss4-dev prelink sgml-data sgmlspl sp tex-common texlive-base texlive-binaries texlive-fonts-recommended texlive-generic-recommended texlive-latex-base texlive-latex-recommended tipa unixodbc unixodbc-dev valgrind x11proto-dri2-dev x11proto-gl-dev x11proto-xf86vidmode-dev
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
		then break
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
            break
            ;;
        *) echo invalid option;;
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
alias ethstats="sudo pm2 start /home/$USER/eth-net-intelligence-api/app.json && firefox -new-tab https://ethstats.net/ && parity --max-peers 100 --peers 100 --min-peers 100"
alias meteor="firefox -new-tab -url http://localhost:3000 && cd /home/$USER/linux && ./geth --rpc --rpccorsdomain='http://localhost:3000'"

#3 random numbers & uuid
alias rng='expr $RANDOM % 9223372036854775807 && od -N 4 -t uL -An /dev/random | tr -d " " && openssl rand 4 | od -DAn && uuidgen'

alias diskusage="df -h && sudo baobab"

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
read -p "Which one is you user gmail user?" $uzer
curl -u $uzer@gmail.com --silent "https://mail.google.com/mail/feed/atom" | perl -ne 'print "\t" if //; print "$2\n" if /<(title|name)>(.*)<\/\1>/;'
}

checkport() {
read -e -p "Port Range: Enter your starting port (80 by default): " -i "80" PORTZS
read -e -p "Port Range: Enter your last port (8080 by default): " -i "8080" PORTZF
read -e -p "Enter your IP (localhost by default): " -i "localhost" IPZ
for i in $(seq $PORTZS $PORTZF); do nc -zv $IPZ $i; done
read -p "Do you want to test which process is listening to that port (only for host system)? If so, write down the port: " PORTZC
lsof -iTCP:$PORTZC -sTCP:LISTEN
}

leeme() {
read -p "Hola amigo :) Introduce el nombre del archivo que quieres que te lea: " ezte
read -p "Introduce el idioma del texto (en-EN, fr-FR, pt-PT... por defecto es-ES)" -i "es-ES" lang
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
        *) echo opcion no reconocida;;
    esac
done
}


ssign(){
read -p "Message to sign (~/message by default): " -i ~/message -e messg
saltpack sign --message $messg | tee ~/signed_message
echo "The signed message was saved as signed_message"
}

sverify(){
read -p "Message to verify (~/signedmessage by default): " -i ~/signedmessage -e messg 
saltpack verify $messg
}

sencrypt(){
read -p "Message to encrypt (~/message by default): " -i ~/message -e messg
MESIG=$(cat $messg)
saltpack encrypt --message $MESIG | tee ~/encrypted_message
echo "The encrypted message was saved as ~/encrypted_message"
}

sdecrypt(){
read -p "Message to decrypt (~/encrypted_message by default): " -i ~/message -e messg
MESIG=$(cat $messg)
saltpack decrypt < MESIG
}

wgetall(){
read -p "Write the file formats to download (pdf,doc,docx,zip,rar,jpg...): " formatt
formattt=$formatt^^+","+$formatt # as accept is case sensitive
read -p "Write the website: " flinkkk
wget --accept $formattt --mirror --adjust-extension --convert-links --backup-converted --no-parent $flinkkk
}


##Linux container set
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

alias emacstex="\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}"

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


crtime() {
  a=()
  for target in "${@}"; do
    inode=$(ls -di "${target}" | cut -d ' ' -f 1)
    fs=$(df "${target}"  | tail -1 | awk '{print $1}')
    crtime=$(sudo debugfs -R 'stat <'"${inode}"'>' "${fs}" 2>/dev/null | 
    grep -oP 'crtime.*--\s*\K.*')
    printf "%s\t%s\n" "${crtime}" "${target}"
  done
}

delnew() {
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
