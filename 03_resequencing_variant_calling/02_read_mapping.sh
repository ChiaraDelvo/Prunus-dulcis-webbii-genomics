#!/usr/bin/env bash

# Align trimmed paired-end reads with Minimap2 and sort the BAM with samtools.
# The short-read preset is -x sr. Each sample receives a read group.
# The sample name is the filename without _1.tr.fq.gz, so identifiers
# that contain underscores stay intact.
#
# Both tools are run from Biocontainers images. The project directory
# is mounted at /data inside the container.
#
# Containers:
#   Minimap2   2.28   quay.io/biocontainers/minimap2:2.28--h577a1d6_4
#   samtools   1.21   quay.io/biocontainers/samtools:1.21--h96c455f_1

TRIM_DIR=TrimmedOutput/Trimmed_files
REF_DIR=Reference
ALN_DIR=alignment
REF_FASTA=${REF_DIR}/TU_1.fasta
REF_MMI=${REF_DIR}/TU_1.mmi
MINIMAP2_IMG=quay.io/biocontainers/minimap2:2.28--h577a1d6_4
SAMTOOLS_IMG=quay.io/biocontainers/samtools:1.21--h96c455f_1

mkdir -p "${ALN_DIR}"

if [ ! -f "${REF_MMI}" ]; then
    docker run --rm \
        -v "${PWD}:/data" \
        -w /data \
        --user "$(id -u):$(id -g)" \
        "${MINIMAP2_IMG}" \
        minimap2 -d "/data/${REF_MMI}" "/data/${REF_FASTA}"
fi

for R1 in "${TRIM_DIR}"/*_1.tr.fq.gz; do
    [ -e "${R1}" ] || continue

    SAMPLE=$(basename "${R1}" _1.tr.fq.gz)
    R2="${TRIM_DIR}/${SAMPLE}_2.tr.fq.gz"
    [ -f "${R2}" ] || continue

    SAM_OUT="${ALN_DIR}/${SAMPLE}.sam"
    BAM_OUT="${ALN_DIR}/${SAMPLE}.sorted.bam"

    docker run --rm \
        -v "${PWD}:/data" \
        -w /data \
        --user "$(id -u):$(id -g)" \
        "${MINIMAP2_IMG}" \
        minimap2 -t 30 -a -R "@RG\tID:${SAMPLE}\tSM:${SAMPLE}" -x sr \
            "/data/${REF_MMI}" "/data/${R1}" "/data/${R2}" \
        > "${SAM_OUT}"

    docker run --rm \
        -v "${PWD}:/data" \
        -w /data \
        --user "$(id -u):$(id -g)" \
        "${SAMTOOLS_IMG}" \
        samtools sort -@ 10 -o "/data/${BAM_OUT}" "/data/${SAM_OUT}"

    rm "${SAM_OUT}"
done
