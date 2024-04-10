#!/usr/bin/bash
#
######
# Script to run BOLT-LMM
#####

# Run from the main LMM_for_large_GWAS directory!
# Assuming multiple sets (subsets) of bed/bim/fam files to run 

# Set to log steps as they run for troubleshooting
set -x

# create directory to hold BOLT output, if it doesn't already exist
if ! ./BOLT_results;
then
    mkdir BOLT_results
fi

#current directory path
cwd=$(pwd)
#path to bed/bim/fam directory: /home/igregga/LMM_files/
geno_dir=/home/igregga/LMM_files
#path to cc phenotypes (with header row containing FID and IID!)
cc_pheno=/home/igregga/LMM_files/phenos/simu_categorical.phen 
#path to qt phenotypes (with header row containing FID and IID!)
qt_pheno=/home/igregga/LMM_files/phenos/simu_continuous.phen 

# base command
# ./bolt --bfile=geno --phenoFile=pheno.txt --phenoCol=phenoName --lmm --LDscoresFile=tables/LDSCORE.1000G_EUR.tab.gz --statsFile=stats.tab

# change to directory with input genotype files
cd $geno_dir

# command to compute for cc (categorical), including time and memory for benchmarking
for f in *simu-genos.bed;
do
    time /usr/bin/time --verbose $cwd/../BOLT-LMM_v2.4.1/bolt \
        --bfile=${f%.bed} \
        --phenoFile=$cc_pheno \
        --phenoCol=TRAIT \
        --numThreads=2 \
        --lmm \
        --maxModelSnps=2000000 \
        --LDscoresMatchBp \
        --LDscoresFile=$cwd/../BOLT-LMM_v2.4.1/tables/LDSCORE.1000G_EUR.tab.gz \
        --statsFile=$cwd/BOLT_results/${f%.bed}_cc_stats.tab;
    echo "BOLT-LMM for subset ${f%.bed} cc is complete."
done

# command to compute for qt (continuous), including time and memory for benchmarking
for f in *simu-genos.bed;
do
    time /usr/bin/time --verbose $cwd/../BOLT-LMM_v2.4.1/bolt \
        --bfile=${f%.bed} \
        --phenoFile=$qt_pheno \
        --phenoCol=TRAIT \
        --numThreads=2 \
        --lmm \
        --maxModelSnps=2000000 \
        --LDscoresMatchBp \
        --LDscoresFile=$cwd/../BOLT-LMM_v2.4.1/tables/LDSCORE.1000G_EUR.tab.gz \
        --statsFile=$cwd/BOLT_results/${f%.bed}_qt_stats.tab;
    echo "BOLT-LMM for subset ${f%.bed} qt is complete."
done

# --lmm: default BOLT-LMM analysis
# --maxModelSnps: maximum SNPs allowed; changed from default of 1000000
# --LDscoresMatchBp: used when bim file does not contain rsIDs, allows matching by base pair coordinate instead; in conjuction with --LDscoresFile
# --LDscoresFile: reference LD scores needed to calibrate BOLT-LMM statistic

#to run: nohup bash run_BOLT.sh > nohup_BOLT.out &