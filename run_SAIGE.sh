#!/usr/bin/bash
#
######
# Script to run SAIGE
#####

# Run from the main LMM_for_large_GWAS directory!
# needs binary traits to be 0 and 1!!

# Set to log steps as they run for troubleshooting
set -x

# create directory to hold SAIGE output, if it doesn't already exist
if ! ./SAIGE_results;
then
    mkdir SAIGE_results
fi

#current directory path
cwd=$(pwd)
#path to bed/bim/fam directory: /home/igregga/LMM_files/
geno_dir=/home/igregga/LMM_files
#path to cc phenotypes (with header row containing FID and IID, and case-control as 1-0!)
cc_pheno=/home/igregga/LMM_files/phenos/simu_categorical-01na.phen
#path to qt phenotypes (with header row containing FID and IID!)
qt_pheno=/home/igregga/LMM_files/phenos/simu_continuous.phen 

#continuous/quantitative (qt) trait

for f in 1250 2500 5000
do
    #step 1: fit the null model using a full GRM (Genetic Relationship Matrix)
    time /usr/bin/time --verbose Rscript /usr/local/bin/SAIGE/extdata/step1_fitNULLGLMM.R \
        --plinkFile=$geno_dir/${f}simu-genos \
        --phenoFile=$qt_pheno \
        --phenoCol=TRAIT \
        --sampleIDColinphenoFile=IID \
        --invNormalize=TRUE \
        --traitType=quantitative \
        --isCovariateOffset=FALSE \
        --outputPrefix=$cwd/SAIGE_results/${f}_qt \
        --nThreads=2 \
        --IsOverwriteVarianceRatioFile=TRUE;
    echo "SAIGE step 1 for subset ${f} qt is complete.";
    #step 2: single-variant association test
    time /usr/bin/time --verbose Rscript /usr/local/bin/SAIGE/extdata/step2_SPAtests.R \
        --bedFile=$geno_dir/${f}simu-genos.bed \
        --bimFile=$geno_dir/${f}simu-genos.bim \
        --famFile=$geno_dir/${f}simu-genos.fam \
        --SAIGEOutputFile=$cwd/SAIGE_results/${f}_qt_fullGRM_with_vr.txt \
        --minMAF=0 \
        --minMAC=20 \
        --LOCO=FALSE \
        --GMMATmodelFile=$cwd/SAIGE_results/${f}_qt.rda \
        --is_output_moreDetails=TRUE \
        --varianceRatioFile=$cwd/SAIGE_results/${f}_qt.varianceRatio.txt;
    echo "SAIGE step 2 for subset ${f} qt is complete.";
done

#categorical/binary (cc) trait

for f in 1250 2500 5000
do
    #step 1: fit the null model using a full GRM (Genetic Relationship Matrix)
    time /usr/bin/time --verbose Rscript /usr/local/bin/SAIGE/extdata/step1_fitNULLGLMM.R \
        --plinkFile=$geno_dir/${f}simu-genos \
        --phenoFile=$cc_pheno \
        --phenoCol=TRAIT \
        --sampleIDColinphenoFile=IID \
        --traitType=binary \
        --isCovariateOffset=FALSE \
        --outputPrefix=$cwd/SAIGE_results/${f}_cc \
        --nThreads=2 \
        --IsOverwriteVarianceRatioFile=TRUE;
    echo "SAIGE step 1 for subset ${f} cc is complete.";
    #step 2: single-variant association test
    time /usr/bin/time --verbose Rscript /usr/local/bin/SAIGE/extdata/step2_SPAtests.R \
        --bedFile=$geno_dir/${f}simu-genos.bed       \
        --bimFile=$geno_dir/${f}simu-genos.bim       \
        --famFile=$geno_dir/${f}simu-genos.fam       \
        --SAIGEOutputFile=$cwd/SAIGE_results/${f}_cc_fullGRM_with_vr.txt  \
        --minMAF=0 \
        --minMAC=20 \
	    --LOCO=FALSE	\
        --GMMATmodelFile=$cwd/SAIGE_results/${f}_cc.rda \
        --is_output_moreDetails=TRUE	\
        --varianceRatioFile=$cwd/SAIGE_results/${f}_cc.varianceRatio.txt \
        --is_Firth_beta=TRUE \
        --pCutoffforFirth=0.05 \
        --is_output_moreDetails=TRUE;
    echo "SAIGE step 2 for subset ${f} cc is complete.";
done
##notes on step 2:
#highly recommends using --LOCO=TRUE with --CHROM specified (genotype/dosage file contain only 1 chrom) to avoid proximal contamination. Trying without
#for binary traits, effect sizes more accurate using Firth's Bias-Reduced Logistic Regression
# to use, --is_Firth_beta=TRUE and --pCutoffforFirth=0.05 so markers with p-value < cutoff will be estimated through Firth's
#for binary traits, --is_output_moreDetails=True outputs heterozygous and homozygous counts and allele freqs

#to run: nohup bash run_SAIGE.sh > nohup_SAIGE.out &