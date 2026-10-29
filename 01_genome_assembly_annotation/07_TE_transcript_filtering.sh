#!/usr/bin/env bash

TRANSCRIPTS=<ANNOTATED_TRANSCRIPTS.fasta>
TE_LIBRARY=<EDTA_NON_REDUNDANT_TE_LIBRARY.fasta>

# BLASTn screening against the EDTA TE library

blastn \
    -query "${TRANSCRIPTS}" \
    -subject "${TE_LIBRARY}" \
    -out <BLAST_OUTPUT> \
    <ORIGINAL_PARAMETERS>

############################################################
# Filtering criteria
############################################################

# Remove transcripts satisfying:
#
#   P-value / E-value < 0.001
#   sequence identity > 80%
#   alignment coverage > 50%

# TODO [BIOINFORMATICIAN]:
# Add the exact BLASTn version/command and clarify how alignment
# coverage was calculated and applied.
