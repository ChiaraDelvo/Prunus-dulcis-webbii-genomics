#!/usr/bin/env bash

# Coalescent species tree with ASTRAL-Pro3 v1.25.3.8.
# Input is the OrthoFinder directory Resolved_Gene_Trees.
# Repeat from each haplotype results directory.
#
# list_genes.txt maps each gene to its species. The species label is the
# first two underscore-separated fields of the gene name (Prunus_mume,
# TU_Hap1). Labels of internal nodes (n1, n2, ...) are excluded.

awk '{print $0}' Resolved_Gene_Trees/* > concat_trees.txt

cat concat_trees.txt \
    | tr '(),;' '\n' \
    | cut -d':' -f1 \
    | grep '[a-zA-Z]' \
    | grep -vE '^n[0-9]+$' \
    | sort -u \
    | awk -F '_' '{OFS="\t"; print $1 "_" $2, $0}' \
    > list_genes.txt

astral-pro3 \
    --root Prunus_mume \
    -a list_genes.txt \
    -i concat_trees.txt \
    -o species.tree
