#!/usr/bin/env bash

VCF=<INPUT_VCF>
CHR0=<CHROMOSOME_0_NAME>
OUT=<OUTPUT_PREFIX>

vcftools \
    --gzvcf "${VCF}" \
    --not-chr "${CHR0}" \
    --remove-indels \
    --min-alleles 2 \
    --max-alleles 2 \
    --minQ 30 \
    --max-missing 0.9 \
    --maf 0.05 \
    --recode \
    --recode-INFO-all \
    --out "${OUT}_set1"

# NOTE:
# Variant filtering in the original study was performed using
# SNP & Variation Suite (SVS) v8.8.3.
#
# This VCFtools command provides an open-source implementation of
# the equivalent filtering thresholds and was included to facilitate
# reproducibility of the filtering procedure.
