#!/usr/bin/env bash

# Maximum-likelihood species tree from the OrthoFinder species-tree alignment.
# ModelFinder (MFP) selects the substitution model. Support is 1,000
# ultrafast bootstrap replicates.
#
# IQ-TREE is run from a Biocontainers image. Each OrthoFinder results
# directory is mounted at /in. The alignment is SpeciesTreeAlignment.fa,
# either in that directory or in its Species_Tree subdirectory.
# OrthoFinder may nest the results in Results_<date>/.
#
# Containers:
#   IQ-TREE   2.4.0   quay.io/biocontainers/iqtree:2.4.0--h503566f_0
#
# Example:
#   docker run --rm -v $PWD:/in -w /in \
#     quay.io/biocontainers/iqtree:2.4.0--h503566f_0 \
#     iqtree -s SpeciesTreeAlignment.fa -m MFP -nt 10 --prefix IQTREE -B 1000

THREADS=10
SPECIES_ALIGNMENT=SpeciesTreeAlignment.fa

for HAP in Hap1 Hap2; do
    docker run --rm -v "${PWD}/Results_${HAP}:/in" \
        quay.io/biocontainers/iqtree:2.4.0--h503566f_0 \
        iqtree \
            -s "/in/${SPECIES_ALIGNMENT}" \
            -m MFP \
            -nt "${THREADS}" \
            --prefix "/in/IQTREE" \
            -B 1000
done
