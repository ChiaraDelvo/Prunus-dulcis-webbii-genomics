#!/usr/bin/env bash

BAM=<RNA_SEQ_ALIGNMENT.bam>
GTF=<S_LOCUS_ANNOTATION.gtf>
OUT=<FEATURECOUNTS_OUTPUT.txt>

# featureCounts v1.6.0

featureCounts \
    -a "${GTF}" \
    -o "${OUT}" \
    "${BAM}"

# TODO [BIOINFORMATICIAN]:
# Add the exact original settings, particularly:
#
#   - strand-specificity (-s 0/1/2)
#   - paired-end counting (-p), if applicable
#   - feature type (-t)
#   - attribute used for gene assignment (-g)
#   - treatment of multi-mapping/multi-overlapping reads
#   - thread number (-T)

# TODO [BIOINFORMATICIAN]:
# Document the exact procedure used to convert featureCounts
# read counts to TPM, including the feature length used for
# normalization.
