#!/bin/bash
echo "Listing all databases:"
cd Databases

ls -F | grep '/' | sed 's/\/$//'
cd ..
echo "End of database list."