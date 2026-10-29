# Metadata

This directory contains sample information and auxiliary files used by the population-genomic analyses.

- `sample_metadata.tsv`  
  General information for the 72 resequenced accessions, including WGS sample ID, manuscript ID, accession name, species assignment, and population-structure group at K = 2.

- `Family_ids_F3.txt`  
  PLINK ID mapping used to assign samples to `K1_Pw`, `K2_Pd`, and `Admixed` groups for the three-population (f3) analysis in `04_population_structure`.

- `Family_Pw_PdAp_PdOt_Admx.txt`  
  PLINK ID mapping used to assign samples to `K1_Pw`, `K2_Pd_Apulia`, `K2_Pd_Other`, and `Admixed` groups for TreeMix migration and four-population (f4) analyses in `04_population_structure`.

- `K1_Pw_IDs.txt`  
  Sample IDs assigned to the `K1_Pw` group. Used for population-specific analyses in `04_population_structure`, `05_diversity_LDdecay`, and `06_selection_signatures`.

- `K2_Pd_IDs.txt`  
  Sample IDs assigned to the `K2_Pd` group. Used for population-specific analyses in `04_population_structure`, `05_diversity_LDdecay`, and `06_selection_signatures`.

- `Remove_D149.txt`  
  Sample-removal file used for the TreeMix migration and f4 analyses in `04_population_structure`.
