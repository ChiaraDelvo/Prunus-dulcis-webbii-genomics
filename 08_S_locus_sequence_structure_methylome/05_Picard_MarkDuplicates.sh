#!/usr/bin/env bash

# Mark duplicate reads in the coordinate-sorted bwa-meth BAM files.
# Duplicates are flagged and left in the BAM. Picard default is
# REMOVE_DUPLICATES=false. A metrics file is written for each library.
# Repeat for the other haplotypes by changing BAM_DIR and OUTPUT_DIR.
#
# The project directory is mounted at /project inside the container.
#
# samtools indexes each duplicate-marked BAM. MethylDackel reads that
# index from the same directory.
#
# Containers:
#   Picard     3.4.0    quay.io/biocontainers/picard:3.4.0--hdfd78af_0
#   samtools   1.22.1   quay.io/biocontainers/samtools:1.22.1--h96c455f_0

BAM_DIR=BWAmeth/DP9_1
OUTPUT_DIR=BWAmeth/DP9_1/Dedup
PICARD_IMAGE=quay.io/biocontainers/picard:3.4.0--hdfd78af_0
SAMTOOLS_IMAGE=quay.io/biocontainers/samtools:1.22.1--h96c455f_0

mkdir -p "${OUTPUT_DIR}"

for BAM_PATH in "${BAM_DIR}"/*.sorted.bam; do
    [ -e "${BAM_PATH}" ] || continue

    BAM_FILENAME=$(basename "${BAM_PATH}")
    SAMPLE=$(basename "${BAM_FILENAME}" .sorted.bam)

    docker run --rm \
        -v "${PWD}:/project" \
        -w /project \
        "${PICARD_IMAGE}" \
        picard MarkDuplicates \
            I="/project/${BAM_PATH}" \
            O="/project/${OUTPUT_DIR}/${SAMPLE}.sorted.markdup.bam" \
            M="/project/${OUTPUT_DIR}/${SAMPLE}.sorted.markdup.metrics.txt"

    docker run --rm \
        -v "${PWD}:/project" \
        -w /project \
        "${SAMTOOLS_IMAGE}" \
        samtools index \
            "/project/${OUTPUT_DIR}/${SAMPLE}.sorted.markdup.bam"
done
