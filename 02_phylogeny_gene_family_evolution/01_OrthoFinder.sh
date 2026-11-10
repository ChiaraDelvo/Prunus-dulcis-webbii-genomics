#!/usr/bin/env bash

# Orthogroup inference with OrthoFinder v3 in MSA mode.
# Searches use DIAMOND ultra-sensitive. Alignments are MAFFT.
# Gene trees are RAxML-NG.
#
# The two haplotype combinations are analysed separately.
# Each input directory contains one proteome FASTA per species:
#   Input_Hap1: Tuono_Hap1, DP9_Hap1, and seven reference Prunus proteomes
#   Input_Hap2: Tuono_Hap2, DP9_Hap2, and the same reference proteomes
#
# OrthoFinder is run from the conda environment orthofinder3.

THREADS=10
ANALYSIS_THREADS=10

for HAP in Hap1 Hap2; do
    conda run -n orthofinder3 --no-capture-output \
        orthofinder \
            -t "${THREADS}" \
            -a "${ANALYSIS_THREADS}" \
            -M msa \
            -S diamond_ultra_sens \
            -A mafft \
            -T raxml-ng \
            -o "Results_${HAP}" \
            -f "Input_${HAP}"
done
