#!/usr/bin/env bash

# Annotate transposable elements in the two final haplotype assemblies
# with EDTA, and generate the repeat-masked genome (--anno 1).
#
# EDTA is run from a Biocontainers image. The working directory is
# mounted at /data inside the container.
#
# Containers:
#   EDTA   2.2.2   quay.io/biocontainers/edta:2.2.2--hdfd78af_0
#
# Example:
#   docker run --rm -v $PWD:/data -w /data \
#     quay.io/biocontainers/edta:2.2.2--hdfd78af_0 <command>

GENOTYPE=SAMPLE_ID
THREADS=20

for HAP in Hap1 Hap2; do
    ASSEMBLY=${GENOTYPE}_${HAP}_final.fasta

    ############################################################
    # EDTA v2.2.2
    ############################################################
    # --anno 1: also write the TE annotation and the masked genome.
    # --overwrite 1: replace an existing EDTA output directory.

    docker run --rm -v "${PWD}:/data" -w /data \
        quay.io/biocontainers/edta:2.2.2--hdfd78af_0 \
        EDTA.pl \
            --genome "${ASSEMBLY}" \
            --species others \
            --anno 1 \
            --overwrite 1 \
            --threads "${THREADS}"
done
