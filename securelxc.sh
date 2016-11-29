

##Check alias ##Linux container set on bash.bashrc
#! /bin/bash
read -e -p "Set a hard limit for kernel memory to fix fork bomb attack for cgroups (1000MB by default): " -i "1000" memm
read -e -p "And swap? (0MB by default): " -i "0" swapp
echo "lxc.cgroup.memory.limit_in_bytes = $memmM" >> sudo tee /var/lib/lxc/$namecont/config
summ=$(expr $swapp + $memm)
"lxc.cgroup.memory.memsw.limit_in_bytes = $summM; " >> tee /var/lib/lxc/$namecont/config
printf '\n\033[42mCreating cgroup hierarchy\033[m\n\n' &&
for d in /sys/fs/cgroup/*; do
        f=$(basename $d)
        echo "looking at $f"
        if [ "$f" = "cpuset" ]; then
                echo 1 | sudo tee -a $d/cgroup.clone_children;
        elif [ "$f" = "memory" ]; then
                echo 1 | sudo tee -a $d/memory.use_hierarchy;
        fi
        sudo mkdir -p $d/$USER
        sudo chown -R $USER $d/$USER
        # add current process to cgroup
       echo $PPID > $d/$USER/tasks
done
