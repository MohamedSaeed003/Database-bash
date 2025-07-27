#!/usr/bin/bash

print_d_option(){
    echo "1) delete by primary key"
    echo "2) delete all rows except header"
    echo "3) exit"
}
print_separator(){
    echo "----------------------------------"
}

cd Databases/"$db_name"

while true
do
read -r -p "enter the name of the table to delete from: " table_name


meta_file=".$table_name.meta_data"

if [ ! -f "$table_name" ]
then
    echo "table named '$table_name' is not exist in '$db_name' database "
    continue
else
    echo "table named '$table_name' is exist in '$db_name' database "
    break
fi

done

echo "select an option:"
select option in "delete by primary key" "delete all rows except header" "exit"
do
    case $REPLY in

 1 )
    pk_name=$(grep '^PK:' "$meta_file" | cut -d':' -f2)  # get PK column name from metadata

    # find the column number of PK in header of the table
    pk_col=$(head -1 "$table_name" | awk -F':' -v pk="$pk_name" '
    {
        for (i=1; i<=NF; i++) {
            if ($i == pk) {
                print i;
                exit;
            }
        }
    }')

    if [ -z "$pk_col" ]
    then
        echo "primary key column '$pk_name' is not found in table "
    fi

    while true
    do

    read -r -p "enter the primary key value to delete: " id_to_delete

    found=$(awk -F':' -v col="$pk_col" -v val="$id_to_delete" 'NR > 1 && $col == val { found=1 } END { print found }' "$table_name")

    if [ "$found" != "1" ]
    then
        echo "no row found with primary key '$id_to_delete' in table"
        continue
    else
        break    
    fi
    done

    # Delete matching row by PK column (keep header)
    temp_file=$(mktemp)
    awk -F':' -v pkcol="$pk_col" -v id="$id_to_delete" 'NR==1 || $pkcol != id' "$table_name" > "$temp_file" && mv "$temp_file" "$table_name"

    echo "row with primary key $pk_name = '$id_to_delete' deleted successfully"
    print_separator
    print_d_option
    print_separator
    ;;
    
2 )
            head -n 1 "$table_name" > temp_file && mv temp_file "$table_name"
            echo "all rows deleted except header"
            print_separator
            print_d_option
            print_separator
            break
            ;;

3)
    echo "exit from delete"
    break
    ;;
*)
    echo "invalid option "
    ;;
    esac
done

    cd ..; cd ..

 #  this comment is last thing          