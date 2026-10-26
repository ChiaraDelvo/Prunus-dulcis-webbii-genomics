# SNP & Variation Suite filtering

**Software:** SNP & Variation Suite (SVS) v8.8.3  
**Developer:** Golden Helix, Bozeman, MT, USA

The original SNP filtering was performed using SVS with the following criteria:

| Criterion | Setting |
|---|---:|
| Variant type | SNP |
| Number of alleles | 2 |
| Variant quality | ≥30 |
| SNP call rate | ≥90% || Chromosome 0 | Excluded |
| INDELs | Excluded |

Two filtering schemes were subsequently considered:

**Set1:** SNP call rate ≥90% and MAF ≥0.05.

**Set2:** SNP call rate ≥90%, without MAF filtering. The exact population-specific nucleotide-diversity commands based on this filtering scheme are provided in `05_diversity_inbreeding_LD`.
