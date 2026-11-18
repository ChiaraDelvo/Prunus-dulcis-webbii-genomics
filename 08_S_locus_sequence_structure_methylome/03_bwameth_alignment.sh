#!/usr/bin/env bash

# Index a haplotype assembly with BWA-MEM2 and align the trimmed WGBS
# libraries to it. bwa-meth writes SAM to standard output. samtools
# converts each SAM to a coordinate-sorted BAM.
# Repeat for the other haplotype assemblies by changing REFERENCE_FASTA
# and OUTPUT_DIR.
#
# The project directory is mounted at /project inside the container.
# Trim Galore paired output is named *_1_val_1.fq.gz and *_2_val_2.fq.gz.
#
# Containers:
#   bwa-meth   0.2.9    quay.io/biocontainers/bwameth:0.2.9--pyh7e72e81_0
#   samtools   1.22.1   quay.io/biocontainers/samtools:1.22.1--h96c455f_0

CORES=10
INPUT_DIR=1.TrimmedData
OUTPUT_DIR=BWAmeth/DP9_1
REFERENCE_FASTA=BWAindex/DP9_1/DP9_1.fasta
BWAMETH_IMAGE=quay.io/biocontainers/bwameth:0.2.9--pyh7e72e81_0
SAMTOOLS_IMAGE=quay.io/biocontainers/samtools:1.22.1--h96c455f_0

mkdir -p "${OUTPUT_DIR}" "$(dirname "${REFERENCE_FASTA}")"

############################################################
# Reference index (BWA-MEM2)
############################################################

docker run --rm \
    -v "${PWD}:/project" \
    -w /project \
    "${BWAMETH_IMAGE}" \
    bwameth.py index-mem2 "/project/${REFERENCE_FASTA}"

############################################################
# Alignment and coordinate sorting
############################################################

for R1_PATH in "${INPUT_DIR}"/*_1_val_1.fq.gz; do
    [ -e "${R1_PATH}" ] || continue

    R1_FILENAME=$(basename "${R1_PATH}")
    SAMPLE=$(basename "${R1_FILENAME}" _1_val_1.fq.gz)
    R2_PATH="${INPUT_DIR}/${SAMPLE}_2_val_2.fq.gz"
    [ -f "${R2_PATH}" ] || continue

    docker run --rm \
        -v "${PWD}:/project" \
        -w /project \
        "${BWAMETH_IMAGE}" \
        bwameth.py \
            --reference "/project/${REFERENCE_FASTA}" \
            -t "${CORES}" \
            "/project/${R1_PATH}" \
            "/project/${R2_PATH}" \
        > "${OUTPUT_DIR}/${SAMPLE}.sam"

    docker run --rm \
        -v "${PWD}:/project" \
        -w /project \
        "${SAMTOOLS_IMAGE}" \
        samtools sort \
            -@ "${CORES}" \
            -o "/project/${OUTPUT_DIR}/${SAMPLE}.sorted.bam" \
            "/project/${OUTPUT_DIR}/${SAMPLE}.sam"
done
