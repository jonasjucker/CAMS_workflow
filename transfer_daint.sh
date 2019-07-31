#!/bin/bash

#########SECOND SCRIPT#########


# ****** run must start at 00 UTC *********

# get BC from daint (cosmo-package)


period=$1

inidir=/scratch/juckerj/sandbox/lm_ifs2lm_c2e_${period}
cd ${inidir}
echo move to ${inidir}

# period1
if [ $period = period1 ];
then
    year=2019
    yy=19
    month=02
    days=(13 14 15 16 17 18 19 20)
fi

# period2
if [ $period = period2 ];
then
    year=2019
    yy=19
    month=06
    days=(23 24 25 26 27 28 29)
fi

# period3
if [ $period = period3 ];
then    
    year=2018
    yy=18
    month=12
    days=(01 02 03 04 05 06 07)
fi

# period4
if [ $period = period4 ];
then    
    year=2018
    yy=18
    month=06
    days=(06 07 08 09 10 11 12)
fi

for day in ${days[@]};
do
    DATE=${year}${month}${day}00
    if [ $day = 01 ];
    then
        day=30
        dd=`printf %02d $day`
        monthd=`echo $month-1 | bc`
        mm=`printf %02d $monthd`
    else
        day=`echo $day-1 | bc`
        dd=`printf %02d $day`
        mm=`printf %02d $month`

    fi
    
    scp -v daint:/scratch/snx3000/juckerj/wd/${yy}${mm}${dd}18_H2C/int2lm_out/* ${inidir}/IFS_out/IFS_out_${DATE}/.
done
