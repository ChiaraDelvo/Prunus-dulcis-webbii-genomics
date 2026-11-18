#!/usr/bin/env bash

# Minimap2 v2.24
#
# All-vs-all comparison of the S-locus haplotype sequences.
# A single multi-FASTA file containing the S-locus sequences from
# the four haplotypes was aligned against itself to identify
# collinear and homologous regions among haplotypes.

MULTIFASTA=<S_LOCUS_HAPLOTYPES.fasta>
OUT=<OUTPUT.paf>

minimap2 \
    -x asm20 \
    -D \
    -P \
    "${MULTIFASTA}" \
    "${MULTIFASTA}" \
    > "${OUT}"


# S-locus interval boundaries were previously defined from the best
# BLASTn matches to:
#   SFB: MH316096.1
#   SLF: MH316056.1
