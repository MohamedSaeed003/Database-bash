#!/bin/bash

db_options=("Create Table" "List Tables" "Drop Table" "Insert Data" "Select Data" "Delete Data" "Update Table" "Exit")
read -p "Enter the name of the database to connect: " db_name
cd Databases
if [ -d "$db_name" ]; then
    echo "Connected successfully to database '$db_name'"
    cd ..

    select db_option in "${db_options[@]}"
    do
        case $db_option in
            "Create Table")
                . ./create_table.sh
                ;;
            "List Tables")
               . ./list_tables.sh
                ;;
            "Drop Table")
            . ./drop_table.sh
                ;;
            "Insert Data")
                . ./insert_data.sh
                ;;
            "Select Data")
                . ./select_data.sh
                ;;
            "Delete Data")
                . ./delete_data.sh
                ;;
            "Update Table")
                . ./update_table.sh
                ;;
            "Exit")
                echo "Exiting..."
                break
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
    esac
    done
else
    echo "there is no such database '$db_name'."
fi

cd ..