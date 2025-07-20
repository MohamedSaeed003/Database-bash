#! /user/bin/bash

read -p "enter tabel name to remove " rm_table

cd Databases/$db_name
rm $rm_table
rm .$rm_table.meta_data

cd ..; cd ..
echo "Table '$rm_table' has been removed successfully."