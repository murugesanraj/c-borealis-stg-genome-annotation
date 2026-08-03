# *Cancer borealis* genome refinement and annotation workflow

Reproducible shell scripts and configuration files used to refine the *Cancer borealis* genome assembly, incorporate stomatogastric ganglion (STG) RNA-seq evidence, predict genes, assign functional annotations, and assess annotation completeness.

## Repository contents

```text
.
├── config/
│   ├── input_C_borealis_STG15_39395.yaml
│   └── run_params.yaml
├── scripts/
│   ├── 01_merge_assemblies.sh
│   ├── 02_align_RNA-Seq_HISAT2.sh
│   ├── 03_polish_genome_pilon.sh
│   ├── 04_mask_repeatmasker.sh
│   ├── 05_edit_assemble_stringTie.sh
│   ├── 06_edit_gene_prediction_BRAKER.sh
│   ├── 07_predict_transdecoder.sh
│   ├── 08_functional_DIAMOND.sh
│   ├── 09_completeness_BUSCO.sh
│   ├── run_egapx_c_borealis.sh
│   └── run_cborealis_emapper.sh
├── data/README.md
├── results/
│   ├── assembly_qc/
│   └── annotation_qc/
├── software_versions.tsv
├── environment.yml
├── CITATION.cff
├── LICENSE
└── CHANGELOG.md
```

The YAML and shell files listed above must be copied from the analysis directory into `config/` and `scripts/`, respectively. 
## Workflow overview

| Order | Script | Main role |
|---:|---|---|
| 1 | `01_merge_assemblies.sh` | Edit sequence identifiers and merge genome assembly components. |
| 2 | `02_align_RNA-Seq_HISAT2.sh` | Align STG RNA-seq reads to the genome with HISAT2. |
| 3 | `03_polish_genome_pilon.sh` | Use aligned reads to polish the genome assembly with Pilon. |
| 4 | `04_mask_repeatmasker.sh` | Identify and mask repetitive elements with RepeatMasker. |
| 5 | `05_edit_assemble_stringTie.sh` | Assemble RNA-seq-supported transcripts with StringTie. |
| 6 | `06_edit_gene_prediction_BRAKER.sh` | Predict protein-coding genes with BRAKER using external evidence. |
| 7 | `07_predict_transdecoder.sh` | Predict coding regions and translated proteins with TransDecoder. |
| 8 | `08_functional_DIAMOND.sh` | Search predicted proteins against the configured reference database with DIAMOND. |
| 9 | `09_completeness_BUSCO.sh` | Assess genome or annotation completeness with BUSCO. |
| Alternative annotation | `run_egapx_c_borealis.sh` | Run NCBI EGAPx with the files in `config/`. |
| Functional annotation | `run_cborealis_emapper.sh` | Assign orthology-based functional annotations with eggNOG-mapper. |

The exact input filenames, output filenames, software options, databases, and computational resources are defined in the scripts and YAML configuration files. Verify those values before running the workflow.

## Data availability

Raw sequencing reads and genome-scale intermediate files are not stored in GitHub. 

| Resource | Accession or URL |
|---|---|
| NCBI BioProject | `PRJNA1505596` |
| NCBI BioSample | `SAMN62090974` |
| STG15 RNA-seq, SRA | `SRR________` |
| Genome assembly | `GCA_041682235.1` and `GCA_036785275.1` 

## Installation

The workflow was designed for a Linux workstation or HPC system. Clone the repository and make the scripts executable:

```bash
git clone https://github.com/murugesanraj/c-borealis-genome-annotation.git
cd c-borealis-genome-annotation
chmod +x scripts/*.sh
```

Create the general-purpose Conda environment:

```bash
mamba env create -f environment.yml
conda activate cborealis-annotation
```

BRAKER and EGAPx are best installed using their project-specific environment or containers. EGAPx additionally requires Nextflow and a supported container runtime (Please refer https://github.com/ncbi/egapx for additional details). RepeatMasker, BUSCO, eggNOG-mapper, and DIAMOND require separately downloaded databases.

## Configuration

1. Copy the two YAML files into `config/`.
2. Copy the eleven shell scripts into `scripts/`.
3. Search every file for project-specific absolute paths, usernames, scheduler settings, database paths, and thread or memory values.
4. Replace them with paths appropriate to the local system or expose them as command-line arguments.
5. Record the software and database versions actually used in `software_versions.tsv`.
6. Validate each YAML file before launching a long run.

## Running the numbered workflow

Run each stage only after checking its configured inputs and confirming that the preceding stage completed successfully:

```bash
bash scripts/01_merge_assemblies.sh
bash scripts/02_align_RNA-Seq_HISAT2.sh
bash scripts/03_polish_genome_pilon.sh
bash scripts/04_mask_repeatmasker.sh
bash scripts/05_edit_assemble_stringTie.sh
bash scripts/06_edit_gene_prediction_BRAKER.sh
bash scripts/07_predict_transdecoder.sh
bash scripts/08_functional_DIAMOND.sh
bash scripts/09_completeness_BUSCO.sh
```

Do not launch all steps as a single chained command until input/output dependencies have been verified from the actual scripts.

## Running EGAPx and eggNOG-mapper

Inspect the wrappers and configuration files first, then run:

```bash
bash scripts/run_egapx_c_borealis.sh
bash scripts/run_cborealis_emapper.sh
```

`input_C_borealis_STG15_39395.yaml` should identify the genome assembly, the *C. borealis* NCBI Taxonomy ID, and the RNA-seq evidence expected by EGAPx. `run_params.yaml` should contain the run-specific EGAPx parameters. Confirm that configuration paths still resolve after moving the files into `config/`.


## Citation

If you use this workflow, cite the associated manuscript and the archived software release.

> Raju M. Northcutt A. and Schulz D. (2026). *Genome refinement and annotation workflow for Cancer borealis* (Version 1.0.0) . GitHub. https://github.com/murugesanraj/c-borealis-genome-annotation


## License

The repository code is released under the [MIT License](LICENSE). Third-party software and databases retain their own licenses and terms of use.

