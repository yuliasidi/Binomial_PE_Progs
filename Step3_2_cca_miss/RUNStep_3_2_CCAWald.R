library(condor)
source('Step_0_init.R')


# generate condor files for all the scenarios
scenarios <- expand.grid(
  MISSING=c('mcar','mar1','mar2','mar3','mar4','mar5','mar6','mnar1','mnar2'),
  PERCENT=sprintf('%02d',seq(5,25,5)),
  TYPE=c('waldxp80')
  #TYPE=c('wald','waldxm30','waldxmm','waldxp80')
  ,stringsAsFactors = FALSE)
 
scenarios_list <- as.list(scenarios)

app_temp <- function(TYPE,MISSING,PERCENT){
  
  build_template(
    file = sprintf('step_3_2_type_%s_missing_%s_percent_%s.R',TYPE,MISSING,PERCENT),
    args = c('$(Process)'),
    tag = sprintf('%s_%s_%s',TYPE,MISSING,PERCENT),
    jobs = 30,
    init_dir = 'jobs/run',
    template_file = sprintf('Step3_2_cca_miss/wald/step_3_2_type_%s_missing_%s_percent_%s.condor',TYPE,MISSING,PERCENT),
    input_files = c('../myfiles/lib/','Step_0_init.R', 'PE_Bin_PD_Functions.R',
                    sprintf('../savedata/dt%s%s%s_$(Process).rds',TYPE, MISSING, PERCENT)),
    job_type = 'short')
}


purrr::pwalk(scenarios_list, app_temp)



library(ssh)

session <- ssh_connect(Sys.getenv('UCONN_USER'))

scenarios1 <- scenarios%>%
  dplyr::mutate(fnameR = 
                  sprintf('Step3_2_cca_miss/wald/step_3_2_type_%s_missing_%s_percent_%s.R',TYPE,MISSING,PERCENT),
                fnameC = 
                  sprintf('Step3_2_cca_miss/wald/step_3_2_type_%s_missing_%s_percent_%s.condor',TYPE,MISSING,PERCENT),
                fnameC.submit = 
                  sprintf('step_3_2_type_%s_missing_%s_percent_%s.condor',TYPE,MISSING,PERCENT))

fname.listR <- as.vector(scenarios1$fnameR)
fname.listC <- as.vector(scenarios1$fnameC)
fname.listC.submit <- as.vector(scenarios1$fnameC.submit)


ssh::scp_upload(session,
                files = fname.listR,
                to = '~')
ssh::scp_upload(session,
                files = fname.listC,
                to = '~')


condor::create_dirs(session, file = 'Step3_2_cca_miss/wald/step_3_2_type_waldxp80_missing_mnar1_percent_25.condor')

ssh::scp_upload(session,
                files = c('Step_0_init.R','PE_Bin_PD_Functions.R'),
                to = '~/jobs/run'
)

c.submit <- function(i){
  condor::condor_submit(session,fname.listC.submit[i],sleeptime='5m')  
}

#Run only wald rho=0.3
#purrr::walk(seq(1,45,1), c.submit)

#Run only wald rho=-0.3
#purrr::walk(seq(1,45,1), c.submit)

#Run only wald rho=max
purrr::walk(seq(1,45,1), c.submit)



condor::condor_q(session)

#my laptop
#dir.create('example/output/data',recursive = TRUE)

condor::pull(session,
             from = c('jobs/run/err'),
             to = c('output'))

condor::read_errs()

condor::pull(session,
             from = c('jobs/run/cca*'),
             to = c('output/data'))

# MOVE DATAFILES YOU WANT TO SAFE
#ssh::ssh_exec_wait(session, 'mv jobs/run/dt*.rds jobs/savedata')


scenarios.cca <- scenarios%>%
  mutate(ANAL = 'cca')

scenarios.cca_wald <- as.list(scenarios.cca)
#cca_waldp30 <- purrr::pmap_df(scenarios.cca_waldp30, read_anal)
#cca_waldm30 <- purrr::pmap_df(scenarios.cca_wald, read_anal)
cca_waldpp <- purrr::pmap_df(scenarios.cca_wald, read_anal)

#saveRDS(cca_waldp30,"DataSummaries/cca_waldp30.rds")
#saveRDS(cca_waldm30,"DataSummaries/cca_waldm30.rds")
saveRDS(cca_waldpp,"DataSummaries/cca_waldpp.rds")

#condor::cleanup_local(dir = 'output',tag = 'fm')
#condor::cleanup_local(dir = 'output',tag = 'wn')
condor::cleanup_local(dir = 'output',tag = 'cca')

condor::cleanup_remote(session)

ssh::ssh_disconnect(session)

