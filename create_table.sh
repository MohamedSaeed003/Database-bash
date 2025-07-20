#! /user/bin/bash

cd Databases/$db_name

read -p "enter your table name: " table_name
if [[ -f $table_name ]]
then
    echo "the table named '$table_name' already exist "
    exit 1
fi

read -p "enter your column number: " col_numbers

columns_line=""
datatypes_line=""


for (( i=1; i<=col_numbers; i++ ))
do
    read -p "enter column $i name: " col_name
    read -p "enter column $i data type (int or string only): " col_type
    columns+=("$col_name")
    datatypes+=("$col_type")

    if [[ $i == 1 ]]
    then
        columns_line="$col_name"
        datatypes_line="$col_type"
    else
        columns_line="$columns_line:$col_name"
        datatypes_line="$datatypes_line:$col_type"
    fi
done

echo "$datatypes_line" > ".$table_name"
echo "$columns_line" > "$table_name"
echo "$datatypes_line" >> "$table_name"
