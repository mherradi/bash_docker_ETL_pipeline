#!/bin/bash
# Script initialization
# ========================================================================================================================
TODAY=$(date +%F)
LOG="logs/run_$TODAY.log" # logs/run_2026-10-07.log

ID=0  # every valid csv processed increments this counter.


# Creating directories and initializing the report
# ========================================================================================================================

mkdir -p result archive errors trash logs input output # -p flag ensures that no error is thrown if the directory already exists.

[ -s "result/report_$TODAY.csv" ] || echo "id,date,city,sum" > "result/report_$TODAY.csv"
[ -s "output/report.csv" ] || echo "id,date,city,reason,count" > "output/report.csv"


# Creating the logging function
# ========================================================================================================================

log() {
    echo "$1" | tee -a "$LOG"    # tee  displays the text in the terminal and write it into LOG file
}






# Processing temporary and junk files.
# ========================================================================================================================

for file in incoming/*.temp; do
    [ -e "$file" ] || continue
    mv "$file" "trash/"
    log "[$(date +%H:%M)] INFO: moved $(basename "$file") to trash/"

done

for file in input/*.temp; do
    [ -e "$file" ] || continue
    mv "$file" "trash/"
    log "[$(date +%H:%M)] INFO: moved $(basename "$file") to trash/"

done


# Fix the reason column header in the CSV files if necessary.
# ========================================================================================================================

for file in input/*.csv; do
    [ -e "$file" ] || continue
    if head -n 1 "$file" | grep -q 'category'; then
        sed -i 's/category/reason/g' "$file"
        log "[$(date +%H:%M)] INFO: header fixed in $(basename "$file")"
    else
        log "[$(date +%H:%M)] INFO: Valid header in $(basename "$file")"
    fi

done


# Processing valid CSV files.
# ========================================================================================================================

process_file(){
    
    local file="$1"
    local name
    name=$(basename "$file")


    if head -n 1 "$file" | grep -q "unit_price"; then

        log "[$(date +%H:%M)] INFO: job started"
        log "[$(date +%H:%M)] INFO: reading incoming/$name"
        
        local city sum
        city=$(awk -F',' 'NR == 2 {print $5}' "$file")  # captures the city name.
        sum=$(awk -F',' 'NR>1 {total += $3*$4} END {printf "%.2f", total}' "$file")

        ID=$((ID + 1))

        echo "$ID,$TODAY,$city,$sum" >> "result/report_$city_do$TODAY.csv"
        mv   "$file" "archive/$(basename "$file" .csv)_$TODAY.csv"

        log "[$(date +%H:%M)] INFO: sales sum $sum"
        log "[$(date +%H:%M)] INFO: archived as $(basename "$file" .csv)_$TODAY.csv"

    else 
        mv "$file" "errors/"
        log "[$(date +%H:%M)] ERROR: missing column 'unit_price' in $name"
    
    fi
    
    log "[$(date +%H:%M)] INFO: job finished"
    
    

    

}


process_returns(){

    local file="$1"
    local name
    name=$(basename "$file")

    if head -n 1 "$file" | grep -q "reason"; then

        log "[$(date +%H:%M)] INFO: returns processing started"
        log "[$(date +%H:%M)] INFO: reading input/$name"

        local city defective wrong_item changed_mind

        city=$(awk -F',' 'NR == 2 {print $4}' "$file")  # captures the city name.
        defective=$(awk -F',' 'NR>1 && $3 == "defective"    {count++} END {print count+0}' "$file")
        wrong_item=$(awk -F',' 'NR>1 && $3 == "wrong_item"   {count++} END {print count+0}' "$file")
        changed_mind=$(awk -F',' 'NR>1 && $3 == "changed_mind" {count++} END {print count+0}' "$file")


        ID=$((ID + 1))
        echo "$ID,$TODAY,$city,defective,$defective" >> "output/report.csv"
        ID=$((ID + 1))
        echo "$ID,$TODAY,$city,wrong_item,$wrong_item" >> "output/report.csv"
        ID=$((ID + 1))
        echo "$ID,$TODAY,$city,changed_mind,$changed_mind" >> "output/report.csv"

        mv   "$file" "archive/$(basename "$file" .csv)_$TODAY.csv"

    else 
        mv "$file" "errors/"
        log "[$(date +%H:%M)] ERROR: missing column 'reason' in $name"
    
    fi
    
    log "[$(date +%H:%M)] INFO: returns processing finished"
    
    

}


# The final loop: connecting everything.
# ========================================================================================================================

for file in incoming/*.csv; do
    [ -e "$file" ] || continue
    process_file "$file"
done


for file in input/*.csv; do
    [ -e "$file" ] || continue
    process_returns "$file"
done
