#Some ncurses dialogs samples


#### LITTLE EXAMPLES ####
#A checklist box allows you to present a set of choices to the user and the user can toggle each one on or off individually using the space bar.
dialog --checklist "Choose OS:" 15 40 5 \
1 Linux off \
2 Solaris on \
3 'HP UX' off \
4 AIX off

#The 'radiolist' control box is same as 'checklist' box.
dialog --backtitle "OS infomration" \
--radiolist "Select OS:" 10 40 3 \
"Linux 7.2" off \
"Solaris 9" on \
"HPUX 11i" off

#The 'inputbox' allows the user to enter a string.
dialog --title "Inputbox - Example" \
--backtitle "unstableme.blogspot.com" \
--inputbox "Enter your favourite OS here" 8 50

#Menu box:
dialog --title "A dialog Menu Example" \
--menu "Please choose an option:" 15 55 5 \
1 "Add a record to DB" \
2 "Delete a record from DB" \
3 "Exit from this menu"

#A message-box:
dialog --title "Example Dialog message box" \
--msgbox "\n Installation Completed on host7" 6 50

#A yesno box:
dialog --title "Confirmation"  --yesno "Want to quit?" 6 20
#Infobox:
dialog --infobox "Processing, please wait" 3 34 ; sleep 5
#Textbox: It is a simple file viewer
dialog --textbox $file 10 4

#Gauge Box:
#!/bin/sh
(
c=10
while [ $c -ne 110 ]
    do
        echo $c
        echo "###"
        echo "$c %"
        echo "###"
        ((c+=10))
        sleep 1
done
) |
dialog --title "A Test Gauge With dialog" --gauge "Please wait ...." 10 60 0

#Calendar Box:
#!/bin/sh
dat=$(dialog --stdout --title "My Calendar" \
                   --calendar "Select a date:" 0 0 25 12 2018)
case $? in
0)
 echo "You have entered: $dat"   ;;
1)
 echo "You have pressed Cancel"  ;;
255)
 echo "Box closed"   ;;
esac

#Time Box:
#!/bin/sh
tim=$(dialog --stdout --title "A TimeBox" \
                    --timebox "Set the time:" 0 0 10 13 59)
case $? in
0)
  echo "You have set: $tim"   ;;
1)
  echo "You have pressed Cancel"  ;;
255)
  echo "Box closed"   ;;
esac

#### BIG EXAMPLE ####

#!/bin/sh
#A sample application using UNIX/Linux dialog utility from http://unstableme.blogspot.com/
#Auto-size with height and width = 0 of the dialog controls
file='/home/'$USER'/.bashrc'
tempfile1=/tmp/dialog_1_$$
tempfile2=/tmp/dialog_2_$$
tempfile3=/tmp/dialog_3_$$

trap "rm -f $tempfile1 $tempfile2 $tempfile3" 0 1 2 5 15

_edit () {
   items=$(awk -F\: '{print $1,$2}' $file)
   dialog --title "A Sample Application" \
          --menu "What you want to change :" 0 0 0 $items 2> $tempfile1

   retval=$?
   parameter=$(cat $tempfile1)

   [ $retval -eq 0 ] && tochange=$parameter || return 1

   val=$(awk -F\: -v x=$tochange '$1==x {print $2}' $file)
   dialog --clear --title "Inputbox - Test" \
          --inputbox "Enter new value($tochange)" 0 0 $val 2> $tempfile2

   dialog --title "Confirmation"  --yesno "Commit ?" 0 0
   case $? in
       0) newval=$(cat $tempfile2)
          awk -v x=$tochange -v n=$newval '
               BEGIN {FS=OFS=":"}$1==x {$2=n} {print}
               ' $file > $file.tmp
          mv $file.tmp $file
       ;;
       1|255) dialog --infobox "No Changes done" 0 0
              sleep 2
   ;;
   esac
   dialog --textbox $file 0 0
}

_main () {
   dialog --title "A sample application" \
           --menu "Please choose an option:" 15 55 5 \
                   1 "View the config file" \
                   2 "Edit config file" \
                   3 "Exit from this menu" 2> $tempfile3

   retv=$?
   choice=$(cat $tempfile3)
   [ $retv -eq 1 -o $retv -eq 255 ] && exit

   case $choice in
       1) dialog --textbox $file 0 0
          _main
           ;;
       2) _edit
          _main ;;
       3) exit ;;
   esac
}

_main
