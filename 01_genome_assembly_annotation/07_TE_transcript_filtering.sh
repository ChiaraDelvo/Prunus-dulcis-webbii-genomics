#!/usr/bin/env bash

# Remove BRAKER transcripts that match the EDTA TE library.
# A transcript is removed when a BLASTn hit has E-value <= 0.001,
# sequence identity > 80%, and query coverage (qcovs) > 50%.
# The same transcript IDs are then removed from the BRAKER GTF.
#
# BLAST and seqkit are run from Biocontainers images. The working
# directory is mounted at /data inside the container.
#
# Containers:
#   BLAST+   2.16.0   quay.io/biocontainers/blast:2.16.0--h6f7f691_0
#   seqkit   2.13.0   quay.io/biocontainers/seqkit:2.13.0--he881be0_0
#
# Example:
#   docker run --rm -v $PWD:/data -w /data \
#     quay.io/biocontainers/blast:2.16.0--h6f7f691_0 <command>

GENOTYPE=SAMPLE_ID
THREADS=20

for HAP in Hap1 Hap2; do
    PREFIX=${GENOTYPE}_${HAP}
    GENOME=${PREFIX}_final.fasta
    TELIB=${GENOME}.mod.EDTA.TElib.fa
    WORKDIR=braker_output_${PREFIX}
    TRANSCRIPTS=${WORKDIR}/braker.codingseq
    GTF=${WORKDIR}/braker.gtf

    ############################################################
    # BLAST+ v2.16.0
    ############################################################
    # qcovs is the percent of the transcript covered by the alignment.

    docker run --rm -v "${PWD}:/data" -w /data \
        quay.io/biocontainers/blast:2.16.0--h6f7f691_0 \
        makeblastdb \
            -in "${TELIB}" \
            -dbtype nucl \
            -out "${PREFIX}_TElib"

    docker run --rm -v "${PWD}:/data" -w /data \
        quay.io/biocontainers/blast:2.16.0--h6f7f691_0 \
        blastn \
            -query "${TRANSCRIPTS}" \
            -db "${PREFIX}_TElib" \
            -evalue 0.001 \
            -outfmt "6 qseqid sseqid pident length qlen evalue qcovs" \
            -num_threads "${THREADS}" \
            -out "${PREFIX}_transcripts_vs_TElib.blastn.tsv"

    ############################################################
    # Identity > 80% and query coverage > 50%
    ############################################################

    awk -F '\t' '$3 > 80 && $7 > 50 {print $1}' \
        "${PREFIX}_transcripts_vs_TElib.blastn.tsv" \
        | sort -u > "${PREFIX}_transcripts_TE_to_remove.txt"

    docker run --rm -v "${PWD}:/data" -w /data \
        quay.io/biocontainers/seqkit:2.13.0--he881be0_0 \
        seqkit grep -v \
            -f "${PREFIX}_transcripts_TE_to_remove.txt" \
            "${TRANSCRIPTS}" \
            -o "${PREFIX}_transcripts.filtered.fa"

    # Drop the same transcript IDs from the BRAKER GTF.
    # match() with a capture group requires GNU awk.
    awk 'NR==FNR {rm[$1]=1; next}
        {
            if (match($0, /transcript_id "([^"]+)"/, a)) {
                if (a[1] in rm) next
            }
            print
        }' "${PREFIX}_transcripts_TE_to_remove.txt" "${GTF}" \
        > "${PREFIX}_braker.filtered.gtf"
done
