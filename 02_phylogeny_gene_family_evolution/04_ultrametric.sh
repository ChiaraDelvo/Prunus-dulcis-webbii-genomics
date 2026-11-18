#!/usr/bin/env bash

# Convert the species tree to the ultrametric chronogram required by CAFE
# and format the OrthoFinder gene counts.
#
# The root age is the P. persica–P. dulcis split: 5.88 million years,
# passed to make_ultrametric.py as 5880000 years. That script writes
# tree_dated.nwk in the current directory.
#
# CAFE matches tip labels by case, so the tree and the count table are
# lowercased. The count table duplicates the first column as the family
# identifier and keeps fields 1-11 (family ID plus the taxa in the tree).
# Change the cut range if the species set changes.

ROOT_AGE=5880000
NEW_TREE=newTree.nwk
ULTRAMETRIC_TREE=tree_dated.nwk
ULTRAMETRIC_TREE_LOWER=lower_tree_dated.nwk
GENE_COUNTS=Orthogroups.GeneCount.tsv
CAFE_COUNTS=table_cafe_counts.txt

for HAP in Hap1 Hap2; do
    (
        cd "Results_${HAP}"

        make_ultrametric.py -r "${ROOT_AGE}" "${NEW_TREE}"

        tr '[:upper:]' '[:lower:]' < "${ULTRAMETRIC_TREE}" > "${ULTRAMETRIC_TREE_LOWER}"

        awk -F '\t' '{print $1 "\t" $0}' "${GENE_COUNTS}" \
            | tr '[:upper:]' '[:lower:]' \
            | cut -f1-11 \
            > "${CAFE_COUNTS}"
    )
done
