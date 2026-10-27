#!/usr/bin/env bash

VCF=<SET2_VCF>
KEEP=<POPULATION_ID_FILE>
OUT=<OUTPUT_PREFIX>

# VCFtools v0.1.14

vcftools \
    --vcf "${VCF}" \
    --keep "${KEEP}" \
    --window-pi 50000 \
    --out "${OUT}"
