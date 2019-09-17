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

# period5 (1.-30.4. 2019)
if [ $period = period5 ];
then    
    year=2019
    yy=19
    month=04
    days=(01 02 03 04 05 06 07 08 09 \
          10 11 12 13 14 15 16 17 18 19 \
          20 21 22 23 24 25 26 27 28 29 30)
fi
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
        day=30
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
    scp -v ${inidir}/fields_combined/fields_combined_${DATE}/laf${DATE} daint:/scratch/snx3000/juckerj/cache/${exp}/LA_RING_assml/coarse/.


    ### copy BC #######
    scp -v ${inidir}/fields_combined/fields_combined_${DATE}/lbff* daint:/scratch/snx3000/juckerj/cache/${exp}/LBC_RING_intpl/coarse/${yy}${mm}${dd}18/.

done


