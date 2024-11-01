#!/bin/bash

latest_file=$(ls -l *.c | awk '$1 ~ /^-/ && $(NF-1) ~ /:/ {print $(NF-3)"-"$(NF-2)"-"$(NF-1), $NF}')

create_sortable_dates(){
    local dates=""
    while IFS='' read -r line; do
      extract_date=$(echo "$line" | awk '{print $1}')
      filename=$(echo "$line" | awk '{printf $2}')
      formatted_date=$(date -j -f "%d-%b-%H:%M" "$extract_date" +"%Y-%m-%dT%H:%M:%SZ")
      dates+="$formatted_date $filename"$'\n'
    done <<< "$1"
    echo "$dates"
}

dates=$(create_sortable_dates "$latest_file")
file_to_run=$(echo "$dates" | sort -r | awk 'NR==1 {print $2}')



echo ""
echo "Running: $file_to_run"
echo "--------"

#remove old file if it exists
rm -f "${file_to_run::-2}"

gcc -std=c17 -Wall -Wextra -pedantic -o ${file_to_run::-2} ${file_to_run} #> /dev/null 2>&1

./${file_to_run::-2}

echo ""
echo "--------"
echo "Completed: $file_to_run"
echo "--------"
 

