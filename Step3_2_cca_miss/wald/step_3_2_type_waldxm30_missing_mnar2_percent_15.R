#!/home/statsadmin/R/bin/Rscript

source('Step_0_init.R')

args <- commandArgs()
idx <- as.numeric(args[length(args)])
.libPaths('ysidi/lib')

#################
###   CCA    ####
#################

dt.miss <- readRDS(file = sprintf('dtwaldxm30mnar215_%d.rds',idx))

cca.anal <- cca.wald.anal(dt.miss)%>%
  mutate(type = 'waldxm30', missing = 'mnar2', do = '15'  )

saveRDS(cca.anal,file = sprintf('ccawaldxm30mnar215_%d.rds',idx))

