#!/usr/bin/env bash

GENOME=<EDTA_MASKED_GENOME.fasta>
PROTEINS=<ROSACEAE_PROTEINS.fasta>
RNA_BAM=<RNA_SEQ_ALIGNMENTS>

# BRAKER3 v3.0.8

braker.pl \
    --genome="${GENOME}" \
    --prot_seq="${PROTEINS}" \
    <RNA_SEQ_EVIDENCE> \
    <ADDITIONAL_PARAMETERS>

# Protein evidence:
# 305,709 Rosaceae protein clusters with >90% identity
# from UniProt.
#
# RNA-seq evidence:
# SRR16267426
# SRR16267427
# SRR16267429
# SRR18264541

# TODO [BIOINFORMATICIAN]:
# Replace placeholders with the exact original BRAKER3 command,
# including the way RNA-seq evidence was supplied.
