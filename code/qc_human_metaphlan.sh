#!/bin/bash
#$ -N qc_metaphlan
#$ -q bio,abio*,free*
#$ -pe make 8
#$ -R y
#$ -ckpt restart
#$ -t 2-366

# directiories variables
BASEDIR=/dfs3/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/demux/
QUALITY=/dfs3/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/quality_filtered/
METAPHLAN=/dfs3/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/metaphlan/

# task assignment
# using list of file name prefixes
g=$(head -n $SGE_TASK_ID /dfs3/bio/tgallagh/Wound_Sputum_RawSeq/data/processed/demux/prefix.txt | tail -n 1)


'''
# unzip demux fastq
cd $BASEDIR
gunzip ${g}_R1.fastq.gz
gunzip ${g}_R2.fastq.gz


# Quality filter your reads
module load prinseq-lite/0.20.4

prinseq-lite.pl \
 -fastq ${BASEDIR}${g}_R1.fastq \
 -fastq2 ${BASEDIR}${g}_R2.fastq  \ 
 -out_bad null -min_qual_mean 30 -ns_max_n 0 \
 -out_good ${QUALITY}${g}_qc

# Use Bowtie2 to decontaminate the human genome
module load bowtie2

bowtie2 -q -p 8 -x /dfs3/bio/whitesonlab/hg38/hg38 \
-1 ${QUALITY}${g}_qc_1.fastq \
-2 ${QUALITY}${g}_qc_2.fastq \ 
 -U ${QUALITY}${g}_qc_1_singletons.fastq,${QUALITY}${g}_qc_2_singletons.fastq \
 --un ${QUALITY}${g}_qc_decon_se.fastq \
 --un-conc ${QUALITY}${g}_qc_decon_pe.fastq \
 1>${QUALITY}${g}_out \
 2>${QUALITY}${g}_alignment_stats.txt

# Clean up any big files bowtie makes
rm ${QUALITY}${g}_out
'''

# Metaphlan analysis
module load metaphlan2
module load bowtie2

export HDF5_DISABLE_VERSION_CHECK=2

cat ${QUALITY}${g}_qc_decon_*.fastq >> ${METAPHLAN}${g}_tmp.fastq

metaphlan2.py ${METAPHLAN}${g}_tmp.fastq \
--input_type fastq --mpa_pkl /dfs3/bio/whitesonlab/metaphlan_database/db_v20/mpa_v20_m200.pkl --bowtie2db /dfs3/bio/whitesonlab/metaphlan_database/db_v20/mpa_v20_m200 --nproc 8 > ${METAPHLAN}${g}_metaphlan.txt

rm ${METAPHLAN}${g}_tmp.fastq

