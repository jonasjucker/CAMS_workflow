!/bin/bash

#########FOURTH SCRIPT#########

# add dummy meteorology to CAMS fields
# in order to run int2lm


function create_nl {
    
    # creates fieldextra namelist for each timestep at DATE
    
    DATE=$1
    step=$2
    name=$3
    period=$4

	time=`echo $step*60 | bc`
    cat > ./nl/nl_${DATE}/merge_${DATE}${step}.nl << end_nl

        &RunSpecification
        /

        &GlobalResource
         dictionary            = "/users/bettems/projects_kesch/fieldextra/resources/dictionary_ifs.txt",
         grib_definition_path  = "/users/bettems/projects_kesch/fieldextra/resources/eccodes_definitions_cosmo",
                                 "/users/bettems/projects_kesch/fieldextra/resources/eccodes_definitions_vendor"
         grib2_sample          = "/users/bettems/projects_kesch/fieldextra/resources/eccodes_samples/COSMO_GRIB2_default.tmpl"
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
    
    # cat tmp-fields of dummy met and aer-species into CAMS_in directory  

    DATE=$1
    step=$2
    name=$3

    cat ./met/met_${DATE}/tmp_grb/met_tmp.grb1 ./met/met_${DATE}/tmp_grb/met_tmp.grb2 ./met/met_${DATE}/tmp_grb/aer_tmp.grb2 > ./CAMS_in/CAMS_in_${DATE}/${name}
    echo cat done for: ${DATE}/${name}
}


# ****** START SCRIPT *********

period=$1

inidir=/scratch/juckerj/sandbox/lm_ifs2lm_c2e_${period}
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
        
        create_nl $DATE $step $name $period
        
        sleep 1

        /scratch/juckerj/sandbox/bin/fieldextra.exe ./nl/nl_${DATE}/merge_${DATE}${step}.nl
        
        sleep 1

        cat_fields $DATE $step $name 

        echo met added for ${DATE} at step ${step} h
    done
done

echo 'clean all nl' 

rm ./nl/nl_${date}/merge_${DATE}*.nl

echo 'done'

