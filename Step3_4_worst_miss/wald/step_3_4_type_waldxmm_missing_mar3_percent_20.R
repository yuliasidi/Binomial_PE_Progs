#!/home/statsadmin/R/bin/Rscript

source('Step_0_init.R')

args <- commandArgs()
idx <- as.numeric(args[length(args)])
.libPaths('ysidi/lib')

################################
###   WORST CASE SCENARIO    ####
################################

dt.miss <- readRDS(file = sprintf('dtwaldxmmmar320_%d.rds',idx))

worst.anal <- worst.wald.anal(dt.miss)%>%
  mutate(type = 'waldxmm', missing = 'mar3', do = '20'  )

saveRDS(worst.anal,file = sprintf('worstwaldxmmmar320_%d.rds',idx))

