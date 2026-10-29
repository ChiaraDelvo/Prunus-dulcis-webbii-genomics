#!/usr/bin/env bash

REFERENCE=<S_LOCUS_HAPLOTYPE_REFERENCE.fasta>
QUERY=<S_LOCUS_HAPLOTYPE_QUERY.fasta>
OUT=<OUTPUT.paf>

# Minimap2 v2.24
# Synteny comparison

minimap2 \
    -x asm20 \
    "${REFERENCE}" \
    "${QUERY}" \
    > "${OUT}"

# TODO [BIOINFORMATICIAN]:
# Confirm the exact Minimap2 version and original command.
#
# S-locus interval boundaries were previously defined from the best
# BLASTn matches to:
#   SFB: MH316096.1
#   SLF: MH316056.1
#
# Add the exact BLASTn procedure if performed through a command-line
# implementation.
