#plotting pairwise betas

#regenie out colnames: CHROM GENPOS ID ALLELE0 ALLELE1 A1FREQ N TEST BETA SE CHISQ LOG10P EXTRA
#bolt: SNP     CHR     BP      GENPOS  ALLELE1 ALLELE0 A1FREQ  F_MISS  BETA    SE      P_BOLT_LMM_INF
#saige: CHR     POS     MarkerID        Allele1 Allele2 AC_Allele2      AF_Allele2      MissingRate     BETA    SE      Tstat   var     p.value N
#plink: #CHROM   POS          ID REF ALT PROVISIONAL_REF? A1 OMITTED A1_FREQ TEST OBS_CT      BETA  SE    T_STAT        P ERRCODE

#.par truth: QTL     RefAllele       Frequency       Effect

library(data.table)
library(ggplot2)
library(dplyr)

#regenie continuous
realqt<-fread('/home/data/simulated_gwas/simu-qt-h2_0.2.par')
reg<-fread('/home/igregga/regenie-out/5000continuous-test_TRAIT.regenie')

merged<-left_join(real,reg,by=c('QTL'='ID'))

ggplot(merged,aes(x=Effect,y=BETA))+geom_point()

#regenie categorical
realcc<-fread('/home/data/simulated_gwas/simu-cc-h2_0.2-prev0.1.par')
reg<-fread('/home/igregga/regenie-out/5000categorical-test_TRAIT.regenie')

merged<-left_join(real,reg,by=c('QTL'='ID'))

ggplot(merged,aes(x=Effect,y=BETA))+geom_point()

#bolt continuous
bolt<-fread('/home/tfischer1/LMM_for_large_GWAS/BOLT_results/5000simu-genos_qt_stats.tab')

merged<-left_join(realqt,bolt,by=c('QTL'='SNP'))

ggplot(merged,aes(x=Effect,y=BETA))+geom_point()

#bolt categorical
bolt<-fread('/home/tfischer1/LMM_for_large_GWAS/BOLT_results/5000simu-genos_cc_stats.tab')

merged<-left_join(realcc,bolt,by=c('QTL'='SNP'))

ggplot(merged,aes(x=Effect,y=BETA))+geom_point()

#saige continuous
saige<-fread('/home/tfischer1/LMM_for_large_GWAS/SAIGE_results/5000_qt_fullGRM_with_vr.txt')
merged<-left_join(realqt,saige,by=c('QTL'='MarkerID'))
ggplot(merged,aes(x=Effect,y=BETA))+geom_point()

#saige categorical
saige<-fread('/home/tfischer1/LMM_for_large_GWAS/SAIGE_results/5000_cc_fullGRM_with_vr.txt')
merged<-left_join(realcc,saige,by=c('QTL'='MarkerID'))
ggplot(merged,aes(x=Effect,y=BETA))+geom_point()

#plink continuous
plink<-fread('/home/wprice2/gwas_results/5000continuous.TRAIT.glm.linear')
merged<-left_join(realqt,plink,by=c('QTL'='ID'))
ggplot(merged,aes(x=Effect,y=BETA))+geom_point()

#plink categorical
plink<-fread('/home/wprice2/gwas_results/5000categorical.TRAIT.glm.logistic.hybrid')
merged<-left_join(realcc,plink,by=c('QTL'='ID'))
ggplot(merged,aes(x=Effect,y=BETA))+geom_point()
