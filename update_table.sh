#!/usr/bin/bash

print_u_options(){
    echo "1) update by primary key"
    echo "2) update all similar values in one column"
    echo "3) exit"
}
print_separator(){
    echo "----------------------------------"
}

cd Databases/"$db_name"

while true
do
    read -p "enter table name to update: " table_name
    if [[ -f "$table_name" ]]
    then
        echo "table named '$table_name' is exist "
        break
    else
        echo "table named '$table_name' is not exist "
        continue
    fi
done

meta_file=".$table_name.meta_data"
pk_name=$(grep '^PK:' "$meta_file" | cut -d':' -f2)
header=($(head -1 "$table_name" | tr ':' ' '))

# Get PK column index
for i in "${!header[@]}"
do
    if [ "${header[$i]}" == "$pk_name" ]
    then
        pk_col=$((i + 1))
        break
    fi
done

echo "select an option:"
select option in "update by primary key" "update all similar values in one column" "exit"
do
    case $REPLY in
    1 )
        while true
        do   
            echo
            read -r -p "enter primary key value to update its row: " pk_value

            matching_row=$(awk -F':' -v col="$pk_col" -v val="$pk_value" 'NR > 1 && $col == val { print $0; exit }' "$table_name")

            if [ -z "$matching_row" ]
            then
                echo
                echo "no row found with primary key = '$pk_value'"
                continue
            else
                break
            fi
        done

        while true
        do
            echo
            read -r -p "enter column name needed to update: " column_to_update
            read -r -p "enter new value for '$column_to_update': " new_value

            update_col_index=-1
            for i in "${!header[@]}"
            do
                if [ "${header[$i]}" == "$column_to_update" ]
                then
                    update_col_index=$((i + 1))
                    break
                fi
            done

            if [ "$column_to_update" == "$pk_name" ]
            then
                echo
                echo "primary key column '$pk_name' cannot be updated"
                continue

            elif [ "$update_col_index" -eq -1 ]
            then
                echo
                echo "column '$column_to_update' is not exist"
                continue
            fi

            expected_type=$(awk -F: -v col="$column_to_update" '
                $2 == col { print $3; exit }
                $1 == col { print $2; exit } 
            ' "$meta_file")

            echo
            echo "expected data type is '$expected_type'"

            if [[ "$expected_type" == "int" && ! "$new_value" =~ ^[0-9]+$ ]]
            then
                echo
                echo "invalid input expected an integer."
                continue
            elif [[ "$expected_type" == "string" ]]
            then
                if [[ "$new_value" =~ ^[0-9]+$ ]]
                then
                    echo
                    echo "invalid input expected a string."
                    continue
                fi
                if [[ "$new_value" =~ [^a-zA-Z0-9_[:space:]] ]]
                then
                    echo
                    echo "invalid input: avoid special characters. Use letters, numbers, _ only"
                    continue
                fi
            fi

            # Passed all checks, perform update
            temp_file=$(mktemp)
            awk -F':' -v pkcol="$pk_col" -v pk="$pk_value" -v col="$update_col_index" -v new="$new_value" 'BEGIN { OFS=":" }
            NR == 1 { print; next }
            $pkcol == pk { $col = new }
            { print }
            ' "$table_name" > "$temp_file" && mv "$temp_file" "$table_name"

            echo
            echo "row which $pk_name = '$pk_value' updated successfully"
            break
        done
        print_separator
        print_u_options
        print_separator
        ;;

    2 )
        while true
        do
            echo
            read -r -p "enter column name to match values in: " match_column
            read -r -p "enter value to match (old value): " old_value
            read -r -p "enter the new value to update with: " new_value

            match_col_index=-1
            for i in "${!header[@]}"
            do
                if [ "${header[$i]}" == "$match_column" ]
                then
                    match_col_index=$((i + 1))
                    break
                fi
            done

            if [[ "$match_col_index" -eq -1 ]]
            then
                echo "column '$match_column' is not exist"
                continue
            fi

            if [ "$match_column" == "$pk_name" ]
            then
                echo
                echo "you cannot update the primary key column '$pk_name'"
                continue
            fi

            expected_type=$(awk -F: -v col="$match_column" '
                $2 == col { print $3; exit }
                $1 == col { print $2; exit }
            ' "$meta_file")

            echo
            echo "expected data type is '$expected_type'"

            if [[ "$expected_type" == "int" && ! "$new_value" =~ ^[0-9]+$ ]]
            then
                echo "invalid input: expected integer."
                continue
            elif [[ "$expected_type" == "string" ]]
            then
                if [[ "$new_value" =~ ^[0-9]+$ ]]
                then
                    echo "invalid input expected a string."
                    continue
                fi
                if [[ "$new_value" =~ [^a-zA-Z0-9_[:space:]] ]]
                then
                    echo "invalid input: avoid special characters. Use letters, numbers, _ only"
                    continue
                fi
            fi

            # Perform update
            temp_file=$(mktemp)
            awk -F':' -v col="$match_col_index" -v old="$old_value" -v new="$new_value" 'BEGIN { OFS=":" }
            NR == 1 { print; next }
            $col == old { $col = new }
            { print }
            ' "$table_name" > "$temp_file" && mv "$temp_file" "$table_name"

            echo
            echo "all rows where '$match_column' = '$old_value' updated to '$new_value' successfully."
            break
        done
        print_separator
        print_u_options
        print_separator
        ;;

    3 )
        echo "exit from update"
        break
        ;;
    * )
        echo "invalid option"
        ;;
    esac
done

cd ..; cd ..
#   this comment is last thing   
