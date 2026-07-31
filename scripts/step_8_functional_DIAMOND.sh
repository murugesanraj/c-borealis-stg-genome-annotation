#!/bin/bash
#SBATCH --job-name=diamond_annotation
#SBATCH --output=diamond_annotation.%j.out
#SBATCH --error=diamond_annotation.%j.err
#SBATCH --time=20:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --mail-type=END,FAIL          	
#SBATCH --mail-user= Your email for notifications

module load miniconda3
conda activate genome_pipeline_env

PREDICTED_PROTEINS="merged_transcripts.gtf.transdecoder.pep"
DIAMOND_DB="/build_ref_genome_crab/diamond_db/uniprot_sprot.dmnd"
ANNOTATIONS="functional_annotations.out"

diamond blastp -d $DIAMOND_DB -q $PREDICTED_PROTEINS -o $ANNOTATIONS

