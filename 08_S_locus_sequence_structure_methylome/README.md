# Analysis of S-locus sequence, structural, and methylome variation

## S-RNase and SFB sequence comparison

Multiple sequence alignments of S-RNase and SFB alleles were performed using T-COFFEE v13.46.0.919e8c6b. Pairwise sequence-similarity matrices were also obtained using T-COFFEE.

Commands are reported in `01_TCOFFEE_alignments.sh`.

## S-locus structural comparison

S-locus genomic intervals from the four `Tuono` and `DP9` haplotypes were defined using the best BLASTn matches to the S1 SFB (GenBank `MH316096.1`) and SLF (GenBank `MH316056.1`) sequences.

Syntenic relationships among the extracted haplotypes were identified using Minimap2 with the `asm20` preset.

The Minimap2 workflow is reported in `02_Minimap2_synteny.sh`.

## Whole-genome bisulfite sequencing analysis

Raw WGBS reads were adapter- and quality-trimmed using Trim Galore!, retaining reads with a minimum post-trimming length of 35 bp.

The corresponding reference genomes were indexed and WGBS reads were aligned using bwa-meth v0.2.9 with BWA-MEM2 indexing.

Duplicate handling was performed using Picard MarkDuplicates v3.4.0.

Methylation fractions in CpG, CHG, and CHH sequence contexts were extracted using MethylDackel v0.6.1 with the `--fraction`, `--CHG`, and `--CHH` options.

Commands are reported in `03_TrimGalore_WGBS.sh` to `06_MethylDackel.sh`.

## Read-coverage analysis at the Sf haplotype

Read coverage across the `Tuono_Hap2` Sf haplotype was calculated using deepTools v4.0.0 for the resequenced P. webbii individuals and the self-compatible P. dulcis cultivars `Tuono`, `Genco`, and `Filippo Cea`.

Coverage was normalized using Reads Per Genomic Content (RPGC).

The corresponding command is reported in `07_deepTools_coverage.sh`.

## Genomic-track visualization

CpG, CHG, and CHH methylation profiles, read-coverage tracks, gene annotations, and transposable-element annotations were integrated using pyGenomeTracks.

The corresponding workflow is reported in `08_pyGenomeTracks.sh`.
