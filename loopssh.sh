##In process


USR=root
declare -a ssh=($USR,IP1,PASS1 $USR,IP2,PASS2)
pos=0
ele=2
pattern=USR
newssh=( `cat "newssh" `)
for c in ssh
    do

        echo  ${#ssh[@]} 
        echo "Number of elements in the array"
        echo ${#ssh[$pos]} 
        echo "Number of characters in the third element of the array"
        echo ${ssh[@]:$pos:$ele} 
        echo "extract 2 elements starting from the position 3"
        echo ${ssh[@]/PASS2/PASS3} 
        echo "searches for ssh in an array elements, and replace"
        echo "${ssh[@]}" "," "$USR,IP3,PASS3" 
        echo "Add an element"
        unset ssh[$ele] 
        echo $ssh
        echo "Make null third element"
        echo ${ssh[@]:0:$ele} ${ssh[@]:$(($ele + 1))}
        echo "Remove the third element completely"
        declare -a patter=( ${ssh[@]/*$pattern*/} ) 
        echo $patter
        echo "Remove with patter $USR with or without something after or later"
        ssh=("${ssh[@]}""," "${newssh[@]}") 
        echo $ssh
        echo "Concatenation of elements of a file newssh"
        IFS=","; set -- $c; 
        echo $1
        echo $2
        echo $3
    done






