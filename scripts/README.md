# Workflow scripts

Copy the following executable scripts into this directory:

- `step_1_edit_merge_assemblies.sh`
- `step_2_polish_genome_pilon.sh`
- `step_3_mask_repeatmasker.sh`
- `step_4_align_RNA_Seq_HISAT2.sh`
- `step_5_edit_assemble_stringTie.sh`
- `step_6_edit_gene_prediction_BRAKER.sh`
- `step_7_predict_transdecoder.sh`
- `step_8_functional_DIAMOND.sh`
- `step_9_completeness_BUSCO.sh`
- `run_egapx_c_borealis.sh`
- `run_cborealis_emapper.sh`

Then run:

```bash
chmod +x scripts/*.sh
bash -n scripts/*.sh
```

Review every script for private paths, credentials, software/module names, database locations, and scheduler-specific settings before publishing.
