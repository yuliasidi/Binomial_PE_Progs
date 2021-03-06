#!/home/statsadmin/R/bin/Rscript

source('Step_0_init.R')

args <- commandArgs()
idx <- as.numeric(args[length(args)])
.libPaths('ysidi/lib')

################################
###   WORST CASE SCENARIO    ####
################################

dt.miss <- readRDS(file = sprintf('dtwaldxmmmnar205_%d.rds',idx))

worst.anal <- worst.wald.anal(dt.miss)%>%
  mutate(type = 'waldxmm', missing = 'mnar2', do = '05'  )

saveRDS(worst.anal,file = sprintf('worstwaldxmmmnar205_%d.rds',idx))

