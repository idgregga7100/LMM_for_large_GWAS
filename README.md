# LMM_for_large_GWAS
COMP383/483 project

## LMM Tools and PLINK2 Installation

The following tools (and any necessary dependencies) were installed according to each tool's Wiki page (in this repo).
* BOLT-LMM
* SAIGE
* SUGEN
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

Command to run:
```
nohup bash run_BOLT.sh > nohup_BOLT.out &
```
Location of results files:
```

```

### SAIGE

### SUGEN

### REGENIE

### PLINK2
