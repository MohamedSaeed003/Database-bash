#! /usr/bin/bash

print_separator() {
    echo "----------------------------------"
}

PS3="Please select an option: "
echo "Welcome to the Database Management System"
print_separator

options=("Press 1 to Create a new Database" "Press 2 to List all Databases" "Press 3 to Connect to a Database" "Press 4 to Drop a Database" "Press 5 to Exit")

print_options(){
    for option in "${options[@]}"; do
        echo "$option"
    done
}

select option in "${options[@]}"
do
    case $REPLY in
        1)
           . ./create_db.sh
            print_separator
            print_options
            ;;
        2)
            . ./list_db.sh
            print_separator
            print_options
            ;;
        3)
            . ./connect_db.sh
            print_separator
            print_options
            ;;
        4)
            . ./drop_db.sh
            print_separator
            print_options
            ;;
       5)
            echo "Exiting the Database Management System..."
            break
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
    print_separator
done