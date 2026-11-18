#!/usr/bin/env bash

# Extract CpG, CHG, and CHH methylation fractions from the
# duplicate-marked BAM files. CpG output is the MethylDackel default.
# --fraction writes the methylation fraction instead of read counts.
# The BAM index written by 03_Picard_MarkDuplicates.sh must sit next to each BAM.
# Repeat for the other haplotypes by changing BAM_DIR, REFERENCE_FASTA,
# and OUTPUT_DIR.
#
# The project directory is mounted at /project inside the container.
#
# Containers:
#   MethylDackel   0.6.1   quay.io/biocontainers/methyldackel:0.6.1--h577a1d6_9

CORES=8
BAM_DIR=BWAmeth/DP9_1/Dedup
REFERENCE_FASTA=BWAindex/DP9_1/DP9_1.fasta
OUTPUT_DIR=MethylDackelFraction/DP9_1
METHYLDACKEL_IMAGE=quay.io/biocontainers/methyldackel:0.6.1--h577a1d6_9

mkdir -p "${OUTPUT_DIR}"

for BAM_PATH in "${BAM_DIR}"/*.sorted.markdup.bam; do
    [ -e "${BAM_PATH}" ] || continue

    SAMPLE=$(basename "${BAM_PATH}" .sorted.markdup.bam)

    docker run --rm \
        -v "${PWD}:/project" \
        -w /project \
        "${METHYLDACKEL_IMAGE}" \
        MethylDackel extract \
            --fraction \
            --CHG \
            --CHH \
            -p "${CORES}" \
            -o "/project/${OUTPUT_DIR}/${SAMPLE}" \
            "/project/${REFERENCE_FASTA}" \
            "/project/${BAM_PATH}"
done
