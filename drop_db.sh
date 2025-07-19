#!/bin/bash

read -p "Enter the name of the database to drop: " db_name
cd Databases
if [ -d "$db_name" ]; then
    rm -rf "$db_name"
    echo "Database '$db_name' has been dropped successfully."
else
    echo "There is no such database '$db_name'."
fi
cd ..
