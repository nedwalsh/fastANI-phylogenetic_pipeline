#!/bin/bash
#SBATCH --job-name=FastAni
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=16G
#SBATCH --time=0:30:00
#SBATCH --account=OD-######

target_dir="$1"
temp="$2"
output="$3"

num=$(find $temp -type d | wc -l)

gen_name_list="${temp}genomepaths.txt"
>"$gen_name_list"

for i in ${target_dir}*; do
    echo $(readlink -f "$i") >> ${gen_name_list}
done

module load fastani

fastani_outname="${output}fastANI.out"

fastANI --ql $gen_name_list --rl $gen_name_list -o $fastani_outname

final_outname="${output}final_fastani_dist.tsv"

while IFS=$'\t' read -r col1 col2 col3; do
    # Extract basenames using basename command
    basename1=$(basename "$col1" | sed 's/\.fna//' | cut -d'_' -f1,2)
    basename2=$(basename "$col2" | sed 's/\.fna//' | cut -d'_' -f1,2)

    # Print just the basenames
    echo -e "$basename1\t$basename2\t$col3\t" >> "$final_outname"
done < "$fastani_outname"

for i in "${target_dir}*"; do 
    echo "$(basename $i | cut -d"_" -f1-2),$(head -n 1 $i | cut -d"," -f1 | cut -d" " -f2-5)"; done > "${output}species_info.csv"
