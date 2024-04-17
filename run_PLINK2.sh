#!/bin/bash
#####
# Script to run plink2
#####

# Define path to plink2 executable
PLINK2_EXEC="/home/wprice2/plink2"
# Directory with input files
INPUT_DIR="/home/igregga/LMM_files"
# Phenotype file
CONT_PHENO_FILE="${INPUT_DIR}/phenos/simu_continuous.phen"
# Categorical phenotype file
CAT_PHENO_FILE="${INPUT_DIR}/phenos/simu_categorical.phen"

# Output files
OUTPUT_DIR="/home/wprice2/gwas_results"

# Make sure output directory exists
mkdir -p $OUTPUT_DIR

# Make an array of our subset prefixes
declare -a subsets=("1250" "2500" "5000")

# Loop through subsets
for f in "${subsets[@]}"
do  
    # Full path to the input file set
    INPUT_PREFIX="${INPUT_DIR}/${f}simu-genos"  
    OUTPUT_PREFIX="${OUTPUT_DIR}/${f}continuous"

    # Run GWAS with plink2, including time and memory benchmarking
    /usr/bin/time --verbose $PLINK2_EXEC --bfile "${INPUT_PREFIX}" \
    --pheno "${CONT_PHENO_FILE}" \
    --pheno-name TRAIT \
    --glm omit-ref allow-no-covars \
    --out "${OUTPUT_PREFIX}" \
    --threads 2

    echo "PLINK2 GWAS analysis for continuous trait subset ${f} is complete."
done

#For categorical traits
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