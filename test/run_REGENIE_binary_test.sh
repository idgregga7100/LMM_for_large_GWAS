#!/bin/bash
######
# Script to run REGENIE with continous phenotype
#####

#ACTIVATE CONDA ENV FIRST from command line
#conda activate regenie_env
# Run from directory 'test' in main LMM_for_large_GWAS directory!
# to run: nohup bash run_REGENIE_binary_test.sh > nohup_REGENIE_binary_test.out &

while :
do
    case "$1" in
      -i | --plink_input_prefix)
	        input_prefix=$2
	        shift 2
	        ;;
      -p | --pheno_file)
	        pheno=$2
	        shift 2
	        ;;
      -o | --output_prefix)
            out_prefix=$2
            shift 2
            ;;      
      -t | --n_threads)
            threads=$2
            shift 2
            ;;
      *)  # No more options
         	shift
	        break
	        ;;
     esac
done

## FOR ARGPARSING!
#path & prefix of bed/bim/fam files (passed to --bed)
#input_prefix=/home/igregga/LMM_files/1250simu-genos
#path to phenotypes (passed to --phenoFile) Phenotypes case-control coded as 0-1!!
#pheno=simu_categorical-01na.phen
#prefix for output file name (passed within --out and --pred)
#out_prefix=100simu-genos
#number of threads to use (passed to --threads)
#threads=2

# Set to log steps as they run for troubleshooting
set -x

# create directory to hold BOLT output, if it doesn't already exist
if ! ./REGENIE_binary_results;
then
    mkdir REGENIE_binary_results
fi

#run regenie step 1
time /usr/bin/time --verbose regenie --step 1 \
--bed ${input_prefix} \
--phenoFile ${pheno} \
--bt \
--bsize 1000 \
--out REGENIE_binary_results/${out_prefix}_binary-fit \
--force-step1 \
--lowmem \
--lowmem-prefix REGENIE_binary_results/tmp \
--threads ${threads}

#run regenie step 2
time /usr/bin/time --verbose regenie --step 2 \
--bed ${input_prefix} \
--pred REGENIE_binary_results/${out_prefix}_binary-fit_pred.list \
--phenoFile ${pheno} \
--bt \
--bsize 1000 \
--out REGENIE_binary_results/${out_prefix}_binary-test \
--threads ${threads}

#conda deactivate

#recommeded: firth pval adjustment/test in step two, but will try without
#for binary/cat trait, there's a flag to specify binary and a flag to specify 1/2 instead of 0/1
#ERROR: it is not recommened to use more than 1000000 variants in step 1 (otherwise use '--force-step1')
