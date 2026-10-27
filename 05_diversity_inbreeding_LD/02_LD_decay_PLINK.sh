#!/usr/bin/env bash

VCF=<SET1_VCF>
KEEP=<POPULATION_KEEP_FILE>
OUT=<OUTPUT_PREFIX>

# PLINK v1.9

plink \
    --vcf "${VCF}" \
    --allow-extra-chr \
    --chr-set 8 no-xy no-mt \
    --allow-no-sex \
    --keep "${KEEP}" \
    --maf 0.01 \
    --r2 gz \
    --ld-window-r2 0 \
    --out "${OUT}"

# TODO:
# Add the exact values used for:
#   --ld-window
#   --ld-window-kb
# if these options were explicitly specified in the original analysis.
