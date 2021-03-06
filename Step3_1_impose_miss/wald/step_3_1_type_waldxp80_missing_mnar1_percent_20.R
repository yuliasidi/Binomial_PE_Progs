#!/home/statsadmin/R/bin/Rscript

source('Step_0_init.R')

args <- commandArgs()
idx <- as.numeric(args[length(args)])
.libPaths('ysidi/lib')


dt.full.X <- readRDS(file = sprintf('dtfullwaldxp80_%d.rds',idx))

set.seed(81762+idx+140)

#generate mnar1 for 5-25% by 5% DO
dt.mnar1 <- miss.apply.do(dt.full.X, b.trt=0, b.y=2, b.X=2, do=0.20)

dt.mnar1.check <- dt.miss.check(dt.mnar1 ,0.20)


saveRDS(dt.mnar1.check,file = sprintf('waldxp80dochmnar120_%d.rds',idx))

saveRDS(dt.mnar1,file = sprintf('dtwaldxp80mnar120_%d.rds',idx))

