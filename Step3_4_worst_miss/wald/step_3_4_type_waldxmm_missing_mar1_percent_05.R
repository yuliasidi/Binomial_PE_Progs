#!/home/statsadmin/R/bin/Rscript

source('Step_0_init.R')

args <- commandArgs()
idx <- as.numeric(args[length(args)])
.libPaths('ysidi/lib')

################################
###   WORST CASE SCENARIO    ####
################################

dt.miss <- readRDS(file = sprintf('dtwaldxmmmar105_%d.rds',idx))

worst.anal <- worst.wald.anal(dt.miss)%>%
  mutate(type = 'waldxmm', missing = 'mar1', do = '05'  )

saveRDS(worst.anal,file = sprintf('worstwaldxmmmar105_%d.rds',idx))

