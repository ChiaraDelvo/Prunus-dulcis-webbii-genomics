#!/usr/bin/env bash

HIFI_READS=<PACBIO_HIFI_READS.fastq.gz>
OUT=<ASSEMBLY_PREFIX>
THREADS=<N_THREADS>

# Hifiasm v0.16.0
#
# -s 0.3:
# similarity threshold for duplicate haplotigs during purging

hifiasm \
    -s 0.3 \
    -t "${THREADS}" \
    -o "${OUT}" \
    "${HIFI_READS}"

# TODO [BIOINFORMATICIAN]:
# Confirm the complete original command and any additional
# non-default Hifiasm parameters.
#
# Add the exact command used to extract the final haplotype
# FASTA sequences from the Hifiasm GFA output.
