#!/home/statsadmin/R/bin/Rscript

source('Step_0_init.R')

args <- commandArgs()
idx <- as.numeric(args[length(args)])
.libPaths('ysidi/lib')

#################
###   CCA    ####
#################

dt.miss <- readRDS(file = sprintf('dtwaldxmmmnar125_%d.rds',idx))

cca.anal <- cca.wald.anal(dt.miss)%>%
  mutate(type = 'waldxmm', missing = 'mnar1', do = '25'  )

saveRDS(cca.anal,file = sprintf('ccawaldxmmmnar125_%d.rds',idx))

