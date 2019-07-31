#!/bin/bash

#########FIFTH SCRIPT#########

# ****** run must start at 00 UTC *********

# link binaries and external fields
# submits ./int2lm
period=$1


inidir=/scratch/juckerj/sandbox/lm_ifs2lm_c2e_${period}

cd ${inidir}

echo move to ${inidir}

# period1
if [ $period = period1 ];
then
    year=2019
    month=02
    days=(13 14 15 16 17 18 19 20)
fi

# period2
if [ $period = period2 ];
then
    year=2019
    month=06
    days=(23 24 25 26 27 28 29)
fi

# period3
if [ $period = period3 ];
then    
    year=2018
    month=12
    days=(01 02 03 04 05 06 07)
fi

# period4
if [ $period = period4 ];
then    
    year=2018
    month=06
    days=(06 07 08 09 10 11 12)
fi

for day in ${days[@]};
do
    DATE=${year}${month}${day}00



    cd ${inidir}/work/work_${DATE}
    
    ln -s /scratch/juckerj/sandbox/bin/int2lm.exe int2lm
    ln -s /scratch/juckerj/sandbox/met/ext ext
    ln -s /scratch/juckerj/sandbox/met/lmExtPara_901x901_0.02_globcover_aster.nc lmExtPara_901x901_0.02_globcover_aster.nc

    cp /scratch/juckerj/sandbox/scripts/job job

############################
# submit job

    sbatch job

done
