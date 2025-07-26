#!/bin/bash
shopt -s extglob

while true
do

read -r -p "enter the name of the new database: " db_name   # -r read input with \ without remove it bash do >> al\i >> ali with -r al\i >> al\i
table_name="${table_name,,}"  # Convert to lowercase

if [ -z "$db_name" ]                # -z check is database name is empty just pressed enter
then
    echo "invalid database name to be empty "
    continue

elif [[ "$db_name" == *"/"* || "$db_name" == *'\'* || "$db_name" == *"-"* ]]  #  backslash skipping
then
    echo "invalid database name cannot contain '/' or '\' or '-' use _ instead "
    continue

elif  echo "$db_name" | grep -qE '[_-]{2,}'   # reject name with 2 or more _ or 2 or more
then
    echo "invalid database name contain 2 or more consecutive of _ & -" 
    continue

elif [ -e "Databases/$db_name" ]      # -e is for file or directory
then
    echo "database '$db_name' already exists "
    continue

elif [[ "$db_name" =~ ^[0-9]+$ ]]
then
    echo "invalid database name cannot be only numbers "        # this depend on user need 
    continue

elif ! [[ "$db_name" =~ [a-zA-Z] ]]
then
    echo "invalid database name must contain at least letter "  # this depend on user need 
    continue

else

case $db_name in

+([A-Za-z0-9_-]) )
                mkdir -p Databases/"$db_name"
                echo "database $db_name has been created successfully"
                break
                ;;
                
*)    
                echo "avoid using spaces & special characters use letters, numbers, _ only "
                continue
                ;;   
esac

fi

done
 

 # loop is last thing add this comment is last thing          