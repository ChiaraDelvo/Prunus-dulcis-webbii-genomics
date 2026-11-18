#!/usr/bin/env bash

INPUT=<ALLELE_SEQUENCES_FASTA>
OUT=<ALIGNMENT_OUTPUT>

# T-COFFEE v13.46.0.919e8c6b

t_coffee \
    -seq "${INPUT}" \
    -outfile "${OUT}"

# Analyses performed:
# - S-RNase: Tuono, DP9, Lauranne Sf, Brown Nonpareil S1,
#   and P. webbii alleles AM690352, AM690353, AM690354.
# - SFB: Tuono and DP9 haplotypes.
