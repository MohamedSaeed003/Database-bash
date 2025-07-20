#!/bin/bash

db_options=("Press 1 to Create Table" "Press 2 to List Tables" "Press 3 to Drop Table" "Press 4 to Insert Data" "Press 5 to Select Data" "Press 6 to Delete Data" "Press 7 to Update Table" "Press 8 to Exit")

print_db_options() {
    for option in "${db_options[@]}"; do
        echo "$option"
    done
}
print_separator() {
    echo "----------------------------------"
}
read -p "Enter the name of the database to connect: " db_name
cd Databases
if [ -d "$db_name" ]; then
    echo "Connected successfully to database '$db_name'"
    print_separator
    cd ..

    select db_option in "${db_options[@]}"
    do
        case $REPLY in
            1)
                . ./create_table.sh
                print_separator
                print_db_options
                ;;
            2)
                . ./list_tables.sh
                print_separator
                print_db_options
                ;;
            3)
                . ./drop_table.sh
                print_separator
                print_db_options
                ;;
            4)
                . ./insert_data.sh
                print_separator
                print_db_options
                ;;
            5)
                . ./select_data.sh
                print_separator
                print_db_options
                ;;
            6)
                . ./delete_data.sh
                print_separator
                print_db_options
                ;;
            7)
                . ./update_table.sh
                print_separator
                print_db_options
                ;;
            8)
                echo "Exiting from database $db_name..."
                break
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
    esac
        print_separator
    done
else
    echo "there is no such database '$db_name'."
fi
