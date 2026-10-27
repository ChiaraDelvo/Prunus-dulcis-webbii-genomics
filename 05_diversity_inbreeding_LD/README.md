# Nucleotide diversity and LD decay

Nucleotide diversity and linkage disequilibrium decay analyses were independently performed on datasets generated using the `DP9_Hap2` and `Tuono_Hap1` reference assemblies. The same analytical settings were applied to both datasets; commands are therefore reported once in a reference-independent format.

## Nucleotide diversity

Nucleotide diversity (π) was estimated separately for the `K1_Pw` and `K2_Pd` groups using VCFtools v0.1.16 and the `set2` datasets.

Mean nucleotide diversity was calculated in non-overlapping 50-kb windows.

The corresponding command is provided in `01_nucleotide_diversity.sh`.

## LD decay

Genome-wide LD decay was estimated separately for the `K1_Pw` and `K2_Pd` groups starting from the `set1` datasets.

Before LD estimation, population-specific datasets were filtered for MAF ≥0.01.

Pairwise LD was calculated using PLINK v1.9 with `--ld-window-r2 0`, thereby retaining pairwise r² estimates irrespective of their magnitude.

The PLINK workflow is provided in `02_LD_decay_PLINK.sh`.

The nonlinear regression used to model r² decay with physical distance was performed in R following Marroni et al., as described in the Materials and Methods.
