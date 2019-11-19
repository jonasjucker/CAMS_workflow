#!/bin/bash

#SBATCH --job-name=fx_add_met                 
#SBATCH --output=OUTPUT                         
#SBATCH --error=stdeoJob_876.fx_add_met                                            
#SBATCH --account=s83 
#SBATCH --time=03:00:00

#########FORTH SCRIPT OF WORKFLOW#########

#########################################
#     !!!run must start at 00 UTC!!!
#########################################


function create_nl {
    
    ###create fx nl for each timestep at DATE###
    
    DATE=$1
    step=$2
    name=$3
    period=$4

	time=`echo $step*60 | bc`
    cat > ./nl/nl_${DATE}/merge_${DATE}${step}.nl << end_nl

        &RunSpecification
        /

        &GlobalResource
         dictionary            = "/users/tsm/project_escha/fieldextra/v13_1_0/resources/dictionary_ifs.txt",
         grib_definition_path  = "/users/tsm/project_escha/fieldextra/v13_1_0/resources/eccodes_definitions_cosmo",
                                 "/users/tsm/project_escha/fieldextra/v13_1_0/resources/eccodes_definitions_vendor"
         grib2_sample          = "/users/tsm/project_escha/fieldextra/v13_1_0/resources/eccodes_samples/COSMO_GRIB2_default.tmpl"
        /

        &GlobalSettings
         default_dictionary    = "ifs"
         default_model_name    = "ifs"
        /

        &ModelSpecification
         model_name            = "ifs"
         earth_axis_large      = 6371229.
         earth_axis_small      = 6371229.
        /

        &Process
          in_file = "./met/met_fields.grb"
          out_file = "./met/met_${DATE}/tmp_grb/met_tmp.grb2"
          out_type = "GRIB2",
          in_size_field=1000, 
          selection_mode= "INCLUDE_ONLY"
        /
        &Process in_field = "U", set_reference_date=${DATE}, set_leadtime=${time} /
        &Process in_field = "V", set_reference_date=${DATE}, set_leadtime=${time}/
        &Process in_field = "T", set_reference_date=${DATE}, set_leadtime=${time} /
        &Process in_field = "QV", set_reference_date=${DATE}, set_leadtime=${time}/
        &Process in_field = "LNSP", set_reference_date=${DATE}, set_leadtime=${time} /

        &Process
          in_file = "./met/met_fields.grb"
          out_file = "./met/met_${DATE}/tmp_grb/met_tmp_tmp.grb1"
          out_type = "GRIB1",
          in_size_field=1000, 
          selection_mode= "EXCLUDE"
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
        &Process in_field = "U" /
        &Process in_field = "V" /
        &Process in_field = "T" /
        &Process in_field = "QV" /
        &Process in_field = "LNSP" /

        &Process
          in_file = "./met/met_${DATE}/tmp_grb/met_tmp_tmp.grb1"
          out_file = "./met/met_${DATE}/tmp_grb/met_tmp.grb1"
          out_type = "GRIB1",
          in_size_field=1000, 
        /
        &Process in_field = "__ALL__", set_reference_date=${DATE}, set_leadtime=${time} /




        &Process
          in_file = "/scratch/juckerj/cams/${period}/${DATE}/${name}"
          out_file = "./met/met_${DATE}/tmp_grb/aer_tmp.grb2"
          out_type = "GRIB2",
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

function cat_fields {
    
    ###cat tmp-fields of dummy meteorology and ###
    ###aer-species into CAMS_in directory ### 

    DATE=$1
    step=$2
    name=$3

    cat ./met/met_${DATE}/tmp_grb/met_tmp.grb1 ./met/met_${DATE}/tmp_grb/met_tmp.grb2 ./met/met_${DATE}/tmp_grb/aer_tmp.grb2 > ./CAMS_in/CAMS_in_${DATE}/${name}
    echo cat done for: ${DATE}/${name}
}


###########START SCRIPT############

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
    days=(01 02 03 04 05 06 07 08 09 10 11 12 \
            13 14 15)
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

# period6 (1.-30-6-2019)
if [ $period = period6 ];
then    
    year=2019
    yy=19
    month=06
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
    
    ### loop over leadtime ###
    for step in `seq 0 3 80`; do
        day=`echo $step/24 | bc`
        hour=`echo $step-$day*24 | bc`
        d=`printf %02d $day`
        h=`printf %02d $hour`


        if [ $step -eq 0 ]; then
            
        name=efsf${d}${h}0000
            
        else
        
        name=efff${d}${h}0000 

        fi
        
        # create_nl for step
        create_nl $DATE $step $name $period
        
        
        # execute fx
        /scratch/juckerj/sandbox/bin/fieldextra.exe ./nl/nl_${DATE}/merge_${DATE}${step}.nl
        
        
        # cat fields
        cat_fields $DATE $step $name 

        echo met added for ${DATE} at step ${step} h
    done
done

echo 'clean all nl' 

rm ./nl/nl_${date}/merge_${DATE}*.nl

echo 'done'

