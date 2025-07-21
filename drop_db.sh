#!/bin/bash

read -r -p "enter name of database to drop: " db_name
cd Databases
if [ -d "$db_name" ]
then
    rm -rf -- "$db_name"  # -- after -rf tell it dont take any other options so he could delete -dbname as he got - as extra option
    echo "Database '$db_name' has been dropped successfully "
else
    echo " no such database named '$db_name' "
fi
cd ..

