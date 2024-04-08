library(data.table)
library(dplyr)

pheno<-fread('/home/igregga/LMM_files/phenos/simu_categorical.phen')
control<-filter(pheno,TRAIT==1)%>%mutate(TRAIT=0)
dim(control)
case<-filter(pheno,TRAIT==2)%>%mutate(TRAIT=1)
dim(case)
na<-filter(pheno,TRAIT==-9)%>%mutate(TRAIT='NA')
dim(na)

newpheno<-rbind(control,case,na)
fwrite(newpheno,'/home/igregga/LMM_files/phenos/simu_categorical-01na.phen',quote=F,sep='\t',row.names=F)
