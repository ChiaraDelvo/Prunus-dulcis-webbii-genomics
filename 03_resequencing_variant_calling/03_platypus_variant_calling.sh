#!/usr/bin/env bash

# Joint variant calling with Platypus v0.8.1.1.
# Every sorted BAM in the alignment directory is passed as one
# comma-separated list. Duplicates are retained.
#
# Platypus is run from the conda environment platypus.
# REF= Tuono_Hap1 or DP9_Hap2

BASE_DIR="."
ALN_DIR="${BASE_DIR}/alignment"
REF_FASTA="${BASE_DIR}/Reference/${REF}.fasta"
OUT_DIR="${BASE_DIR}/variantCalling"
OUT_VCF="${OUT_DIR}/Variant_calling_Platypus_${REF}.vcf"

mkdir -p "${OUT_DIR}"

BAM_LIST=$(printf '%s,' "${ALN_DIR}"/*.sorted.bam)
BAM_LIST=${BAM_LIST%,}

conda run -n platypus --no-capture-output \
    platypus callVariants \
        --bamFiles="${BAM_LIST}" \
        --refFile="${REF_FASTA}" \
        --output="${OUT_VCF}" \
        --nCPU=20 \
        --minReads=4 \
        --minMapQual=30 \
        --minBaseQual=30 \
        --filterDuplicates=0
