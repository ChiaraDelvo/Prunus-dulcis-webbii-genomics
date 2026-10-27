INPUT=Set1_Input_Mig_F4.treemix.gz
PREFIX=TreeMix_migration

bash Step1_TreeMix.sh \
    "${INPUT}" \
    28 \
    100 \
    noRoot \
    100 \
    "$(which consense)" \
    "${PREFIX}" \
    1 \
    3 \
    10

    # STEP 2
# Evaluate migration-edge models using section A of
# Step2&4_TreeMix.R from the Dahms, 2021 (https://github.com/carolindahms/TreeMix) TreeMix pipeline.
#
# For the present dataset, m = 1 was retained for the final analyses.
# The Evanno-based OptM statistic could not be calculated when replicate
# likelihoods showed zero variance (SD = 0).

bash Step3_TreeMix.sh \
    "${INPUT}" \
    10 \
    100 \
    noRoot \
    100 \
    1 \
    "${PREFIX}" \
    10 \
    "${PREFIX}_constree.newick" \
    "$(which consense)"

# STEP 4
# Sections B and C of Step2&4_TreeMix.R were used to:
#
# - select/visualize the final maximum-likelihood migration graph;
# - generate residual-fit plots;
# - obtain migration-weight summary statistics using GetMigrStats().
