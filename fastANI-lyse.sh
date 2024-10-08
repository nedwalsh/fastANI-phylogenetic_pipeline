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

if [ "$num" -gt 50]; then
        src/run_split_analysis.sh $source_dir
else
        src/fastANI_pipeline.q $source_dir
fi
