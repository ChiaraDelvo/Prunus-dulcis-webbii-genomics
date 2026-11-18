#!/usr/bin/env bash

# De novo assembly of PacBio HiFi reads with Hifiasm, followed by
# conversion of the two haplotype contig graphs to FASTA with gfatools.
#
# Both tools are run from Biocontainers images. The working directory
# is mounted at /data inside the container.
#
# Containers:
#   Hifiasm    0.16.0   quay.io/biocontainers/hifiasm:0.16.0--h2e03b76_0
#   gfatools   0.5      quay.io/biocontainers/gfatools:0.5--hed695b0_0
#
# Example:
#   docker run --rm -v $PWD:/data -w /data \
#     quay.io/biocontainers/hifiasm:0.16.0--h2e03b76_0 <command>

GENOTYPE=SAMPLE_ID
READS=${GENOTYPE}.hifi.fastq.gz
THREADS=20

############################################################
# Hifiasm v0.16.0
############################################################
# Assemble HiFi reads.
# -s 0.3: similarity threshold used to purge duplicate haplotigs.

docker run --rm -v "${PWD}:/data" -w /data \
    quay.io/biocontainers/hifiasm:0.16.0--h2e03b76_0 \
    hifiasm -s 0.3 -o "${GENOTYPE}" -t "${THREADS}" "${READS}"

############################################################
# gfatools v0.5
############################################################
# Convert the two haplotype-resolved contig graphs to FASTA.
# Redirection is handled by the host shell.
#   *.bp.hap1.p_ctg.gfa   haplotype 1
#   *.bp.hap2.p_ctg.gfa   haplotype 2

docker run --rm -v "${PWD}:/data" -w /data \
    quay.io/biocontainers/gfatools:0.5--hed695b0_0 \
    gfatools gfa2fa "${GENOTYPE}.bp.hap1.p_ctg.gfa" > "${GENOTYPE}_Hap1_assembly.fasta"

docker run --rm -v "${PWD}:/data" -w /data \
    quay.io/biocontainers/gfatools:0.5--hed695b0_0 \
    gfatools gfa2fa "${GENOTYPE}.bp.hap2.p_ctg.gfa" > "${GENOTYPE}_Hap2_assembly.fasta"
