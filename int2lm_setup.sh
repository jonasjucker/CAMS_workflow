#!/bin/bash
. ./period_definitions

#########SIXTH SCRIPT OF WORKFLOW#########

#########################################
#     !!!run must start at 00 UTC!!!
#########################################

## link binaries and external fields ##


########## submits ./int2lm #########
period=$1

# working directory
inidir=/scratch/juckerj/sandbox/lm_ifs2lm_c2e_${period}

# set date-specific variables 
get_dates_for_periods $period

####go to working directory####

cd ${inidir}

echo '####'move to ${inidir}'####'

###### iterate over all days of period#####

for day in ${days[@]};
do
    DATE=${year}${month}${day}00

    # enter working directory
    cd ${inidir}/work/work_${DATE}
    
    # link binary and external parameters
    ln -s /scratch/juckerj/sandbox/bin/int2lm.exe int2lm
    ln -s /scratch/juckerj/sandbox/met/ext ext
    ln -s /scratch/juckerj/sandbox/met/lmExtPara_901x901_0.02_globcover_aster.nc lmExtPara_901x901_0.02_globcover_aster.nc
    
    # copy submit script
    cp /scratch/juckerj/sandbox/scripts/job job

####### submit job #############
    sbatch job
####### submit job ############
done
