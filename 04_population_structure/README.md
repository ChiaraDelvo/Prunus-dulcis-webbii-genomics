# Population structure analyses

Population structure analyses were independently performed on the LD-pruned `set1` datasets generated using the `DP9_Hap2` and `Tuono_Hap1` reference assemblies. The same analytical settings were applied to both datasets; commands are therefore reported once in a reference-independent format.

## LD pruning

LD pruning was performed using SNP & Variation Suite (SVS) v8.8.3 using:

| Parameter | Setting |
|---|---:|
| Window size | 50 markers |
| Step size | 5 markers |
| LD threshold | r² = 0.2 |
| LD estimator | Composite Haplotype Method (CHM) |

The LD-pruned datasets were used for ADMIXTURE and TreeMix-based analyses.

## Analyses

Commands are provided for:

`01_ADMIXTURE.sh` – individual ancestry estimation.

`02_threepop_f3.sh` – preparation of population-stratified allele frequencies and TreeMix three-population f3 statistics.

`03_prepare_TreeMix_migration_input.sh` – preparation of the four-population TreeMix input used for migration and f4 analyses.

`04_TreeMix_migration_pipeline.sh` – TreeMix population split and migration analyses following the Dahms et al. workflow.

`05_fourpop_f4.sh` – TreeMix four-population f4 statistics.
