#!/usr/bin/env bash

PROTEOMES=<PROTEOME_DIRECTORY>
THREADS=<N_THREADS>

# OrthoFinder v3.0.1b1

orthofinder \
    -f "${PROTEOMES}" \
    -t "${THREADS}"

# Two independent runs were performed:
#
# Run 1:
#   Tuono_Hap1
#   DP9_Hap1
#   + seven reference Prunus proteomes
#
# Run 2:
#   Tuono_Hap2
#   DP9_Hap2
#   + seven reference Prunus proteomes
#
# TODO [BIOINFORMATICIAN]:
# Confirm the exact OrthoFinder version and original command,
# including any additional non-default parameters.
#
# Single-copy orthogroups were retained for downstream
# phylogenetic analyses.
