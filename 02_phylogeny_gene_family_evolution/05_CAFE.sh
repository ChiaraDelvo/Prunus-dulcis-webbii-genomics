#!/usr/bin/env bash

# Gene-family expansion and contraction with CAFE.
# lambda -s estimates one global gain/loss rate. The value is not
# supplied in advance.
# load -r is the number of Monte Carlo samples used to calculate
# p-values for the observed gene-family sizes.
# -filter restricts the families passed to the calculation.
#
# The commands below are those entered in the CAFE shell.
# cafetutorial_report_analysis.py then summarises expansions and
# contractions.

CAFE=/software/CAFE/release/cafe
CAFE_SAMPLES=1000
CAFE_THREADS=10
CAFE_COUNTS=table_cafe_counts.txt
ULTRAMETRIC_TREE_LOWER=lower_tree_dated.nwk

for HAP in Hap1 Hap2; do
    (
        cd "Results_${HAP}"

        "${CAFE}" <<EOF
tree ${ULTRAMETRIC_TREE_LOWER}
load -r ${CAFE_SAMPLES} -t ${CAFE_THREADS} -i ${CAFE_COUNTS} -l log.txt -filter
lambda -s
report results
EOF

        python2.7 cafetutorial_report_analysis.py \
            -i results.cafe \
            -r 0 \
            -o report_cafe
    )
done
