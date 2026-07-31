#!/bin/bash
#SBATCH --job-name=busco
#SBATCH --output=busco.%j.out
#SBATCH --error=busco.%j.err
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --mail-type=END,FAIL          
#SBATCH --mail-user= Your email for notifications

module load miniconda3
conda activate genome_pipeline_env

POLISHED="polished_assembly.fasta"
BUSCO_LINEAGE="/build_ref_genome_crab/busco_lineages/arthropoda_odb10"

singularity exec -B /mnt/pixstor:/mnt/pixstor $BRAKER_IMAGE busco \
    -i $POLISHED \
    -l $BUSCO_LINEAGE \
    -o busco_output \
    -m genome \
    --cpu 8

