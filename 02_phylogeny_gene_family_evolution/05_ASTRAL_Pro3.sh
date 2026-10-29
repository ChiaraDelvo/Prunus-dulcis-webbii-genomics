#!/usr/bin/env bash

GENE_TREES=<GENE_TREES.newick>
OUT=<ASTRAL_SPECIES_TREE.newick>
THREADS=<N_THREADS>

# ASTRAL-Pro3 v1.25.3.8

astral-pro3 \
    -i "${GENE_TREES}" \
    -o "${OUT}" \
    -t "${THREADS}" \
    --root P_mume

# TODO [BIOINFORMATICIAN]:
# Confirm:
# - exact gene-tree input used;
# - whether a gene-to-species mapping file (-a) was required;
# - exact rooting syntax/species identifier;
# - additional non-default parameters.
