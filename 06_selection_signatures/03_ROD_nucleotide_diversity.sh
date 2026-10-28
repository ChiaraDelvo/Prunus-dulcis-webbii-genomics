#!/usr/bin/env bash

VCF=<DP9_Hap2_set1.vcf>

PW="../metadata/K1_Pw_IDs.txt"
PD="../metadata/K2_Pd_IDs.txt"

# VCFtools v0.1.14


############################################################
# Nucleotide diversity: P. webbii
############################################################

vcftools \
    --vcf "${VCF}" \
    --keep "${PW}" \
    --window-pi 10000 \
    --window-pi-step 5000 \
    --out DP9H2_PI_Pw_WS10k_SS5k


############################################################
# Nucleotide diversity: P. dulcis
############################################################

vcftools \
    --vcf "${VCF}" \
    --keep "${PD}" \
    --window-pi 10000 \
    --window-pi-step 5000 \
    --out DP9H2_PI_Pd_WS10k_SS5k


############################################################
# Reduction of diversity
############################################################

# ROD = 1 - (pi_query / pi_reference)
#
# Selection scan in P. dulcis:
#   ROD_Pd = 1 - (pi_Pd / pi_Pw)
#
# Selection scan in P. webbii:
#   ROD_Pw = 1 - (pi_Pw / pi_Pd)
#
# A value of pi = 0 was assigned to monomorphic windows
# within each population.
#
# Windows containing fewer than 10 variants in total across
# both populations were excluded from downstream analyses.
#
# Only positive ROD values were considered when identifying
# windows in the upper percentile of the ROD distribution.
