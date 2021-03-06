#!/home/statsadmin/R/bin/Rscript

source('Step_0_init.R')

args <- commandArgs()
idx <- as.numeric(args[length(args)])
.libPaths('ysidi/lib')

# Fixed margin approach for proportions difference.
# The margin was set at 5%, 7.5%, 10%, 15%, 20%.
# The success rates for the primary endpoint range btw 0.6-0.95 by increments of 0.05.
# alpha level is 2.5%.
# Power is 0.9.

#M2 <- c(0.05, 0.075, 0.1, 0.15, 0.2)
#p_C <- seq(0.6, 0.95, 0.05)
#alpha <- c(0.025)
#beta <- c(0.1)

SS <- readRDS(file = "SS_power90FM.rds")

#########################################################
########      Generate Patient Level Data     ###########
#########################################################
set.seed(10+idx)

SS.idx <- SS%>%
  dplyr::slice(idx+1)

# generate patient level data for under H1
dt.full <- SS.idx%>%
  as_tibble()%>%
  mutate( 
    N_T = N.total/2,
    N_C = N_T,
    t.H1 = pmap(list(N_T,N_C,p_T,p_C), .f = function(..., n.sim){
      rerun(n.sim,ni.d(...))%>%
        dplyr::bind_rows(.id = 'sim.id')
    },n.sim = n.sim))

# generate patient level data for under H0
dt.full <- dt.full%>%
  mutate( 
    p_T0 = p_C - M2,
    t.H0 = pmap(list(N_T,N_C,p_T = p_T0, p_C), .f = function(..., n.sim){
      rerun(n.sim,ni.d(...))%>%
        dplyr::bind_rows(.id = 'sim.id')
    },n.sim = n.sim))%>%
  dplyr::select(-N_T, -N_C)


# Check the simulated result
check.full <- dt.full%>%
  dplyr::mutate(c.H0 = pmap(list(t.H0, p_C, p_T, M2 = M2), check_p))%>%
  dplyr::mutate(c.H1 = pmap(list(t.H1, p_C, p_T, M2 = 0) , check_p))%>%
  dplyr::select(scenario.id, c.H0, c.H1)

saveRDS(check.full, sprintf('check_pfm_%d.rds',idx))

######################################
###### Test NI by CI approach ########
######################################

dt.full <- dt.full%>%
  mutate(FM.H0 = pmap(list(df=t.H0, M2 =  M2), FM.CI, y = y),
         FM.H1 = pmap(list(df=t.H1, M2 =  M2), FM.CI, y = y))

dt.full <- dt.full%>%
  mutate(type1.FM   = map(FM.H0,   reject.H0),
         power.FM   = map(FM.H1,   reject.H0))#%>%
  # dplyr::rename(t.GLM.H0 = t.H0, t.GLM.H1 = t.H1)%>%
  # type1_glm()%>%
  # power_glm()%>%
  # dplyr::rename(t.H0 = t.GLM.H0, t.H1 = t.GLM.H1)

# Add X with predefined cor.

rho <- 0.3

dt.full.X <- dt.full%>%
  mutate(t.H1.X = map(t.H1, .f = function(df, rho = rho){
    df%>%nest(-sim.id)%>%
      mutate(t.X = map(data,add.X))%>%
      select(-data)%>%
      unnest()
  }))%>%
  select(-t.H1)%>%
  rename(t.H1 = t.H1.X)

dt.full.X <- dt.full.X%>%
  mutate(t.H0.X = map(t.H0, .f = function(df, rho = rho){
    df%>%nest(-sim.id)%>%
      mutate(t.X = map(data,add.X))%>%
      select(-data)%>%
      unnest()
  }))%>%
  select(-t.H0)%>%
  rename(t.H0 = t.H0.X)

# Save simulation results
dt.full.sum <- dt.full%>%
  select(scenario.id, p_T, p_C, M2, alpha, power, N.total, type1.FM, power.FM)%>%
  mutate(type1.FM   = map_dbl(type1.FM  , as.numeric),
         power.FM   = map_dbl(power.FM  , as.numeric),
         n.sim = n.sim)

#saveRDS(dt.full.sum, file = sprintf('dtfullsumnmax_%02d.rds',idx))
#saveRDS(dt.full.X, file = sprintf('dtfullnmax_%02d.rds',idx))

saveRDS(dt.full.sum, file = sprintf('dtfullsumfm_%d.rds',idx))
saveRDS(dt.full.X, file = sprintf('dtfullfm_%d.rds',idx))



