#!/usr/bin/env bash

ASSEMBLY=<INITIAL_ASSEMBLY.fasta>

############################################################
# 1. Contig-length filtering
############################################################

# Retain contigs >= 50 kb.

# TODO [BIOINFORMATICIAN]:
# Add the exact command/software used to remove contigs <50 kb.


############################################################
# 2. Taxonomic classification
############################################################

# Kraken2 v2.1.6

kraken2 \
    --db <KRAKEN2_DATABASE> \
    --report kraken2.report \
    --output kraken2.out \
    "${ASSEMBLY}"

# Retained classifications:
#   Viridiplantae
#   unclassified

# TODO [BIOINFORMATICIAN]:
# Add the Kraken2 database/version used and the exact command
# used to retain Viridiplantae and unclassified contigs.


############################################################
# 3. Removal of organellar-derived contigs
############################################################

# Reference sequences:
# mitochondrial genome: CM038036.1
# chloroplast genome:   CM038037.1

# Contigs showing high synteny with these organellar reference
# genomes were removed.

# TODO [BIOINFORMATICIAN]:
# Add the software, exact alignment command, and threshold used
# to define "high synteny".
