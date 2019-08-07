#!/bin/bash

#########THIRD SCRIPT OF WORKFLOW#########

#########################################
#     !!!run must start at 00 UTC!!!
#########################################

# unpack and rename CAMS from mars-retrieve

period=$1

# working directory
inidir=/scratch/juckerj/cams/${period}



###########define periods###############

# period1 (13.-20.2 2019)
if [ $period = period1 ];
then
    year=2019
    yy=19
    month=02
    days=(13 14 15 16 17 18 19 20)
fi

# period2 (23.-29.6 2019)
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

    # enter specific day
    cd ${inidir}/${DATE}
    
    # rename due to other fienames from mars-retrieve
    yy=${year}
    mm=${month}
    dd=${day}
    hh='00'

    ### iterate over leadtime ###
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
    done
done
