#plotting pairwise betas

#regenie out colnames: CHROM GENPOS ID ALLELE0 ALLELE1 A1FREQ N TEST BETA SE CHISQ LOG10P EXTRA
#bolt: SNP     CHR     BP      GENPOS  ALLELE1 ALLELE0 A1FREQ  F_MISS  BETA    SE      P_BOLT_LMM_INF
#saige: CHR     POS     MarkerID        Allele1 Allele2 AC_Allele2      AF_Allele2      MissingRate     BETA    SE      Tstat   var     p.value N
#plink: #CHROM   POS          ID REF ALT PROVISIONAL_REF? A1 OMITTED A1_FREQ TEST OBS_CT      BETA  SE    T_STAT        P ERRCODE

#.par truth: QTL     RefAllele       Frequency       Effect

library(data.table)
library(ggplot2)
library(dplyr)
realqt<-fread('/home/igregga/LMM_files/phenos/simu-qt-h2_0.2_filtered.par')
realcc<-fread('/home/igregga/LMM_files/phenos/simu-cc-h2_0.2-prev0.1_filtered.par')

#regenie continuous
reg<-fread('/home/igregga/regenie-out/5000continuous-test_TRAIT.regenie')
merged<-left_join(realqt,reg,by=c('QTL'='ID'))
ggplot(merged,aes(x=Effect,y=BETA))+geom_point()+geom_abline(slope=1,intercept=0,color='red')+geom_smooth()#+ expand_limits(x=c(-50,50))

#regenie categorical
reg<-fread('/home/igregga/regenie-out/5000categorical-test_TRAIT.regenie')
merged<-left_join(realcc,reg,by=c('QTL'='ID'))
ggplot(merged,aes(x=Effect,y=BETA))+geom_point()+geom_abline(slope=1,intercept=0,color='red')+geom_smooth()#+expand_limits(y=c(-4,4))

#bolt continuous
bolt<-fread('/home/tfischer1/LMM_for_large_GWAS/BOLT_results/5000simu-genos_qt_stats.tab')
merged<-left_join(realqt,bolt,by=c('QTL'='SNP'))
ggplot(merged,aes(x=Effect,y=BETA))+geom_point()+geom_abline(slope=1,intercept=0,color='red')+geom_smooth()+expand_limits(x=c(-50,50))

#bolt categorical
bolt<-fread('/home/tfischer1/LMM_for_large_GWAS/BOLT_results/5000simu-genos_cc_stats.tab')
merged<-left_join(realcc,bolt,by=c('QTL'='SNP'))
ggplot(merged,aes(x=Effect,y=BETA))+geom_point()+geom_abline(slope=1,intercept=0,color='red')+geom_smooth()+expand_limits(y=c(-4,4))

#saige continuous
saige<-fread('/home/tfischer1/LMM_for_large_GWAS/SAIGE_results/5000_qt_fullGRM_with_vr.txt')
merged<-left_join(realqt,saige,by=c('QTL'='MarkerID'))
ggplot(merged,aes(x=Effect,y=BETA))+geom_point()+geom_abline(slope=1,intercept=0,color='red')+geom_smooth()+expand_limits(y=c(-4,4))

#saige categorical
saige<-fread('/home/tfischer1/LMM_for_large_GWAS/SAIGE_results/5000_cc_fullGRM_with_vr.txt')
merged<-left_join(realcc,saige,by=c('QTL'='MarkerID'))
ggplot(merged,aes(x=Effect,y=BETA))+geom_point()+geom_abline(slope=1,intercept=0,color='red')+geom_smooth()+expand_limits(y=c(-4,4))

#plink continuous
plink<-fread('/home/wprice2/gwas_results/5000continuous.TRAIT.glm.linear')
merged<-left_join(realqt,plink,by=c('QTL'='ID'))
ggplot(merged,aes(x=Effect,y=BETA))+geom_point()+geom_abline(slope=1,intercept=0,color='red')+geom_smooth()+geom_smooth()+expand_limits(x=c(-60,60))

#plink categorical
plink<-fread('/home/wprice2/gwas_results/5000categorical.TRAIT.glm.logistic.hybrid')
merged<-left_join(realcc,plink,by=c('QTL'='ID'))
#need to calc beta
merged<-mutate(merged,BETA=log(OR))
ggplot(merged,aes(x=Effect,y=BETA))+geom_point()+geom_abline(slope=1,intercept=0,color='red')+geom_smooth()+expand_limits(y=c(-4,4))
