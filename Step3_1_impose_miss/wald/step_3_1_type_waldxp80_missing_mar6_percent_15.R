#!/home/statsadmin/R/bin/Rscript

source('Step_0_init.R')

args <- commandArgs()
idx <- as.numeric(args[length(args)])
.libPaths('ysidi/lib')


dt.full.X <- readRDS(file = sprintf('dtfullwaldxp80_%d.rds',idx))

set.seed(81762+idx+100)

#generate mar6 for 5-25% by 5% DO
dt.mar6 <- miss.apply.do(dt.full.X, b.trt=-2, b.y=0, b.X=2, do=0.15)

dt.mar6.check <- dt.miss.check(dt.mar6 ,0.15)


saveRDS(dt.mar6.check,file = sprintf('waldxp80dochmar615_%d.rds',idx))

saveRDS(dt.mar6,file = sprintf('dtwaldxp80mar615_%d.rds',idx))

