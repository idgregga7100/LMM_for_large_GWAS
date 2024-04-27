#!/bin/bash
#####
# Script to run plink2
#####

# Run from directory 'test' in main LMM_for_large_GWAS directory!
# Command to run script: nohup bash run_PLINK2_test.sh > nohup_PLINK2_test.out &

## FOR ARGPARSING!
# Path & prefix of bed/bim/fam input files (passed to --bfile)
INPUT_PREFIX=100simu-genos
# Phenotype file (passed to --pheno) Case/controls need to be 1/2!!!
PHENO_FILE=simu_categorical.phen
# name of column in pheno file containing the phenotype (passed to --pheno-name)
PHENO_COL=TRAIT
#prefix for output file name (passed to --out with directory name)
OUTPUT_PREFIX=100simu-genos_cc
#number of threads to use
THREADS=2

# no need to specify cc or qt, runs the same for both!

# Set to log steps as they run for troubleshooting
set -x

# Make sure output directory exists
mkdir -p PLINK2_results

# Run GWAS with plink2, including time and memory benchmarking
time /usr/bin/time --verbose ../plink2 \
    --bfile ${INPUT_PREFIX} \
    --pheno ${PHENO_FILE} \
    --pheno-name ${PHENO_COL} \
    --glm omit-ref allow-no-covars \
    --out PLINK2_results/${OUTPUT_PREFIX} \
    --threads ${THREADS}

echo "PLINK2 GWAS analysis for ${INPUT_PREFIX} is complete."
