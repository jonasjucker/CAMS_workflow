#!/bin/bash
########## move BC - dt#################

# run inside BC-folder from COSMO-sandbox

########################################

if [ "$#" -eq 2 ]; then
    dt=$1
    leadtime=$2
else
    echo Enter dt in h, enter leadtime in h!
    exit
fi


for step in `seq 0 3 ${leadtime}`; do
    day=`echo $step/24 | bc`
    hour=`echo $step-$day*24 | bc`
    d=`printf %02d $day`
    h=`printf %02d $hour`
    
    stepshift=`echo $step+$dt | bc`
    # shift time for ifs-boundary for dt
    dayshift=`echo $stepshift/24 | bc`
    hourshift=`echo $stepshift-$dayshift*24 | bc`
    dshift=`printf %02d $dayshift`
    hshift=`printf %02d $hourshift`

    
    mv  lbff${dshift}${hshift}0000 lbff${d}${h}0000
    echo lbff${dshift}${hshift}0000 moved to lbff${d}${h}0000! 
done
