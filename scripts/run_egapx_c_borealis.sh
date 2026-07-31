#!/bin/bash
#SBATCH --job-name=agapx
#SBATCH --output=agapx_%j.out
#SBATCH --error=agapx_%j.err
#SBATCH --time=47:59:00
#SBATCH --cpus-per-task=32
#SBATCH --mem=256G
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user= Your email for notifications

# Load and activate Conda environment
module load miniconda3
module load nextflow
conda activate egapx
export PATH=/envs/egapx/bin:$PATH
python3 ui/egapx.py ./examples/test_gm_vd.yaml -e slurm -w /egapx/C_borealis_all -o C_borealis_out_all

