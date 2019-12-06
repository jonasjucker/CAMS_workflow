#!/bin/bash

#SBATCH --job-name=transfer_daint                 
#SBATCH --output=OUTPUT                         
#SBATCH --error=stdeoJob_876.transfer_daint
#SBATCH --account=s83 
#SBATCH --time=03:00:00

#########SECOND SCRIPT OF WORKFLOW#########

#########################################
#     !!!run must start at 00 UTC!!!
#########################################


#######get int2lm data from daint#####

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

    #### copy data from int2lm from daint ######
    scp -v daint:/scratch/snx3000/juckerj/wd/${yy}${mm}${dd}18_H2C/int2lm_out/* ${inidir}/IFS_out/IFS_out_${DATE}/.
done
