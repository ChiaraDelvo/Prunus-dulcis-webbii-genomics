# Phylogenetic inference and gene family evolutionary dynamics

Phylogenomic analyses were independently performed using two alternative haplotype combinations:

- `Tuono_Hap1` and `DP9_Hap1`
- `Tuono_Hap2` and `DP9_Hap2`

Each analysis also included the reference proteomes of *P. davidiana*, *P. ferganensis*, *P. kansuensis*, *P. mira*, *P. mongolica*, *P. persica*, and *P. mume*.

## Orthogroup inference and phylogenetic reconstruction

Orthogroups were inferred using OrthoFinder, and single-copy orthogroups were retained for phylogenetic reconstruction.

Protein sequences from single-copy orthogroups were aligned using MAFFT. Alignments were subsequently trimmed according to the criteria described in the manuscript and concatenated into a supermatrix.

Maximum-likelihood phylogenetic trees were inferred using IQ-TREE with 100 non-parametric bootstrap replicates.

Tree topology was independently assessed using the coalescent-based ASTRAL-Pro3 approach.

Commands are reported in `01_OrthoFinder.sh` to `05_ASTRAL_Pro3.sh`.

## Divergence-time calibration

Phylogenetic trees were converted to ultrametric trees using the divergence between *P. persica* and *P. dulcis* (5.88 MYA) as calibration.

Details of the software and command used for time calibration are reported in `06_time_calibration.md`.

## Gene family evolution

Gene-family expansions and contractions were inferred using CAFE v4.2.1 from the time-calibrated phylogenetic trees.

Before CAFE analysis, gene families were filtered to:

- retain families present in at least two species;
- exclude families containing ≥100 gene copies in any species.

The custom filtering script is provided in `07_CAFE_family_filtering.py`.

The CAFE workflow is reported in `08_CAFE.sh`.
