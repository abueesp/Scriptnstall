# System-wide .bashrc file for interactive bash(1) shells.
. /usr/share/autojump/autojump.sh #autojump
# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

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
gcreate() {
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

gitnew() {
repo_name=$1
username=$2
git init 
git add . 
git commit -m 'Initial commit' 
gcreate $1 
git remote add origin git@github.com:abueesp/$1.git 
echo "if gcreate didn't work, create the github repo on   https://github.com/new   and push the code using   git push -u origin master"
git push -u origin master
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

### Some cheatsheets###
alias bitcoinsheet="https://en.bitcoin.it/wiki/Script#Words"
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
sudo apt-get install xclip
xclip -sel clip < ~/.ssh/id_rsa.pub
echo 'those are your keys up to now, id_rsa.pub is the default. If you want to change it, type switchmyssh'
ls -al -R ~/.ssh
echo "Now you may have your ssh key on your clipboard. If you have already set your app global configuration, now you should go to Settings -> New SSH key and paste it there"
}

mylastsshkey(){
sudo apt-get install xclip
xclip -sel clip < ~/.ssh/lastid_rsa.pub
echo 'this is your last key, lastid_rsa.pub is the default.'
ls -al -R ~/.ssh
echo "Now you may have your last ssh key on your clipboard. If you have already set your app global configuration, now you should go to Settings -> New SSH key and paste it there"
}

switchsshkey(){
if [ $1 ]
then
    sudo mv ~/.ssh/$1 ~/.ssh/id_rsa.pub ~/.ssh/lastid_rsa.pub
    sudo mv ~/.ssh/$1 ~/.ssh/id_rsa.pub
    echo "Your last key is now lastid_rsa.pub. If you want to copy the new one type mysshkey. If you want to copy the last one type mylastsshkey"
else
    echo "Please, introduce the key you want to switch by the default id_rsa.pub. Those are your current keys: "
    ls -al -R ~/.ssh
fi
}


newsshkey(){
echo 'those are your keys up to now'
ls -al -R ~/.ssh
# Lists the files in your .ssh directory, if they exist
if [ $1 ]
then
    ssh-keygen -t rsa -b 4096 -C $1
else
    echo "Please, introduce 'youremail@server.com'"
    return
fi

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
sudo chown -R $USER:$USER .ssh
sudo chmod -R 600 .ssh
sudo chmod +x .ssh
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
