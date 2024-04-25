library(data.table)
fam<-fread('/home/data/simulated_gwas/simu-genos.fam')
#fam cols: fid, iid, father, mother, sex, pheno

set.seed(7)
#get random 2500
#subset1<-sample(fam$V2,2500,replace=F)
#fwrite(data.frame(subset1),'/home/igregga/LMM_files/2500_id_list.txt',col.names=F,quote=F,sep='\t')

#get random 1250
#subset2<-sample(fam$V2,1250,replace=F)
#fwrite(data.frame(subset2),'/home/igregga/LMM_files/1250_id_list.txt',col.names=F,quote=F,sep='\t')

#get random 100 for test data
subset3<-sample(fam$V2,100,replace=F)
fwrite(data.frame(subset3),'/home/igregga/LMM_files/100_id_list.txt',col.names=F,quote=F,sep='\t')
