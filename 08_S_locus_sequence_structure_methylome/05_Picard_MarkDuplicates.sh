#!/usr/bin/env bash

INPUT=<SORTED_INPUT.bam>
OUTPUT=<DUPLICATE_PROCESSED.bam>
METRICS=<DUPLICATION_METRICS.txt>

# Picard MarkDuplicates v3.4.0

picard MarkDuplicates \
    I="${INPUT}" \
    O="${OUTPUT}" \
    M="${METRICS}"

# TODO [BIOINFORMATICIAN]:
# Confirm the complete original command and, in particular, whether
# duplicates were physically removed or only marked.
