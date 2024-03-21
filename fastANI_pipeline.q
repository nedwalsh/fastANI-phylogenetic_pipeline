#!/bin/bash
#SBATCH --job-name=FastAni
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=32G
#SBATCH --time=0:30:00
#SBATCH --account=OD-226706

target_dir="$1"

temp="${target_dir}temp"

if [ ! -d "$temp" ]; then
    mkdir "$temp"
fi

output_dir="${target_dir}output"

if [ ! -d "$output_dir" ]; then
    mkdir "$output_dir"
fi

output_basename=$(basename "$target_dir")
gen_name_list="${target_dir}${output_basename}_genomepaths.txt"


> "$gen_name_list"
for i in ${target_dir}/Genomes/*; do
    echo $(readlink -f "$i") >> ${gen_name_list}
done

module load fastani

fastani_outname="${target_dir}${output_basename}_fastANI.out"

fastANI --ql $gen_name_list --rl $gen_name_list -o $fastani_outname

final_outname="${target_dir}${output_basename}_fastani_edited.tsv"

while IFS=$'\t' read -r col1 col2 col3; do
    # Extract basenames using basename command
    basename1=$(basename "$col1" | sed 's/\.fna//' | cut -d'_' -f1,2)
    basename2=$(basename "$col2" | sed 's/\.fna//' | cut -d'_' -f1,2)

    # Print just the basenames
    echo -e "$basename1\t$basename2\t$col3\t" >> "$final_outname"
done < "$fastani_outname"

rm -r "$temp"
