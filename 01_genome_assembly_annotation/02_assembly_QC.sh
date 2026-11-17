#!/usr/bin/env bash

# Quality assessment of the two initial haplotype assemblies with QUAST
# and BUSCO. The same procedure was applied to the final assemblies.
#
# Both tools are run from Biocontainers images. The working directory
# is mounted at /data inside the container.
#
# Containers:
#   QUAST   5.0.2   quay.io/biocontainers/quast:5.0.2--py27pl5321h8f2a353_7
#   BUSCO   5.2.2   quay.io/biocontainers/busco:5.2.2--pyhdfd78af_0
#
# Example:
#   docker run --rm -v $PWD:/data -w /data \
#     quay.io/biocontainers/quast:5.0.2--py27pl5321h8f2a353_7 <command>

GENOTYPE=SAMPLE_ID
THREADS=20

for HAP in Hap1 Hap2; do
    ASSEMBLY=${GENOTYPE}_${HAP}_assembly.fasta

    ############################################################
    # QUAST v5.0.2
    ############################################################

    docker run --rm -v "${PWD}:/data" -w /data \
        quay.io/biocontainers/quast:5.0.2--py27pl5321h8f2a353_7 \
        quast \
            --threads "${THREADS}" \
            -o "quast_${GENOTYPE}_${HAP}_initial" \
            "${ASSEMBLY}"

    ############################################################
    # BUSCO v5.2.2
    ############################################################
    # Lineages: eudicots_odb10.

    docker run --rm -v "${PWD}:/data" -w /data \
        quay.io/biocontainers/busco:5.2.2--pyhdfd78af_0 \
        busco \
            --in "${ASSEMBLY}" \
            --mode genome \
            --lineage_dataset eudicots_odb10 \
            --cpu "${THREADS}" \
            --out "${GENOTYPE}_${HAP}_busco_initial_eudicots"
done
