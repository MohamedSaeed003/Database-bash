#!/user/bin/bash

select_options=("Press 1 to Select all" "Press 2 to Select with condition" "Press 3 to Exit")
condition_options=("Press 1 to Select where name is equal to a value" "Press 2 to Select where salary is greater than a value" "Press 3 to to Select where salary is less than a value" "Press 4 to Exit")

print_soptions() {
    echo "Select Options:"
    for option in "${select_options[@]}"; do
        echo "$option"
    done
}
print_coptions() {
    echo "Condition Options:"
    for option in "${condition_options[@]}"; do
        echo "$option"
    done
}
print_separator() {
    echo "----------------------------------------"
}
print_separator

read -p "Enter the name of the table to select data from: " table_name
cd Databases/$db_name

declare -i number_of_columns=$(awk -F: '{if (NR == 1) print NF}' $table_name)
for (( i=1; i<=number_of_columns; i++ ))
    do
        column_names[$i]=$(awk -F: -v col="$i" '{if (NR == col) print $2}' .$table_name.meta_data)

        column_types[$i]=$(awk -F: -v col="$i" '{if (NR == col) print $3}' .$table_name.meta_data)

done

if [[ -f $table_name ]]; then
    echo "Connected successfully to table '$table_name'"

    select select_option in "${select_options[@]}"
    do
        case $REPLY in
            1)
                cat "$table_name"
                print_separator
                print_soptions
                print_separator
                ;;
            2)
                select condition_option in "${condition_options[@]}"
                do
                    case $REPLY in
                        1)
                            read -p "Enter the name of column to filter by: " column_name
                            if [[ " ${column_names[@]} " =~ " ${column_name} " ]]; then
                                col_index=-1
                                for idx in "${!column_names[@]}"; do
                                    if [[ "${column_names[$idx]}" == "$column_name" ]]; then
                                        col_index=$idx
                                        break
                                    fi
                                done
                            else
                                echo "Column '$column_name' does not exist in the table."
                                continue
                            fi
                            read -p "Enter the value to match: " value
                            result=$(awk -F: -v col="$col_index" -v val="$value" 'NR==1 || $col==val' "$table_name")
                            if [[ "$result" == "$(awk -F: 'NR==1' "$table_name")" ]]; then
                                echo "No matching records found."
                            else
                                echo "$result"
                            fi
                            print_separator
                            print_coptions
                            print_separator
                            ;;
                        2)  read -p "Enter the name of column to filter by: " column_name
                            if [[ " ${column_names[@]} " =~ " ${column_name} " ]]; then
                                col_index=-1
                                for idx in "${!column_names[@]}"; do
                                    if [[ "${column_names[$idx]}" == "$column_name" ]]; then
                                        col_index=$idx
                                        break
                                    fi
                                done
                                if [[ "${column_types[$col_index]}" != "int" ]]; then
                                    echo "Cannot compare: Column '$column_name' is not of type int."
                                    continue
                                fi
                            else
                                echo "Column '$column_name' does not exist in the table."
                                continue
                            fi
                            read -p "Enter the minimum salary: " min_salary
                            awk -F: -v col="$col_index" -v min="$min_salary" 'NR==1 || $col > min' "$table_name"
                            print_separator
                            print_coptions
                            print_separator
                            ;;
                        3)
                            read -p "Enter the name of column to filter by: " column_name
                            if [[ " ${column_names[@]} " =~ " ${column_name} " ]]; then
                                col_index=-1
                                for idx in "${!column_names[@]}"; do
                                    if [[ "${column_names[$idx]}" == "$column_name" ]]; then
                                        col_index=$idx
                                        break
                                    fi
                                done
                                if [[ "${column_types[$col_index]}" != "int" ]]; then
                                    echo "Cannot compare: Column '$column_name' is not of type int."
                                    continue
                                fi
                            else
                                echo "Column '$column_name' does not exist in the table."
                                continue
                            fi
                            read -p "Enter the maximum salary: " max_salary
                            awk -F: -v col="$col_index" -v max="$max_salary" 'NR==1 || $col < max' "$table_name"
                            print_separator
                            print_coptions
                            print_separator
                            ;;
                        4)
                            echo "Exiting from select options..."
                            break
                            ;;
                        *)
                            echo "Invalid option. Please try again."
                            ;;    
                    esac        
                done
                print_separator
                print_soptions
                print_separator
                ;;
            3)
                echo "Exiting from table $table_name..."
                break
                ;;
            *)
                echo "Invalid option. Please try again."
                ;;
        esac
    done
    
else
    echo "Table '$table_name' does not exist."
fi
cd ..; cd ..