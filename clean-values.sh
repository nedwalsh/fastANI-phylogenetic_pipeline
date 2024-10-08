#!/bin/bash
source_dir="$1"

for i in "$source_dir/*"; do 
    echo "$(basename $i | cut -d"_" -f1-2),$(head -n 1 $i | cut -d"," -f1 | cut -d" " -f2-3)"; done > species_info.csv
