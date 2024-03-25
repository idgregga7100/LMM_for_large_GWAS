#!/bin/bash
#ACTIVATE CONDA ENV FIRST
conda activate regenie_env

#need to loop through sample sizes, again phenos need different commands
for f in 1250 2500 5000
do
#run regenie step 1
./regenie --step 1 \
--bed /home/igregga/LMM_files/${f}simu-gwas \
--phenoFile /home/igregga/LMM_files/phenos/simu_continuous.phen \
--bsize 100 \
--out /home/igregga/regenie-out/${f}continuous-fit

#run regenie step 2
./regenie --step 2 \
--bed /home/igregga/LMM_files/${f}simu-gwas \
--pred /home/igregga/regenie-out/${f}continuous-fit_pred.list \
--phenoFile /home/igregga/LMM_files/phenos/simu_continuous.phen \
--bsize 100 \
--out /home/igregga/regenie-out/${f}continuous-test
done

conda deactivate

#recommeded: firth pval adjustment/test in step two, but will try without
#for binary/cat trait, there's a flag to specify binary and a flag to specify 1/2 instead of 0/1