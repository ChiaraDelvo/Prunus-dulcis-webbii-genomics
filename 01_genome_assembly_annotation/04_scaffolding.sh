#!/usr/bin/env bash

ASSEMBLY=<FILTERED_ASSEMBLY.fasta>
REFERENCE=<NONPAREIL_GCA_021292205.2.fasta>


############################################################
# Redundans v2.0
############################################################

# TODO [BIOINFORMATICIAN]:
# Add the exact Redundans command and parameters used in the
# original scaffolding workflow.


############################################################
# RagTag v2.1.0
############################################################

ragtag.py scaffold \
    "${REFERENCE}" \
    "${ASSEMBLY}"

# TODO [BIOINFORMATICIAN]:
# Confirm the complete original command and any additional
# non-default RagTag parameters.


############################################################
# Chromosome 0
############################################################

# Unanchored contigs were concatenated into the fictitious
# chromosome 0.

# TODO [BIOINFORMATICIAN]:
# Add the exact command used for chromosome-0 construction.
