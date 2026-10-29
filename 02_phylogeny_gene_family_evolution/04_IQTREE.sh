#!/usr/bin/env bash

SUPERMATRIX=<CONCATENATED_ALIGNMENT.fasta>
OUT=<OUTPUT_PREFIX>

# IQ-TREE v2.4.0

iqtree2 \
    -s "${SUPERMATRIX}" \
    -b 100 \
    --prefix "${OUT}"

# TODO [BIOINFORMATICIAN]:
# Confirm:
# - exact executable name;
# - substitution-model specification or ModelFinder settings;
# - sequence type;
# - thread settings;
# - exact rooting procedure using P. mume.
