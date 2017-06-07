sudo apt-get install xfsprogs mdadm -y
modprobe raid456
cat /proc/mdstat
read -p "Introduce name for new raid, f.i. /dev/md0: " RAIDNAME
xfs_info $RAIDNAME
sudo mdadm --detail-platform
read -p "If Intel Matrix Storage Manager write imsm, other options is 1.0 and 1.1 but 1.2 is default (pulse Intro if so): " $RAIDMETADA
sudo fdisk -l
read -p "Introduce number of disks : " NUMDISKS
read -p "Introduce /dev/disk1 /dev/disk2 ... : " DEVDISKS
for DISKS in $DEVDISKS
  do
  sudo mdadm --misc --examine $DISKS
  done
read -p "Write
A) linear : If you have two or more partitions which are not necessarily the same size (but of course can be), which you want to append to each other. 
B) stripe : You have two or more devices, of approximately the same size, and you want to combine their storage capacity and also combine their performance by accessing them in parallel. 
C) mirror : You have two devices of approximately same size, and you want the two to be mirrors of each other. Eventually you have more devices, which you want to keep as stand-by spare-disks, that will automatically become a part of the mirror if one of the active devices break. 
D) 4 or 5 or 6 : You have three or more devices (four or more for RAID-6) of roughly the same size, you want to combine them into a larger device, but still to maintain a degree of redundancy for data safety. If you use N devices where the smallest has size S, the size of the entire raid-5 array will be (N-1)*S, or (N-2)*S for raid-6. This "missing" space is used for parity (redundancy) information. Thus, if any disk fails, all the data stays intact. 
     RAID 0 with 2 disks: 2 data disks (n)
    RAID 1 with 2 disks: 1 data disk (n/2)
    RAID 10 with 10 disks: 5 data disks (n/2)
    RAID 5 with 6 disks (no spares): 5 data disks (n-1)
    RAID 6 with 6 disks (no spares): 4 data disks (n-2) 
" LEVELDISK
read -p "If you want 1 spare device /dev/sd1 to leave out write --spare-devices=1 /dev/sde1 Otherwise leave intro: " SPAREDISK
sudo mdadm --create --verbose $RAIDNAME --metadata=$RAIDMETADA --level=$LEVELDISK --raid-devices=$NUMDISKS '$DEVDISKS' $SPAREDISK
sudo mdadm --assemble --scan 
sudo mdadm --assemble $RAIDNAME '$DEVDISKS'
cat /proc/mdstat
sudo mdadm --monitor $DEVDISK
sudo mdadm --detail --scan
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
xfs_info $RAIDNAME
echo "The chunk-size deserves an explanation. You can never write completely parallel to a set of disks. If you had two disks and wanted to write a byte, you would have to write four bits on each disk.  Thus, for large writes, you may see lower overhead by having fairly large chunks, whereas arrays that are primarily holding small files may benefit more from a smaller chunk size. 
For optimal performance, you should experiment with the chunk-size, as well as with the block-size of the filesystem. A 32 kB chunk-size is a reasonable starting point for RAID0 (linear) and RAID4. A reasonable chunk-size for RAID-5 is 128 kB. A study showed that with 4 drives (even-number-of-drives might make a difference) that large chunk sizes of 512-2048 kB gave superior results. RAID1 (stripe) the chunk-size doesn't affect the array.
     chunk size = 128kB (set by mdadm cmd, see chunk size advise above)
    block size = 4kB (recommended for large files, and most of time)
    stride = chunk / block = 128kB / 4k = 32
    stripe-width = stride * ( (n disks in raid5) - 1 ) = 32 * ( (3) - 1 ) = 32 * 2 = 64 
    It is possible to change the parameters with   
    
    tune2fs -E stride=n,stripe-width=m /dev/mdx
    mkfs -t xfs -d su=64k -d sw=3 /dev/md0
    mkfs -t xfs -d sunit=128 -d swidth=384 /dev/md0

You can also stop raid with stopraid command, add a device with add2raid, and manage with manageraid"

read -p "Add aliases? y/n" yn
    case $yn in
        [Yy]* )
          sudo tee -a 'alias stopraid="cat /proc/mdstat; read -p '/Introduce raid name /dev/md0: '/ RAIDNAME; sudo mdadm --stop $RAIDNAME"' ~/.bashrc;
          sudo tee -a 'alias stopraid="cat /proc/mdstat; read -p '/Introduce raid name /dev/md0: '/ RAIDNAME; sudo mdadm --manage $RAIDNAME"' ~/.bashrc;
          sudo tee -a 'alias add2raid="sudo fdisk -l; cat /proc/mdstat; echo '/Using sudo mdam --grow /dev/md0 you can grow instead of using mdadm --assemble --scan, using mdadm --incremental'/"' ~/.bashrc;
          break;;
        [Nn]* ) break;;
        * ) echo "Answer y/n";;
    esac
