#!/home/statsadmin/R/bin/Rscript

source('Step_0_init.R')

args <- commandArgs()
idx <- as.numeric(args[length(args)])
.libPaths('ysidi/lib')


dt.full.X <- readRDS(file = sprintf('dtfullwaldxp80_%d.rds',idx))

set.seed(81762+idx+92)

#generate mar4 for 5-25% by 5% DO
dt.mar4 <- miss.apply.do(dt.full.X, b.trt=-2, b.y=0, b.X=-2, do=0.15)

dt.mar4.check <- dt.miss.check(dt.mar4 ,0.15)


saveRDS(dt.mar4.check,file = sprintf('waldxp80dochmar415_%d.rds',idx))

saveRDS(dt.mar4,file = sprintf('dtwaldxp80mar415_%d.rds',idx))

