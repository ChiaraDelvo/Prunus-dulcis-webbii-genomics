#!/usr/bin/env bash

VCF=<DP9_Hap2_set1.vcf>

PW="../metadata/K1_Pw_IDs.txt"
PD="../metadata/K2_Pd_IDs.txt"


############################################################
# MYB61
# Gene region + 3 kb upstream + 1 kb downstream
############################################################

vcftools \
    --vcf "${VCF}" \
    --chr Chr6_DP9_Hap2 \
    --from-bp 31395509 \
    --to-bp 31401081 \
    --weir-fst-pop "${PW}" \
    --weir-fst-pop "${PD}" \
    --out DP9H2_FST_MYB61_Pw_vs_Pd


############################################################
# COMT
# Gene region + 3 kb upstream + 1 kb downstream
############################################################

vcftools \
    --vcf "${VCF}" \
    --chr Chr2_DP9_Hap2 \
    --from-bp 15056052 \
    --to-bp 15064941 \
    --weir-fst-pop "${PW}" \
    --weir-fst-pop "${PD}" \
    --out DP9H2_FST_COMT_Pw_vs_Pd


############################################################
# F5H
# Gene region + 3 kb upstream + 1 kb downstream
############################################################

vcftools \
    --vcf "${VCF}" \
    --chr Chr7_DP9_Hap2 \
    --from-bp 20968958 \
    --to-bp 20974724 \
    --weir-fst-pop "${PW}" \
    --weir-fst-pop "${PD}" \
    --out DP9H2_FST_F5H_Pw_vs_Pd
