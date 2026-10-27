#!/usr/bin/env bash

VCF=<LD_PRUNED_SET1_VCF>
OUT=set1_LD02_INPUT_ADMX

# PLINK v1.90b6.21
plink \
    --vcf "${VCF}" \
    --allow-extra-chr \
    --chr-set 8 no-xy no-mt \
    --keep-allele-order \
    --real-ref-alleles \
    --make-bed \
    --out "${OUT}"

    # ADMIXTURE v1.4.0
# 10-fold cross-validation and 200 bootstrap replicates

for K in {1..10}; do
    admixture \
        --cv=10 \
        -B200 \
        "${OUT}.bed" \
        "${K}" \
        | tee "${OUT}_B200_K${K}.out"
done
