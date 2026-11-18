#!/usr/bin/env bash

# Trim raw paired-end resequencing reads with Trimmomatic.
# Quality threshold 20 drops low-quality bases from both ends.
# Reads shorter than 35 bp after trimming are discarded.
# Paired output is named *_1.tr.fq.gz and *_2.tr.fq.gz, which is the
# input read by 02_read_mapping.sh.
#
# Trimmomatic is run from a Biocontainers image. The working directory
# is mounted at /data inside the container.
#
# Containers:
#   Trimmomatic   0.39   quay.io/biocontainers/trimmomatic:0.39--0

THREADS=10
INPUT_DIR=rawdata
OUTPUT_DIR=TrimmedOutput/Trimmed_files
TRIMMOMATIC_IMAGE=quay.io/biocontainers/trimmomatic:0.39--0

mkdir -p "${OUTPUT_DIR}"

for R1_PATH in "${INPUT_DIR}"/*_1.fq.gz; do
    [ -e "${R1_PATH}" ] || continue

    R1_FILENAME=$(basename "${R1_PATH}")
    SAMPLE=$(basename "${R1_FILENAME}" _1.fq.gz)
    R2_PATH="${INPUT_DIR}/${SAMPLE}_2.fq.gz"
    [ -f "${R2_PATH}" ] || continue

    docker run --rm \
        -v "${PWD}:/data" \
        -w /data \
        "${TRIMMOMATIC_IMAGE}" \
        trimmomatic PE \
            -threads "${THREADS}" \
            -phred33 \
            "${R1_PATH}" "${R2_PATH}" \
            "${OUTPUT_DIR}/${SAMPLE}_1.tr.fq.gz" \
            "${OUTPUT_DIR}/${SAMPLE}_1.unpaired.fq.gz" \
            "${OUTPUT_DIR}/${SAMPLE}_2.tr.fq.gz" \
            "${OUTPUT_DIR}/${SAMPLE}_2.unpaired.fq.gz" \
            LEADING:20 TRAILING:20 MINLEN:35
done
