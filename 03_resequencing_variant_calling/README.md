# Whole-genome resequencing and SNP calling

Whole-genome resequencing reads were processed independently against the `Tuono_Hap1` and `DP9_Hap2` assemblies with the same settings. Commands are therefore reported once in a reference-independent format

Raw whole-genome resequencing FASTQ files are available through NCBI SRA under BioProject `PRJNA1381291`.

The reference assemblies used for read mapping are available through NCBI under BioProject `PRJNA1387188` (`DP9_Hap2`) and `PRJNA1387209` (`Tuono_Hap1`).

Commands are therefore reported once in a reference-independent format and can be applied to either dataset by specifying the corresponding reference genome and output prefix.

## Read trimming

Paired-end reads were trimmed with Trimmomatic v0.39. Bases with quality below 20 were removed from both ends (`LEADING:20` and `TRAILING:20`), and reads shorter than 35 bp were discarded (`MINLEN:35`). Trimming used 10 threads.

Commands are reported in `01_trimming.sh`.

## Read mapping

Trimmed reads (`*_1.tr.fq.gz` and `*_2.tr.fq.gz`) were aligned with Minimap2 v2.24. An index of the reference was built with `minimap2 -d`, and alignments used the short-read preset (`-x sr`), 30 threads, and a read group whose `ID` and `SM` are the sample name.

Alignments were coordinate-sorted with samtools v1.21 using 10 threads. The temporary SAM file was removed after sorting.

Commands are reported in `02_read_mapping.sh`.

## Variant calling

Sorted BAMs were called jointly with Platypus v0.8.1.1. Every `*.sorted.bam` in the alignment directory was passed as one comma-separated list. Non-default settings were:

- minimum mapping quality: 30
- minimum number of supporting reads: 4
- minimum base quality: 30
- 20 CPUs
- duplicated read pairs retained (`filterDuplicates = 0`)

Commands are reported in `03_platypus_variant_calling.sh`.

## SNP filtering

SNP filtering in the original analysis was performed using SNP & Variation Suite (SVS) v8.8.3 (Golden Helix, Bozeman, MT, USA).

Biallelic SNPs were retained after excluding INDELs and variants located on chromosome 0 and applying a minimum variant quality score of 30.

Two filtered datasets were generated independently for each reference assembly:

- `set1`: SNP call rate ≥90% and MAF ≥0.05.

- `set2`: SNP call rate ≥90%, without MAF filtering.

The filtering parameters originally applied in SVS are summarized in SVS_filtering_parameters.md.

The SVS parameters are summarised in `SVS_filtering_parameters.md`.
