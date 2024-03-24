#!/bin/bash
#####
# Script to run plink2
#####

#Define path to plink2 executable
PLINK2_CMD="plink2"

#Full path to the input files
INPUT_DIR="/home/igregga/LMM_files"
#Define the prefix for our input files
INPUT_PREFIX="simu-genos"

#Define the output directory and file prefix 
OUTPUT_DIR="./plink2_results"
OUTPUT_PREFIX="${OUTPUT_DIR}/analysis_output"

#Create the output dir. if it doesn't already exist
mkdir -p $OUTPUT_DIR

#Calculate allele freq.
$PLINK2_CMD --bfile $INPUT_PREFIX --freq --out ${OUTPUT_PREFIX}_freq

#Perform basic qc 
#Remove individuals with missing genotype rate > 0.02 and variants
# with a minor allele freq. < 0.05
$PLINK2_CMD --bfile $INPUT_PREFIX --geno 0.02 --maf 0.05 --make-bed --out ${OUTPUT_PREFIX}

echo "plink2 analysis complete."
