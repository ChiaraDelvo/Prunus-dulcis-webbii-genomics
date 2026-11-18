#!/usr/bin/env bash

# Quality-filter paired-end RNA-seq reads with fastp.
# Bases below Phred 20 are unqualified, and reads shorter than 35 bp
# are discarded. Adapter detection is the fastp default for paired reads.
# HTML and JSON reports are written next to the trimmed FASTQ files.
#
# fastp is run from a Biocontainers image. Input and output directories
# are mounted at /data/input and /data/output.
#
# Containers:
#   fastp   1.0.1   quay.io/biocontainers/fastp:1.0.1--heae3180_0
#
# Example:
#   docker run --rm -v $PWD:/data -w /data \
#     quay.io/biocontainers/fastp:1.0.1--heae3180_0 <command>

INPUT_DIR="Data"
OUTPUT_DIR="01.Trimmed"
FASTP_IMG="quay.io/biocontainers/fastp:1.0.1--heae3180_0"
THREADS=16
PHRED_QUALITY=20
MIN_LENGTH=35

mkdir -p "${OUTPUT_DIR}"

for R1_PATH in "${INPUT_DIR}"/*_1.fq.gz; do
    [ -e "${R1_PATH}" ] || continue

    R1_FILENAME=$(basename "${R1_PATH}")
    R2_FILENAME="${R1_FILENAME/_1.fq.gz/_2.fq.gz}"
    SAMPLE_PREFIX=$(basename "${R1_FILENAME}" _1.fq.gz)
    [ -f "${INPUT_DIR}/${R2_FILENAME}" ] || continue

    docker run --rm \
        -u "$(id -u):$(id -g)" \
        -v "${INPUT_DIR}:/data/input:ro" \
        -v "${OUTPUT_DIR}:/data/output:rw" \
        "${FASTP_IMG}" \
        fastp \
            -i "/data/input/${R1_FILENAME}" \
            -I "/data/input/${R2_FILENAME}" \
            -o "/data/output/${SAMPLE_PREFIX}_1.tr.fq.gz" \
            -O "/data/output/${SAMPLE_PREFIX}_2.tr.fq.gz" \
            --html "/data/output/${SAMPLE_PREFIX}.html" \
            --json "/data/output/${SAMPLE_PREFIX}.json" \
            --thread "${THREADS}" \
            --qualified_quality_phred "${PHRED_QUALITY}" \
            --length_required "${MIN_LENGTH}"
done
