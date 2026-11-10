#!/usr/bin/env bash

# Filter the two initial haplotype assemblies:
#   (i)   remove contigs shorter than 50 kb
#   (ii)  keep Viridiplantae (including child taxa) and unclassified contigs
#   (iii) align remaining contigs to the Nonpareil organellar genomes
#
# Tools are run from Biocontainers images. The working directory is mounted
# at /data. The Kraken2 database directory is mounted read-only at /db.
#
# Containers:
#   seqtk        1.4     quay.io/biocontainers/seqtk:1.4--h577a1d6_3
#   Kraken2      2.1.6   quay.io/biocontainers/kraken2:2.1.6--pl5321h077b44d_0
#   KrakenTools  1.2     quay.io/biocontainers/krakentools:1.2--pyh7e72e81_1
#   Minimap2     2.17    quay.io/biocontainers/minimap2:2.17--hed695b0_3
#
# Example:
#   docker run --rm -v $PWD:/data -w /data \
#     quay.io/biocontainers/seqtk:1.4--h577a1d6_3 <command>

GENOTYPE=SAMPLE_ID
THREADS=20
KRAKEN2_DB=PlusPFP_Jan2024

# Nonpareil organellar genomes (GenBank).
NONPAREIL_MT=CM038036.1.fasta
NONPAREIL_CP=CM038037.1.fasta

for HAP in Hap1 Hap2; do
    PREFIX=${GENOTYPE}_${HAP}
    ASSEMBLY=${PREFIX}_assembly.fasta

    ############################################################
    # (i) seqtk v1.4 — remove contigs shorter than 50 kb
    ############################################################

    docker run --rm -v "${PWD}:/data" -w /data \
        quay.io/biocontainers/seqtk:1.4--h577a1d6_3 \
        seqtk seq -L 50000 "${ASSEMBLY}" > "${PREFIX}_min50kb.fasta"

    ############################################################
    # (ii) Kraken2 v2.1.6 and KrakenTools v1.2
    ############################################################
    # Keep Viridiplantae (taxid 33090, including child taxa) and
    # unclassified contigs (taxid 0).

    docker run --rm \
        -v "${PWD}:/data" \
        -v "${KRAKEN2_DB}:/db:ro" \
        -w /data \
        quay.io/biocontainers/kraken2:2.1.6--pl5321h077b44d_0 \
        kraken2 \
            --threads "${THREADS}" \
            --db /db \
            --report "${PREFIX}_kraken_report.txt" \
            --output "${PREFIX}_kraken.out" \
            "${PREFIX}_min50kb.fasta"

    docker run --rm -v "${PWD}:/data" -w /data \
        quay.io/biocontainers/krakentools:1.2--pyh7e72e81_1 \
        extract_kraken_reads.py \
            -k "${PREFIX}_kraken.out" \
            -r "${PREFIX}_kraken_report.txt" \
            --taxid 33090 0 \
            --include-children \
            -s "${PREFIX}_min50kb.fasta" \
            -o "${PREFIX}_kraken_clean.fasta"

    ############################################################
    # (iii) Minimap2 v2.17 — organellar synteny
    ############################################################
    # Align to the Nonpareil mitochondrial (CM038036.1) and chloroplast
    # (CM038037.1) genomes. A contig is removed when either genome covers
    # at least 50% of its length. Overlapping alignments are merged first;
    # coverage from the two genomes is not added together.

    docker run --rm -v "${PWD}:/data" -w /data \
        quay.io/biocontainers/minimap2:2.17--hed695b0_3 \
        minimap2 -x asm5 -t "${THREADS}" \
            "${NONPAREIL_MT}" "${PREFIX}_kraken_clean.fasta" \
        > "${PREFIX}_vs_mt.paf"

    docker run --rm -v "${PWD}:/data" -w /data \
        quay.io/biocontainers/minimap2:2.17--hed695b0_3 \
        minimap2 -x asm5 -t "${THREADS}" \
            "${NONPAREIL_CP}" "${PREFIX}_kraken_clean.fasta" \
        > "${PREFIX}_vs_cp.paf"

    # PAF columns used: query name, query length, query start, query end.
    awk 'BEGIN{OFS="\t"} NF >= 4 && $4 > $3 {print $1, $3, $4, $2, FILENAME}' \
            "${PREFIX}_vs_mt.paf" "${PREFIX}_vs_cp.paf" \
        | sort -k5,5 -k1,1 -k2,2n \
        | awk '
            function flush() {
                if (name != "" && nlen > 0 && covered / nlen >= 0.5)
                    print name
            }
            $5 != src || $1 != name {
                flush()
                src = $5
                name = $1
                nlen = $4
                covered = 0
                end = 0
            }
            {
                s = $2
                e = $3
                if (s < end) {
                    if (e > end) {
                        covered += e - end
                        end = e
                    }
                } else {
                    covered += e - s
                    end = e
                }
            }
            END { flush() }
        ' \
        | sort -u > "${PREFIX}_organelle_contigs.txt"

    grep '^>' "${PREFIX}_kraken_clean.fasta" \
        | sed 's/^>//; s/[[:space:]].*//' \
        | grep -vxF -f "${PREFIX}_organelle_contigs.txt" \
        > "${PREFIX}_no_organelle.ids"

    docker run --rm -v "${PWD}:/data" -w /data \
        quay.io/biocontainers/seqtk:1.4--h577a1d6_3 \
        seqtk subseq \
            "${PREFIX}_kraken_clean.fasta" \
            "${PREFIX}_no_organelle.ids" \
        > "${PREFIX}_no_organelle.fasta"
done
