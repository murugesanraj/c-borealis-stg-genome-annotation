#!/bin/bash
#SBATCH --job-name=stringTie
#SBATCH --output=stringTie.%j.out
#SBATCH --error=stringTie.%j.err
#SBATCH --time=48:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=128G     			
#SBATCH --mail-type=END,FAIL          	
#SBATCH --mail-user= Your email for notifications

# Load Conda and activate the environment
module load miniconda3
export PATH=/envs/genome_pipeline_env/bin:$PATH
conda activate genome_pipeline_env

RNA_ALIGN_BAM="merged_alignment_properly_paired.bam"
TRANSCRIPTS_GTF="transcripts.gtf"
MERGED_TRANSCRIPTS="merged_transcripts.gtf"

stringtie $RNA_ALIGN_BAM -o $TRANSCRIPTS_GTF
ls transcripts.gtf > transcripts_list.txt
stringtie --merge -o $MERGED_TRANSCRIPTS transcripts_list.txt
