#!/usr/bin/env bash

TRACKS=<TRACKS_CONFIG.ini>
REGION=<S_LOCUS_REGION>
OUT=<OUTPUT_FIGURE.pdf>

pyGenomeTracks \
    --tracks "${TRACKS}" \
    --region "${REGION}" \
    --outFileName "${OUT}"

# Tracks included:
# - CpG methylation
# - CHG methylation
# - CHH methylation
# - resequencing read coverage
# - gene annotation
# - transposable-element annotation
#
# TODO [BIOINFORMATICIAN]:
# Add the pyGenomeTracks version, the original region coordinates,
# and the configuration file/settings used for the final tracks.
