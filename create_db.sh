#!/bin/bash

read -p "Enter the name of the new database: " db_name

mkdir -p Databases/"$db_name"
echo "Creating database '$db_name'..."