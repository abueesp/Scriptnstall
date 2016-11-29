#Current LXC uses the following kernel features to contain processes:
##Kernel namespaces (ipc, uts, mount, pid, network and user)
##Apparmor and SELinux profiles
##Seccomp policies
##Chroots (using pivot_root)
##Kernel capabilities
##CGroups (control groups)

sudo apt-get install lxc openssh-server -y
mkdir ~/.config/lxc
cp /etc/lxc/default.conf ~/.config/lxc/default.conf
echo "lxc.id_map = u 0 100000 65536" >> ~/.config/lxc/default.conf
echo "lxc.id_map = g 0 100000 65536" >> ~/.config/lxc/default.conf


  ##Check alias in bash.bashrc
