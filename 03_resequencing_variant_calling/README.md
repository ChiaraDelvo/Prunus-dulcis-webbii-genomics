# Whole-genome resequencing and SNP calling

Whole-genome resequencing reads were processed independently against the `Tuono_Hap1` and `DP9_Hap2` assemblies with the same settings. The commands are written for `Tuono_Hap1` (`TU_1.fasta`). Repeating the analysis on `DP9_Hap2` requires only a change of reference FASTA and output names.

Raw whole-genome resequencing FASTQ files are available through NCBI SRA under BioProject `PRJNA1381291`.

The reference assemblies used for read mapping are available through NCBI under BioProject `PRJNA1387188` (`DP9_Hap2`) and `PRJNA1387209` (`Tuono_Hap1`).

## Read trimming

Paired-end reads were trimmed with Trimmomatic v0.39. Bases with quality below 20 were removed from both ends (`LEADING:20` and `TRAILING:20`), and reads shorter than 35 bp were discarded (`MINLEN:35`). Trimming used 10 threads.

Commands are reported in `01_trimming.sh`.

## Read mapping

Trimmed reads (`*_1.tr.fq.gz` and `*_2.tr.fq.gz`) were aligned with Minimap2 v2.28. An index of the reference was built with `minimap2 -d`, and alignments used the short-read preset (`-x sr`), 30 threads, and a read group whose `ID` and `SM` are the sample name.

Alignments were coordinate-sorted with samtools v1.21 using 10 threads. The temporary SAM file was removed after sorting.

Commands are reported in `02_read_mapping.sh`.

## Variant calling

Sorted BAMs were called jointly with Platypus v0.8.1.1. Every `*.sorted.bam` in the alignment directory was passed as one comma-separated list. Non-default settings were:

- minimum mapping quality: 30
- minimum number of supporting reads: 4
- minimum base quality: 30
- 20 CPUs
- duplicated read pairs retained (`filterDuplicates = 0`)

The Tuono haplotype 1 call set is `Variant_calling_Platypus_TU_Hap1.vcf`.

Commands are reported in `03_platypus_variant_calling.sh`.

## SNP filtering

SNP filtering was performed in SNP & Variation Suite (SVS) v8.8.3 (Golden Helix, Bozeman, MT, USA).

Biallelic SNPs were retained. INDELs and variants on chromosome 0 were excluded, and a minimum variant quality of 30 was required.

Two filtered datasets were generated independently for each reference assembly:

- `set1`: SNP call rate ≥90% and MAF ≥0.05. Used for population structure, inbreeding, linkage-disequilibrium decay, and the other population-genomic analyses.
- `set2`: SNP call rate ≥90%, without a MAF filter. Used for nucleotide-diversity analyses.

The SVS parameters are summarised in `SVS_filtering_parameters.md`.
