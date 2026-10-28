#!/usr/bin/env bash

VCF=<DP9_HAP2_SET1_VCF>

PW="../metadata/K1_Pw_IDs.txt"
PD="../metadata/K2_Pd_IDs.txt"


############################################################
# Nucleotide diversity: P. webbii
############################################################

vcftools \
    --vcf "${VCF}" \
    --keep "${PW}" \
    --window-pi 10000 \
    --window-pi-step 5000 \
    --out PI_Pw_WS10k_SS5k


############################################################
# Nucleotide diversity: P. dulcis
############################################################

vcftools \
    --vcf "${VCF}" \
    --keep "${PD}" \
    --window-pi 10000 \
    --window-pi-step 5000 \
    --out PI_Pd_WS10k_SS5k


############################################################
# ROD definition used downstream
############################################################

# ROD = 1 - (pi_query / pi_reference)
#
# P. dulcis:
# ROD_Pd = 1 - (pi_Pd / pi_Pw)
#
# P. webbii:
# ROD_Pw = 1 - (pi_Pw / pi_Pd)
#
# pi = 0 was assigned to monomorphic windows within each population.
#
# Windows with fewer than 10 variants in total across the two
# populations were excluded from downstream analyses.
#
# Only positive ROD values were considered when defining the
# upper 5% of the ROD distribution.
