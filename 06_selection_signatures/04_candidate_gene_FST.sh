#!/usr/bin/env bash

VCF=<DP9_HAP2_SET1_VCF>

PW="../metadata/K1_Pw_IDs.txt"
PD="../metadata/K2_Pd_IDs.txt"

REGIONS="../metadata/candidate_gene_regions_DP9_Hap2.tsv"

mkdir -p candidate_gene_FST

tail -n +2 "${REGIONS}" |
while IFS=$'\t' read -r GENE CHR START END
do

    vcftools \
        --vcf "${VCF}" \
        --chr "${CHR}" \
        --from-bp "${START}" \
        --to-bp "${END}" \
        --weir-fst-pop "${PW}" \
        --weir-fst-pop "${PD}" \
        --out "candidate_gene_FST/${GENE}_Pw_vs_Pd"

done
