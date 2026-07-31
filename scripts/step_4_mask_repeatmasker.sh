#!/bin/bash
#SBATCH --job-name=mask_repeats
#SBATCH --output=mask_repeats.%j.out
#SBATCH --error=mask_repeats.%j.err
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --mail-type=END,FAIL          	
#SBATCH --mail-user= Your email for notifications


# Load Conda and activate the environment
module load miniconda3
conda activate genome_pipeline_env


# Define input and output files
POLISHED="polished_assembly.fasta"
MASKED="polished_assembly.masked.fasta"

# Ensure output directory exists and is writable
OUTPUT_DIR="./output"
mkdir -p $OUTPUT_DIR
chmod 755 $OUTPUT_DIR

# Run RepeatMasker with 4 threads
RepeatMasker -species "Strongylocentrotus purpuratus" -pa 4 -dir $OUTPUT_DIR $POLISHED
