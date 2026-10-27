#!/usr/bin/env bash

VCF=<LD_PRUNED_SET1_VCF>
GROUPS=../metadata/Family_Ids_F3.txt
OUT=set1_LD_input_F3

# PLINK v1.90b6.21

plink \
    --vcf "${VCF}" \
    --allow-extra-chr \
    --allow-no-sex \
    --chr-set 8 no-xy no-mt \
    --keep-allele-order \
    --real-ref-alleles \
    --update-ids "${GROUPS}" \
    --family \
    --freq \
    --nonfounders \
    --out "${OUT}"

gzip "${OUT}.frq.strat"

python2 plink2treemix.py \
    "${OUT}.frq.strat.gz" \
    "${OUT}.treemix.gz"

threepop \
    -i "${OUT}.treemix.gz" \
    -k 100 \
    | tee TreeMix_F3.out
