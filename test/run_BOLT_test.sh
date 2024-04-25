#!/usr/bin/bash
#
######
# Script to run BOLT-LMM
#####

# Run from directory 'test' in main LMM_for_large_GWAS directory!

## FOR ARGPARSING!
#full path to bed/bim/fam directory: /home/igregga/LMM_files/
geno_dir=/home/igregga/LMM_files/
#prefix of bed/bim/fam files
geno_prefix=/home/igregga/LMM_files/1250simu-genos
#full path to phenotypes (with header row containing FID and IID!)
pheno=/home/igregga/LMM_files/phenos/simu_categorical.phen 
#name of column in pheno file containing the phenotype
pheno_col=TRAIT
#prefix for output file name, will be <prefix>.tab
out_prefix=1250simu-genos_bolt
#number of threads to use
threads=2

# Set to log steps as they run for troubleshooting
set -x

# create directory to hold BOLT output, if it doesn't already exist
if ! ./BOLT_results;
then
    mkdir BOLT_results
fi

#current directory path to enable returning to cwd
cwd=$(pwd)

# base command
# ./bolt --bfile=geno --phenoFile=pheno.txt --phenoCol=phenoName --lmm --LDscoresFile=tables/LDSCORE.1000G_EUR.tab.gz --statsFile=stats.tab

# change to directory with input genotype files
#cd $geno_dir

# command to compute for categorical or continuous, including time and memory for benchmarking
time /usr/bin/time --verbose $cwd/../../BOLT-LMM_v2.4.1/bolt \
    --bfile=$geno_prefix \
    --phenoFile=$pheno \
    --phenoCol=$pheno_col \
    --numThreads=$threads \
    --lmm \
    --maxModelSnps=2000000 \
    --LDscoresMatchBp \
    --LDscoresFile=$cwd/../../BOLT-LMM_v2.4.1/tables/LDSCORE.1000G_EUR.tab.gz \
    --statsFile=$cwd/BOLT_results/${out_prefix}.tab;
echo "BOLT-LMM for ${geno_prefix} is complete."


# --lmm: default BOLT-LMM analysis
# --maxModelSnps: maximum SNPs allowed; changed from default of 1000000
# --LDscoresMatchBp: used when bim file does not contain rsIDs, allows matching by base pair coordinate instead; in conjuction with --LDscoresFile
# --LDscoresFile: reference LD scores needed to calibrate BOLT-LMM statistic

# to run: nohup bash run_BOLT_test.sh > nohup_BOLT_test.out &


#_______________________
# Notes for converting to argparse

# no need to specify cc or qt, runs the same for both!
# need to take in:
    # full path to directory containing bam/bim/fam files for $geno_dir
    # prefix of bam/bim/fam plink format files for $geno_prefix (passed to --bfile)
    # pheno file path/name (full path!) for $pheno (passed to --phenoFile)
    # column name of column containing phenotype for $pheno_col (passed to --phenoCol)
    # prefix to name output file (passed to --statFile)
    # ?maybe number of threads for $threads (passed to --numThreads)