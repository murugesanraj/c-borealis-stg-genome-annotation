#!/bin/bash
#SBATCH --job-name=merge_assemblies
#SBATCH --output=merge_assemblies.%j.out
#SBATCH --error=merge_assemblies.%j.err
#SBATCH --time=48:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=196G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=rajum@umsystem.edu

# Activate Conda Environment
module load miniconda3
export PATH=/envs/genome_pipeline_env/bin:$PATH
conda activate genome_pipeline_env

# Define input files and output prefix
ASSEMBLY1="GCA_041682235.1_GMGI_Cborealis_1.0_genomic.fna"
ASSEMBLY2="GCA_036785275.1_qmCanBore1_p1.0_genomic.fna"
MERGED="merged_assembly"

# Check input files
if [[ ! -f "$ASSEMBLY1" ]]; then echo "Error: $ASSEMBLY1 not found."; exit 1; fi
if [[ ! -f "$ASSEMBLY2" ]]; then echo "Error: $ASSEMBLY2 not found."; exit 1; fi

# Create the merge_results directory if it doesn't exist
mkdir -p merge_results

# Step 1: Generate Delta File
nucmer --maxmatch -c 100 -p merge_results/delta_file "$ASSEMBLY1" "$ASSEMBLY2" &> merge_results/nucmer_delta.log || { echo "Nucmer failed"; exit 1; }

# Step 2: Merge Assemblies with QuickMerge
quickmerge -d merge_results/delta_file.delta -q "$ASSEMBLY2" -r "$ASSEMBLY1" -hco 5.0 -c 1.5 -l 1000 -ml 5000 -p merge_results/$MERGED > merge_results/quickmerge.log || { echo "QuickMerge failed"; exit 1; }

# Step 3: Check N50 Metric (Using seqkit for accurate N50)
seqkit stats merge_results/${MERGED}.fasta | awk 'NR==2 {print "Total Length:", $5, "N50:", $7}' > merge_results/n50.log

# Step 4: Compare Sequence Overlap (ASSEMBLY1)
nucmer --maxmatch -p merge_results/overlap_check "$ASSEMBLY1" merge_results/${MERGED}.fasta &> merge_results/nucmer_overlap1.log
delta-filter -q merge_results/overlap_check.delta > merge_results/overlap_check.filtered.delta
show-coords -rcl -T merge_results/overlap_check.filtered.delta > merge_results/show_coords1.tsv

# Step 5: Compare Sequence Overlap (ASSEMBLY2)
nucmer --maxmatch -p merge_results/overlap_check2 "$ASSEMBLY2" merge_results/${MERGED}.fasta &> merge_results/nucmer_overlap2.log
delta-filter -q merge_results/overlap_check2.delta > merge_results/overlap_check2.filtered.delta
show-coords -rcl -T merge_results/overlap_check2.filtered.delta > merge_results/show_coords2.tsv

echo "Pipeline completed successfully!"

