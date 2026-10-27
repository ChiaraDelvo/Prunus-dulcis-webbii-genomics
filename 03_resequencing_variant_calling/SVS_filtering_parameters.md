# SNP & Variation Suite filtering

**Software:** SNP & Variation Suite (SVS) v8.8.3  
**Developer:** Golden Helix, Bozeman, MT, USA

The original SNP filtering was performed using SVS with the following criteria:

| Criterion | Setting |
|---|---:|
| Variant type | SNP |
| Number of alleles | 2 |
| Variant quality | ≥30 |
| Chromosome 0 | Excluded |
| INDELs | Excluded |

Two filtering schemes were subsequently considered:

**Set1:** SNP call rate ≥90%

MAF ≥0.05

**Set2:** SNP call rate ≥90%

no MAF filtering

Set1 was used for population structure, inbreeding, LD decay, and downstream population-genomic analyses

Set2 was used for nucleotide-diversity analyses.
