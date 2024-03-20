#!/bin/bash
#using plink and generated keeplists to get subsampled plink files
#2500
./plink2 --bfile /home/data/simulated_gwas/simu-genos --keep /home/igregga/LMM_files/2500_id_list.txt --make-bed --out /home/igregga/LMM_files/2500simu-genos

#1250
./plink2 --bfile /home/data/simulated_gwas/simu-genos --keep /home/igregga/LMM_files/1250_id_list.txt --make-bed --out /home/igregga/LMM_files/1250simu-genos

