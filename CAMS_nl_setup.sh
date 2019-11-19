#!/bin/bash

#########FIFTH SCRIPT OF WORKFLOW#########

#########################################
#     !!!run must start at 00 UTC!!!
#########################################

#### create int2lm namelist for period####


period=$1

# aerosol switch for nl, default = 4
itype_aerosol=4

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
    
    # IN/Output directory of int2lm
    CAMS_in=${inidir}/CAMS_in/CAMS_in_${DATE}
    CAMS_out=${inidir}/CAMS_out/CAMS_out_${DATE}
    
    # copy external parameter
    cp ${inidir}/met/ext ${CAMS_in}/.

    # go to working directory
    cd ${inidir}/work/work_${DATE}

    # write namelist INPUT
    cat > INPUT << end_input
      &CONTRL
        lmixcld=.TRUE.,
        yinput_model='IFS',
        hincbound=3.0,
        hstart = 0.0,
        hstop=76.0,
        linitial = .true.,
        lboundaries=.true.,
        idbg_level=5,
        itype_aerosol=${itype_aerosol},
        itype_albedo=3,
        itype_ndvi=1,
        itype_t_cl=0,
        lt_cl_corr=.TRUE.,
        llake=.TRUE.,
        llake_coldstart=.TRUE.,
        lradtopo=.TRUE.,
        lsso=.FALSE.,
        luvcor=.TRUE.,
        luse_t_skin=.TRUE.,
        nincwait=30,
        nmaxwait=300,
        lprog_qi=.true.,
        lprog_qr_qs=.false.,
        lprog_rho_snow=.FALSE.,
        lmulti_layer_in=.FALSE.,
        lmulti_layer_lm=.true.,
        l_smi=.false.,
        itype_w_so_rel=1,
        lpost_0006=.TRUE.,
        lforest=.TRUE.,
        lvertwind_ini=.true.,
        lvertwind_bd=.false.,
        llbc_smooth=.true.,
        nlbc_smooth=31,
        lfilter_pp=.true.,
        lfilter_oro=.false.,
            ilow_pass_xso=5,
              lxso_first=.FALSE.,
              numfilt_xso=1,
              rxso_mask=750.0,
            norder_filter=5,
          l_topo_z=.false.,
        rfill_valley=0.0,
          ifill_valley=7,
        ltime_mean=.true.,
        lreorder=.false.,
        lasync_io=.true.,
        nprocx=1, nprocy=6, nprocio=0,
        ydate_ini='$DATE',
        ydate_bd ='$DATE',
      /
     &GRID_IN
      pcontrol_fi = 50000.,
      ie_in_tot = 264, je_in_tot = 223, ke_in_tot = 60,
      startlat_in_tot = -10.7, startlon_in_tot = -18.3,
      pollat_in = 43.0, pollon_in = -170.0,
      dlat_in = 0.1, dlon_in = 0.1,
     /
     &LMGRID
      ielm_tot=582, jelm_tot=390, kelm_tot=60,
      lanalyt_calc_t0p0=.true.,
      irefatm=1,
      ivctype=2,
      svc1=10000.0,
      svc2=2900.0,
      nfltvc=100,
      vcflat=11357.0,
      vcoord_d=22000.00, 20905.22, 19848.88, 18830.22, 17848.51,
               16903.01, 15992.98, 15117.70, 14276.42, 13468.41,
               12692.96, 11949.32, 11236.77, 10554.60,  9902.08,
               9278.48,  8683.10,  8115.21,  7574.10,  7059.07,
               6569.40,  6104.39,  5663.33,  5245.53,  4850.27,
               4476.87,  4124.63,  3792.85,  3480.86,  3187.96,
               2913.47,  2656.71,  2417.00,  2193.66,  1986.04,
               1793.45,  1615.23,  1450.72,  1299.27,  1160.22,
               1032.92,   916.73,   811.00,   715.10,   628.39,
               550.25,   480.05,   417.19,   361.04,   311.01,
               266.50,   226.91,   191.67,   160.20,   131.95,
               106.35,    82.86,    60.98,    40.18,    20.00,
               0.00,

      pollat =43.0 , pollon =-170.0 ,
      dlon=0.02 , dlat=0.02,
      startlat_tot  = -4.42,
      startlon_tot  = -6.82,
      lanalyt_calc_t0p0=.TRUE.
     /
     &DATABASE
     /
     &DATA
      yinput_type='forecast',
      l_ke_in_gds=.TRUE.,
      ie_ext=901, je_ext=901,
      ylmext_lfn='lmExtPara_901x901_0.02_globcover_aster.nc',
      ylmext_cat='./',
      ylmext_form_read='ncdf',
      yinext_lfn='ext',
      yinext_cat='./',
      yinext_form_read='apix',
      yin_cat='${CAMS_in}',
      yin_form_read='apix',
      ylm_cat='${CAMS_out}/',
      ylm_form_write='grb1',
      ncenter=215, nprocess_ini = 131, nprocess_bd = 132,
      ymode_write = 'w  ',
     /
     &PRICTR
      igp_tot = 36, 40, 48, 44, 48, 85, 77,
      jgp_tot = 30, 94, 38, 26, 26, 96, 12,
      lchkin=.TRUE., lchkout=.TRUE.,lprgp=.FALSE.,
     /

     /END
end_input
done
