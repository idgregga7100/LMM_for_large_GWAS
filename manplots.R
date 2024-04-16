library(data.table)
library(qqman)

#bolt
boltqt<-fread('/home/tfischer1/LMM_for_large_GWAS/BOLT_results/5000simu-genos_qt_stats.tab')
#boltcc<-fread('/home/tfischer1/LMM_for_large_GWAS/BOLT_results/5000simu-genos_cc_stats.tab')
manhattan(boltqt,p='P_BOLT_LMM_INF')
#manhattan(boltcc,p='P_BOLT_LMM_INF')

#saige
saigeqt<-fread('/home/tfischer1/LMM_for_large_GWAS/SAIGE_results/5000_qt_fullGRM_with_vr.txt')
#saigecc<-fread('/home/tfischer1/LMM_for_large_GWAS/SAIGE_results/5000_cc_fullGRM_with_vr.txt')
manhattan(saigeqt,bp='POS',p='p.value',snp='MarkerID')

#regenie
regqt<-fread('/home/igregga/regenie-out/5000continuous-test_TRAIT.regenie')
#regcc<-fread('/home/igregga/regenie-out/5000categorical-test_TRAIT.regenie')
manhattan(regqt,snp='ID',chr='CHROM',bp='GENPOS',p='LOG10P',logp=F)

#plink
plinkqt<-fread('/home/wprice2/gwas_results/5000continuous.TRAIT.glm.linear')
#plinkcc<-fread('/home/wprice2/gwas_results/5000categorical.TRAIT.glm.logistic.hybrid')
manhattan(plinkqt,chr='#CHROM',bp='POS',snp='ID')
