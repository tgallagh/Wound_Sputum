#!/bin/bash
#$ -N breseq_annotation
#$ -q bio,abio*,free*
#$ -ckpt restart
#$ -t 1-43

module load tgallagh/breseq/0.35.1 
module load samtools
module load bowtie2 
module load R/3.3.2

# annotate the sub files (D5 antbx - d5 control - d1 control)
prefix_path=/dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/D5_antbx_minus_bothcontrols/D5antbx_prefix.txt 
input_file=$(head -n $SGE_TASK_ID $prefix_path | tail -n 1)

ref_assembly=$(grep $input_file /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq_lookuptable.txt | cut -f2)

echo $ref_assembly
echo $input_file

gdtools ANNOTATE -o /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/D5_antbx_minus_bothcontrols/annotations/$input_file\.html \
-r /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/ref_assemblies/$ref_assembly\.gb \
/dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/D5_antbx_minus_bothcontrols/$input_file\.gd

