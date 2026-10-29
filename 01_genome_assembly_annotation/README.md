# De novo assembly and annotation of nuclear and chloroplast genomes

## Nuclear genome assembly

PacBio HiFi reads were assembled using Hifiasm v0.16.0 with a purging similarity threshold of 0.3.

Initial and final assembly quality was assessed using QUAST v5.0.2 and BUSCO v5.2.2 with the Eudicots reference dataset.

Assembly filtering included removal of contigs shorter than 50 kb, taxonomic filtering using Kraken2 v2.1.6, and removal of contigs showing high synteny with the almond mitochondrial and chloroplast genomes.

Scaffolding was performed using Redundans v2.0 and RagTag v2.1.0 against the `Nonpareil` almond reference genome (GenBank assembly `GCA_021292205.2`).

Commands are reported in `01_hifiasm_assembly.sh` to `04_scaffolding.sh`.

## Repeat and gene annotation

Transposable elements were annotated using EDTA v2.2.2, which was also used to generate a repeat-masked genome.

Gene annotation was performed using BRAKER3 v3.0.8 using Rosaceae protein evidence and RNA-seq data.

Following functional annotation, transcripts matching the EDTA non-redundant TE library were filtered according to the criteria reported in the manuscript.

Commands are reported in `05_EDTA.sh` to `07_TE_transcript_filtering.sh`.

## Whole-genome comparison and structural variation

Pairwise whole-genome alignments between haplotypes were performed using Minimap2 with the `asm5` preset.

SyRI v1.6.3 was subsequently used to identify collinear regions and structural rearrangements.

Commands are reported in `08_Minimap2_SyRI.sh`.

## Chloroplast genome assembly

Chloroplast genomes were assembled from PacBio HiFi reads using ptGAUL v1.0.5 with default parameters and the *P. dulcis* chloroplast genome `NC_034696` as reference.

Commands are reported in `09_ptGAUL_chloroplast.sh`.

Chloroplast genome annotation was performed using GeSeq with:

- `Chloroplast land plants (CDS + rRNA)` as reference set;
- all available *Prunus* chloroplast annotations as third-party references;
- Chloë v0.1.0 enabled as third-party stand-alone annotator.
