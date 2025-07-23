#! /user/bin/bash

read -r -p "enter the name of the table to delete from: " table_name  

cd Databases/$db_name

if [ ! -f "$table_name" ]
then 

    echo "table named '$table_name' is not exist in '$db_name' database"

else
    echo "table named '$table_name'is exist."

read -r -p "enter the PK of data to delete: " id_to_delete

    if ! grep -q "^$id_to_delete:" "$table_name"
    then
        echo "no row found with PK '$id_to_delete'."
    else

        temp_file=$(mktemp)

        # Write header + filtered rows to temp file
        awk -v id="$id_to_delete" -F':' 'NR==1 || $1 != id' "$table_name" > "$temp_file"

        # Overwrite the original table file with the temp file
        mv "$temp_file" "$table_name"

        echo " row with PK '$id_to_delete' has been deleted successfully"


    fi

fi

cd ..; cd ..