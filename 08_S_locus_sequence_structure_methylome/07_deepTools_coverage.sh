#!/usr/bin/env bash

BAM=<INPUT_RESEQUENCING.bam>
OUT=<OUTPUT_COVERAGE.bw>

EFFECTIVE_GENOME_SIZE=<EFFECTIVE_GENOME_SIZE>

# deepTools v4.0.0

bamCoverage \
    --bam "${BAM}" \
    --outFileName "${OUT}" \
    --normalizeUsing RPGC \
    --effectiveGenomeSize "${EFFECTIVE_GENOME_SIZE}"

# TODO [BIOINFORMATICIAN]:
# Add the effective genome size used in the original analysis and
# any additional non-default bamCoverage settings (e.g. bin size,
# fragment handling, filtering or region restriction).
