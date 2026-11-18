#!/usr/bin/env bash

# Chloroplast genome assembly of Tuono (TU) and DP9 from PacBio HiFi reads
# with ptGAUL. The reference is the P. dulcis chloroplast genome NC_034696
# (NC_034696.fasta). Threads are 10; the other ptGAUL settings are defaults.
#
# The image is started with the working directory mounted at the same
# absolute path, because ptGAUL is given host paths.
# combine_gfa.py reads edges.fa and sorted_depth from this directory.
# Each sample is combined into its own output directory, and those two
# files are moved there before the next sample is assembled.
#
# Software:
#   ptGAUL   1.0.5   docker image ptgaul
#
# Example:
#   docker run --rm -v $PWD:$PWD ptgaul ptGAUL.sh <arguments>

REFERENCE=NC_034696.fasta
THREADS=10

############################################################
# Tuono
############################################################

docker run --rm -v "${PWD}:${PWD}" ptgaul \
    ptGAUL.sh \
        -t "${THREADS}" \
        -r "${PWD}/${REFERENCE}" \
        -l "${PWD}/TU.fastq.gz" \
        -o "${PWD}/TU_pt"

docker run --rm -v "${PWD}:${PWD}" ptgaul \
    combine_gfa.py \
        -e "${PWD}/edges.fa" \
        -d "${PWD}/sorted_depth" \
        -o "${PWD}/TU_pt/"

mv edges.fa sorted_depth TU_pt/

############################################################
# DP9
############################################################

docker run --rm -v "${PWD}:${PWD}" ptgaul \
    ptGAUL.sh \
        -t "${THREADS}" \
        -r "${PWD}/${REFERENCE}" \
        -l "${PWD}/DP9.fastq.gz" \
        -o "${PWD}/DP9_pt"

docker run --rm -v "${PWD}:${PWD}" ptgaul \
    combine_gfa.py \
        -e "${PWD}/edges.fa" \
        -d "${PWD}/sorted_depth" \
        -o "${PWD}/DP9_pt/"

mv edges.fa sorted_depth DP9_pt/
