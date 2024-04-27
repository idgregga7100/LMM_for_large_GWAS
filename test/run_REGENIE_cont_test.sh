#!/bin/bash
######
# Script to run REGENIE with continous phenotype
#####

#ACTIVATE CONDA ENV FIRST from command line
#conda activate regenie_env
# Run from directory 'test' in main LMM_for_large_GWAS directory!
# to run: nohup bash run_REGENIE_cont_test.sh > nohup_REGENIE_cont_test.out &

## FOR ARGPARSING!
#path & prefix of bed/bim/fam files (passed to --bed)
input_prefix=100simu-genos
#path to phenotypes (passed to --phenoFile)
pheno=simu_continous.phen
#name of column in pheno file containing the phenotype (passed to --phenoCol)
#pheno_col=TRAIT
#prefix for output file name, will be <prefix>.tab (passed to --statsFile with directory)
out_prefix=100simu-genos
#number of threads to use (passed to --numThreads)
threads=2

# Set to log steps as they run for troubleshooting
set -x

# create directory to hold BOLT output, if it doesn't already exist
if ! ./REGENIE_results;
then
    mkdir REGENIE_results
fi

#run regenie step 1
time /usr/bin/time --verbose regenie --step 1 \
--bed ${input_prefix} \
--phenoFile ${pheno} \
--bsize 1000 \
--out REGENIE_results/${input_prefix}_cont-fit \
--force-step1 \
--lowmem \
--lowmem-prefix REGENIE_results/tmp \
--threads ${threads}

#run regenie step 2
time /usr/bin/time --verbose regenie --step 2 \
--bed ${input_prefix} \
--pred REGENIE_results/${input_prefix}_cont-fit_pred.list \
--phenoFile ${pheno} \
--bsize 1000 \
--out REGENIE_results/${f}_cont-test \
--threads ${threads}

#conda deactivate

#recommeded: firth pval adjustment/test in step two, but will try without
#for binary/cat trait, there's a flag to specify binary and a flag to specify 1/2 instead of 0/1
#ERROR: it is not recommened to use more than 1000000 variants in step 1 (otherwise use '--force-step1')
