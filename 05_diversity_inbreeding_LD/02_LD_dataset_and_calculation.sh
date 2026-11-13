#!/usr/bin/env bash
set -Eeuo pipefail

# ============================================================
# Population-specific dataset preparation and genome-wide LD
#
# Starting dataset:
#   set1 VCF generated against either reference assembly
#
# Populations:
#   PW = K1_Pw
#   PD = K2_Pd
#
# Workflow:
#   1. Extract population-specific samples from set1
#   2. Retain SNPs with MAF >= 0.01
#   3. Generate PLINK BED/BIM/FAM datasets
#   4. Calculate genome-wide pairwise LD within 500 kb
#
# PLINK v1.9
# ============================================================


# ------------------------------------------------------------
# INPUTS
# ------------------------------------------------------------

VCF=<SET1_VCF>

# Use a short identifier for the reference dataset, e.g.
# DP9H2 or TUH1
REF_PREFIX=<REFERENCE_PREFIX>

PW_IDS="../metadata/K1_Pw_IDs.txt"
PD_IDS="../metadata/K2_Pd_IDs.txt"

MAF=0.01


# ------------------------------------------------------------
# OUTPUT DIRECTORIES
# ------------------------------------------------------------

INPUT_DIR="LD_decay_inputs"
LD_DIR="LD_decay_PLINK"

mkdir -p "${INPUT_DIR}" "${LD_DIR}"


# ------------------------------------------------------------
# TEMPORARY PLINK KEEP FILES
#
# Metadata files contain one sample ID per line.
# --double-id assigns FID = IID = VCF sample ID.
# Temporary two-column FID/IID files are generated for --keep.
# ------------------------------------------------------------

TMP_KEEP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_KEEP_DIR}"' EXIT


# ------------------------------------------------------------
# FUNCTION: PREPARE POPULATION-SPECIFIC PLINK DATASET
# ------------------------------------------------------------

prepare_population () {

    POP="$1"
    IDS="$2"

    KEEP="${TMP_KEEP_DIR}/${POP}.keep"
    OUT="${INPUT_DIR}/${REF_PREFIX}_${POP}_MAF01"

    # Convert one-column sample ID list to:
    # FID    IID
    awk 'NF && $1 !~ /^#/ {print $1 "\t" $1}' \
        "${IDS}" > "${KEEP}"

    plink \
        --vcf "${VCF}" \
        --double-id \
        --allow-extra-chr \
        --chr-set 8 no-xy no-mt \
        --allow-no-sex \
        --keep-allele-order \
        --real-ref-alleles \
        --keep "${KEEP}" \
        --maf "${MAF}" \
        --make-bed \
        --out "${OUT}"
}


# ------------------------------------------------------------
# STEP 1: CREATE PW AND PD DATASETS
# ------------------------------------------------------------

prepare_population "PW" "${PW_IDS}"
prepare_population "PD" "${PD_IDS}"


# ------------------------------------------------------------
# STEP 2: GENOME-WIDE PAIRWISE LD CALCULATION
#
# All SNP pairs within a maximum physical distance of 500 kb
# are retained irrespective of their r2 value.
# ------------------------------------------------------------

LD_WINDOW=99999
LD_WINDOW_KB=500
LD_WINDOW_R2=0


for POP in PW PD; do

    BFILE="${INPUT_DIR}/${REF_PREFIX}_${POP}_MAF01"

    plink \
        --bfile "${BFILE}" \
        --allow-extra-chr \
        --chr-set 8 no-xy no-mt \
        --allow-no-sex \
        --r2 gz \
        --ld-window "${LD_WINDOW}" \
        --ld-window-kb "${LD_WINDOW_KB}" \
        --ld-window-r2 "${LD_WINDOW_R2}" \
        --out "${LD_DIR}/${REF_PREFIX}_LDecay_${POP}_500Kb_AllSNP"

done

echo "Population-specific dataset preparation and genome-wide LD calculation completed."
