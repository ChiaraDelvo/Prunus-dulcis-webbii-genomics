#!/usr/bin/env bash

VCF=<INPUT_VCF>
CHR0=<CHROMOSOME_0_NAME>
OUT=<OUTPUT_PREFIX>

# VCFtools v0.1.14
#
# NOTE:
# Variant filtering in the original study was performed using
# SNP & Variation Suite (SVS) v8.8.3.
#
# The commands below provide an open-source implementation of the
# corresponding filtering criteria using VCFtools.

############################################################
# SET1
# SNP call rate >= 90%
# MAF >= 0.05
############################################################

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


############################################################
# SET2
# SNP call rate >= 90%
# No MAF filtering
############################################################

vcftools \
    --gzvcf "${VCF}" \
    --not-chr "${CHR0}" \
    --remove-indels \
    --min-alleles 2 \
    --max-alleles 2 \
    --minQ 30 \
    --max-missing 0.9 \
    --recode \
    --recode-INFO-all \
    --out "${OUT}_set2"
