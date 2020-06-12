#!/bin/bash
#$ -N megahit_align
#$ -q bio,abio*,free*
#$ -pe openmp 16-64
#$ -ckpt restart
#$ -t 2-367


module load megahit/1.1.1
prefix_path=/dfs3/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/prefix.txt
input_file=$(head -n $SGE_TASK_ID $prefix_path | tail -n 1)

suffix_files_r1="_qc_decon_pe.1.fastq.gz"
suffix_files_r2="_qc_decon_pe.2.fastq.gz"
quality_filtered=/dfs3/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/quality_filtered/
output=/dfs3/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/megahit/
#megahit -1 $quality_filtered$input_file$suffix_files_r1 -2 $quality_filtered$input_file$suffix_files_r2 -o $output$input_file

# dereplicate and merge overlapping contigs with CD-HIT 
# v 4.8.1
mkdir $output$input_file\/cdhit
/dfs3/bio/tgallagh/programs/cdhit/cd-hit -i $output$input_file\/final.contigs.fa -o $output$input_file\/cdhit/contigs.fa  -c 0.90 -n 5 -s 0.9 -l 10 
# filter out contigs by length (keep > 2000 bp)
awk 'BEGIN{RS=">";ORS=""} length($0)>2038 {print ">"$0}' $output$input_file\/cdhit/contigs.fa > $output$input_file\/cdhit/contigs_filtered.fa

#align reads to contigs with bowtie2
module load bowtie2/2.2.7
module load samtools
mkdir $output$input_file\/bowtie2
bowtie2-build $output$input_file\/cdhit/contigs_filtered.fa $output$input_file\/bowtie2/ref

bowtie2 --very-fast -x $output$input_file\/bowtie2/ref -1 $quality_filtered$input_file$suffix_files_r1 -2  $quality_filtered$input_file$suffix_files_r2 -S $output$input_file\/bowtie2/$input_file\.sam \
--al-gz $output$input_file\/bowtie2/$input_file\.gzip 

samtools view -bS $output$input_file\/bowtie2/$input_file\.sam | samtools sort > $output$input_file\/bowtie2/$input_file\.bam

# bin reads with concoct 
#module load  anaconda
# source activate concoct_env



