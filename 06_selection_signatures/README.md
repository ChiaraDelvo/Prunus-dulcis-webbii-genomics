# Identification and characterization of selection signals

Selection scans reported in the manuscript were performed using the `DP9_Hap2_set1` dataset and individuals assigned to the `K1_Pw` and `K2_Pd` groups at K = 2.

Three complementary statistics were considered: XP-CLR, Weir and Cockerham's weighted FST, and reduction of diversity (ROD). All three genome-wide selection metrics were evaluated using 10-kb genomic windows with a 5-kb overlap.

## XP-CLR

XP-CLR scans in *P. dulcis* and *P. webbii* were performed using the Harding implementation of XP-CLR (https://github.com/hardingnj/xpclr).

Chromosome-specific mean recombination rates were derived from chromosome physical lengths in the `DP9_Hap2` assembly and the corresponding genetic-map lengths reported by Gómez et al. (2026).

Detailed XP-CLR commands and recombination-rate settings are provided in `01_XPCLR.sh`.

## FST

Weir and Cockerham's weighted FST between `K1_Pw` and `K2_Pd` was calculated using VCFtools.

Detailed commands are provided in `02_windowed_FST.sh`.

## Reduction of diversity

Nucleotide diversity was calculated separately for `K1_Pw` and `K2_Pd`.

ROD was calculated as:

`ROD = 1 - (π_query / π_reference)`

Each population was alternatively considered as the query and reference population.

Detailed commands and downstream filtering criteria are provided in `03_ROD_nucleotide_diversity.sh`.

## Selection-signal thresholds

For each metric, genomic windows ranking within the upper 5% of the corresponding genome-wide distribution were considered candidate windows.

Putative selection signals were defined as windows supported by at least two of the three metrics: XP-CLR, weighted FST, and ROD.

## Candidate-gene analyses

Variants located within `MYB61`, `COMT`, and `F5H`, including regions extending 3 kb upstream and 1 kb downstream of the gene boundaries, were further characterized using per-site FST and Ensembl Variant Effect Predictor (VEP).

Per-site FST commands are provided in `04_candidate_gene_FST.sh`, whereas variant extraction and VEP analysis are reported in `05_VEP.sh`.
