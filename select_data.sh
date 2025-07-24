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
get_column_index() {
    local column_name="$1"
    col_index=-1
    for idx in "${!column_names[@]}"; do
        if [[ "${column_names[$idx]}" == "$column_name" ]]; then
            col_index=$idx
            break
        fi
    done
}
print_separator

read -p "Enter the name of the table to select data from: " table_name
cd Databases/$db_name

if [[ -f $table_name ]]; then

    echo "Connected successfully to table '$table_name'"

    declare -i number_of_columns=$(awk -F: '{if (NR == 1) print NF}' $table_name)
    for (( i=1; i<=number_of_columns; i++ ))
    do
        column_names[$i]=$(awk -F: -v col="$i" '{if (NR == col) print $2}' .$table_name.meta_data)

        column_types[$i]=$(awk -F: -v col="$i" '{if (NR == col) print $3}' .$table_name.meta_data)
    done
    
    read -p "Do you want all columns? (y/n): " all_columns

    if [[ $all_columns != "y" && $all_columns != "Y" ]]; then
        echo "Available columns with indices:"
        for (( i=1; i<=number_of_columns; i++ ))
        do
            echo "$i: ${column_names[$i]}"
        done
        
        while true; do
            read -p "Enter the number of columns you want to select (1-$number_of_columns): " num_columns
            if [[ $num_columns =~ ^[0-9]+$ ]] && [[ $num_columns -gt 0 ]] && [[ $num_columns -le $number_of_columns ]]; then
                break
            else
                echo "Invalid input. Please enter a number between 1 and $number_of_columns."
            fi
        done

        declare -a selected_columns
        for (( i=1; i<=num_columns; i++ ))
        do
            while true; do
                read -p "Enter column index $i (1-$number_of_columns): " column_index
                
                if [[ $column_index =~ ^[0-9]+$ ]] && [[ $column_index -ge 1 ]] && [[ $column_index -le $number_of_columns ]]; then
                    selected_columns+=($column_index)
                    echo "Column ${column_names[$column_index]} selected"
                    break
                else
                    echo "Invalid index. Please enter a number between 1 and $number_of_columns."
                fi
            done
        done
    else
        selected_columns=($(seq 1 $number_of_columns))
    fi

    echo "You have selected the following columns: ${selected_columns[@]}"

    cut_selected_columns=$(IFS=, ; echo "${selected_columns[@]}")

    select select_option in "${select_options[@]}"
    do
        case $REPLY in
            1)
                cat "$table_name"| cut -d: -f"$cut_selected_columns"
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
                                get_column_index "$column_name"
                                if [[ $col_index -eq -1 ]]; then
                                    echo "Column '$column_name' does not exist in the table."
                                    continue
                                fi
                            fi
                            read -p "Enter the value to match: " value
                            result=$(awk -F: -v col="$col_index" -v val="$value" 'NR==1 || $col==val' "$table_name")
                            if [[ "$result" == "$(awk -F: 'NR==1' "$table_name")" ]]; then
                                echo "No matching records found."
                            else
                                echo "$result" | cut -d: -f"$cut_selected_columns"
                            fi
                            print_separator
                            print_coptions
                            print_separator
                            ;;
                        2)  read -p "Enter the name of column to filter by: " column_name
                
                                get_column_index "$column_name"
                                if [[ $col_index -eq -1 ]]; then
                                    echo "Column '$column_name' does not exist in the table."
                                    continue
                                fi
                                if [[ "${column_types[$col_index]}" != "int" ]]; then
                                    echo "Cannot compare: Column '$column_name' is not of type int."
                                    continue
                                fi
                            read -p "Enter the minimum value: " min_value
                            awk -F: -v col="$col_index" -v min="$min_value" 'NR==1 || $col > min' "$table_name" | cut -d: -f"$cut_selected_columns"
                            print_separator
                            print_coptions
                            print_separator
                            ;;
                        3)
                            read -p "Enter the name of column to filter by: " column_name
                            
                                get_column_index "$column_name"
                                if [[ $col_index -eq -1 ]]; then
                                    echo "Column '$column_name' does not exist in the table."
                                    continue
                                fi
                                if [[ "${column_types[$col_index]}" != "int" ]]; then
                                    echo "Cannot compare: Column '$column_name' is not of type int."
                                    continue
                                fi
                            read -p "Enter the maximum value: " max_value
                            awk -F: -v col="$col_index" -v max="$max_value" 'NR==1 || $col < max' "$table_name"| cut -d: -f"$cut_selected_columns"
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
                selected_columns=()
                
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