#!/usr/bin/env bash

# Convert MethylDackel bedGraph files to bigWig for pyGenomeTracks.
# Each bedGraph is sorted by chromosome and start, then converted.
# bedGraphToBigWig needs a two-column chrom.sizes file. The FASTA index
# has five columns, so only the sequence name and length are kept.
# The sorted bedGraph is removed after the bigWig is written.
# Repeat for the other haplotypes by changing INPUT_DIR, OUTPUT_DIR,
# and FAI.
#
# Sorting runs on the host. The project directory is mounted at /project
# inside the container.
#
# Containers:
#   bedGraphToBigWig  quay.io/biocontainers/ucsc-bedgraphtobigwig:482--hdc0a859_0

INPUT_DIR=MethylDackelFraction/DP9_1
OUTPUT_DIR=MethylDackelFraction/DP9_1/BW
FAI=BWAindex/DP9_1/DP9_1.fasta.fai
CHROM_SIZES=${OUTPUT_DIR}/DP9_1.chrom.sizes
UCSC_IMAGE=quay.io/biocontainers/ucsc-bedgraphtobigwig:482--hdc0a859_0

mkdir -p "${OUTPUT_DIR}"
cut -f1,2 "${FAI}" > "${CHROM_SIZES}"

for BG_PATH in "${INPUT_DIR}"/*.bedGraph; do
    [ -e "${BG_PATH}" ] || continue

    BASE_NAME=$(basename "${BG_PATH}" .bedGraph)
    SORTED_BG="${OUTPUT_DIR}/${BASE_NAME}.sorted.bedGraph"

    LC_COLLATE=C sort -k1,1 -k2,2n "${BG_PATH}" > "${SORTED_BG}"

    docker run --rm \
        -v "${PWD}:/project" \
        -w /project \
        "${UCSC_IMAGE}" \
        bedGraphToBigWig \
            "/project/${SORTED_BG}" \
            "/project/${CHROM_SIZES}" \
            "/project/${OUTPUT_DIR}/${BASE_NAME}.bw"

    rm "${SORTED_BG}"
done
