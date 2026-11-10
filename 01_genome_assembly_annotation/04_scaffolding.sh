#!/usr/bin/env bash

# Scaffold the two filtered haplotype assemblies:
#   (i)  reduce and scaffold with Redundans
#   (ii) reference-guide scaffold with RagTag against the Nonpareil genome
#
# Both tools are run from Biocontainers images. The working directory
# is mounted at /data inside the container.
#
# Containers:
#   Redundans   2.0.1   quay.io/biocontainers/redundans:2.01--py310pl5321h43eeafb_0
#   RagTag      2.1.0   quay.io/biocontainers/ragtag:2.1.0--pyhb7b1952_0
#
# Example:
#   docker run --rm -v $PWD:/data -w /data \
#     quay.io/biocontainers/redundans:2.01--py310pl5321h43eeafb_0 <command>

GENOTYPE=SAMPLE_ID
THREADS=20

# Nonpareil almond reference (GenBank assembly GCA_021292205.2).
NONPAREIL_REF=GCA_021292205.2.fasta

for HAP in Hap1 Hap2; do
    PREFIX=${GENOTYPE}_${HAP}

    ############################################################
    # Redundans v2.0.1
    ############################################################
    # --minimap2reduce removes redundant sequences.
    # --minimap2scaffold joins contigs using minimap2 overlaps.

    docker run --rm -v "${PWD}:/data" -w /data \
        quay.io/biocontainers/redundans:2.01--py310pl5321h43eeafb_0 \
        redundans.py \
            --fasta "${PREFIX}_no_organelle.fasta" \
            --outdir "redundans_${PREFIX}" \
            --threads "${THREADS}" \
            --log "redundans_${PREFIX}.log" \
            --tmp "tmp_${PREFIX}" \
            --minimap2reduce \
            --minimap2scaffold

    ############################################################
    # RagTag v2.1.0
    ############################################################
    # Order and orient the reduced scaffolds against Nonpareil.

    docker run --rm -v "${PWD}:/data" -w /data \
        quay.io/biocontainers/ragtag:2.1.0--pyhb7b1952_0 \
        ragtag.py scaffold \
            "${NONPAREIL_REF}" \
            "redundans_${PREFIX}/scaffolds.reduced.fa" \
            -o "ragtag_${PREFIX}" \
            -t "${THREADS}" \
            --aligner minimap2
done
