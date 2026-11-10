#!/usr/bin/env bash

# Trim paired-end reads with Trim Galore and run FastQC on the results.
# Reads shorter than 35 bp after trimming are discarded.
# Adapter and quality trimming use the Trim Galore defaults.
#
# The project directory is mounted at /project inside the container.
#
# Containers:
#   Trim Galore   latest   ghcr.io/felixkrueger/trimgalore:latest

INPUT_DIR=rawdata
OUTPUT_DIR=1.TrimmedData
IMAGE_NAME=ghcr.io/felixkrueger/trimgalore:latest

mkdir -p "${OUTPUT_DIR}"

for R1_PATH in "${INPUT_DIR}"/*_1.fq.gz; do
    [ -e "${R1_PATH}" ] || continue

    R1_FILENAME=$(basename "${R1_PATH}")
    SAMPLE=$(basename "${R1_FILENAME}" _1.fq.gz)
    R2_PATH="${INPUT_DIR}/${SAMPLE}_2.fq.gz"
    [ -f "${R2_PATH}" ] || continue

    docker run --rm \
        -v "${PWD}:/project" \
        -w /project \
        "${IMAGE_NAME}" \
        trim_galore \
            --paired \
            --fastqc \
            --length 35 \
            -o "/project/${OUTPUT_DIR}" \
            "/project/${R1_PATH}" \
            "/project/${R2_PATH}"
done
