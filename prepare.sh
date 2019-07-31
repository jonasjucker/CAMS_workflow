#!/bin/bash

#########FIRST SCRIPT#########

##############################
# run must be at 00 UTC
#############################

# prepares folders and directories
# for the specified period 1-4



period=$1

inidir=/scratch/juckerj/sandbox/lm_ifs2lm_c2e_${period}


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

    mkdir -p ${inidir}/IFS_in/IFS_in_${DATE}
    mkdir -p ${inidir}/IFS_out/IFS_out_${DATE}

    mkdir -p ${inidir}/CAMS_in/CAMS_in_${DATE}
    mkdir -p ${inidir}/CAMS_out/CAMS_out_${DATE}

    mkdir -p ${inidir}/fields_combined/fields_combined_${DATE}
    mkdir -p ${inidir}/nl/nl_${DATE}

    
    mkdir -p ${inidir}/work/work_${DATE}

    mkdir -p ${inidir}/met/met_${DATE}
    mkdir -p ${inidir}/met/met_${DATE}/tmp_grb

    cp /scratch/juckerj/sandbox/met/* ${inidir}/met/.
done

