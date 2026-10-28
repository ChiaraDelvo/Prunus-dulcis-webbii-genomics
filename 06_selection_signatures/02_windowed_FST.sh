#!/usr/bin/env bash

VCF=<DP9_Hap2_set1.vcf>

PW="../metadata/K1_Pw_IDs.txt"
PD="../metadata/K2_Pd_IDs.txt"

# VCFtools v0.1.14

vcftools \
    --vcf "${VCF}" \
    --weir-fst-pop "${PW}" \
    --weir-fst-pop "${PD}" \
    --fst-window-size 10000 \
    --fst-window-step 5000 \
    --out DP9H2_Pw_vs_Pd_FST_WS10k_SS5k


############################################################
# Downstream filtering
############################################################

# Windows containing fewer than 10 variants were excluded
# from downstream selection-signal analyses.
#
# WEIGHTED_FST was used as the window-level FST statistic.
