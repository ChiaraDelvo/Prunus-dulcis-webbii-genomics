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
