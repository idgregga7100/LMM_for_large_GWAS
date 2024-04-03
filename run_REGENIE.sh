#!/bin/bash
#ACTIVATE CONDA ENV FIRST from command line
#conda activate regenie_env

#need to loop through sample sizes, again phenos need different commands
for f in 1250 2500 5000
do
#run regenie step 1
time /usr/bin/time --verbose regenie --step 1 \
--bed /home/igregga/LMM_files/${f}simu-genos \
--phenoFile /home/igregga/LMM_files/phenos/simu_continuous.phen \
--bsize 100 \
--out /home/igregga/regenie-out/${f}continuous-fit \
--force-step1 \
--threads 2

#run regenie step 2
time /usr/bin/time --verbose regenie --step 2 \
--bed /home/igregga/LMM_files/${f}simu-genos \
--pred /home/igregga/regenie-out/${f}continuous-fit_pred.list \
--phenoFile /home/igregga/LMM_files/phenos/simu_continuous.phen \
--bsize 100 \
--out /home/igregga/regenie-out/${f}continuous-test \
--threads 2
done

#conda deactivate

#recommeded: firth pval adjustment/test in step two, but will try without
#for binary/cat trait, there's a flag to specify binary and a flag to specify 1/2 instead of 0/1
#ERROR: it is not recommened to use more than 1000000 variants in step 1 (otherwise use '--force-step1')
#to run: nohup /home/igregga/LMM_for_large_GWAS/run_REGENIE.sh > /home/igregga/regenie-out/regeniecont.log &