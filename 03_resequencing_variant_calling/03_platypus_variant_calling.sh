#!/usr/bin/env bash

REF=<REFERENCE_FASTA>
BAM_LIST=<BAM_LIST>
OUT=<OUTPUT_VCF>

python Platypus.py callVariants \
    --bamFiles="${BAM_LIST}" \
    --refFile="${REF}" \
    --output="${OUT}" \
    --minMapQual=30 \
    --minReads=4 \
    --minBaseQual=30 \
    --filterDuplicates=0

# Platypus version: 0.8.1.1
#
# TODO [BIOINFORMATICIAN]:
# Verify the Platypus executable/path and the exact syntax of the
# original command.
