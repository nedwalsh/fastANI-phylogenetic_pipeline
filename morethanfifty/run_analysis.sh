#!/bin/bash
module load fastani
# module load mash
source_dir="$1"
file_size="$2"
dest_base_dir="scripts_fastani/subset/"
echo $dest_base_dir
if [ ! -d "$dest_base_dir" ]; then
        mkdir "$dest_base_dir"
fi
slurmout="slurmout/"
if [ ! -d "$slurmout" ]; then
        mkdir "$slurmout"
fi
#break script
if [ ! -n "$(find "$source_dir" -maxdepth 1 -type f)" ]; then
    echo "Source directory is empty."
    exit 1
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
echo "Files moved successfully."
for query_1 in "${dest_base_dir}"*; do
        for query_2 in "${dest_base_dir}"*; do
                echo "sbatch multiple_fastANI_pipeline.q $query_1 $query_2"
                sbatch multiple_fastANI_pipeline.q $query_1 $query_2
        done
done
