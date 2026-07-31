#!/bin/bash
#SBATCH --job-name=cb_emapper
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=120G
#SBATCH --time=47:57:00
#SBATCH --output=cb_emapper_%j.out
#SBATCH --error=cb_emapper_%j.err

set -euo pipefail

module load miniconda3
module load eggnog-mapper/v2.1.12

WORKDIR=egapx/C_borealis_out
PROTEINS=C_borealis_out/complete.proteins.faa
EGGNOG_DATA=/diamond_db/eggnog5_data

cd ${WORKDIR}

mkdir -p C_borealis_emapper

python clean_cborealis_protein_headers.py \
  ${PROTEINS} \
  C_borealis_proteins.clean.faa \
  C_borealis_protein_gene_map.tsv

emapper.py \
  -i C_borealis_proteins.clean.faa \
  --itype proteins \
  -m diamond \
  --data_dir ${EGGNOG_DATA} \
  --cpu 32 \
  --tax_scope Metazoa \
  --target_orthologs all \
  --output_dir C_borealis_emapper \
  -o C_borealis \
  --override

echo "Done."
echo "Main output:"
echo "${WORKDIR}/C_borealis_emapper/C_borealis.emapper.annotations"
