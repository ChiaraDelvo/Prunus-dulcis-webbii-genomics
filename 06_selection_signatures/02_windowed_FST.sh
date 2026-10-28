#!/usr/bin/env bash

VCF=<DP9_HAP2_SET1_VCF>

PW="../metadata/K1_Pw_IDs.txt"
PD="../metadata/K2_Pd_IDs.txt"

vcftools \
    --vcf "${VCF}" \
    --weir-fst-pop "${PW}" \
    --weir-fst-pop "${PD}" \
    --fst-window-size 10000 \
    --fst-window-step 5000 \
    --out Pw_vs_Pd_WS10k_SS5k


# Downstream filtering used for selection-signal definition:
# retain windows with N_VARIANTS >= 10.
#
# The WEIGHTED_FST statistic was used for downstream analyses.
