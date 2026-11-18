# Analysis of S-locus sequence, structural, and methylome variation

## S-RNase and SFB sequence comparison

Multiple sequence alignments of S-RNase and SFB alleles, together with the corresponding pairwise sequence-similarity matrices, were generated using the T-COFFEE v13.46.0.919e8c6b web interface (https://www.ebi.ac.uk/jdispatcher/msa/tcoffee).

For S-RNase, the analysis included the Tuono and DP9 alleles, the Lauranne Sf allele, the Brown Nonpareil S1 allele, and the *P. webbii* alleles AM690352, AM690353, and AM690354.

For SFB, the analysis included the corresponding Tuono and DP9 haplotypes.

## S-locus structural comparison

S-locus genomic intervals from the four `Tuono` and `DP9` haplotypes were defined using the best BLASTn matches to the S1 SFB (GenBank `MH316096.1`) and SLF (GenBank `MH316056.1`) sequences.

Syntenic relationships among the extracted haplotypes were identified using Minimap2 with the `asm20` preset.

The Minimap2 workflow is reported in `02_Minimap2_synteny.sh`.

## Whole-genome bisulfite sequencing analysis

Raw WGBS reads were trimmed with Trim Galore (`--paired --fastqc --length 35`). Reads shorter than 35 bp after trimming were discarded, and FastQC reports were written with the trimmed reads.

Commands are reported in `03_TrimGalore.sh`.

Each reference genome was indexed with `bwameth.py index-mem2` (bwa-meth v0.2.9, BWA-MEM2). Trimmed paired reads were aligned with 10 threads. SAM output was converted to coordinate-sorted BAM with samtools v1.22.1.

Duplicates were marked with Picard MarkDuplicates v3.4.0 and left in the BAM. A duplication-metrics file was written for each library, and each BAM was indexed with samtools v1.22.1.

Methylation fractions in CpG, CHG, and CHH contexts were extracted with MethylDackel v0.6.1 (`--fraction --CHG --CHH`, 8 threads). The bedGraph files were sorted and converted to bigWig with UCSC `bedGraphToBigWig` (kent 482). The chromosome sizes were the first two columns of the FASTA index.

Commands are reported in `04_bwameth_alignment.sh`, `05_Picard_MarkDuplicates.sh`, `06_MethylDackel.sh`, and `07_bedGraphToBigWig.sh`.

## Read-coverage analysis at the Sf haplotype

Read coverage across the `Tuono_Hap2` Sf haplotype was calculated with deepTools v3.5.6 for the resequenced P. webbii individuals and the self-compatible P. dulcis cultivars `Tuono`, `Genco`, and `Filippo Cea`.

Coverage was normalized with Reads Per Genomic Content (RPGC), a bin size of 50 bp, an effective genome size of 267,641,598 bp, and 10 threads.

The corresponding command is reported in `08_deepTools_coverage.sh`.

## Genomic-track visualization

Methylation and read-coverage bigWig tracks and the gene annotation were drawn with pyGenomeTracks v2.1.

The corresponding workflow is reported in `09_pyGenomeTracks.sh`.
