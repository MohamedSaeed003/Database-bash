#! /user/bin/bash

read -p "Enter the name of the table: " table_name
cd Databases/$db_name
if [ -f "$table_name" ]; then

    declare -i number_of_columns=$(awk -F: '{if (NR == 1) print NF}' $table_name)
    echo "Number of columns in the table: $number_of_columns"

    for (( i=1; i<=number_of_columns; i++ ))
    do
        column_names[$i]=$(awk -F: -v col="$i" '{if (NR == col) print $2}' .$table_name.meta_data)
        echo "Column $i: ${column_names[$i]}"
        column_types[$i]=$(awk -F: -v col="$i" '{if (NR == col) print $3}' .$table_name.meta_data)
        echo "Type of column $i: ${column_types[$i]}"
    done

    primary_key=$(awk -F: '{if ($1 == "PK") print $2}' .$table_name.meta_data)
    echo "Primary key for the table: $primary_key"

    declare -a row_values

    for (( i=1; i<=number_of_columns; i++ ))
    do
        col_name="${column_names[$i]}"
        col_type="${column_types[$i]}"
        while true; do
            read -r -p "Enter value for column '$col_name' (type: $col_type): " value
            if [[ "$col_name" == "$primary_key" ]]; then
                
                pk_index=$(awk -F: -v pk="$primary_key" 'NR==1 {for(i=1;i<=NF;i++) if($i==pk) print i}' "$table_name")
               
                if awk -F: -v idx="$pk_index" -v val="$value" 'NR>1 {if($idx==val) found=1} END{exit !found}' "$table_name"
                then
                    echo "Error: Value '$value' for primary key '$primary_key' already exists. Please enter a unique value."
                    continue
                fi
            fi
            if [[ "$col_type" == "int" ]]; then
                if [[ "$value" =~ ^-?[0-9]+$ ]]; then
                    row_values[$i]="$value"
                    break
                else
                    echo "Invalid input. Please enter an integer."
                fi
            elif [[ "$col_type" == "string" ]]; then
                if [[ "$value" =~ ^[a-zA-Z0-9_" "]+$ ]]; then
                    row_values[$i]="$value"
                    break
                else
                    echo "Invalid input. Please enter a valid string (letters, numbers, spaces, underscores)."
                fi
            else
                row_values[$i]="$value"
                break
            fi
        done
    done

    row_line=$(IFS=:; echo "${row_values[*]}")
    echo "$row_line" >> "$table_name"
    echo "Row inserted successfully."
    row_values=()

else
    echo "Table '$table_name' does not exist in database '$db_name'."
fi

cd ..; cd ..