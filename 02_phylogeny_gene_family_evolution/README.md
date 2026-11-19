# Phylogenetic inference and gene family evolutionary dynamics

Phylogenomic analyses were independently performed using two alternative haplotype combinations:

- `Tuono_Hap1` and `DP9_Hap1`
- `Tuono_Hap2` and `DP9_Hap2`

Each analysis also included the reference proteomes of *P. davidiana*, *P. ferganensis*, *P. kansuensis*, *P. mira*, *P. mongolica*, *P. persica*, and *P. mume*.

## Orthogroup inference

Orthogroup inference was performed following the OrthoFinder v3.0.1b1 workflow, using DIAMOND in ultra-sensitive mode for sequence searches, MAFFT v7.526 for multiple sequence alignments, the default MSA trimming procedure, and RAxML-NG for gene-tree inference. Single-copy orthogroups were retained, and the corresponding trimmed alignments were concatenated into a supermatrix for downstream phylogenetic inference. 

The corresponding OrthoFinder command is reported in `01_OrthoFinder.sh`.
## Species tree

The species-tree alignment produced by OrthoFinder was used for maximum-likelihood inference with IQ-TREE v2.4.0 under ModelFinder (`MFP`) and 100 ultrafast bootstrap replicates.

The resolved gene trees were concatenated and summarised with ASTRAL-Pro3 v1.25.3.8, rooted on `Prunus_mume`. Each gene was mapped to the species given by the first two fields of its name.

Commands are reported in `02_IQTREE.sh` and `02b_ASTRAL_Pro3.sh`.

## Divergence-time calibration

The species tree (`newTree.nwk`) was dated in R with `ape`, `phytools`, and `castor`. The tree was rooted on `Prunus_mume`. The *P. persica*–*P. dulcis* split (`Prunus_persica` and `TU_Hap1`) was set to 5.8 million years by rescaling the root age. The ultrametric tree is `tree_dated.nwk`.

Commands are reported in `03_time_calibration.R`.

## Gene family evolution

`04_ultrametric.sh` does not date the tree again. It lowercases `tree_dated.nwk` from the R calibration and formats the OrthoFinder gene counts for CAFE. The count table keeps the family identifier plus the taxa used in the tree.

CAFE estimated a global gene gain/loss rate (`lambda -s`). P-values used 1,000 Monte Carlo samples. Family-wise expansions and contractions were summarised from the CAFE report.

Commands are reported in `04_ultrametric.sh` and `05_CAFE.sh`.
