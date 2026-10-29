#!/usr/bin/env bash

INPUT=<SINGLE_COPY_ORTHOGROUP.fasta>
OUTPUT=<ALIGNED_ORTHOGROUP.fasta>

# MAFFT v7.526

mafft \
    --auto \
    "${INPUT}" \
    > "${OUTPUT}"

# TODO [BIOINFORMATICIAN]:
# Confirm the exact original MAFFT alignment strategy and parameters.
