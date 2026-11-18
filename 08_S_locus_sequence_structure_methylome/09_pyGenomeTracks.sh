#!/usr/bin/env bash

# Build a pyGenomeTracks configuration from the bigWig files and a GTF.
# Put the methylation and coverage bigWig files in TRACK_DIR.
# Colors and the gene-track style can be edited in tracks.ini before
# the pyGenomeTracks call.
#
# The project directory is mounted at /project inside the container.
#
# Containers:
#   pyGenomeTracks   2.1   quay.io/biocontainers/pygenometracks:2.1--py27_0

TRACK_DIR=tracks
GTF_FILE=DP9_Hap1.gtf
TRACKS_INI=tracks.ini
REGION=
OUT_PLOT=locus_tracks.pdf
PYGENOMETRACKS_IMAGE=quay.io/biocontainers/pygenometracks:2.1--py27_0

docker run --rm \
    -v "${PWD}:/project" \
    -w /project \
    "${PYGENOMETRACKS_IMAGE}" \
    make_tracks_file \
        --trackFiles "${TRACK_DIR}"/*.bw "${GTF_FILE}" \
        -o "${TRACKS_INI}"

if [ -z "${REGION}" ]; then
    echo "Set REGION to the S-locus interval before drawing the figure." >&2
    exit 1
fi

docker run --rm \
    -v "${PWD}:/project" \
    -w /project \
    "${PYGENOMETRACKS_IMAGE}" \
    pyGenomeTracks \
        --tracks "${TRACKS_INI}" \
        --region "${REGION}" \
        -o "${OUT_PLOT}"
