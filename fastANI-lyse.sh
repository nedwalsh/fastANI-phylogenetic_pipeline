#!/bin/bash

source_dir="$1"

num=$(find $source_dir -type f | wc -l)


if [ ! -n "$(find "$source_dir" -maxdepth 1 -type f)" ]; then
    echo "Source directory is empty."
    exit 1
fi


if [ ! -d ".temp/" ]; then
    mkdir ".temp/"
fi

if [ ! -d "output/" ]; then
    mkdir "output/"
fi

dnum=$(find $temp -type d | wc -l)

output_basename=$(basename "$target_dir")
folderName="${output_basename}_${dnum}/"

output="output/${folderName}"
if [ ! -d "${output}" ]; then
    mkdir "${output}"
fi

temp=".temp/${folderName}"
if [ ! -d "${temp}" ]; then
    mkdir "${temp}"
fi

for i in "$source_dir"*; do 
    echo "$(basename $i | cut -d"_" -f1-2),$(head -n 1 $i | cut -d"," -f1 | cut -d" " -f2-5)"; done > output/species_info.csv

name="$(dirname "${BASH_SOURCE[0]}")"

if [ "$num" -gt 50 ]; then
        chmod +x ${name}/src/run_split_analysis.sh
        nohup ${name}/src/run_split_analysis.sh $source_dir $name $temp $output > info.txt 2>&1 &
else
        chmod +x ${name}/src/fastANI_pipeline.q
        nohup ${name}/src/fastANI_pipeline.q $source_dir $temp $output > info.txt 2>&1 &
fi
