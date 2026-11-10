#!/usr/bin/env bash

# Reconstruct S-locus transcripts with StringTie.
# The full alignment is assembled first. Guided and de novo assemblies
# then use the BAM restricted to the S locus (--rf, -j 3). Those two
# GTFs are merged with the haplotype annotation.
# Repeat for the other haplotypes by changing GENOME_DIR and GTF_FILE.
#
# StringTie is run from a Biocontainers image.
#
# Containers:
#   StringTie   2.2.3   quay.io/biocontainers/stringtie:2.2.3--h29c0135_1

GENOME_DIR=References/DP9_Hap1
GTF_FILE=DP9_Hap1_annotation.gtf
BAM_DIR=03.Mapped
S_LOCUS_DIR=S_locus_bam
OUT_DIR=04.StringTie
STRINGTIE_IMG=quay.io/biocontainers/stringtie:2.2.3--h29c0135_1

mkdir -p "${OUT_DIR}"

############################################################
# Full-alignment assembly
############################################################

for BAM_PATH in "${BAM_DIR}"/*Aligned.sortedByCoord.out.bam; do
    [ -e "${BAM_PATH}" ] || continue

    BAM_FILENAME=$(basename "${BAM_PATH}")
    SAMPLE=${BAM_FILENAME%Aligned.sortedByCoord.out.bam}

    docker run --rm \
        -u "$(id -u):$(id -g)" \
        -v "${OUT_DIR}:/out" \
        -v "${BAM_DIR}:/mapped:ro" \
        -v "${GENOME_DIR}:/ref:ro" \
        "${STRINGTIE_IMG}" \
        stringtie "/mapped/${BAM_FILENAME}" \
            --rf \
            -G "/ref/${GTF_FILE}" \
            -o "/out/${SAMPLE}.gtf" \
            -p 1 \
            -v
done

############################################################
# S-locus guided and de novo assembly, then merge
############################################################
# S_locus_bam holds the alignments restricted to the S locus.

for BAM_PATH in "${S_LOCUS_DIR}"/*.bam; do
    [ -e "${BAM_PATH}" ] || continue

    BAM_FILENAME=$(basename "${BAM_PATH}")
    SAMPLE=$(basename "${BAM_FILENAME}" .bam)

    docker run --rm \
        -u "$(id -u):$(id -g)" \
        -v "${OUT_DIR}:/out" \
        -v "${S_LOCUS_DIR}:/in:ro" \
        -v "${GENOME_DIR}:/ref:ro" \
        "${STRINGTIE_IMG}" \
        stringtie "/in/${BAM_FILENAME}" \
            --rf \
            -G "/ref/${GTF_FILE}" \
            -o "/out/Ref_${SAMPLE}.gtf" \
            -p 1 \
            -j 3 \
            -v

    docker run --rm \
        -u "$(id -u):$(id -g)" \
        -v "${OUT_DIR}:/out" \
        -v "${S_LOCUS_DIR}:/in:ro" \
        "${STRINGTIE_IMG}" \
        stringtie "/in/${BAM_FILENAME}" \
            --rf \
            -o "/out/NoRef_${SAMPLE}.gtf" \
            -p 1 \
            -j 3 \
            -v

    docker run --rm \
        -u "$(id -u):$(id -g)" \
        -v "${OUT_DIR}:/out" \
        -v "${GENOME_DIR}:/ref:ro" \
        "${STRINGTIE_IMG}" \
        stringtie --merge \
            -G "/ref/${GTF_FILE}" \
            -p 1 \
            -v \
            -o "/out/${SAMPLE}_merged.gtf" \
            "/out/Ref_${SAMPLE}.gtf" \
            "/out/NoRef_${SAMPLE}.gtf"
done
