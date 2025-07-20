#!/bin/bash

cd Databases/$db_name

read -p "enter your table name: " table_name
if [[ -f $table_name ]]
then
    echo "the table named '$table_name' already exist "
    exit 1
fi

read -p "enter how many columns: " col_numbers

columns_line=""

meta_data_file=".$table_name.meta_data"
> "$meta_data_file"

# Check for primary key after collecting column info
pk_set=0
for (( i=1; i<=col_numbers; i++ ))
do
    read -p "enter column $i name: " col_name

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
    if [[ $pk_set -eq 0 ]]; then
        read -p "Is column '$col_name' the primary key? (y/n): " is_pk
        if [[ "$is_pk" == "y" || "$is_pk" == "Y" ]]; then
            pk="PK"
            pk_set=1
        fi
    fi

    if [[ $i == 1 ]]
    then
        columns_line="$col_name"
    else
        columns_line="$columns_line:$col_name"
    fi

    echo "$pk:$col_name:$col_type" >> "$meta_data_file"
done

if [[ $pk_set -eq 0 ]]; then
    echo "Error: No primary key defined. Table will not be created."
    rm -f "$meta_data_file"
    cd ..; cd ..
    echo "Table creation aborted."
    return
fi

echo "$columns_line" > "$table_name"
echo "Table '$table_name' has been created successfully with primary key defined."
cd ..; cd ..
