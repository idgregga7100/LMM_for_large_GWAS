#!/usr/bin/bash
#
######
# Script to run BOLT-LMM
#####

# Run from directory 'test' in main LMM_for_large_GWAS directory!
# to run: nohup bash run_BOLT_test.sh -i 100simu-genos -p simu_categorical-01na.phen -c TRAIT -o 100simu-genos_cc_bolt -t 2 > nohup_BOLT_test.out &

while :
do
    case "$1" in
      -i | --plink_input_prefix)
	        geno_prefix=$2
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
#path & prefix of bed/bim/fam files (passed to --bfile)
#geno_prefix=100simu-genos
#path to phenotypes (with header row containing FID and IID!) (passed to --phenoFile)
#pheno=simu_categorical-01na.phen
#name of column in pheno file containing the phenotype (passed to --phenoCol)
#pheno_col=TRAIT
#prefix for output file name, will be <prefix>.tab (passed to --statsFile with directory)
#out_prefix=100simu-genos_cc_bolt
#number of threads to use (passed to --numThreads)
#threads=2

# no need to specify cc or qt, runs the same for both!

# Set to log steps as they run for troubleshooting
set -x

# create directory to hold BOLT output, if it doesn't already exist
if ! ./BOLT_results;
then
    mkdir BOLT_results
fi

#current directory path to enable returning to cwd
cwd=$(pwd)

# base command
# ./bolt --bfile=geno --phenoFile=pheno.txt --phenoCol=phenoName --lmm --LDscoresFile=tables/LDSCORE.1000G_EUR.tab.gz --statsFile=stats.tab

# command to compute for categorical or continuous, including time and memory for benchmarking
time /usr/bin/time --verbose $cwd/../BOLT-LMM_v2.4.1/bolt \
    --bfile=$geno_prefix \
    --phenoFile=$pheno \
    --phenoCol=$pheno_col \
    --numThreads=$threads \
    --lmm \
    --maxModelSnps=2000000 \
    --LDscoresMatchBp \
    --LDscoresFile=$cwd/../BOLT-LMM_v2.4.1/tables/LDSCORE.1000G_EUR.tab.gz \
    --statsFile=$cwd/BOLT_results/${out_prefix}.tab;
echo "BOLT-LMM for ${geno_prefix} is complete."

#Notes on flags:
# --lmm: default BOLT-LMM analysis
# --maxModelSnps: maximum SNPs allowed; changed from default of 1000000
# --LDscoresMatchBp: used when bim file does not contain rsIDs, allows matching by base pair coordinate instead; in conjuction with --LDscoresFile
# --LDscoresFile: reference LD scores needed to calibrate BOLT-LMM statistic