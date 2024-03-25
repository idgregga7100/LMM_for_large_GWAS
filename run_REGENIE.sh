#!/bin/bash
#ACTIVATE CONDA ENV FIRST
conda activate regenie_env

#run regenie step 1
./regenie --step 1 \
--bed /home/igregga/LMM_files/5000simu-gwas \
--phenoFile /home/igregga/LMM_files/phenos/simu_continuous.phen \
--bsize 100 \
--out /home/igregga/regenie-out/continuous-fit

#run regenie step 2
./regenie --step 2 \
--bed /home/igregga/LMM_files/5000simu-gwas \
--pred /home/igregga/regenie-out/continuous-fit_pred.list \
--phenoFile /home/igregga/LMM_files/phenos/simu_continuous.phen \
--bsize 100 \
--out /home/igregga/regenie-out/continuous-test

conda deactivate

#recommeded: firth pval adjustment/test in step two, but will try without
#for binary/cat trait, there's a flag to specify binary and a flag to specify 1/2 instead of 0/1