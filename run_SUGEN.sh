#!/bin/bash
#run sugen

/home/igregga/SUGEN-master/SUGEN \
--pheno /home/igregga/LMM_files/phenos/simu_continuous.phen \
--formula "trait=" \
--unweighted \
--vcf /home/igregga/LMM_files/vcfs/1250simu-genos.vcf \
--model linear \
--out-prefix /home/igregga/sugen-out/continuous_1250

#this should be essentially their default linear association, if i understand their documentation