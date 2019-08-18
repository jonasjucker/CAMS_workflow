# CAMS_worflow

These scripts prepare the BC and the CAMS-data
in order to run the new CLOUDRAD implementation.


The order of the scripts is the following:

1. prepare.sh
2. transfer_daint.sh
3. unpack_CAMS_fiels.sh
4. fx_add_met.sh
5. CAMS-nl_setup.sh
6. int2lm_setup.sh
7. fx_merge_grib.sh
8. transfer_kesch.sh

Additional scripts in the repository:

job: submission script for int2lm
mv_lbff_dt.sh: renames BC for experiments outside of cosmo-package
