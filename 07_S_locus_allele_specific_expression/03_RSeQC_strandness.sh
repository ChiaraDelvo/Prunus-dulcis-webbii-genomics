#!/usr/bin/env bash

# Assess RNA-seq library strandness with RSeQC infer_experiment.py.
# One million reads are sampled from each coordinate-sorted BAM.
# The reference is a BED12 gene model of the same haplotype.
# Repeat for the other haplotypes by changing GENOME_DIR and BED_FILE.
#
# RSeQC is run from a Biocontainers image.
#
# Containers:
#   RSeQC   5.0.4   quay.io/biocontainers/rseqc:5.0.4--pyhdfd78af_1

BAM_DIR=03.Mapped
GENOME_DIR=References/DP9_Hap1
BED_FILE=DP9_Hap1.bed
RSEQC_IMG=quay.io/biocontainers/rseqc:5.0.4--pyhdfd78af_1

for BAM_PATH in "${BAM_DIR}"/*Aligned.sortedByCoord.out.bam; do
    [ -e "${BAM_PATH}" ] || continue

    BAM_FILENAME=$(basename "${BAM_PATH}")

    docker run --rm \
        -u "$(id -u):$(id -g)" \
        -v "${BAM_DIR}:/bam:ro" \
        -v "${GENOME_DIR}:/genome:ro" \
        "${RSEQC_IMG}" \
        infer_experiment.py \
            -i "/bam/${BAM_FILENAME}" \
            -r "/genome/${BED_FILE}" \
            -s 1000000
done
