source_dir="$1"

num=$(find $source_dir -type f | wc -l)

if [ ! -n "$(find "$source_dir" -maxdepth 1 -type f)" ]; then
    echo "Source directory is empty."
    exit 1
fi

temp="temp/"
if [ ! -d "$temp" ]; then
    mkdir "$temp"
fi
output="output/"
if [ ! -d "$output" ]; then
    mkdir "$output"
fi

for i in "$source_dir"*; do 
    echo "$(basename $i | cut -d"_" -f1-2),$(head -n 1 $i | cut -d"," -f1 | cut -d" " -f2-5)"; done > output/species_info.csv

name="$(dirname "${BASH_SOURCE[0]}")"

if [ "$num" -gt 50 ]; then
        chmod +x ${name}/src/run_split_analysis.sh
        ${name}/src/run_split_analysis.sh $source_dir
else
        chmod +x ${name}/src/fastANI_pipeline.q
        ${name}/src/fastANI_pipeline.q $source_dir
fi
