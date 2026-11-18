#!/usr/bin/env bash

# Pairwise whole-genome alignment and structural-rearrangement detection.
# Minimap2 alignments are sorted to BAM and passed to SyRI.
# --eqx writes =/X CIGAR operators, which SyRI requires.
#
# Comparisons, in plotsr chain order:
#   DP9 haplotype 1  (DP9_1.fasta) vs DP9 haplotype 2  (DP9_2.fasta)
#   DP9 haplotype 2  (DP9_2.fasta) vs Tuono haplotype 1 (TU_1.fasta)
#   Tuono haplotype 1 (TU_1.fasta) vs Tuono haplotype 2 (TU_2.fasta)
#
# Minimap2, SyRI, and plotsr are run from Biocontainers images. The
# working directory is mounted at /data inside the container.
#
# Containers:
#   Minimap2 2.24    quay.io/biocontainers/minimap2:2.24--h7132678_1
#   SyRI     1.6.3   quay.io/biocontainers/syri:1.6.3--py39he10ea66_1
#   plotsr   1.0.0   quay.io/biocontainers/plotsr:1.0.0--pyh7cba7a3_0
#
# Example:
#   docker run --rm -v $PWD:/data -w /data \
#     quay.io/biocontainers/syri:1.6.3--py39he10ea66_1 <command>

THREADS=4

############################################################
# Minimap2 v2.24
############################################################

docker run --rm -v "${PWD}:/data" -w /data \
    quay.io/biocontainers/minimap2:2.24--h7132678_1 \
    minimap2 -ax asm5 -t "${THREADS}" --eqx DP9_1.fasta DP9_2.fasta \
    | samtools sort -O BAM - > DP9_Hap1_DP9_Hap2.bam

docker run --rm -v "${PWD}:/data" -w /data \
    quay.io/biocontainers/minimap2:2.24--h7132678_1 \
    minimap2 -ax asm5 -t "${THREADS}" --eqx DP9_2.fasta TU_1.fasta \
    | samtools sort -O BAM - > DP9_Hap2_TU_Hap1.bam

docker run --rm -v "${PWD}:/data" -w /data \
    quay.io/biocontainers/minimap2:2.24--h7132678_1 \
    minimap2 -ax asm5 -t "${THREADS}" --eqx TU_1.fasta TU_2.fasta \
    | samtools sort -O BAM - > TU_Hap1_TU_Hap2.bam

############################################################
# SyRI v1.6.3
############################################################
# -F B: the alignment is BAM. Output is <prefix>syri.out.

docker run --rm -v "${PWD}:/data" -w /data \
    quay.io/biocontainers/syri:1.6.3--py39he10ea66_1 \
    syri -c DP9_Hap1_DP9_Hap2.bam -r DP9_1.fasta -q DP9_2.fasta \
        -F B --prefix DP9_Hap1_DP9_Hap2

docker run --rm -v "${PWD}:/data" -w /data \
    quay.io/biocontainers/syri:1.6.3--py39he10ea66_1 \
    syri -c DP9_Hap2_TU_Hap1.bam -r DP9_2.fasta -q TU_1.fasta \
        -F B --prefix DP9_Hap2_TU_Hap1

docker run --rm -v "${PWD}:/data" -w /data \
    quay.io/biocontainers/syri:1.6.3--py39he10ea66_1 \
    syri -c TU_Hap1_TU_Hap2.bam -r TU_1.fasta -q TU_2.fasta \
        -F B --prefix TU_Hap1_TU_Hap2

############################################################
# plotsr v1.0.0
############################################################
# genomes.txt is tab-separated (file, name) and must list the
# assemblies in the same order as the alignment chain:
# DP9_1.fasta, DP9_2.fasta, TU_1.fasta, TU_2.fasta.

docker run --rm -v "${PWD}:/data" -w /data \
    quay.io/biocontainers/plotsr:1.0.0--pyh7cba7a3_0 \
    plotsr \
        --sr DP9_Hap1_DP9_Hap2syri.out \
        --sr DP9_Hap2_TU_Hap1syri.out \
        --sr TU_Hap1_TU_Hap2syri.out \
        --genomes genomes.txt \
        -o output_plot.png
