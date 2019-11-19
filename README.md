# CAMS_worflow

This repo provides the scripts to prepare the BC containing the CAMS-aerosol fields
necessary for the CLOUDRAD-radiation scheme.

In case of problems or questions regarding the workflow please contact
Jonas Jucker: joni.jucker@yahoo.de


Overview

Due to the long time needed for the MARS-retrieve from ECMWF, we only request the 11 aerosol-species
from the CAMS model run.
We then add a dummy meteorology to these 11 aerosol-fields in order to process it with the int2lm-software.
After the interpolation in int2lm, the 11 aerosol-fields are extracted and concatenated with
the true BC from IFS.

The IFS grib files contain grib1 and grib2 fields in one single grib file, what cannot be processed by fieldextra.

REMARK: The scripts were only tested for model runs starting at 00 UTC!

Short description in order of execution

prepare.sh:
create all directories for the other scripts

transfer_daint.sh:
transfer the interpolated BC from IFS from daint to kesch

unpack_CAMS_files.sh:
unpack all CAMS aerosol-fields from .tar and rename them.
Use of software "grib-copy"

fx_add_met.sh:
add dummy meteorology to 11 aerosol-fields, bit complicated because
IFS BC contain grib1 and grib2 fields, which cannot be processed by fieldextra at the same time.
Therefore grib1 and grib2 fields are extracted from dummy meteorology separately and the concatenated
into one mixed grib file (CAMS-aerosols, dummy-met(grib1), dummy-met(grib2)).

CAMS-nl_setup.sh:
create int2lm-namelist for each day in period in a seperate working directory.

int2lm_setup.sh:
link int2lm executable, external parameters and other stuff needed for int2lm.
submit int2lm on kesch

fx_merge_grib.sh:
extract 11 aerosol-fields from int2lm interpolation with dummy meteorology.
Concatenate these fields with analysis from KENDA and BC from IFS.
As COSMO-ORG is used, the fields RSMIN EMIS_RAD and SST_STDH are added too.

transfer_kesch.sh:
Transfer the analysis and BC from Kesch back to daint into "cache"
as required from the cosmo-package.

Other scripts

job:
script to submit int2lm on kesch (used as a template in int2lm_setup.sh)

mv_lbff_dt.sh:
shift name of BC for a certain dt and leadtime, as BC f rom IFS 
are usually -6h from COSMO-run at MeteoSwiss. Used for sandbox experiments
on Kesch. Cosmo-Package does this shift automatically.



NOT IN THIS REPO:   SCRIPT FOR MARS-RETRIEVE AT ECMWF
