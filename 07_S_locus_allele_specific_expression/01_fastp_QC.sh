#!/usr/bin/env bash

R1=<RAW_R1.fastq.gz>
R2=<RAW_R2.fastq.gz>

OUT_R1=<FILTERED_R1.fastq.gz>
OUT_R2=<FILTERED_R2.fastq.gz>

# fastp v1.0.1
#
# Settings reported in the manuscript:
#   minimum Phred quality = 20
#   minimum retained read length = 35 bp
#   adapter trimming enabled

fastp \
    --in1 "${R1}" \
    --in2 "${R2}" \
    --out1 "${OUT_R1}" \
    --out2 "${OUT_R2}" \
    --qualified_quality_phred 20 \
    --length_required 35

# TODO [BIOINFORMATICIAN]:
# Confirm the exact original fastp command and adapter-trimming settings.
