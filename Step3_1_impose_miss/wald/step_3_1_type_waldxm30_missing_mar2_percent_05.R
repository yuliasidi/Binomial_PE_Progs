#!/home/statsadmin/R/bin/Rscript

source('Step_0_init.R')

args <- commandArgs()
idx <- as.numeric(args[length(args)])
.libPaths('ysidi/lib')


dt.full.X <- readRDS(file = sprintf('dtfullwaldxm30_%d.rds',idx))

set.seed(81762+idx+10)

#generate mar2 for 5-25% by 5% DO
dt.mar2 <- miss.apply.do(dt.full.X, b.trt=2, b.y=0, b.X=2, do=0.05)

dt.mar2.check <- dt.miss.check(dt.mar2 ,0.05)


saveRDS(dt.mar2.check,file = sprintf('waldxm30dochmar205_%d.rds',idx))

saveRDS(dt.mar2,file = sprintf('dtwaldxm30mar205_%d.rds',idx))

