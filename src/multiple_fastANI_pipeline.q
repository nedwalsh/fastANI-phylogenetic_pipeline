#!/bin/bash

#SBATCH --job-name=FastAni
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=16G
#SBATCH --time=0:40:00
#SBATCH --account=OD-########

target_script1="$1"
target_script2="$2"

temp=".temp/"

outname1=$(basename "$target_script1")
outname2=$(basename "$target_script2")
output_basename1="${outname1%.*}"
output_basename2="${outname2%.*}"
echo $output_basename1
echo $output_basename2
module load fastani
fastani_outname="${temp}${output_basename1}${output_basename2}_fastANI.out"
echo
fastANI --ql $target_script1 --rl $target_script2 -o $fastani_outname
final_outname="${output}${output_basename1}${output_basename2}_fastani_edited.tsv"
echo $final_outname
while IFS=$'\t' read -r col1 col2 col3; do
    # Extract basenames using basename command
    basename1=$(basename "$col1" | sed 's/\.fna//' | cut -d'_' -f1,2)
    basename2=$(basename "$col2" | sed 's/\.fna//' | cut -d'_' -f1,2)
    # Print just the basenames
    echo -e "$basename1\t$basename2\t$col3\t" >> "$final_outname"
done < "$fastani_outname"
