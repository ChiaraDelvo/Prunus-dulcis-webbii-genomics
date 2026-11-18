#!/usr/bin/env bash

# Gene prediction on the two final haplotype assemblies with BRAKER3.
# Evidence is the EDTA soft-masked genome, Rosaceae protein clusters,
# and RNA-seq alignments.
#
# BRAKER3 is run from a Biocontainers image. The working directory is
# mounted at /data. The Augustus config shipped in the image is copied
# into that directory before the run, because Augustus must be able to
# write its species parameters.
#
# Containers:
#   BRAKER3   3.0.8   quay.io/biocontainers/braker3:3.0.8--hdfd78af_0
#
# Example:
#   docker run --rm -v $PWD:/data -w /data \
#     quay.io/biocontainers/braker3:3.0.8--hdfd78af_0 <command>

GENOTYPE=SAMPLE_ID
THREADS=30

# Rosaceae UniProt protein clusters at >90% identity (305,709 clusters).
PROTEINS=rosaceae_uniprot_clusters_id90_jan2024.faa

# RNA-seq libraries (SRA accessions).
SRA_IDS="SRR16267426 SRR16267427 SRR16267429 SRR18264541"

for HAP in Hap1 Hap2; do
    PREFIX=${GENOTYPE}_${HAP}
    # EDTA names its products from the genome file name plus the .mod suffix.
    GENOME=${PREFIX}_final.fasta
    MASKED=${GENOME}.mod.EDTA.softmask/${GENOME}.mod.softmasked.fa
    TELIB=${GENOME}.mod.EDTA.TElib.fa
    TEGFF=${GENOME}.mod.EDTA.TEanno.gff3

    # Augustus species label and output directory, one per haplotype.
    BRAKER_SPECIES=${PREFIX}
    WORKDIR=braker_output_${PREFIX}
    AUGUSTUS_CONFIG=augustus_config_${PREFIX}

    # Comma-separated BAMs of the RNA-seq libraries aligned to this haplotype.
    BAMS=""
    for SRA in ${SRA_IDS}; do
        BAMS=${BAMS:+${BAMS},}${PREFIX}_${SRA}.bam
    done

    ############################################################
    # BRAKER3 v3.0.8
    ############################################################
    # BRAKER uses the soft-masked genome. The TE library and GFF
    # (${TELIB}, ${TEGFF}) are the matching EDTA products.
    # Outputs:
    #   ${WORKDIR}/braker.gtf
    #   ${WORKDIR}/braker.codingseq
    #   ${WORKDIR}/braker.aa

    docker run --rm --entrypoint bash \
        -v "${PWD}:/data" -w /data \
        quay.io/biocontainers/braker3:3.0.8--hdfd78af_0 \
        -c "mkdir -p '${AUGUSTUS_CONFIG}' '${WORKDIR}' \
            && cp -r /opt/Augustus/config/* '${AUGUSTUS_CONFIG}/' \
            && export AUGUSTUS_CONFIG_PATH=/data/${AUGUSTUS_CONFIG} \
            && braker.pl \
                --genome=${MASKED} \
                --prot_seq=${PROTEINS} \
                --bam=${BAMS} \
                --threads=${THREADS} \
                --species=${BRAKER_SPECIES} \
                --AUGUSTUS_CONFIG_PATH=/data/${AUGUSTUS_CONFIG} \
                --workingdir=${WORKDIR}"
done
