#!/usr/bin/env bash

REF=<REFERENCE_FASTA>
R1=<TRIMMED_R1_FASTQ>
R2=<TRIMMED_R2_FASTQ>
OUT=<OUTPUT_PREFIX>

minimap2 \
    -x sr \
    "${REF}" \
    "${R1}" \
    "${R2}" \
    > "${OUT}.sam"

# TODO [BIOINFORMATICIAN]:
# Confirm the exact original command and add the commands/software used
# for SAM/BAM conversion, sorting and indexing, if these steps were
# performed separately.
