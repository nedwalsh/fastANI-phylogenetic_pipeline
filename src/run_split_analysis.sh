#!/bin/bash

source_dir="$1"
pathdir="$2"
temp="$3"
output="$4"

file_size=50

dest_base_dir="${temp}subset/"
echo $dest_base_dir
if [ ! -d "$dest_base_dir" ]; then
        mkdir "$dest_base_dir"
fi

file_count=0
dir_count=1
# Loop through the files in the source directory
dest_path="${dest_base_dir}query${dir_count}.txt"
>$dest_path
for file in "$source_dir"*; do
        echo $file
    printf '%s\n' "$(readlink -f "${file}")" >> "${dest_path}"
    ((file_count++))
    if [ $((file_count % file_size)) -eq 0 ]; then
        ((dir_count++))
        dest_path="${dest_base_dir}query${dir_count}.txt"
                >"$dest_path"
    fi
done

fileoutput="${output}final_fastani_dist.tsv"
>$fileoutput

for query_1 in "${dest_base_dir}"*; do
        for query_2 in "${dest_base_dir}"*; do
                echo "sbatch multiple_fastANI_pipeline.q $query_1 $query_2 $temp $output"
                sbatch ${pathdir}/src/multiple_fastANI_pipeline.q $query_1 $query_2 $temp $output
        done
done
