#!/usr/bin/env bash

REF=<REFERENCE_GENOME.fasta>
R1=<TRIMMED_R1.fastq.gz>
R2=<TRIMMED_R2.fastq.gz>
OUT=<OUTPUT.sam>

# bwa-meth v0.2.9

############################################################
# Reference indexing with BWA-MEM2
############################################################

bwameth.py index-mem2 "${REF}"


############################################################
# WGBS alignment
############################################################

bwameth.py \
    --reference "${REF}" \
    "${R1}" "${R2}" \
    > "${OUT}"

# Alignment was performed using bwa-meth default parameters.

# TODO [BIOINFORMATICIAN]:
# Add the exact commands/software used for SAM/BAM conversion,
# coordinate sorting and BAM indexing prior to downstream analysis.
