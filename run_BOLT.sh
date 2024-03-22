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
#path to cc phenotypes: /home/data/simulated_gwas/simu-cc-h2_0.2-prev0.1.phen 
cc_pheno=/home/data/simulated_gwas/simu-cc-h2_0.2-prev0.1.phen
#path to qt phenotypes: /home/data/simulated_gwas/simu-qt-h2_0.2.phen 
qt_pheno=/home/data/simulated_gwas/simu-qt-h2_0.2.phen 

# base command
# ./bolt --bfile=geno --phenoFile=pheno.txt --phenoCol=phenoName --lmm --LDscoresFile=tables/LDSCORE.1000G_EUR.tab.gz --statsFile=stats.tab

# change to directory with input genotype files
cd $geno_dir

# command to compute cc
for f in *simu-genos.bed;
do
    $cwd/../BOLT-LMM_v2.4.1/bolt \
        --bfile=${f%.bed} \
        --phenoFile=$cc_pheno \
        --phenoCol=3 \
        --numThreads=2 \
        --lmm \
        --LDscoresFile=$cwd/../BOLT-LMM_v2.4.1/tables/LDSCORE.1000G_EUR.tab.gz \
        --statsFile=$cwd/BOLT_results/${f%.bed}_cc_stats.tab;
done
