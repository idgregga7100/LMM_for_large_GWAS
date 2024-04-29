#compiled beta correlation and manplots
library(argparse)
library(data.table)
library(dplyr)
library(qqman)
library(ggplot2)
library(stringr)
"%&%" = function(a,b) paste(a,b,sep="")

#this ASSUMES tool output file names include the name of the tool in lower case, and the trait as either qt or cc

parser<-ArgumentParser()
parser$add_argument("-p", "--plink_files", type="character")
parser$add_argument('-t','--tool_files',type='character')
parser$add_argument('-o','--outdir',type='character')
args<-parser$parse_args()
plinkfiles<-args$plink_files
plinkfiles<-str_split(plinkfiles,',')[[1]]
toolfiles<-args$tool_files
toolfiles<-str_split(toolfiles,',')[[1]]
outdir<-args$outdir

#filtering down plink; using suggestive line from manplot fn at 1e-5
plinkqt<-str_subset(plinkfiles,'qt')%>%fread()
plinkcc<-str_subset(plinkfiles,'cc')%>%fread()
plinkqt<-filter(plinkqt,P<=1e-5)
plinkcc<-filter(plinkcc,P<=1e-5)
plinkcc<-mutate(plinkcc,BETA=log(OR))

for(trait in c('qt','cc')){
  if(trait=='qt'){plink<-plinkqt}else{plink<-plinkcc}
  #regenie
  reg<-str_subset(toolfiles,'regenie')%>%str_subset(trait)%>%fread()
  merged<-left_join(plink,reg,by=c('ID'='ID'))
  r2 <- (cor(merged$BETA.x, merged$BETA.y, method='pearson'))^2
  r2 <- as.character(round(r2, digits=2))
  ggplot(merged,aes(x=BETA.x,y=BETA.y))+
    geom_point()+
    geom_smooth(method='lm')+
    theme_gray(base_size=18)+
    ggtitle('REGENIE '%&%trait%&%', R2='%&%r2)+xlab('REGENIE')+ylab('PLINK')
  ggsave('REGENIE-PLINK_'%&%trait%&%'_beta_r2.png',device='png')
  
  #bolt
  bolt<-str_subset(toolfiles,'bolt')%>%str_subset(trait)%>%fread()
  merged<-left_join(plink,bolt,by=c('ID'='SNP'))
  r2 <- (cor(merged$BETA.x, merged$BETA.y, method='pearson'))^2
  r2 <- as.character(round(r2, digits=2))
  ggplot(merged,aes(x=BETA.x,y=BETA.y))+
    geom_point()+
    geom_smooth(method='lm')+
    theme_gray(base_size=18)+
    ggtitle('BOLT '%&%trait%&%', R2='%&%r2)+xlab('BOLT')+ylab('PLINK')
  ggsave('BOLT-PLINK_'%&%trait%&%'_beta_r2.png',device='png')
  
  #saige
  saige<-str_subset(toolfiles,'saige')%>%str_subset(trait)%>%fread()
  merged<-left_join(plink,saige,by=c('ID'='MarkerID'))
  r2 <- (cor(merged$BETA.x, merged$BETA.y, method='pearson'))^2
  r2 <- as.character(round(r2, digits=2))
  ggplot(merged,aes(x=BETA.x,y=BETA.y))+
    geom_point()+
    geom_smooth(method='lm')+
    theme_gray(base_size=18)+
    ggtitle('SAIGE '%&%trait%&%', R2='%&%r2)+xlab('SAIGE')+ylab('PLINK')
  ggsave('SAIGE-PLINK_'%&%trait%&%'_beta_r2.png',device='png')
}

#manplots
#get any sig plink snps from qt
plinkqt<-str_subset(plinkfiles,'qt')%>%fread()
plinkcc<-str_subset(plinkfiles,'cc')%>%fread()

hits<-filter(plinkqt,P<=5e-8)
hits<-arrange(hits,P)
sigsnps<-pull(hits,ID)

m<-manhattan(plinkqt,chr='#CHROM',bp='POS',snp='ID',highlight=sigsnps)
png('plinkqt_manhattan.png')
print(m)
dev.off()

boltqt<-str_subset(toolfiles,'bolt')%>%str_subset('qt')%>%fread()
m<-manhattan(boltqt,p='P_BOLT_LMM_INF',highlight=sigsnps)
png('boltqt_manhattan.png')
print(m)
dev.off()
saigeqt<-str_subset(toolfiles,'saige')%>%str_subset('qt')%>%fread()
m<-manhattan(saigeqt,bp='POS',p='p.value',snp='MarkerID',highlight=sigsnps)
png('saigeqt_manhattan.png')
print(m)
dev.off()
regqt<-str_subset(toolfiles,'regenie')%>%str_subset('qt')%>%fread()
m<-manhattan(regqt,snp='ID',chr='CHROM',bp='GENPOS',p='LOG10P',logp=F,highlight=sigsnps)
png('regenieqt_manhattan.png')
print(m)
dev.off()

