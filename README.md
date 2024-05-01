# LMM_for_large_GWAS
COMP383/483 project

## General Dependencies (Install If Needed)
To run the included scripts, users need to have the following programs (and packages) installed:

- R & Rscript (dplyr, ggplot2, qqman, data.table, stringr, argparse)  

## Install LMM Tools and PLINK2

Install the following tools (and any necessary dependencies) according to each tool's Wiki page (in this repo).
* PLINK2
* BOLT-LMM
* SAIGE
* REGENIE
* ~~SUGEN~~ (so far not entirely functional)

## Run Test Scripts with Test Data

The directory `test` includes generalized scripts and small data files (a simulated subset, n=100 individuals) to test functionality. All test scripts should be run from within the `test` directory.

### PLINK2 (baseline)

The test script can be used for either categorical or continous phenotypes with no adjustment needed.

Command to run with provided test data using nohup:
```
nohup bash run_PLINK2_test.sh -i 100simu-genos -p simu_categorical.phen -c TRAIT -o 100simu-genos_plink_cc -t 2 > nohup_PLINK2_test.out &
```
A more generalized command (update with user-specific parameters):
```
nohup bash run_PLINK2_test.sh -i <path/prefix of bed-bim-fam> -p <phenotype file> -c <pheno column name> -o <output prefix> -t <threads> > nohup_PLINK2_test.out &
```

### BOLT-LMM

The test script can be used for either categorical or continuous phenotypes. BOLT requires that phenotype files have a header row with the first two columns labeled FID and IID, and that categorical phenotypes are coded control=0 and case=1.

Command to run with provided test data using nohup:
```
nohup bash run_BOLT_test.sh -i 100simu-genos -p simu_categorical-01na.phen -c TRAIT -o 100simu-genos_bolt_cc -t 2 > nohup_BOLT_test.out &
```
A more generalized command (update with user-specific parameters):
```
nohup bash run_BOLT_test.sh -i <path/prefix of bed-bim-fam> -p <phenotype file> -c <pheno column name> -o <output prefix> -t <threads> > nohup_BOLT_test.out &
```

### SAIGE

SAIGE also requires that phenotype files have a header row with the first two columns labeled FID and IID, and that categorical phenotypes are coded control=0 and case=1. Different flags are used for binary versus continous, so there are two test scripts.

For the binary test data (~4.5 min real time):
```
nohup bash run_SAIGE_binary_test.sh -i 100simu-genos -p simu_categorical-01na.phen -c TRAIT -s IID -o 100simu-genos_saige_cc -t 2 > nohup_SAIGE_binary_test.out &
```
A generalized command for binary phenotypes:
```
nohup bash run_SAIGE_binary_test.sh -i <path/prefix of bed-bim-fam> -p <phenotype file> -c <pheno column name> -s <sample id column name in pheno file> -o <output prefix> -t <threads> > nohup_SAIGE_binary_test.out &
```
For the continous test data (~3 min real time):
```
nohup bash run_SAIGE_cont_test.sh -i 100simu-genos -p simu_continous.phen -c TRAIT -s IID -o 100simu-genos_saige_qt -t 2 > nohup_SAIGE_cont_test.out &
```
And a generalized command for continous phenotypes:
```
nohup bash run_SAIGE_cont_test.sh -i <path/prefix of bed-bim-fam> -p <phenotype file> -c pheno column name> -s <sample id column name in pheno file> -o <output prefix> -t <threads> > nohup_SAIGE_cont_test.out &
```

### REGENIE

Since REGENIE is installed within a conda environment, activate the environment before running REGENIE scripts:
```
conda activate regenie_env
```
REGENIE accepts phenotype file containing a header row. For binary traits, it has the option to accept 1/2 instead of 0/1 for control/case, but script currently set to accept 0/1.

Running REGENIE with the included n=100 test dataset generates an error (errors out analyzing a SNP on chromosome 1 that has 0 variance), but it does work with the n=1250 and larger subsets from the benchmark analysis. (It takes >10 Gb of memory at times while running!) Command to run for binary phenotype, n=1250 subset on class server (~30 min real time):
```
nohup bash run_REGENIE_binary_test.sh -i /home/igregga/LMM_files/1250simu-genos -p <phenotype file> -o 1250simu-genos_regenie_cc -t 2 > nohup_REGENIE_binary_test.out &
```
Generalized command for binary:
```
nohup bash run_REGENIE_binary_test.sh -i <path/prefix of bed-bim-fam> -p simu_categorical-01na.phen -o <output prefix> -t <threads> > nohup_REGENIE_binary_test.out &
```
Command to run for continous phenotype, n=1250 subset on class server:
```
nohup bash run_REGENIE_cont_test.sh -i /home/igregga/LMM_files/1250simu-genos -p simu_continous.phen -o 1250simu-genos_regenie_qt -t 2 > nohup_REGENIE_cont_test.out &
```
Generalized command for continous (~64 min real time):
```
nohup bash run_REGENIE_cont_test.sh -i <path/prefix of bed-bim-fam> -p <phenotype file> -o <output prefix> -t <threads> > nohup_REGENIE_cont_test.out &
```
When finished, deactivate the conda environment:
```
conda deactivate
```
Documentation FAQ does address the low variance error; could be addressed by filtering out low MAC variants before running step 1. There is an MAC filter flag included, but only for REGENIE step 2, so it doesn't help this specific situaion.

### Plots and Correlations

The Rscript plots_and_cor.R will take in all tool outputs to produce beta correlations and manhattan plots. Assumes all GWAS file names have the tool and either qt or cc in the file names, ie 'bolt_qt.txt'
```
Rscript plots_and_cor.R --plink_files <plink qt>,<plink cc> --tool_files <the other six filenames comma separated>
```
This will output a series of png files. R2 correlations are contained in pairwise beta plot titles.

______________________________________________________________
*Note: The rest of this README details the scripts and full-scale data used to benchmark the tools in this project, as well as notes on tool use. Includes hardcoded paths, as many files are too big to store on github.*

# Benchmark Runs and Analysis

## Overview of Workflow

![Workflow_diagram](https://github.com/idgregga7100/LMM_for_large_GWAS/assets/160544130/bf258ca6-0202-4355-ad6f-87c7b3a9528c)


## Preprocessing & File Preparation

Original simulated data files generated by Dr. Wheeler; n=5000 plink files with a continuous and a categorical/case-control phenotype file. True beta values for both phenotypes also provided. Located in:
```
#plink files
/home/data/simualted_gwas/simu_genos*
#pheno files
/home/data/simulated_gwas/simu*.phen
#true beta values
/home/data/simulated_gwas/simu*.par
```

Subsetted using subsampling.R and subsampling2.sh. path to subsetted plink files: 
```
/home/igregga/LMM_files/*simu-genos* 
#test if you can read them
head /home/igregga/LMM_files/*simu-genos.bim
```
VCF file conversion using plink_to_vcf.sh. path:
```
/home/igregga/LMM_files/vcfs/
```
Header added to pheno files using cat on the command line. Case/control coding converted from 1/2/-9 to 0/1/NA using convert_casecontrol_codes.R. path:
```
/home/igregga/LMM_files/phenos/
```

## Benchmark Runs

For benchmark runs, each tool was set to use 2 threads where possible. Time was measured using the `time` command and memory usage by `/usr/bin/time --verbose`, which logs the maximum resident set size. The general command format:
```
time /usr/bin/time --verbose <tool command>
```
This was incorporated into each of the tool-specific shell scripts detailed below.

### BOLT-LMM

The script to run BOLT, `run_BOLT.sh`, first completes a GWAS for the continous trait (looping through each of the subsets) and then does the same for the categorical trait. 

Command to run:
```
nohup bash run_BOLT.sh > nohup_BOLT.out &
```
Location of results files:
```
# final BOLT output for continous trait:
/home/tfischer1/LMM_for_large_GWAS/BOLT_results/1250simu-genos_qt_stats.tab 
/home/tfischer1/LMM_for_large_GWAS/BOLT_results/2500simu-genos_qt_stats.tab
/home/tfischer1/LMM_for_large_GWAS/BOLT_results/5000simu-genos_qt_stats.tab

# final output for categorical:
/home/tfischer1/LMM_for_large_GWAS/BOLT_results/1250simu-genos_cc_stats.tab
/home/tfischer1/LMM_for_large_GWAS/BOLT_results/2500simu-genos_cc_stats.tab
/home/tfischer1/LMM_for_large_GWAS/BOLT_results/5000simu-genos_cc_stats.tab

# log file:
/home/tfischer1/LMM_for_large_GWAS/nohup_BOLT.out 
```
Notes on this run:
* No covariates provided.
* BOLT requires reference LD scores to calibrate its BOLT-LMM statistic. Used the included LD score table for a European population, which is of course not ideal for an admixed population.
* Default is to allow a maximum of 1 million SNPs for the model, but our data includes >1.6 million. Changed to `--maxModelSnps=2000000` at the expense of computation and potential poor convergence.
* The tool really wants genetic coordinates to prevent proximal contamination. Our .bim files don't contain coordinates (have 0s in column 3). Reference genetic maps are available in the tool, but need the build (e.g. hg17, hg18, hg38). What build is our data? Could then use `--geneticMapFile flag`, without which the program gives a warning.

### SAIGE

SAIGE requires two steps for each GWAS run. The first step fits a null model. We used a full GRM (Genetic Relationship Matrix). The second step performs a single-variant association test.

The benchmark script for SAIGE, `run_SAIGE.sh`, first completes the two-step GWAS for the continous trait (looping through the subset sizes) and then does the same for the categorical trait. Note that time and memory are measured separately for step 1 and step 2 of each run.

Command to run:
```
nohup bash run_SAIGE.sh > nohup_SAIGE.out &
```
Location of results files:
```
# final SAIGE output for continous trait:
/home/tfischer1/LMM_for_large_GWAS/SAIGE_results/1250_qt_fullGRM_with_vr.txt
/home/tfischer1/LMM_for_large_GWAS/SAIGE_results/2500_qt_fullGRM_with_vr.txt
/home/tfischer1/LMM_for_large_GWAS/SAIGE_results/5000_qt_fullGRM_with_vr.txt

# for categorical trait:
/home/tfischer1/LMM_for_large_GWAS/SAIGE_results/1250_cc_fullGRM_with_vr.txt
/home/tfischer1/LMM_for_large_GWAS/SAIGE_results/2500_cc_fullGRM_with_vr.txt
/home/tfischer1/LMM_for_large_GWAS/SAIGE_results/5000_cc_fullGRM_with_vr.txt

# log file:
/home/tfischer1/LMM_for_large_GWAS/nohup_SAIGE.out  
```
Notes on this run:
* No covariates provided.
* Runs in two steps, with more required flags than the other tools.
* Fit a full genetic relationship model in step 1, which may have overfit the data (and takes a long time to run). There is an option to use a sparse model.
* Manual highly recommends running for 1 chromosome at a time using parameters `--LOCO=TRUE` with `--CHROM` specified (genotype/dosage file contain only 1 chrom) to avoid proximal contamination. Did not use, and went ahead with all at once.
* Did go with the recommendation to use Firth's Bias-Reduced Logistic Regression for more accurate effect sizes (binary only). Used `--is_Firth_beta=TRUE` and `--pCutoffforFirth=0.05` so markers with p-value < cutoff are estimated through Firth's.

### SUGEN

SUGEN has a weird error. See wiki page.

If it HAD worked:
* No covariates provided.
* Requires user to type out full regression formula as one of the arguments, eg trait=age+sex+pc1+pc2...
* May need more specific pheno file formatting that wasn't explained well enough in the documentation, or more specifically formatted regression formula, based on the error message. ???

### REGENIE

REGENIE like SAIGE also takes two steps, both wrapped in run_REGENIE.sh and run_REGENIE-binary.sh (one for continuous pheno, one categorical/binary pheno). Run with:
```
nohup /home/igregga/LMM_for_large_GWAS/run_REGENIE.sh > /home/igregga/regenie-out/regeniecont.log &
nohup /home/igregga/LMM_for_large_GWAS/run_REGENIE-binary.sh > /home/igregga/regenie-out/regeniecat.log &
```
Tool generates multiple log files for each run, and prints much of this info to command line (so it's a very long nohup log, and this isn't even using the --verbose flag). The actual results are:
```
/home/igregga/regenie-out/*.regenie
```
Notes on this run:
* No covariates provided.
* Runs in two steps. Longest and most taxing part of the process is step one (calculating GRM). Recommended 1 mil SNPs or less, like BOLT. Try LD pruning in the future?
* If not using the optional --lowmem flag, it takes so much memory that it almost made the class server unusable.
* Additional options like Firth available and recommended, similar to SAIGE. Did not use these for this run.

### PLINK2 (baseline)
The script to run PLINK2, `run_PLINK2.sh`, completes a GWAS for the continuous trait for each subset and then the categorical. 

The command to run the plink2 script is:
```
nohup bash run_PLINK2.sh > PLINK2.out &
```
The location of results files, including the log file, can all be found in the same directory: `/home/wprice2/gwas_results`.

Notes on this run:
* No covariates provided
* Run in one step
* Extremely straightforward execution with no hiccups

## Analysis

### Scalability
Runtime was recorded using the `--time` command which outputs CPU realtime, CPU user time, and CPU system time. To achieve the most holistic metric, we added user time and system time in our final analysis. 

Memory was recorded using the `/usr/bin/time --verbose` command which recorded the max CPU the job may occupy (aka max resident) in kilobytes. These values were converted to gigabytes in the final analysis. 

### Accuracy

The effect sizes of new tools were correlated with the effect sizes of PLINK2 results with p<1e-05, under the assumption that these should capture causal SNPs. Seven SNPs were significant at the genome-wide threshold 5e-08 for the continuous trait with PLINK2, and these were highlighted in continuous GWAS results of the new tools.

## Usability Ratings

### PLINK2.0
**Installation & Accessibility**: 5/5

**Usability**: 5/5

**Overall**: 5/5

**Notes**: There is a reason why plink is the industry standard!

### BOLT-LMM
**Installation & Accessibility**: 5/5

**Usability**: 4/5

**Overall**: 4/5

**Notes**: Runs in one step and relatively easy to use. Requires reference LD scores.

### SAIGE
**Installation & Accessibility**: 4/5

**Usability**: 3/5

**Overall**: 3/5

**Notes**:Takes two steps per run, with different settings for categorical and continuous in each step. One the one hand, the plethera of flag options means it's very customizable, but it's a lot to sort through. If fitting a full GRM model, takes a LONG time to run!

### REGENIE
**Installation & Accessibility**: 5/5, if using provided conda env. 2/5 if not

**Usability**: 4/5

**Overall**: 4/5

**Notes**: Dependency requirements are complicated, but conda works smoothly and easily. Needs two steps. Documentation is pretty thorough, with explanation of the algorithm/process etc.

### SUGEN
**Installation & Accessibility**: 3/5

**Usability**: 0/5

**Overall**: 1/5

**Notes**: It has potential: installed easily enough, but documentation has a lot of room for improvement. No help flag. Would only need one step to run, but ran into an error message about formatting (?) and couldn't figure out what is needed to fix it. Could not run. Opened a github issue but haven't gotten any response.

