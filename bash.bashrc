# System-wide .bashrc file for interactive bash(1) shells.
. /usr/share/autojump/autojump.sh #autojump
# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

color_def="~/.colorrc"
 
if [[ -f $color_def ]]; then
   . $color_def
else
   # color definitions
   black="$(tput setaf 0)"
   darkgrey="$(tput bold ; tput setaf 0)"
   lightgrey="$(tput setaf 7)"
   white="$(tput bold ; tput setaf 7)"
   red="$(tput setaf 1)"
   lightred="$(tput bold ; tput setaf 1)"
   green="$(tput setaf 2)"
   lightgreen="$(tput bold ; tput setaf 2)"
   yellow="$(tput setaf 3)"
   blue="$(tput setaf 4)"
   lightblue="$(tput bold ; tput setaf 4)"
   purple="$(tput setaf 5)"
   pink="$(tput bold ; tput setaf 5)"
   cyan="$(tput setaf 6)"
   lightcyan="$(tput bold ; tput setaf 6)"
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
cat <<'EOF'
 
usage: debug [option] script arguments
 
possilbe options are:
- help|usage: print this screen
- verbose: sets -xv flags
- noexec: sets -xvn flags
- no parameter sets -x flags
 
EOF
fmt <<EOF
if the script takes arguments remember to enclose the script and arugments
in ""
EOF
 
fmt <<EOF
 
The script prints the script name, script line number and function name as it
executes the script. The various parts of the script prompt are printed in
color. If the default colors are not suitable than you can set the environment
varialbes script_color linenum_color funcname_color to any of the following
colors: ${darkgrey}darkgrey$nc, ${lightgrey}light grey$nc, ${white}white,
${red}red, ${lightred}light red, ${green}green, ${lightgreen}light green,
${yellow}yellow, ${blue}blue, ${lightblue}light blue, ${purple}purple,
${pink}pink, ${cyan}cyan, ${lightcyan}light cyan$nc.
EOF
 
cat <<EOF
 
default colors are:
${level_color}- shell level color:cyan$nc
${script_color}- script name: yellow$nc
${linenum_color}- line number: red$nc
${funcname_color}- function name: green$nc
${command_color}- command executed: white'$nc
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

verify() {
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

## Create a repo on Github (not git)
gitnew() {
 repo_name=$1

 dir_name=`basename $(pwd)`

 if [ "$repo_name" = "" ]; then
 echo "Repo name (hit enter to use '$dir_name')?"
 read repo_name
 fi

 if [ "$repo_name" = "" ]; then
 repo_name=$dir_name
 fi

 username=`git config github.user`
 if [ "$username" = "" ]; then
 echo "Could not find username, run 'git config --global github.user <username>'"
 invalid_credentials=1
 fi

 token=`git config github.token`
 if [ "$token" = "" ]; then
 echo "Could not find token, run 'git config --global github.token <token>'"
 invalid_credentials=1
 fi

 if [ "$invalid_credentials" == "1" ]; then
 return 1
 fi

 echo -n "Creating Github repository '$repo_name' ..."
 curl -u "$username:$token" https://api.github.com/user/repos -d '{"name":"'$repo_name'"}' > /dev/null 2>&1
 echo " done."
}


gitupload () {
  echo "introduce tu email"
  read email
  git config --global user.email $email
  echo "introduce tu username"
  read username
  git config --global user.name $username
  git commit -m "First commit"
  echo "introduce la url del repositorio"
  read url
  git remote add origin $url
  git remote -v
  git pull origin master
  git push origin master
}

docsthemagic () {
  echo "vas a crear las copias, luego armonizar los nombres y finalmente limpiar los metadatos de todos los archivos ubicados en esta carpeta. Introduce los documentos. recuerda que si quieres hacer un backup puedes usar mat -b"
  read docs
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
  for file in *.html.epub; do
    sudo mv "$file" "`basename $file .html.pdf`.epub"
  for file in *.html.wiki; do
    sudo mv "$file" "`basename $file .html.wiki`.wiki"
  for file in *.html.txt; do
    sudo mv "$file" "`basename $file .html.txt`.txt"
 for file in *.html.md; do
    sudo mv "$file" "`basename $file .html.md`.md"
  for file in *.html.odt; do
    sudo mv "$file" "`basename $file .html.odt`.odt"
  sudo mat -c **
  sudo mat **
}

rbash() {
sudo wget https://raw.githubusercontent.com/abueesp/Scriptnstall/master/bash.bashrc
sudo rm /etc/bash.bashrc
sudo rm /etc/bash.bashrc~
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

#Aliases
alias process="sudo ps ax | grep"
alias superkill="sudo kill -9"
alias appmon="sudo lsof -i -n -P | grep"
alias systemmon="sudo htop; sudo w -i"
alias netmon="sudo iptables -S; sudo w -i; sudo tcpdump -i wlan0; sudo iotop; sudo ps; netstat -avnp -ef; echo 'En router ir a Básica -> Estado -> Listado de equipos'"
alias portmon="nc -l -6 -4 -u"
alias nmaproute="sudo nmap -v -A --reason -O -sV -PO -sU -sX -f -PN --spoof-mac 0"
alias nmap100="sudo nmap -F -v -A --reason -O -sV -PO -sU -sX -f -PN --spoof-mac 0"
alias lss="ls -ld && ls -latr -FGAhp --color=auto -t -a -al"
alias verifykey="gpg --keyid-format long --import"
alias verifyfile="gpg --keyid-format long --verify"
alias secfirefox="firejail --dns=8.8.8.8 --dns=8.8.4.4 firefox"
alias lsssh="ls -al ~/.ssh"
alias dt='date "+%F %T"'
alias pdf2txt='ls * | sudo xargs -n1 pdftotext'
alias bashrc='/etc/bash.bashrc'
alias geditbash='sudo gedit /etc/bash.bashrc'
alias vimbash='sudo vim /etc/bash.bashrc'
alias atombash='sudo atom /etc/bash.bashrc'
alias nanobash='sudo nano /etc/bash.bashrc'
alias myip="dig +short http://myip.opendns.com @http://resolver1.opendns.com"
alias cpc='cp -i -r'
alias mvm='mv -i -u'
alias rmr='sudo rm -irv -rf'
alias delete=rmr
alias remove=rmr
alias df='df -h'
alias aptup='sudo apt-get update && sudo apt-get upgrade && sudo apt-get clean'
alias mkdirr='mkdir -p -v'
alias lk='ls -lSr --color=auto -FGAhp'        # sort by siz
alias lr='ls -lR --color=auto -FGAhp'        # recursice ls
alias lt='ls -ltr --color=auto -FGAhp'        # sort by date
alias lvim="vim -c \"normal '0\"" # open vim editor with last edited file
alias grepp='grep --color=auto -r -H'
alias egrepp='egrep --color=auto -r -w'
alias fgrepp='fgrep --color=auto'
alias aptclean='sudo apt-get autoremove'
alias rename='mv'
alias gitlist='git remote -v'
alias gethlocal="geth --rpc --rpccorsdomain localhost --etherbase '0x9B366b5493a545f070E4a0F16c81182670fEE6' --solc console"
alias gethmine='geth --etherbase '0x9B366b5493a545f070E4a0F16c81182670fEE6' --mine --minergpus --autodag --minerthreads "8" console'
alias gethtest="geth --testnet console"
alias gethupgrade="geth upgradedb --fast console"


### Some cheatsheets###
alias gethsheet="https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options"
alias gpgsheet="firefox http://irtfweb.ifa.hawaii.edu/~lockhart/gpg/gpg-cs.html"
alias bitcoinsheet="firefox https://en.bitcoin.it/wiki/Script#Words"
alias dockersheet="firefox https://www.cheatography.com/storage/thumb/aabs_docker-and-friends.600.jpg && firefox http://container-solutions.com/content/uploads/2015/06/15.06.15_DockerCheatSheet_A2.pdf"
alias nmapsheet="firefox https://4.bp.blogspot.com/-lCguW2iNKi4/UgmjCu1UNfI/AAAAAAAABuI/35Px0VIOuIg/s1600/Screen+Shot+2556-08-13+at+10.06.38+AM.png"
alias gitsheet="firefox http://developer.exoplatform.org/docs/scm/git/cheatsheet/ && firefox https://github.com/tiimgreen/github-cheat-sheet && echo 'Warning: Never git add, commit, or push sensitive information to a remote repository. Sensitive information can include, but is not limited to:
    Passwords
    SSH keys
    AWS access keys
    API keys
    Credit card numbers
    PIN numbers'"
alias ubuntusheet="firefox http://slashbox.org/index.php/Ubuntu#Cheat_Sheet && firefox 'http://slashbox.org/index.php/Ubuntu#Cheat_Sheet'" 
alias vimsheet="firefox http://michael.peopleofhonoronly.com/vim/vim_cheat_sheet_for_programmers_screen.png && firefox https://cdn.shopify.com/s/files/1/0165/4168/files/digital-preview-letter.png && firefox http://michael.peopleofhonoronly.com/vim/vim_cheat_sheet_for_programmers_screen.png && firefox https://cdn.shopify.com/s/files/1/0165/4168/files/digital-preview-letter.png'"


### Functions ###

free(){
  sudo chmod 777 $1 $2
}

install(){
  sudo apt-get install -y $1
}

uninstall(){
  sudo apt-get remove --purge -y $1
}

mysshkey(){
sudo chown -R $USER:$USER ~/.ssh
sudo chmod -R 600 ~/.ssh
sudo chmod +x ~/.ssh 
sudo apt-get install xclip
sudo xclip -sel clip ~/.ssh/id_rsa/id_rsa.pub
echo 'those are your keys up to now, id_rsa.pub is the default. If you want to change it, type switchmyssh'
sudo ls -al -R ~/.ssh/id_rsa
echo "Now you may have your ssh key on your clipboard. If you have already set your app global configuration, now you should go to Settings -> New SSH key and paste it there"
sudo chmod -R 600 ~/.ssh
}

mylastsshkey(){
sudo chown -R $USER:$USER ~/.ssh
sudo chmod -R 600 ~/.ssh
sudo chmod +x ~/.ssh  
sudo apt-get install xclip
xclip -sel clip < ~/.ssh/lastid_rsa.pub
echo 'this is your last key, lastid_rsa.pub is the default.'
ls -al -R ~/.ssh
echo "Now you may have your last ssh key on your clipboard. If you have already set your app global configuration, now you should go to Settings -> New SSH key and paste it there"
sudo chmod -R 600 ~/.ssh
}

switchsshkey(){
sudo chown -R $USER:$USER ~/.ssh
sudo chmod -R 600 ~/.ssh
sudo chmod +x ~/.ssh
if [ $1 ]
then
    sudo mv ~/.ssh/$1 ~/.ssh/id_rsa.pub ~/.ssh/lastid_rsa.pub
    sudo mv ~/.ssh/$1 ~/.ssh/id_rsa.pub
    echo "Your last key is now lastid_rsa.pub. If you want to copy the new one type mysshkey. If you want to copy the last one type mylastsshkey"
else
    ls -al -R ~/.ssh
    echo "Please, introduce the key you want to switch by the default id_rsa.pub. Those are your current keys: "
fi
sudo chmod -R 600 ~/.ssh
}


newsshkey(){
sudo chown -R $USER:$USER ~/.ssh
sudo chmod -R 600 ~/.ssh
sudo chmod +x ~/.ssh 
$emai = emai
sudo mkdir ~/.ssh
sudo mkdir ~/.ssh/id_rsa
echo 'those are your keys up to now'
sudo ls -al -R ~/.ssh # Lists the files in your .ssh directory, if they exist
echo "Please, introduce 'youremail@server.com'"
read emai
echo "please choose a file like this /home/node/.ssh/id_rsa/id_rsa.pub and a password longer or equal to 5 caractheres"
sudo ssh-keygen -t rsa -b 4096 -C $emai
eval "$(ssh-agent -s)" 
ssh-add ~/.ssh/id_rsa
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

#bu - Back Up a file. Usage "bu filename.txt"
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
