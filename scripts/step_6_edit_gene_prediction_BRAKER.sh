#!/bin/bash
#SBATCH --job-name=braker
#SBATCH --output=braker.%j.out
#SBATCH --error=braker.%j.err
#SBATCH --time=48:00:00
#SBATCH --cpus-per-task=16
#SBATCH --mem=128G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user= Your email for notifications

# Define Variables
MASKED="/build_ref_genome_crab/merged_merged_assembly.fasta.masked"
RNA_ALIGN_BAM="/build_ref_genome_crab/merged_alignment_properly_paired.bam"
BRAKER_IMAGE="/build_ref_genome_crab/braker3.sif" # Corrected path
WORKDIR="/build_ref_genome_crab/baker"
OUTPUT_DIR="$WORKDIR/braker_output"
AUGUSTUS_CONFIG_PATH="/build_ref_genome_crab/augustus_config/config"

# Prepare Augustus configuration directory
mkdir -p "$AUGUSTUS_CONFIG_PATH/species/cancer_borealis"
chmod -R u+w "$AUGUSTUS_CONFIG_PATH"

# Set the AUGUSTUS_CONFIG_PATH environment variable
export AUGUSTUS_CONFIG_PATH="$AUGUSTUS_CONFIG_PATH"

# Confirm the environment variable
echo "AUGUSTUS_CONFIG_PATH is set to: $AUGUSTUS_CONFIG_PATH"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Check if input files exist
if [[ ! -f "$MASKED" ]]; then
  echo "Error: Masked genome file not found: $MASKED"
  exit 1
fi

if [[ ! -f "$RNA_ALIGN_BAM" ]]; then
  echo "Error: RNA-seq BAM file not found: $RNA_ALIGN_BAM"
  exit 1
fi

# Run BRAKER
singularity exec --env AUGUSTUS_CONFIG_PATH="$AUGUSTUS_CONFIG_PATH" -B "$BRAKER_IMAGE" braker.pl \
  --genome="$MASKED" \
  --bam="$RNA_ALIGN_BAM" \
  --softmasking \
  --species=cancer_borealis \
  --verbosity=3 \
  --workingdir="$OUTPUT_DIR"

# Check BRAKER exit status
if [[ $? -ne 0 ]]; then
  echo "Error: BRAKER execution failed."
  exit 1
fi

echo "BRAKER execution completed successfully."
