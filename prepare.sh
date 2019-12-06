#!/bin/bash
. ./period_definitions

#########FIRST SCRIPT OF WORKFLOW#########

#########################################
#     !!!run must start at 00 UTC!!!
#########################################

#    prepare directories for 
#    period passed as argument


period=$1

# working directory
inidir=/scratch/juckerj/sandbox/lm_ifs2lm_c2e_${period}

# set date-specific variables 
get_dates_for_periods $period

###### iterate over all days of period#####

for day in ${days[@]};
do
    DATE=${year}${month}${day}00

    # create all directories
    mkdir -p ${inidir}/IFS_in/IFS_in_${DATE}
    mkdir -p ${inidir}/IFS_out/IFS_out_${DATE}

    mkdir -p ${inidir}/CAMS_in/CAMS_in_${DATE}
    mkdir -p ${inidir}/CAMS_out/CAMS_out_${DATE}

    mkdir -p ${inidir}/fields_combined/fields_combined_${DATE}
    mkdir -p ${inidir}/nl/nl_${DATE}

    
    mkdir -p ${inidir}/work/work_${DATE}

    mkdir -p ${inidir}/met/met_${DATE}
    mkdir -p ${inidir}/met/met_${DATE}/tmp_grb

    # copy dummy-meteorlogy
    cp /scratch/juckerj/sandbox/met/* ${inidir}/met/.
done

