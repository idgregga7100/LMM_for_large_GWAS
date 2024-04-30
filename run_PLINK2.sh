#!/bin/bash
#####
# This script is meant to run a GWAS using plink2
# for both continuous and categorial traits across different subsets of data
# and benchmark the performance of each run
#####

# Define path to plink2 executable
PLINK2_EXEC="/home/wprice2/plink2"
# Directory with input files
INPUT_DIR="/home/igregga/LMM_files"
# Define the path to the cont. phenotype file
CONT_PHENO_FILE="${INPUT_DIR}/phenos/simu_continuous.phen"
# Define the path to the cat. phenotype file
CAT_PHENO_FILE="${INPUT_DIR}/phenos/simu_categorical.phen"

# Specify the directory to store output files from the GWAS analyses
OUTPUT_DIR="/home/wprice2/gwas_results"

# Make sure output directory exists, and create one if it does not
mkdir -p $OUTPUT_DIR

# Make an array of our subset prefixes
declare -a subsets=("1250" "2500" "5000")

# Loop through subsets for the continuous trait analysis
for f in "${subsets[@]}"
do  
    # Define the path to the input genotype files for this subset
    INPUT_PREFIX="${INPUT_DIR}/${f}simu-genos"  
    #Define the output file prefix for this subset
    OUTPUT_PREFIX="${OUTPUT_DIR}/${f}continuous"

    # Execute plink2 for GWAS, including timing and memory usage stats
    /usr/bin/time --verbose $PLINK2_EXEC --bfile "${INPUT_PREFIX}" \
    --pheno "${CONT_PHENO_FILE}" \
    --pheno-name TRAIT \
    --glm omit-ref allow-no-covars \
    --out "${OUTPUT_PREFIX}" \
    --threads 2
    #Log the completion of the analysis
    echo "PLINK2 GWAS analysis for continuous trait subset ${f} is complete."
done

#Repeat categorical traits
for f in "${subsets[@]}"
do
    # Full path to the input file set
    INPUT_PREFIX="${INPUT_DIR}/${f}simu-genos"
    OUTPUT_PREFIX="${OUTPUT_DIR}/${f}categorical"

    # Run GWAS again with plink2 just using cat phen file
    /usr/bin/time --verbose $PLINK2_EXEC --bfile "${INPUT_PREFIX}" \
    --pheno "${CAT_PHENO_FILE}" \
    --pheno-name TRAIT \
    --glm omit-ref allow-no-covars \
    --out "${OUTPUT_PREFIX}" \
    --threads 2

    echo "PLINK2 GWAS analysis for categorical trait subset ${f} is complete."
done


echo "ALL GWAS analyses completed!"

# Command to run script: nohup bash run_PLINK2.sh > PLINK2.out &