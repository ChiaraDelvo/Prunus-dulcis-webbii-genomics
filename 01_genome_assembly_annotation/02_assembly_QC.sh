#!/usr/bin/env bash

ASSEMBLY=<ASSEMBLY.fasta>
THREADS=<N_THREADS>

############################################################
# QUAST v5.0.2
############################################################

quast.py \
    "${ASSEMBLY}" \
    -o QUAST_output


############################################################
# BUSCO v5.2.2
############################################################

busco \
    -i "${ASSEMBLY}" \
    -m genome \
    -l eudicots_odb10 \
    -c "${THREADS}" \
    -o BUSCO_output

# TODO [BIOINFORMATICIAN]:
# Confirm the exact Eudicots BUSCO lineage/database version
# and any additional parameters used.
#
# The same QC procedure was applied to initial and final assemblies.
