#!/bin/bash

#SBATCH --job-name=fx_merge                 
#SBATCH --output=OUTPUT                         
#SBATCH --error=stdeoJob_876.ifs2lm                                            
#SBATCH --account=s83 
#SBATCH --time=01:00:00   

#########SEVENTH SCRIPT OF WORKFLOW#########

#########################################
#     !!!run must start at 00 UTC!!!
#########################################

function create_nl {
    
    # creates fieldextra namelist for each timestep at DATE
    
    DATE=$1
    step=$2
    name=$3
    
	time=`echo $step*60 | bc`
    cat > ./nl/nl_${DATE}/aer_${DATE}${step}.nl << end_nl

        &RunSpecification
        /

        &GlobalResource
         dictionary            = "/users/bettems/projects_kesch/fieldextra/resources/dictionary_cosmo.txt",
         grib_definition_path  = "/users/bettems/projects_kesch/fieldextra/resources/eccodes_definitions_cosmo",
                                 "/users/bettems/projects_kesch/fieldextra/resources/eccodes_definitions_vendor"
         grib2_sample          = "/users/bettems/projects_kesch/fieldextra/resources/eccodes_samples/COSMO_GRIB2_default.tmpl"
        /

        &GlobalSettings
         default_dictionary    = "cosmo"
         default_model_name    = "cosmo"
        /

        &ModelSpecification
         model_name            = "cosmo"
         earth_axis_large      = 6371229.
         earth_axis_small      = 6371229.
        /


        &Process
          in_file = "./CAMS_out/CAMS_out_${DATE}/${name}"
          out_file = "./fields_combined/fields_combined_${DATE}/aer_${DATE}_${step}"
          out_type = "GRIB1",
          in_size_field=1000, 
          selection_mode= "INCLUDE_ONLY"
        /
        &Process in_field = "AERMR01" /
        &Process in_field = "AERMR02" /
        &Process in_field = "AERMR03" /
        &Process in_field = "AERMR04" /
        &Process in_field = "AERMR05" /
        &Process in_field = "AERMR06" /
        &Process in_field = "AERMR07" /
        &Process in_field = "AERMR08" /
        &Process in_field = "AERMR09" /
        &Process in_field = "AERMR10" /
        &Process in_field = "AERMR11" /
        
        /END
        
end_nl
}


function mergeCAMS {

    ### merge CAMS and IFS into fields-combined ###

    DATE=$1
    step=$2
    name=$3
    name_ifs=$4
    yy=$5
	
    # execute fx
    /scratch/juckerj/sandbox/bin/fieldextra.exe ./nl/nl_${DATE}/aer_${DATE}${step}.nl

    # laf-case
    if [ ${name} = laf${DATE} ];
    then
        echo 'get KENDA_laf'
        cat /store/s83/owm/KENDA/ANA${yy}/det/laf${DATE}_combined ./fields_combined/fields_combined_${DATE}/aer_${DATE}_${step} > ./fields_combined/fields_combined_${DATE}/${name}
        
    # normal case
    else
        echo 'get boundary files'
	    cat ./IFS_out/IFS_out_${DATE}/${name_ifs} ./fields_combined/fields_combined_${DATE}/aer_${DATE}_${step} > ./fields_combined/fields_combined_${DATE}/${name_ifs}
	
    fi
}

############# START SCRIPT ##########

period=$1

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

    # loop over leadtime
    for step in `seq 0 3 76`; do
        day=`echo $step/24 | bc`
        hour=`echo $step-$day*24 | bc`
        d=`printf %02d $day`
        h=`printf %02d $hour`
        
        # IFS-BC shifted +6 hours
        stepshift=`echo $step+6 | bc`
        
        echo $stepshift
        
        dayshift=`echo $stepshift/24 | bc`
        hourshift=`echo $stepshift-$dayshift*24 | bc`
        dshift=`printf %02d $dayshift`
        hshift=`printf %02d $hourshift`

        # step 0
        if [ $step -eq 0 ]; then
            
            create_nl $DATE $step laf$DATE 
            
            mergeCAMS $DATE $step laf$DATE dummy_name $yy
        fi
        
        # normal case
        create_nl $DATE $step lbff${d}${h}0000
        
        mergeCAMS $DATE $step lbff${d}${h}0000 lbff${dshift}${hshift}0000 $yy
    done

    echo 'merge done -> start adding RSMIN EMIS_RAD SST_STDH'

    fxclone --reference_date=${DATE} --force -o laf${DATE}_SSO_STDH /scratch/juckerj/sandbox/met/laf2019070512

    
    cat fields_combined/fields_combined_${DATE}/laf${DATE} laf${DATE}_SSO_STDH > fields_combined/fields_combined_${DATE}/laf${DATE}_tmp


    mv fields_combined/fields_combined_${DATE}/laf${DATE}_tmp fields_combined/fields_combined_${DATE}/laf${DATE}

    rm laf${DATE}_SSO_STDH
    echo 'adding of RSMIN EMIS_RAD SSO_STDH done '
done
