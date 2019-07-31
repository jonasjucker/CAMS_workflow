#!/bin/bash

#########SIXTH SCRIPT OF WORKFLOW#########

#########################################
#     !!!run must start at 00 UTC!!!
#########################################

## link binaries and external fields ##


########## submits ./int2lm #########
period=$1

# working directory
inidir=/scratch/juckerj/sandbox/lm_ifs2lm_c2e_${period}



###########define periods###############

# period1 (13.-20.2 2019)
if [ $period = period1 ];
then
    year=2019
    yy=19
    month=02
    days=(13 14 15 16 17 18 19 20)
fi

# period2 (23.-29.2 2019)
if [ $period = period2 ];
then
    year=2019
    yy=19
    month=06
    days=(23 24 25 26 27 28 29)
fi

# period3 (1.-7.12 2018)
if [ $period = period3 ];
then    
    year=2018
    yy=18
    month=12
    days=(01 02 03 04 05 06 07)
fi

# period4 (6.-13.6. 2018)
if [ $period = period4 ];
then    
    year=2018
    yy=18
    month=06
    days=(06 07 08 09 10 11 12)
fi

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
