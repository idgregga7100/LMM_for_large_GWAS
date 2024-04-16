#filtering true betas to only >1 or <-1
library(data.table)
library(dplyr)

qt<-fread('/home/data/simulated_gwas/simu-qt-h2_0.2.par')
cc<-real<-fread('/home/data/simulated_gwas/simu-cc-h2_0.2-prev0.1.par')

qt<-mutate(qt,absEffect=abs(Effect))
cc<-mutate(cc,absEffect=abs(Effect))

qt<-filter(qt,absEffect>=1)
cc<-filter(cc,absEffect>=1)

fwrite(qt,'/home/igregga/LMM_files/phenos/simu-qt-h2_0.2_filtered.par',quote=F,row.names=F,sep='\t')
fwrite(cc,'/home/igregga/LMM_files/phenos/simu-cc-h2_0.2-prev0.1_filtered.par',quote=F,row.names=F,sep='\t')
