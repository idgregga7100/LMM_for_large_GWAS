#!/bin/bash
#####
# Script to run plink2
#####

# Define path to plink2 executable
# Directory with input files
INPUT_DIR="/home/igregga/LMM_files"
# Phenotype file
PHENO_FILE="${INPUT_DIR}/simu-cc-h2_0.2-prev0.1.phen"

# Output files
OUTPUT_DIR="$/home/wprice2/gwas_results"

# Make sure output directory exists
mkdir -p $OUTPUT_DIR

# Make an array of our subset prefixes
declare -a subsets=("1250simu-genos" "2500simu-genos")  # Corrected the spelling of 'declare'

# Loop through subsets
for subset in "${subsets[@]}"
do  
    # Full path to the input file set
    INPUT_PREFIX="${INPUT_DIR}/${subset}"  # Corrected the variable name, it should be ${INPUT_DIR}, not {INPUT_DIR}
    OUTPUT_PREFIX="${OUTPUT_DIR}/gwas_output_${subset}"

    # Run GWAS with plink2
    /home/wprice/plink2 --bfile "$INPUT_PREFIX" \
       --pheno "$PHENO_FILE" \
       --glm 'omit-ref' \
       --maf 0.001 \
       --out "$OUTPUT_PREFIX"

    echo "PLINK2 GWAS analysis for subset ${subset} is complete."
done

echo "ALL GWAS analyses completed!"
