#!/home/statsadmin/R/bin/Rscript

source('Step_0_init.R')

args <- commandArgs()
idx <- as.numeric(args[length(args)])
.libPaths('ysidi/lib')

################################
###   BEST CASE SCENARIO    ####
################################

dt.miss <- readRDS(file = sprintf('dtwaldxmmmcar20_%d.rds',idx))

best.anal <- best.wald.anal(dt.miss)%>%
  mutate(type = 'waldxmm', missing = 'mcar', do = '20'  )

saveRDS(best.anal,file = sprintf('bestwaldxmmmcar20_%d.rds',idx))

