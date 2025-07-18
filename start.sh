#! /usr/bin/bash

options=("Create a new Database" "List all Databases" "Connect to a Database" "Drop a Database" "Exit")
select option in "${options[@]}"
do
    case $option in
        "Create a new Database")
           . ./create_db.sh
            ;;
        "List all Databases")
            . ./list_db.sh
            ;;
        "Connect to a Database")
            . ./connect_db.sh
            ;;
        "Drop a Database")
            . ./drop_db.sh
            ;;
        "Exit")
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
    echo "----------------------------------"
    echo "Select another option:"
done
echo "Exiting..."
exit 0