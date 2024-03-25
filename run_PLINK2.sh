#!/bin/bash
#####
# Script to run plink2
#####

#Define path to plink2 executable
PLINK2_CMD="plink2"
#Directory with input files
INPUT_DIR="/home/igregga/LMM_files"
#Phenotype file
PHENO_FILE="${INPUT_DIR}/simu-cc-h2_0.2-prev0.1.phen"

#Output files
OUTPUT_DIR="${INPUT_DIR}/gwas_results"


#Make sure output directory exists
mkdir -p $OUTPUT_DIR

#Make an array of our subset prefixes
declar -a subsets=("1250simu-genos" "2500simu-genos")

#Loop through subsets
for subset in "${subsets[@]}"
do  
    #full path to the iunput file set
    INPUT_PREFIX="{INPUT_DIR}/${subset}"
    OUTPUT_PREFIX="${OUTPUT_DIR}/gwas_output_${subset}"

    #Run GWAS with plink2
    plink2 --bfile $INPUT_PREFIX \
    --pheno $PHENO_FILE \
    --glm 'omit-ref'
    --maf 0.001 \
    --out $OUTPUT_PREFIX

    echo "PLINK2 GWAS analysis for subset ${subset} is complete."
done

echo "All GWAS analsyes completed!"

