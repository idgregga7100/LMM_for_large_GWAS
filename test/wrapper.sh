#!/bin/bash
#okay here's my idea. set up, like, absolute args for this script
#edit output path arg with string manip for each tool
#be able to take the output path formula to easily call sumstat scripts for plotting
#??????? how do we feel about this
#for example
input=plink
pheno=whatev
output=test_out

outbolt=${output}_bolt
outsaige=${output}_saige
#etc

run_bolt -o outbolt

rscript -e 'rmarkdown::render(\"plot.rmd\",params=list(bolt=outbolt,saige=outsaige,etc))'
#not 100% on how passing a bash variable to the rendering command should work