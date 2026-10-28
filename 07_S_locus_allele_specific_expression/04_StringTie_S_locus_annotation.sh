#!/usr/bin/env bash

S_LOCUS_BAM=<S_LOCUS_FILTERED.bam>
BRAKER_GTF=<BRAKER3_ANNOTATION.gtf>

GUIDED_GTF=<STRINGTIE_GUIDED.gtf>
DENOVO_GTF=<STRINGTIE_DENOVO.gtf>
MERGED_GTF=<STRINGTIE_MERGED.gtf>


############################################################
# TODO [BIOINFORMATICIAN]
#
# Add the exact command used to extract RNA-seq alignments
# mapping within the S-locus coordinates of each haplotype.
############################################################


############################################################
# Reference-guided transcript assembly
############################################################

# StringTie v2.2.3

stringtie "${S_LOCUS_BAM}" \
    -G "${BRAKER_GTF}" \
    -j 3 \
    -o "${GUIDED_GTF}"

# TODO:
# Add any other non-default StringTie parameters used.


############################################################
# De novo transcript assembly
############################################################

stringtie "${S_LOCUS_BAM}" \
    -j 3 \
    -o "${DENOVO_GTF}"

# TODO:
# Confirm whether -j 3 was also applied to the de novo run.


############################################################
# Merge guided and de novo transcript models
############################################################

printf "%s\n%s\n" \
    "${GUIDED_GTF}" \
    "${DENOVO_GTF}" \
    > mergelist.txt

stringtie --merge \
    -o "${MERGED_GTF}" \
    mergelist.txt
# NOTE:
# The Tuono_Hap2 S-RNase allele was subsequently assigned by
# nucleotide-sequence similarity against the Sf S-RNase allele
# (GenBank MH730647.1) using the NCBI BLASTn web interface.


# TODO [BIOINFORMATICIAN]:
# Confirm whether a reference annotation (-G) or other options
# were also provided during the merge step.
