#!/usr/bin/env bash

R1=<RAW_R1.fastq.gz>
R2=<RAW_R2.fastq.gz>
OUTDIR=<OUTPUT_DIRECTORY>

trim_galore \
    --paired \
    --length 35 \
    --output_dir "${OUTDIR}" \
    "${R1}" "${R2}"

# TODO [BIOINFORMATICIAN]:
# Add the Trim Galore! version and confirm the exact original command,
# including any explicitly specified quality or adapter parameters.
