#!/usr/bin/env bash

REF=<REFERENCE_HAPLOTYPE.fasta>
QRY=<QUERY_HAPLOTYPE.fasta>

# Minimap2 v2.24
# Pairwise whole-genome alignment

minimap2 \
    -ax asm5 \
    "${REF}" \
    "${QRY}" \
    > alignment.sam


############################################################
# SyRI v1.6.3
############################################################

syri \
    -c alignment.sam \
    -r "${REF}" \
    -q "${QRY}" \
    <ADDITIONAL_PARAMETERS>

# Pairwise comparisons:
#
# DP9_Hap1  vs DP9_Hap2
# DP9_Hap2  vs Tuono_Hap1
# Tuono_Hap1 vs Tuono_Hap2
#
# TODO [BIOINFORMATICIAN]:
# Add the exact original SyRI command and any SAM/BAM preprocessing.
