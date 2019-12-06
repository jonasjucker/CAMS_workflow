#!/bin/bash

#SBATCH --job-name=transfer_kesch                 
#SBATCH --output=OUTPUT                         
#SBATCH --error=stdeoJob_876.transfer_kesch                                            
#SBATCH --account=s83 
#SBATCH --time=03:00:00

#########EIGTH SCRIPT OF WORKFLOW#########

#########################################
#     !!!run must start at 00 UTC!!!
#########################################


#######copy prepared data from kesch back to daint#####

if [ "$#" -eq 2 ]; then
    period=$1
    exp=$2
else
    echo Enter period, enter exp!
    exit
fi

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
    
    # special case for period3 (1.12)
    if [ $day = 01 ];
    then
        echo *****************CAUTION******************
        echo special case for months following months 
        echo with 31 days activ! For months with less 
        echo days please change day in this if-condition.
        day=31
        dd=`printf %02d $day`
        monthd=`echo $month-1 | bc`
        mm=`printf %02d $monthd`
    
    # normal cases
    else
        day=`echo $day-1 | bc`
        dd=`printf %02d $day`
        mm=`printf %02d $month`
    
    fi
    #### copy laf ######
    # scp -v ${inidir}/fields_combined/fields_combined_${DATE}/laf${DATE} daint:/scratch/snx3000/juckerj/cache/${exp}/LA_RING_assml/coarse/.


    ### copy BC #######
     scp -v ${inidir}/fields_combined/fields_combined_${DATE}/lbff* daint:/scratch/snx3000/juckerj/cache/${exp}/LBC_RING_intpl/coarse/${yy}${mm}${dd}18/.

done


