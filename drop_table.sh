#! /user/bin/bash

read -p  "enter tabel name to remove " rm_table
cd Databases/$db_name

if [[ -f $rm_table ]]; then
    rm -- $rm_table
    rm -- .$rm_table.meta_data
else
    echo "Table '$rm_table' does not exist."
fi

cd ..; cd ..