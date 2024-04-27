#!/usr/bin/bash
#
######
# Script to run SAIGE with binary phenotype
#####

# Run from directory 'test' in main LMM_for_large_GWAS directory!
# to run: nohup bash run_SAIGE_binary_test.sh > nohup_SAIGE_binary_test.out &

# needs binary traits to be 0 and 1!!

## FOR ARGPARSING!
#path & prefix of bed/bim/fam files (passed to --plinkFile, --bedFile, --bimFile, --famFile)
input_prefix=100simu-genos
#path to phenotypes (passed to --phenoFile) with header row containing FID and IID! Phenotypes case-control coded as 0-1!!
pheno=simu_categorical-01na.phen
#name of column in pheno file containing the phenotype (passed to --phenoCol)
pheno_col=TRAIT
#name of column in pheno file containing sample ids (passed to --sampleIDColinphenoFile)
sample_col=IID
#prefix for output file name (passed within --outputPrefix)
out_prefix=100simu-genos
#number of threads to use (passed to --threads)
threads=2

# Set to log steps as they run for troubleshooting
set -x

# create directory to hold SAIGE output, if it doesn't already exist
if ! ./SAIGE_binary_results;
then
    mkdir SAIGE_binary_results
fi

#categorical/binary (cc) trait

#step 1: fit the null model using a full GRM (Genetic Relationship Matrix)
time /usr/bin/time --verbose Rscript /usr/local/bin/SAIGE/extdata/step1_fitNULLGLMM.R \
    --plinkFile=${input_prefix} \
    --phenoFile=${pheno} \
    --phenoCol=${pheno_col} \
    --sampleIDColinphenoFile=${sample_col} \
    --traitType=binary \
    --isCovariateOffset=FALSE \
    --outputPrefix=SAIGE_binary_results/${out_prefix}_binary \
    --nThreads=${threads} \
    --IsOverwriteVarianceRatioFile=TRUE;
echo "SAIGE step 1 for subset ${input_prefix} binary is complete.";
#step 2: single-variant association test
time /usr/bin/time --verbose Rscript /usr/local/bin/SAIGE/extdata/step2_SPAtests.R \
    --bedFile=${input_prefix}.bed \
    --bimFile=${input_prefix}.bim \
    --famFile=${input_prefix}.fam \
    --SAIGEOutputFile=SAIGE_binary_results/${out_prefix}_binary_fullGRM_with_vr.txt   \
    --minMAF=0 \
    --minMAC=20 \
    --LOCO=FALSE	\
    --GMMATmodelFile=SAIGE_binary_results/${out_prefix}_binary.rda \
    --is_output_moreDetails=TRUE	\
    --varianceRatioFile=SAIGE_binary_results/${out_prefix}_binary.varianceRatio.txt \
    --is_Firth_beta=TRUE \
    --pCutoffforFirth=0.05 \
    --is_output_moreDetails=TRUE;
echo "SAIGE step 2 for subset ${input_prefix} binary is complete.";

##notes on step 2:
#highly recommends using --LOCO=TRUE with --CHROM specified (genotype/dosage file contain only 1 chrom) to avoid proximal contamination. Trying without
#for binary traits, effect sizes more accurate using Firth's Bias-Reduced Logistic Regression
# to use, --is_Firth_beta=TRUE and --pCutoffforFirth=0.05 so markers with p-value < cutoff will be estimated through Firth's
#for binary traits, --is_output_moreDetails=True outputs heterozygous and homozygous counts and allele freqs
