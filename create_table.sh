#!/bin/bash

cd Databases/$db_name

#----------------------------start check table name ------------------------------------------------------
table_names_check=()  # Array to store table names

while true
do

read -r -p "enter your table name: " table_name

if [ -z "$table_name" ]             
then
    echo "invalid table name to be empty "
    continue

elif [[ "$table_name" == *"/"* || "$table_name" == *'\'* ]]  
then
    echo "invalid table name cannot contain '/' or '\' use _ & - instead "
    continue

elif  echo "$table_name" | grep -qE '[_-]{2,}'  
then
    echo "invalid table name contain 2 or more consecutive of _ & -" 
    continue

elif [ -f "$table_name" ]
then
    echo "table named '$table_name' already exists " 
    continue

elif [[ "$table_name" =~ ^[0-9]+$ ]]
then
    echo "invalid table name cannot be only numbers "        
    continue

elif ! [[ "$table_name" =~ [a-zA-Z] ]]
then
    echo "invalid table name must contain at least letter "  
    continue

elif [[ "$table_name" =~ [^a-zA-Z0-9_-] ]]
then
    echo "avoid using spaces & special characters use letters, numbers, _ & - only "
    continue

else
        echo "valid table name  $table_name "
        table_names_check+=("$table_name")

        break

fi
done
#----------------------------end check table name ------------------------------------------------------

#----------------------------start check col numbers ------------------------------------------------------

while true
do

read -r -p "enter how many columns: " col_numbers

if ! [[ "$col_numbers" =~ ^[0-9]+$ ]]
then
    echo "invalid input please enter numbers only"
    continue

elif [ "$col_numbers" -eq 0 ]
then
    echo "invalid input columns cannot be 0 "   
    continue

elif [ "$col_numbers" -gt 100 ]
then
    echo "invalid input max number of columns 100 "
    continue

else
    echo "you have $col_numbers columns"
    break

fi
done
#----------------------------end check col numbers ------------------------------------------------------


columns_line=""

meta_data_file=".$table_name.meta_data"
> "$meta_data_file"

# Check for primary key after collecting column info
pk_set=0
column_names_check=()  # Array to store column names
for (( i=1; i<=col_numbers; i++ ))
do

#----------------------------start check col name ------------------------------------------------------

    while true           
    do

    read -r -p "enter column $i name: " col_name

if [ -z "$col_name" ]             
then
    echo "invalid column name to be empty "
    continue

elif [[ "$col_name" == *"/"* || "$col_name" == *'\'* ]]  
then
    echo "invalid column name cannot contain '/' or '\' use _ & - instead "
    continue

elif  echo "$col_name" | grep -qE '[_-]{2,}'  
then
    echo "invalid column name contain 2 or more consecutive of _ & -" 
    continue

elif [[ " ${column_names_check[@]} " =~ " $col_name " ]]            
then
    echo "table column '$col_name' already exists "
    continue

elif [[ "$col_name" =~ ^[0-9]+$ ]]
then
    echo "invalid column name cannot be only numbers "        
    continue

elif ! [[ "$col_name" =~ [a-zA-Z] ]]
then
    echo "invalid column name must contain at least letter "  
    continue

elif [[ "$col_name" =~ [^a-zA-Z0-9_-] ]]
then
    echo "avoid using spaces & special characters use letters, numbers, _ & - only "
    continue

else
        echo "valid column name  $col_name "
        column_names_check+=("$col_name")
        break
 
fi
done

#----------------------------end check col name ------------------------------------------------------


    select col_type in "int" "string"
    do
       echo please enter column $i data type:
       case $col_type in
        int)
            col_type="int"
            break
            ;;
        string)
            col_type="string"
            break
            ;;
        *)
            echo "Invalid option. Please select 'int' or 'string'."
            continue
            ;;
        esac    
    done

    pk=""
    if [[ $pk_set -eq 0 ]]
    then
        while true
        do
        #----------------------------start check pk answer ------------------------------------------------------

            read -r -p "is column '$col_name' the primary key ? (yes/no)  " is_pk
            is_pk_lower=$(echo "$is_pk" | tr '[:upper:]' '[:lower:]')  # tr to normalize input

            if [[ "$is_pk_lower" == "yes" || "$is_pk_lower" == "y" ]]
            then
                pk="PK"
                pk_set=1
                break
            elif [[ "$is_pk_lower" == "no" || "$is_pk_lower" == "n" ]]
            then
                pk=""
                break
            else
                echo "Invalid input. Please enter yes or no."
            fi
            done
         #----------------------------end check pk answer ------------------------------------------------------

    fi

    if [[ $i == 1 ]]
    then
        columns_line="$col_name"
    else
        columns_line="$columns_line:$col_name"
    fi

    echo "$pk:$col_name:$col_type" >> "$meta_data_file"
done

if [[ $pk_set -eq 0 ]]
then
    echo "no primary key defined table will not be created "
    rm -f "$meta_data_file"
    cd ..; cd ..
    echo "table creation aborted "
    return
fi

echo "$columns_line" > "$table_name"
echo "table '$table_name' has been created successfully with primary key '$table_name' "
cd ..; cd ..


 #  this comment is last thing        