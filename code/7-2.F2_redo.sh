
#!/bin/bash
#$ -N sample_7-2.F2
#$ -q bio,abio*,free*
#$ -pe openmp 8
#$ -ckpt restart

gunzip 7-2.F2_R1_001.fastq.gz
gunzip 7-2.F2_R2_001.fastq.gz

# Quality filter your reads
module load prinseq-lite/0.20.4

prinseq-lite.pl -fastq /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/7-2.F2_R1_001.fastq -fastq2 /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/7-2.F2_R2_001.fastq -out_bad null -min_qual_mean 30 -ns_max_n 0 -out_good /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_qc

# Use Bowtie2 to decontaminate the human genome
module load bowtie2

bowtie2 -q -p 8 -x /dfs3/bio/whitesonlab/hg38/hg38 -1 /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_qc_1.fastq -2 /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_qc_2.fastq -U /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_qc_1_singletons.fastq,/dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_qc_2_singletons.fastq --un /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_qc_decon_se.fastq --un-conc /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_qc_decon_pe.fastq 1>/dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_out 2>/dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_alignment_stats.txt

# Clean up any big files bowtie makes
rm /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_out

# Metaphlan analysis
module load metaphlan2

export HDF5_DISABLE_VERSION_CHECK=2

cat /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_qc_decon_*.fastq >> /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/metaphlan/7-2.F2_tmp.fastq

metaphlan2.py /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/metaphlan/7-2.F2_tmp.fastq --input_type fastq --mpa_pkl /dfs3/bio/whitesonlab/metaphlan_database/db_v20/mpa_v20_m200.pkl --bowtie2db /dfs3/bio/whitesonlab/metaphlan_database/db_v20/mpa_v20_m200 --nproc 8 > /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/metaphlan/7-2.F2.txt

rm /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/metaphlan/7-2.F2_tmp.fastq

export PYTHONPATH=:/dfs3/bio/aoliver2/software/IGGsearch
export PATH=/data/apps/gcc/6.4.0/bin:/data/apps/commonbin/:/opt/gridengine/bin:/opt/gridengine/bin/lx-amd64:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/data/hpc/bin:/data/hpc/etc:/opt/ibutils/bin:/usr/java/latest/bin:/opt/rocks/bin:/opt/rocks/sbin:/bio/aoliver2/bin/sanger-pathogens-Roary-18af663/bin:/data/users/aoliver2/bin:/dfs3/bio/aoliver2/software/IGGsearch
export IGG_DB=/dfs3/bio/whitesonlab/IGG_database/iggdb_v1.0.0

module purge
module load python/2.7.15
module load samtools/1.8-11
module load bowtie2/2.2.7

run_iggsearch.py search --outdir /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/IGG/7-2.F2 --m1 /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_qc_decon_pe.1.fastq --m2 /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_qc_decon_pe.2.fastq --threads 8

gzip 7-2.F2_R1_001.fastq
gzip 7-2.F2_R2_001.fastq
#gzip /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_qc_decon_pe.1.fastq
#gzip /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_qc_decon_pe.2.fastq
gzip /dfs3/bio/aoliver2/chicha/chicha_full/demux/fecal/quality_filtered/7-2.F2_qc_decon_se*fastq


