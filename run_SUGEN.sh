#!/bin/bash
#run sugen

#need to loop through: phenos BUT need diff commands so not actually ideal for loop, sample sizes

for f in 1250 2500 5000
do
/home/igregga/SUGEN-master/SUGEN \
--pheno /home/igregga/LMM_files/phenos/simu_continuous.phen \
--formula "trait=" \
--unweighted \
--vcf /home/igregga/LMM_files/vcfs/${f}simu-genos.vcf \
--model linear \
--out-prefix /home/igregga/sugen-out/continuous_${f}
done

#this should be essentially their default linear association, if i understand their documentation