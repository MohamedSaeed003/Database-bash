#!/bin/bash
shopt -s extglob

read -r -p "enter the name of the new database: " db_name   # -r read input with \ without remove it bash do >> al\i >> ali with -r al\i >> al\i

if [ -z "$db_name" ]                # -z check is database name is empty just pressed enter
then
    echo "invalid database name to be empty "

elif [[ "$db_name" == *"/"* || "$db_name" == *'\'* ]]  #  backslash skipping
then
    echo "invalid database name cannot contain '/' or '\' use _ & - instead "

elif [[ "$db_name" =~ ^_{3,} || "$db_name" =~ ^-{3,} ]]     # =~ match this regex, reject name that start with 3 or more _ or 3 or more -
then
    echo "invalid database name contain 3 or more of _ & -" 

elif [ -e "Databases/$db_name" ]      # -e is for file or directory
then
    echo "database '$db_name' already exists "
    
else

case $db_name in
+(_) | +(-) )
                echo "invalid database name cannot be only _ or -" 
                ;;

+([A-Za-z0-9_-]) )
                mkdir -p Databases/"$db_name"
                echo "database $db_name has been created successfully"
                ;;
                
*)    
                echo "invalid database name: $db_name"
                echo "avoid using spaces & special characters use letters, numbers, _ & - only "
                ;;   
esac

fi

