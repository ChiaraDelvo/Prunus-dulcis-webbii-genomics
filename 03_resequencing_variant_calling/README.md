**Whole-genome resequencing and SNP calling**

Whole-genome resequencing data were independently processed against the `DP9_Hap2` and `Tuono_Hap1` reference assemblies using the same computational settings. Commands are therefore reported once in a reference-independent format and can be applied to either dataset by specifying the corresponding reference genome and output prefix.

Raw whole-genome resequencing FASTQ files are available through NCBI SRA under BioProject `PRJNA1381291`.

The reference assemblies used for read mapping are available through NCBI under BioProject `PRJNA1387188` (`DP9_Hap2`) and `PRJNA1387209` (`Tuono_Hap1`).

**Read trimming**

Raw reads were trimmed using Trimmomatic. A minimum read length of 35 bp and a quality threshold of 20 were applied.

The exact command used in the original analysis is reported in `01_trimming.sh`.

**Read mapping**

Trimmed reads were aligned against either the `DP9_Hap2` or `Tuono_Hap1` reference assembly using Minimap2 v2.24-r1122 with the short-read preset (`-x sr`).

The mapping command is reported in `02_read_mapping.sh`.

**Variant calling**

Variant calling was performed using Platypus v0.8.1.1 using the following non-default settings explicitly reported in the manuscript:

- minimum mapping quality: 30
- minimum number of supporting reads: 4
- minimum base quality: 30
- duplicated read pairs retained (`filterDuplicates = 0`)

The corresponding command is reported in `03_platypus_variant_calling.sh`.

## SNP filtering

SNP filtering in the original analysis was performed using SNP & Variation Suite (SVS) v8.8.3 (Golden Helix, Bozeman, MT, USA).

Biallelic SNPs were retained after excluding INDELs and variants located on chromosome 0 and applying a minimum variant quality score of 30.

Two filtered datasets were generated independently for each reference assembly:

`set1`: SNP call rate ≥90% and MAF ≥0.05.

`set2`: SNP call rate ≥90%, without MAF filtering.

The filtering parameters originally applied in SVS are summarized in `SVS_filtering_parameters.md`.

For reproducibility using open-source software, `04_vcftools_equivalent_filtering.sh` provides the VCFtools implementation of the variant-filtering criteria used to generate the `set1` and `set2` dataset. This command represents an open-source equivalent of the filtering criteria originally applied in SVS.
