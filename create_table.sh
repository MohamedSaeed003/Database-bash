#!/bin/bash

cd Databases/$db_name

read -p "enter your table name: " table_name
if [[ -f $table_name ]]
then
    echo "the table named '$table_name' already exist "
    exit 1
fi

read -p "enter your column number: " col_numbers

columns_line=""

meta_data_file=".$table_name.meta_data"
> "$meta_data_file"

# Check for primary key after collecting column info
pk_set=0
for (( i=1; i<=col_numbers; i++ ))
do
    read -p "enter column $i name: " col_name
    read -p "enter column $i data type (int or string only): " col_type

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

# Create the table file with column names in the first line (colon-separated)
echo "$columns_line" > "$table_name"
cd ..; cd ..

# The table file is now ready for data insertion.
# Each subsequent line will be added by your insert script, containing row data (colon-separated).
