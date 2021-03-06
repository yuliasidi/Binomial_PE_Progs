#!/home/statsadmin/R/bin/Rscript

source('Step_0_init.R')

args <- commandArgs()
idx <- as.numeric(args[length(args)])
.libPaths('ysidi/lib')


dt.full.X <- readRDS(file = sprintf('dtfullwaldxm30_%d.rds',idx))

set.seed(81762+idx+178)

#generate mnar2 for 5-25% by 5% DO
dt.mnar2 <- miss.apply.do(dt.full.X, b.trt=1, b.y=-2, b.X=-2, do=0.25)

dt.mnar2.check <- dt.miss.check(dt.mnar2 ,0.25)


saveRDS(dt.mnar2.check,file = sprintf('waldxm30dochmnar225_%d.rds',idx))

saveRDS(dt.mnar2,file = sprintf('dtwaldxm30mnar225_%d.rds',idx))

