#!/home/statsadmin/R/bin/Rscript

source('Step_0_init.R')

args <- commandArgs()
idx <- as.numeric(args[length(args)])
.libPaths('ysidi/lib')

################################
###   BEST CASE SCENARIO    ####
################################

dt.miss <- readRDS(file = sprintf('dtwaldxm30mar220_%d.rds',idx))

best.anal <- best.wald.anal(dt.miss)%>%
  mutate(type = 'waldxm30', missing = 'mar2', do = '20'  )

saveRDS(best.anal,file = sprintf('bestwaldxm30mar220_%d.rds',idx))

