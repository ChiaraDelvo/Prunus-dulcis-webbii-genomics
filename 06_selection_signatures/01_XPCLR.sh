#!/usr/bin/env bash

# XP-CLR v1.1.2
# Harding implementation: https://github.com/hardingnj/xpclr
#
# Input:
#   DP9_Hap2_set1 VCF
#
# Population files:
#   K1_Pw_IDs.txt
#   K2_Pd_IDs.txt
#
# Chromosome-specific recombination rates were calculated from:
#   - physical chromosome lengths from the DP9_Hap2 assembly
#   - genetic-map lengths reported by Gomez et al. (2026)
#
# Formula:
#   rrate (M/bp) = genetic_length_cM / (100 * chromosome_length_bp)
#
# equivalent to:
#   rrate (M/bp) = (cM/Mb) * 1e-8


VCF=<DP9_Hap2_set1.vcf>

PW="../metadata/K1_Pw_IDs.txt"
PD="../metadata/K2_Pd_IDs.txt"

mkdir -p XPCLR_output


C_values=(Chr1_DP9_Hap2 Chr2_DP9_Hap2 Chr3_DP9_Hap2 Chr4_DP9_Hap2 Chr5_DP9_Hap2 Chr6_DP9_Hap2 Chr7_DP9_Hap2 Chr8_DP9_Hap2)

RRATE_values=(
    1.8273e-08
    1.3205e-08
    1.9731e-08
    2.1332e-08
    2.6090e-08
    1.8967e-08
    2.3104e-08
    1.9508e-08
)


############################################################
# Selection scan in P. dulcis
#
# Population A = K2_Pd
# Population B = K1_Pw
############################################################

for i in "${!C_values[@]}"; do

    CHR="${C_values[$i]}"
    RRATE="${RRATE_values[$i]}"

    xpclr \
        --format vcf \
        --input "${VCF}" \
        --samplesA "${PD}" \
        --samplesB "${PW}" \
        --out "XPCLR_output/XPCLR_Pd_${CHR}" \
        --chr "${CHR}" \
        --rrate "${RRATE}" \
        --minsnps 10 \
        --maxsnps 200 \
        --ld 0.95 \
        --size 10000 \
        --step 5000

done


############################################################
# Selection scan in P. webbii
#
# Population A = K1_Pw
# Population B = K2_Pd
############################################################

for i in "${!C_values[@]}"; do

    CHR="${C_values[$i]}"
    RRATE="${RRATE_values[$i]}"

    xpclr \
        --format vcf \
        --input "${VCF}" \
        --samplesA "${PW}" \
        --samplesB "${PD}" \
        --out "XPCLR_output/XPCLR_Pw_${CHR}" \
        --chr "${CHR}" \
        --rrate "${RRATE}" \
        --minsnps 10 \
        --maxsnps 200 \
        --ld 0.95 \
        --size 10000 \
        --step 5000

done
