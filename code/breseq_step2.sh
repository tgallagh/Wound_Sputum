#!/bin/bash
#$ -N breseq_two
#$ -q bio,abio*,free*
#$ -ckpt restart
#$ -t 1-46

module load tgallagh/breseq/0.35.1 
module load samtools
module load bowtie2 
module load R/3.3.2

# breseq analyses
#Step 1: breseq variant calls on all files
#Step 2: subtract D5 antibiotics from D5 controls (D5 antibiotics only mutations) = D5_antbx_D5_controls
#Step 3: subtract D5 controls from D1 controls (remove time mutations) = D5_controls+D1_controls
#Step 4: subtract step2-step3 output D5_antbx_all_controls
#Step 5: annotate the output in step4 

# this is step 2

prefix_path=/dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/D5antbx_prefix.txt 
input_file=$(head -n $SGE_TASK_ID $prefix_path | tail -n 1)

control1=$(grep $input_file /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq_d5antbx_d5control_table.txt | cut -f2)
if test -f /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control1\/output/output.gd; then control1path=/dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control1\/output/output.gd ; else control1path="" && echo $control1 >> /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/code/D5_missing.txt ; fi

control2=$(grep $input_file /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq_d5antbx_d5control_table.txt | cut -f3)
if test -f /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control2\/output/output.gd; then control2path=/dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control2\/output/output.gd ; else control2path="" && echo $control2 >> /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/code/D5_missing.txt; fi

control3=$(grep $input_file /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq_d5antbx_d5control_table.txt | cut -f4)
if test -f /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control3\/output/output.gd; then control3path=/dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control3\/output/output.gd ; else control3path="" && echo $control3 >> /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/code/D5_missing.txt; fi

gdtools SUBTRACT /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$input_file\/output/output.gd $control1path $control2path $control3path -o /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/D5_antbx_D5_controls/$input_file\.gd
