#!/bin/bash
#$ -N wound_sputum_demux
#$ -q bio
#$ -m beas


module load BBMap/37.50


INPUT1="/dfs3/bio/tgallagh/Wound_Sputum_RawSeq/data/raw_data/TaraGal/TaraGal_CKDL190143273-1a_H53V3BBXX_L7_1.fq.gz"
INPUT2="/dfs3/bio/tgallagh/Wound_Sputum_RawSeq/data/raw_data/TaraGal/TaraGal_CKDL190143273-1a_H53V3BBXX_L7_2.fq.gz"

OUT1="/dfs3/bio/tgallagh/Wound_Sputum_RawSeq/data/raw_data/TaraGal/demux/%_R1.fastq.gz"
OUT2="/dfs3/bio/tgallagh/Wound_Sputum_RawSeq/data/raw_data/TaraGal/demux/%_R2.fastq.gz"
cd /dfs3/bio/tgallagh/Wound_Sputum_RawSeq/raw_data/TaraGal/demux/

demuxbyname.sh \
    prefixmode=f \
    in=/dfs3/bio/tgallagh/Wound_Sputum_RawSeq/data/raw_data/TaraGal/TaraGal_CKDL190143273-1a_H53V3BBXX_L7_1.fq.gz  \
    in2=/dfs3/bio/tgallagh/Wound_Sputum_RawSeq/data/raw_data/TaraGal/TaraGal_CKDL190143273-1a_H53V3BBXX_L7_2.fq.gz \
    out=%_R1.fastq.gz \
    out2=%_R2.fastq.gz \
    outu=Undetermined_R1.fastq.gz \
    outu2=Undetermined_R2.fastq.gz \
    names=/dfs3/bio/tgallagh/Wound_Sputum_RawSeq/NOVEMBER_2019_BARCODES.txt
