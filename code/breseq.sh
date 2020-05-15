#!/bin/bash
#$ -N breseq_one
#$ -q bio,abio*,free*
#$ -pe openmp 8
#$ -ckpt restart
#$ -t 1-204

module load tgallagh/breseq/0.35.1 
module load samtools
module load bowtie2 
module load R/3.3.2

prefix_path=/dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq_prefix.txt
input_file=$(head -n $SGE_TASK_ID $prefix_path | tail -n 1)

ref_assembly=$(grep $input_file /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq_lookuptable.txt | cut -f2)

echo $ref_assembly
echo $input_file

breseq -j 8 -p -o /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$input_file -r /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/ref_assemblies/$ref_assembly\.gb /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/quality_filtered/$input_file\_qc_decon_pe.1.fastq.gz /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/quality_filtered/$input_file\_qc_decon_pe.2.fastq.gz 


