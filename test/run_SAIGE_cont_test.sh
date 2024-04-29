#!/usr/bin/bash
#
######
# Script to run SAIGE with continous phenotype
#####

# Run from directory 'test' in main LMM_for_large_GWAS directory!
# to run: nohup bash run_SAIGE_cont_test.sh -i 100simu-genos -p simu_continous.phen -c TRAIT -s IID -o 100simu-genos_qt -t 2 > nohup_SAIGE_cont_test.out &

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
      -c | --trait_col_name)
	        pheno_col=$2
	        shift 2
	        ;;
      -s | --sample_col_name)
            sample_col=$2
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
#path & prefix of bed/bim/fam files (passed to --plinkFile, --bedFile, --bimFile, --famFile)
#input_prefix=100simu-genos
#path to phenotypes (passed to --phenoFile) with header row containing FID and IID! Phenotypes case-control coded as 0-1!!
#pheno=simu_continous.phen
#name of column in pheno file containing the phenotype (passed to --phenoCol)
#pheno_col=TRAIT
#name of column in pheno file containing sample ids (passed to --sampleIDColinphenoFile)
#sample_col=IID
#prefix for output file name (passed within --outputPrefix)
#out_prefix=100simu-genos_qt
#number of threads to use (passed to --threads)
#threads=2

# Set to log steps as they run for troubleshooting
set -x

# create directory to hold SAIGE output, if it doesn't already exist
if ! ./SAIGE_results;
then
    mkdir SAIGE_results
fi

#continuous/quantitative (qt) trait

#step 1: fit the null model using a full GRM (Genetic Relationship Matrix)
time /usr/bin/time --verbose Rscript /usr/local/bin/SAIGE/extdata/step1_fitNULLGLMM.R \
    --plinkFile=${input_prefix} \
    --phenoFile=${pheno} \
    --phenoCol=${pheno_col} \
    --sampleIDColinphenoFile=${sample_col} \
    --invNormalize=TRUE \
    --traitType=quantitative \
    --isCovariateOffset=FALSE \
    --outputPrefix=SAIGE_results/${out_prefix}_cont \
    --nThreads=${threads} \
    --IsOverwriteVarianceRatioFile=TRUE;
echo "SAIGE step 1 for subset ${input_prefix} continous is complete.";
#step 2: single-variant association test
time /usr/bin/time --verbose Rscript /usr/local/bin/SAIGE/extdata/step2_SPAtests.R \
    --bedFile=${input_prefix}.bed \
    --bimFile=${input_prefix}.bim \
    --famFile=${input_prefix}.fam \
    --SAIGEOutputFile=SAIGE_results/${out_prefix}_cont_fullGRM_with_vr.txt \
    --minMAF=0 \
    --minMAC=20 \
    --LOCO=FALSE \
    --GMMATmodelFile=SAIGE_results/${out_prefix}_cont.rda \
    --is_output_moreDetails=TRUE \
    --varianceRatioFile=SAIGE_results/${out_prefix}_cont.varianceRatio.txt;
echo "SAIGE step 2 for subset ${input_prefix} continous is complete.";

##notes on step 2:
#highly recommends using --LOCO=TRUE with --CHROM specified (genotype/dosage file contain only 1 chrom) to avoid proximal contamination. Trying without
#for binary traits, effect sizes more accurate using Firth's Bias-Reduced Logistic Regression
# to use, --is_Firth_beta=TRUE and --pCutoffforFirth=0.05 so markers with p-value < cutoff will be estimated through Firth's
#for binary traits, --is_output_moreDetails=True outputs heterozygous and homozygous counts and allele freqs
