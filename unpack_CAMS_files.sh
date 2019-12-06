#!/bin/bash

#########THIRD SCRIPT OF WORKFLOW#########

#########################################
#     !!!run must start at 00 UTC!!!
#########################################

# unpack and rename CAMS from mars-retrieve

period=$1

# working directory
inidir=/scratch/juckerj/cams/${period}

# set date-specific variables 
get_dates_for_periods $period

####go to working directory####

cd ${inidir}

echo '####'move to ${inidir}'####'

###### iterate over all days of period#####

for day in ${days[@]};
do
    DATE=${year}${month}${day}00
    echo ${DATE}

    # enter directory for specific day
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

        # use grib_copy
        /oprusers/owm/modules/RH7.5/grib_api/1.20.0-noomp/gnu-5.4.0/bin/grib_copy C3macc_*_${yy}-${mm}-${dd}-${hh}-${step}.grb $fout 
    done
done
