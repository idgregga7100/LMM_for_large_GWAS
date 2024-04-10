# LMM_for_large_GWAS
COMP383/483 project

## LMM Tools and PLINK2 Installation

The following tools (and any necessary dependencies) were installed according to each tool's Wiki page (in this repo).
* BOLT-LMM
* SAIGE
* SUGEN (so far not entirely functional?)
* REGENIE
* PLINK2

## Preprocessing & File Preparation

path to subsetted plink files: 
```
/home/igregga/LMM_files/*simu-genos* 
#test if you can read them
head /home/igregga/LMM_files/*simu-genos.bim
```

header added to pheno files using cat on the command line
```
/home/igregga/LMM_files/phenos/
```
## Benchmark Runs

*Note: all commands can be run from inside the `LMM_for_large_GWAS` repo directory.??*

### BOLT-LMM

The script to run BOLT, `run_BOLT.sh`, first completes a GWAS for the continous trait (looping through each of the subsets) and then completes a GWAS for the categorical trait. 

Command to run:
```
nohup bash run_BOLT.sh > nohup_BOLT.out &
```
Location of results files:
```

```

### SAIGE

SAIGE requires two steps for each GWAS run. The first step fits a null model. We used a full GRM (Genetic Relationship Matrix). The second step performs a single-variant association test.

The benchmark script for SAIGE, `run_SAIGE.sh`, first completes the two-step GWAS for the continous trait (looping through the subset sizes) and then does the same for the categorical trait. Note that time and memory are measured separately for step 1 and step 2 of each run.

Command to run:
```
nohup bash run_SAIGE.sh > nohup_SAIGE.out &
```
Location of results files:
```

```

### SUGEN

### REGENIE

### PLINK2
