#!/usr/bin/env bash

# Convert coordinate-sorted resequencing BAM files to RPGC-normalized
# bigWig coverage tracks for the Tuono_Hap2 Sf haplotype.
# These BAM files are the resequencing alignments, not the WGBS BAMs.
#
# The project directory is mounted at /project inside the container.
#
# Containers:
#   deepTools   3.5.6   quay.io/biocontainers/deeptools:3.5.6--pyhdfd78af_0

BIN_SIZE=50
EFFECTIVE_GENOME_SIZE=267641598
THREADS=10
BAM_DIR=sorted_bam
OUTPUT_DIR=coverage
DEEPTOOLS_IMAGE=quay.io/biocontainers/deeptools:3.5.6--pyhdfd78af_0

mkdir -p "${OUTPUT_DIR}"

for BAM_PATH in "${BAM_DIR}"/*.sorted.bam; do
    [ -e "${BAM_PATH}" ] || continue

    BAM_FILENAME=$(basename "${BAM_PATH}")
    BASE_NAME="${BAM_FILENAME%.bam}"

    docker run --rm \
        -v "${PWD}:/project" \
        -w /project \
        "${DEEPTOOLS_IMAGE}" \
        bamCoverage \
            -b "/project/${BAM_PATH}" \
            -o "/project/${OUTPUT_DIR}/${BASE_NAME}.bw" \
            --binSize "${BIN_SIZE}" \
            --normalizeUsing RPGC \
            --effectiveGenomeSize "${EFFECTIVE_GENOME_SIZE}" \
            -p "${THREADS}"
done
