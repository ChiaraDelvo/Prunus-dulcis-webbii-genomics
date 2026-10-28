#!/usr/bin/env bash

REF=<HAPLOTYPE_REFERENCE_FASTA>
GTF=<HAPLOTYPE_ANNOTATION_GTF>
INDEX=<STAR_INDEX_DIRECTORY>

############################################################
# Genome indexing
############################################################

STAR \
    --runMode genomeGenerate \
    --genomeDir "${INDEX}" \
    --genomeFastaFiles "${REF}" \
    --sjdbGTFfile "${GTF}"

# TODO [BIOINFORMATICIAN]:
# Add the original STAR indexing parameters, including
# --sjdbOverhang and --runThreadN, if explicitly specified.
