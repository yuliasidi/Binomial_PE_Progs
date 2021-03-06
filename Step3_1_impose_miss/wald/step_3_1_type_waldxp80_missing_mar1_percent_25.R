#!/home/statsadmin/R/bin/Rscript

source('Step_0_init.R')

args <- commandArgs()
idx <- as.numeric(args[length(args)])
.libPaths('ysidi/lib')


dt.full.X <- readRDS(file = sprintf('dtfullwaldxp80_%d.rds',idx))

set.seed(81762+idx+152)

#generate mar1 for 5-25% by 5% DO
dt.mar1 <- miss.apply.do(dt.full.X, b.trt=0, b.y=0, b.X=2, do=0.25)

dt.mar1.check <- dt.miss.check(dt.mar1 ,0.25)


saveRDS(dt.mar1.check,file = sprintf('waldxp80dochmar125_%d.rds',idx))

saveRDS(dt.mar1,file = sprintf('dtwaldxp80mar125_%d.rds',idx))

