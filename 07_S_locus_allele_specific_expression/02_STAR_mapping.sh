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


R1=<FILTERED_R1.fastq.gz>
R2=<FILTERED_R2.fastq.gz>
PREFIX=<OUTPUT_PREFIX>

# STAR v2.7.11b

STAR \
    --genomeDir "${INDEX}" \
    --readFilesIn "${R1}" "${R2}" \
    --readFilesCommand zcat \
    --twopassMode Basic \
    --outSAMstrandField intronMotif \
    --outFileNamePrefix "${PREFIX}"

# TODO [BIOINFORMATICIAN]:
# Add the exact output BAM format, sorting options, thread number,
# and any additional non-default alignment parameters.
