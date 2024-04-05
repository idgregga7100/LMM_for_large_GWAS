#!/bin/bash
#run sugen
#need to loop through: phenos BUT need diff commands so not actually ideal for loop, sample sizes

#setting threads, no built in option in sugen. stole this from dr w lmao
threads=2
export MKL_NUM_THREADS=$threads
export NUMEXPR_NUM_THREADS=$threads
export OMP_NUM_THREADS=$threads

for f in 1250 2500 5000
do

time /usr/bin/time --verbose /home/igregga/SUGEN-master/SUGEN \
--pheno /home/igregga/LMM_files/phenos/simu_continuous.phen \
--formula "TRAIT=" \
--unweighted \
--vcf /home/igregga/LMM_files/vcfs/${f}simu-genos.vcf \
--model linear \
--out-prefix /home/igregga/sugen-out/continuous_${f}

done

#this should be essentially their default linear association, if i understand their documentation
#to run: nohup /home/igregga/LMM_for_large_GWAS/run_SUGEN.sh > /home/igregga/sugen-out/sugencont.log &