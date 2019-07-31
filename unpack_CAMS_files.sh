#!/bin/bash

#########THIRD SCRIPT#########


# ****** run must start at 00 UTC *********

# unpack and rename CAMS from mars-retrieve

period=$1

inidir=/scratch/juckerj/cams/${period}
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
    cd ${inidir}/${DATE}
    yy=${year}
    mm=${month}
    dd=${day}
    hh='00'
    for step in `seq 0 3 80`; do

        tar xzf C3macc_${yy}-${mm}-${dd}-${hh}-${step}.tar.gz
        rm -f C3macc_${yy}-${mm}-${dd}-${hh}-${step}.tar.gz

        if [ $step -eq 0 ]; then
            fout=efsf00000000
        else
            day=`echo $step/24 | bc`
            hour=`echo $step-$day*24 | bc`
            d=`printf %02d $day`
            h=`printf %02d $hour`
            fout=efff${d}${h}0000
        fi

        grib_copy C3macc_*_${yy}-${mm}-${dd}-${hh}-${step}.grb $fout 
        #rm -f C3macc_*_${yy}-${mm}-${dd}-${hh}-${step}.grb
    done
done
