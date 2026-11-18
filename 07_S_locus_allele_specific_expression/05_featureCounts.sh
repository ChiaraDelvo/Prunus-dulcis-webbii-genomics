#!/usr/bin/env bash

# Count fragments on the merged StringTie annotation with featureCounts.
# -s 2 is reverse-stranded, matching the StringTie --rf assemblies.
# -p counts paired-end fragments. -Q 30 keeps reads with mapping
# quality of at least 30.
#
# featureCounts v1.6.0
# GTF_FILE is the StringTie --merge product. With one S-locus library,
# 04_StringTie_S_locus_annotation.sh copies it to this name.
# Repeat for the other haplotypes by changing GTF_FILE.

GTF_FILE=04.StringTie/DP9_Hap1_merged.gtf
BAM_DIR=03.Mapped
OUT_DIR=05.featureCounts
THREADS=5

mkdir -p "${OUT_DIR}"

for BAM_PATH in "${BAM_DIR}"/*Aligned.sortedByCoord.out.bam; do
    [ -e "${BAM_PATH}" ] || continue

    BAM_FILENAME=$(basename "${BAM_PATH}")
    SAMPLE=${BAM_FILENAME%Aligned.sortedByCoord.out.bam}

    featureCounts \
        -a "${GTF_FILE}" \
        -s 2 \
        -p \
        -T "${THREADS}" \
        -o "${OUT_DIR}/${SAMPLE}" \
        -Q 30 \
        "${BAM_DIR}/${BAM_FILENAME}"
done
