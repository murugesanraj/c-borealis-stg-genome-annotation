#!/bin/bash
#SBATCH --job-name=align_rna
#SBATCH --output=align_rna.%j.out
#SBATCH --error=align_rna.%j.err
#SBATCH --time=20:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --mail-type=END,FAIL          	
#SBATCH --mail-user= Your email for notifications

module load miniconda3
conda activate genome_pipeline_env

MERGED="merged_assembly.fasta"
RNA_SEQ_R1="combined_R1.fastq.gz"
RNA_SEQ_R2="combined_R2.fastq.gz"
RNA_ALIGN_BAM="rna_alignment.bam"

hisat2-build $MERGED $MERGED
hisat2 -x $MERGED -1 $RNA_SEQ_R1 -2 $RNA_SEQ_R2 -S rna_alignment.sam
samtools sort -o $RNA_ALIGN_BAM rna_alignment.sam
samtools index $RNA_ALIGN_BAM

