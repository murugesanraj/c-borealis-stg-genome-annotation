#!/bin/bash
#SBATCH --job-name=transdecoder
#SBATCH --output=transdecoder.%j.out
#SBATCH --error=transdecoder.%j.err
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --mail-type=END,FAIL          	
#SBATCH --mail-user= Your email for notifications

module load miniconda3
export PATH=$PATH:/envs/transdecoder_env/opt/transdecoder
conda activate transdecoder_env

conda activate genome_pipeline_env

MERGED_TRANSCRIPTS="merged_transcripts.gtf"

TransDecoder.LongOrfs -t $MERGED_TRANSCRIPTS
TransDecoder.Predict -t $MERGED_TRANSCRIPTS

