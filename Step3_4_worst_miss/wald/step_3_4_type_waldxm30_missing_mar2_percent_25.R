#!/home/statsadmin/R/bin/Rscript

source('Step_0_init.R')

args <- commandArgs()
idx <- as.numeric(args[length(args)])
.libPaths('ysidi/lib')

################################
###   WORST CASE SCENARIO    ####
################################

dt.miss <- readRDS(file = sprintf('dtwaldxm30mar225_%d.rds',idx))

worst.anal <- worst.wald.anal(dt.miss)%>%
  mutate(type = 'waldxm30', missing = 'mar2', do = '25'  )

saveRDS(worst.anal,file = sprintf('worstwaldxm30mar225_%d.rds',idx))

