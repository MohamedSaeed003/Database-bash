#! /user/bin/bash


read -p "enter table name need to update " table_name
read -p "enter column name " search_col
read -p "enter value to update it " search_val
read -p "enter the new value " new_val


header=$(head -n 1 "$table_name")
col_index=0
index=1

for col in $(echo "$header")
do
    if [ "$col" == "$search_col" ]
    then
        col_index=$index
        break
    fi
    index=$((index + 1))
done
