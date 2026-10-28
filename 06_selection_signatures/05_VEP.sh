#!/usr/bin/env bash

INPUT_VCF=<DP9_Hap2_set1.vcf.gz>

VEP_INPUT="VEP_input_MYB61_COMT_F5H.vcf.gz"

GTF=<DP9_Hap2_annotation.gtf.gz>
FASTA=<DP9_Hap2_final_assembly.fasta>


############################################################
# 1. Extract variants located within candidate-gene regions
#
# Regions include:
#   gene body + 3 kb upstream + 1 kb downstream
############################################################

bcftools view \
    --regions Chr6_DP9_Hap2:31395509-31401081,Chr2_DP9_Hap2:15056052-15064941,Chr7_DP9_Hap2:20968958-20974724 \
    --output-type z \
    --output "${VEP_INPUT}" \
    "${INPUT_VCF}"


############################################################
# 2. Index VCF
############################################################

tabix -p vcf "${VEP_INPUT}"


############################################################
# 3. Variant Effect Predictor
############################################################

vep \
    --fasta "${FASTA}" \
    --gtf "${GTF}" \
    --input_file "${VEP_INPUT}" \
    --output_file VEP_MYB61_COMT_F5H.txt \
    --species Prunus_webbii \
    --force_overwrite
