#!/bin/bash
#$ -N breseq_all
#$ -q bio,abio*,free*
#$ -ckpt restart
#$ -t 1-46

module load tgallagh/breseq/0.35.1 
module load samtools
module load bowtie2 
module load R/3.3.2

# breseq analyses
# remove mutataions in D5, D1 controls from D5 antbx

prefix_path=/dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/D5antbx_prefix.txt 
input_file=$(head -n $SGE_TASK_ID $prefix_path | tail -n 1)

control1=$(grep $input_file /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq_d5antbx_d5control_table.txt | cut -f2)
if test -f /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control1\/output/output.gd; then control1path=/dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control1\/output/output.gd ; else control1path="" && echo $control1 >> /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/code/D5_missing.txt ; fi

control2=$(grep $input_file /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq_d5antbx_d5control_table.txt | cut -f3)
if test -f /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control2\/output/output.gd; then control2path=/dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control2\/output/output.gd ; else control2path="" && echo $control2 >> /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/code/D5_missing.txt; fi

control3=$(grep $input_file /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq_d5antbx_d5control_table.txt | cut -f4)
if test -f /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control3\/output/output.gd; then control3path=/dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control3\/output/output.gd ; else control3path="" && echo $control3 >> /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/code/D5_missing.txt; fi

control4=$(grep $input_file /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq_d5control_d1control_table.txt | cut -f2)
if test -f /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control4\/output/output.gd; then control4path=/dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control4\/output/output.gd ; else control4path="" && echo $control4 >> /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/code/D5_missing.txt ; fi

control5=$(grep $input_file /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq_d5control_d1control_table.txt | cut -f3)
if test -f /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control5\/output/output.gd; then control5path=/dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control5\/output/output.gd ; else control5path="" && echo $control5 >> /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/code/D5_missing.txt; fi

control6=$(grep $input_file /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq_d5control_d1control_table.txt | cut -f4)
if test -f /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control6\/output/output.gd; then control6path=/dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$control6\/output/output.gd ; else control6path="" && echo $control6 >> /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/code/D5_missing.txt; fi

gdtools SUBTRACT /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/breseq/$input_file\/output/output.gd $control1path $control2path $control3path $control4path $control5path $control6path -o /dfs5/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/D5_antbx_minus_bothcontrols/$input_file\.gd
