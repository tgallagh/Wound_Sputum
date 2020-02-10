
Description of output files and file formats from 'merge_midas.py snps'

Output files
############
snps_freq.txt
  frequency of minor allele per genomic site and per sample
  a value of 1.0 indicates that all reads matched the minor allele for site-sample
  the major (most common) and minor allele (2nd most common) are determined from pooled reads across ALL samples
  see: snps_info.txt for details on the major, minor, and reference alleles
snps_depth.txt
  number of reads mapped to genomic site per sample
  only accounts for reads matching either major or minor allele
snps_info.txt  
  metadata for genomic site
  see below for more information
snps_summary.txt
  alignment summary statistics per sample
  see below for more information
snps_log.txt
  log file containing parameters used

Output formats
############
snps_freq.txt and snps_depth.txt
  tab-delimited matrix files
  field names are sample ids
  row names are genome site ids
  see: snps_info.txt for details on each genomic site
snps_summary.txt
  sample_id: sample identifier
  genome_length: number of base pairs in representative genome
  covered_bases: number of reference sites with at least 1 mapped read
  fraction_covered: proportion of reference sites with at least 1 mapped read
  mean_coverage: average read-depth across reference sites with at least 1 mapped read
  aligned_reads: number of reads that aligned BEFORE quality filtering
  mapped_reads: number of reads that aligned AFTER quality filtering
snps_info.txt
  site_id: incrementing integer field
  ref_id: identifier of scaffold in representative genome
  ref_pos: position of site on ref_id
  ref_allele: allele in reference genome
  major_allele: most common allele in metagenomes
  minor_allele: second most common allele in metagenomes
  count_samples: number of metagenomes where site_id was found
  count_a: count of A allele in pooled metagenomes
  count_c: count of C allele in pooled metagenomes
  count_g: count of G allele in pooled metagenomes
  count_t: count of T allele in pooled metagenomes
  locus_type: CDS (site in coding gene), RNA (site in non-coding gene), IGR (site in intergenic region)
  gene_id: gene identified if locus_type is CDS, or RNA
  snp_type: indicates the number of alleles observed at site (mono,bi,tri,quad); observed allele are determined by --snp_maf flag  
  site_type: indicates degeneracy: 1D, 2D, 3D, 4D
  amino_acids: amino acids encoded by 4 possible alleles

Additional information for species can be found in the reference database:
 /dfs2/commondata/midas_db_v1.2/rep_genomes/Streptococcus_anginosus_58223
