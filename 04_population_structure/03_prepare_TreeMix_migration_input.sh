#!/usr/bin/env bash

VCF=<LD_PRUNED_SET1_VCF>
GROUPS=../metadata/Family_Pw_PdAp_PdOt_Admx.txt
REMOVE=../metadata/Remove_D149.txt
OUT=Set1_Input_Mig_F4

plink \
    --vcf "${VCF}" \
    --allow-extra-chr \
    --keep-allele-order \
    --real-ref-alleles \
    --chr-set 8 no-xy no-mt \
    --allow-no-sex \
    --remove "${REMOVE}" \
    --update-ids "${GROUPS}" \
    --family \
    --freq \
    --nonfounders \
    --out "${OUT}"

gzip "${OUT}.frq.strat"

python2 plink2treemix.py \
    "${OUT}.frq.strat.gz" \
    "${OUT}.treemix.gz"
