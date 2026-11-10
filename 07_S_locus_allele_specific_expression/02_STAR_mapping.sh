#!/usr/bin/env bash

# Build a STAR index for a haplotype assembly and align the trimmed
# RNA-seq libraries to it. Alignments are coordinate-sorted BAM files.
# Repeat with the other haplotype assemblies by changing GENOME_DIR,
# GENOME_FASTA, and GTF_FILE.
#
# STAR is run from a Biocontainers image. Reference, reads, and output
# directories are mounted separately.
#
# Containers:
#   STAR   2.7.11b   quay.io/biocontainers/star:2.7.11b--h5ca1c30_7

THREADS=10
GENOME_DIR=References/DP9_Hap1
GENOME_FASTA=DP9_Hap1_Final_Assembly.fasta
GTF_FILE=DP9_Hap1_annotation.gtf
STAR_INDEX_DIR=${GENOME_DIR}/index
READS=01.Trimmed
BAM_DIR=03.Mapped
STAR_IMG=quay.io/biocontainers/star:2.7.11b--h5ca1c30_7

mkdir -p "${STAR_INDEX_DIR}" "${BAM_DIR}"

############################################################
# Genome index
############################################################
# genomeSAindexNbases 13 suits the almond genome size.

docker run --rm \
    -u "$(id -u):$(id -g)" \
    -v "${GENOME_DIR}:/genome:ro" \
    -v "${STAR_INDEX_DIR}:/index" \
    --workdir /index \
    "${STAR_IMG}" \
    STAR \
        --runThreadN "${THREADS}" \
        --runMode genomeGenerate \
        --genomeDir /index \
        --genomeFastaFiles "/genome/${GENOME_FASTA}" \
        --sjdbGTFfile "/genome/${GTF_FILE}" \
        --genomeSAindexNbases 13

############################################################
# Alignment
############################################################

for R1_PATH in "${READS}"/*_1.tr.fq.gz; do
    [ -e "${R1_PATH}" ] || continue

    R1_FILENAME=$(basename "${R1_PATH}")
    R2_FILENAME="${R1_FILENAME/_1.tr.fq.gz/_2.tr.fq.gz}"
    SAMPLE=$(basename "${R1_FILENAME}" _1.tr.fq.gz)
    [ -f "${READS}/${R2_FILENAME}" ] || continue

    docker run --rm \
        -u "$(id -u):$(id -g)" \
        -v "${STAR_INDEX_DIR}:/index:ro" \
        -v "${READS}:/reads:ro" \
        -v "${BAM_DIR}:/output" \
        "${STAR_IMG}" \
        STAR \
            --runThreadN "${THREADS}" \
            --genomeDir /index \
            --readFilesIn "/reads/${R1_FILENAME}" "/reads/${R2_FILENAME}" \
            --readFilesCommand zcat \
            --outFileNamePrefix "/output/${SAMPLE}_vsDP9_Hap1" \
            --outSAMtype BAM SortedByCoordinate \
            --twopassMode Basic \
            --outSAMstrandField intronMotif
done
