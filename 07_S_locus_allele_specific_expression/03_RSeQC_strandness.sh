#!/usr/bin/env bash

BAM=<RNA_SEQ_ALIGNMENT.bam>
BED=<REFERENCE_GENE_MODEL.bed>

# RSeQC v3.1.0

infer_experiment.py \
    -i "${BAM}" \
    -r "${BED}"

# TODO [BIOINFORMATICIAN]:
# Confirm how the BED reference file was generated and which
# annotation was used for strandness assessment.
