#!/bin/bash
#convert from plink to vcf format
./plink2 --bfile /home/igregga/LMM_files/2500simu-genos --export vcf --out /home/igregga/LMM_files/vcfs/2500simu-genos
./plink2 --bfile /home/igregga/LMM_files/1250simu-genos --export vcf --out /home/igregga/LMM_files/vcfs/1250simu-genos