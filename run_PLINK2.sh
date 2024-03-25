#!/bin/bash
#####
# Script to run plink2
#####

#Define path to plink2 executable
PLINK2_CMD="plink2"
#prefix for our bed/bim/fam files
INPUT_PREFIX="/home/igregga/LMM_files/simu-genos"
#Phenotype file
PHENO_FILE="/home/igregga/LMM_files/simu-cc-h2_0.2-prev0.1.phen"

#Output files
OUTPUT_DIR="/home/igregga/LMM_files/gwas_results"
OUTPUT_PREFIX="${OUTPUT_DIR}/gwas_output"

#Make sure output directory exists
mkdir -p $OUTPUT_DIR

#Run GWAS with plink2
$PLINK2_CMD --bfile $INPUT_PREFIX \
--pheno $PHENO_FILE \
--pheno-col 3 \
--glm 'omit-ref' \
--maf 0.001 \
--out $OUTPUT_PREFIX

echo "GWAS analysis complete!"

