#!/bin/bash
#SBATCH --job-name=polish_genome
#SBATCH --output=polish_genome.%j.out
#SBATCH --error=polish_genome.%j.err
#SBATCH --time=48:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=256G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user= Your email for notifications

module load miniconda3
export PATH=/envs/genome_pipeline_env/bin:$PATH
source activate genome_pipeline_env

MERGED="merged_merged_assembly.fasta"
RNA_ALIGN_BAM="merged_alignment_properly_paired.bam"
POLISHED="polished_assembly.fasta"

# Start from the last successfully completed chunk (if restarting)
START_CHUNK=${START_CHUNK:-1}

# Function to run Pilon on a chunk
run_pilon() {
  chunk=$1
  pilon --genome $chunk --bam $RNA_ALIGN_BAM --output polished_$chunk --fix bases,indels -Xmx128g
}

# Split the genome into chunks (each contig in a separate file)
csplit -z $MERGED '/^>/' '{*}' --prefix=contig_ --suffix-format='%04d.fasta'


# Get total number of chunks
total_chunks=$(ls contig_*.fasta | wc -l)

# Loop through chunks
for ((i=$START_CHUNK; i<=$total_chunks; i++)); do
  chunk="contig_$(printf %04d $i).fasta"
  echo "Polishing chunk $i of $total_chunks (file: $chunk)..."
  run_pilon $chunk
  if [[ $? -ne 0 ]]; then
    echo "Error polishing chunk $i (file: $chunk). Exiting."
    exit 1
  fi
done

# Combine polished chunks
cat polished_contig_*.fasta > $POLISHED

echo "Genome polishing complete."
