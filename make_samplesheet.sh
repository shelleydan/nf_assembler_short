#!/bin/bash

# Usage:
# ./make_samplesheet.sh /path/to/fastqs samplesheet.csv

indir="${1:-.}"
outfile="${2:-samplesheet.csv}"

echo "sample_id,r1,r2" > "$outfile"

for r1 in "$indir"/*_1.fq.gz; do
    [ -e "$r1" ] || continue

    sample=$(basename "$r1" _1.fq.gz)
    r2="$indir/${sample}_2.fq.gz"

    if [ ! -f "$r2" ]; then
        echo "Warning: missing reverse read for ${sample}" >&2
        continue
    fi

    echo "${sample},$(realpath "$r1"),$(realpath "$r2")" >> "$outfile"
done

echo "Created $outfile"
