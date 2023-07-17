#! /bin/csh -f

#------------------------------------------------------------------------------
# Get variables from Case XML-files
#------------------------------------------------------------------------------

set CASEROOT = `./xmlquery CASEROOT --value`
set OCN_GRID = `./xmlquery OCN_GRID --value`
set BLOM_VCOORD = `./xmlquery BLOM_VCOORD --value`
set BLOM_UNIT = `./xmlquery BLOM_UNIT --value`
set DIN_LOC_ROOT = `./xmlquery  DIN_LOC_ROOT --value`
set RUN_TYPE = `./xmlquery RUN_TYPE --value`
set CONTINUE_RUN = `./xmlquery CONTINUE_RUN --value`
set CASEBUILD = `./xmlquery CASEBUILD --value`
set CCSM_CO2_PPMV = `./xmlquery CCSM_CO2_PPMV --value`
set OCN_NCPL = `./xmlquery OCN_NCPL --value`
set BLOM_COUPLING = `./xmlquery BLOM_COUPLING --value`
set RUNDIR = `./xmlquery RUNDIR --value`
set BLOM_TRACER_MODULES = `./xmlquery BLOM_TRACER_MODULES --value`
set BLOM_RIVER_NUTRIENTS = `./xmlquery BLOM_RIVER_NUTRIENTS --value`
set BLOM_N_DEPOSITION = `./xmlquery BLOM_N_DEPOSITION --value`
set BLOM_NDEP_SCENARIO = `./xmlquery BLOM_NDEP_SCENARIO --value`
set HAMOCC_VSLS = `./xmlquery HAMOCC_VSLS --value`
set HAMOCC_CISO = `./xmlquery HAMOCC_CISO --value`
set HAMOCC_SEDSPINUP = `./xmlquery HAMOCC_SEDSPINUP --value`
set HAMOCC_SEDSPINUP_YR_START = `./xmlquery HAMOCC_SEDSPINUP_YR_START --value`
set HAMOCC_SEDSPINUP_YR_END = `./xmlquery HAMOCC_SEDSPINUP_YR_END --value`
set HAMOCC_SEDSPINUP_NCYCLE = `./xmlquery HAMOCC_SEDSPINUP_NCYCLE --value`
set RUN_STARTDATE = `./xmlquery RUN_STARTDATE --value`
set PIO_TYPENAME_OCN = `./xmlquery PIO_TYPENAME_OCN --value`
set PIO_NETCDF_FORMAT_OCN = `./xmlquery PIO_NETCDF_FORMAT_OCN --value`
set NINST_OCN = `./xmlquery NINST_OCN --value`
set TEST=`./xmlquery TEST --value`

#------------------------------------------------------------------------------
# Check if HAMOCC is requested
#------------------------------------------------------------------------------

set ecosys = FALSE
set tracers = (`echo $BLOM_TRACER_MODULES`)
if ($#tracers != 0) then
  foreach module ($tracers)
    if ($module == ecosys) then
      set ecosys = TRUE
    endif
  end
endif

#------------------------------------------------------------------------------
# Set RUN_TYPE to 'continue' if CONTINUE_RUN equals TRUE
#------------------------------------------------------------------------------

if ("$CONTINUE_RUN" == TRUE) then
  set RUN_TYPE = continue
endif

#------------------------------------------------------------------------------
# Get start date
#------------------------------------------------------------------------------

set YEAR0   = `echo $RUN_STARTDATE | cut -c1-4 `
set MONTH0  = `echo $RUN_STARTDATE | cut -c6-7 `
set DAY0    = `echo $RUN_STARTDATE | cut -c9-10`

#------------------------------------------------------------------------------
# Set namelist variables
#------------------------------------------------------------------------------

#------------------------------
# set LIMITS defaults
#------------------------------
set NDAY1    = 0
set NDAY2    = 0
set IDATE    = $YEAR0$MONTH0$DAY0
set IDATE0   = $YEAR0$MONTH0$DAY0
set RUNID    = "'unset'"
set EXPCNF   = "'cesm'"
set RUNTYP   = "'$RUN_TYPE'"
set GRFILE   = "'unset'"
set ICFILE   = "'unset'"
if ("$BLOM_UNIT" == cgs) then
  set PREF     = 2000.e5
else
  set PREF     = 2000.e4
endif
set BACLIN   = 1800.
set BATROP   = 36.
if ("$BLOM_UNIT" == cgs) then
  set MDV2HI   = 2.
  set MDV2LO   = .4
  set MDV4HI   = 0.
  set MDV4LO   = 0.
  set MDC2HI   = 5000.e4
  set MDC2LO   = 300.e4
else
  set MDV2HI   = .02
  set MDV2LO   = .004
  set MDV4HI   = 0.
  set MDV4LO   = 0.
  set MDC2HI   = 5000.
  set MDC2LO   = 300.
endif
set VSC2HI   = .5
set VSC2LO   = .5
set VSC4HI   = 0.
set VSC4LO   = 0.
if ("$BLOM_UNIT" == cgs) then
  set CBAR     = 5.
else
  set CBAR     = .05
endif
set CB       = .002
set CWBDTS   = 5.e-5
set CWBDLS   = 25.
set MOMMTH   = "'enscon'"
set BMCMTH   = "'uc'"
set RMPMTH   = "'eitvel'"
set MLRTTP   = "'constant'"
set RM0      = 1.2
set RM5      = 0.
set CE       = .06
set TDFILE   = "'unset'"
set NIWGF    = 0.
set NIWBF    = .35
set NIWLF    = .5
set SWAMTH   = "'jerlov'"
set JWTYPE   = 3
set CHLOPT   = "'climatology'"
set CCFILE   = "'unset'"
set TRXDAY   = 0.
set SRXDAY   = 0.
set TRXDPT   = 1.
set SRXDPT   = 1.
set TRXLIM   = 1.5
set SRXLIM   = .5
set APTFLX   = .false.
set APSFLX   = .false.
set DITFLX   = .false.
set DISFLX   = .false.
set SRXBAL   = .false.
set SCFILE   = "'unset'"
set WAVSRC   = "'none'"
set SMTFRC   = .true.
set SPRFAC   = .false.
set ATM_PATH = "'unset'"
set ITEST    = 60
set JTEST    = 60
set CNSVDI   = .false.
set CSDIAG   = .false.
set RSTFRQ   =  1
if ("$PIO_NETCDF_FORMAT_OCN" == 64bit_offset) then
  set RSTFMT   =  1
else
  set RSTFMT   =  0
endif
set RSTCMP   =  0 
if ("$PIO_TYPENAME_OCN" == pnetcdf) then
  set IOTYPE =  1 
else
  set IOTYPE =  0 
endif

#------------------------------
# set VCOORD defaults
#------------------------------
set VCOORD_TYPE            = "'$BLOM_VCOORD'"
set RECONSTRUCTION_METHOD  = "'ppm'"
set DENSITY_LIMITING       = "'monotonic'"
set TRACER_LIMITING        = "'non_oscillatory'"
set VELOCITY_LIMITING      = "'non_oscillatory'"
set DENSITY_PC_UPPER_BNDR  = .false.
set DENSITY_PC_LOWER_BNDR  = .false.
set TRACER_PC_UPPER_BNDR   = .true.
set TRACER_PC_LOWER_BNDR   = .false.
set VELOCITY_PC_UPPER_BNDR = .true.
set VELOCITY_PC_LOWER_BNDR = .false.
set DPMIN_SURFACE          = 2.5
set DPMIN_INFLATION_FACTOR = 1.08
set DPMIN_INTERIOR         = .1
set DKTZU                  = 4
set DKTZL                  = 1

#------------------------------
# set DIFFUSION defaults
#------------------------------
set EITMTH   = "'gm'"
set EDRITP   = "'large scale'"
set EDWMTH   = "'smooth'"
set EDDF2D   = .false.
set EDSPRS   = .true.
set EGC      = 0.85
set EGGAM    = 200.
if ("$BLOM_UNIT" == cgs) then
  set EGLSMN   = 4000.e2
  set EGMNDF   = 100.e4
  set EGMXDF   = 1500.e4
else
  set EGLSMN   = 4000.
  set EGMNDF   = 100.
  set EGMXDF   = 1500.
endif
set EGIDFQ   = 1.
set TBFILE   = "'unset'"
set RHISCF   = 0.
set EDANIS   = .false.
set REDI3D   = .false.
set RHSCTP   = .false.
set RI0      = 1.2
set BDMTYP   = 2
if ("$BLOM_UNIT" == cgs) then
  set BDMC1    = 5.e-4
  set BDMC2    = .1
else
  set BDMC1    = 5.e-8
  set BDMC2    = 1.e-5
endif
set TKEPF    = .006
set SMOBLD   = .true.
set LNGMTP   = "'none'"
if ("$BLOM_VCOORD" == isopyc_bulkml) then
  set BDMLDP   = .true.
  set LTEDTP   = "'layer'"
else
  set BDMLDP   = .false.
  set LTEDTP   = "'neutral'"
endif

#------------------------------
# set BGCNML defaults
#------------------------------
set ATM_CO2  = "$CCSM_CO2_PPMV"
if ("$BLOM_RIVER_NUTRIENTS" == TRUE) then
  set DO_RIVINPT = .true.
else
  set DO_RIVINPT = .false.
endif
if ("$BLOM_N_DEPOSITION" == TRUE) then
  set DO_NDEP   = .true.
  if(      "$BLOM_NDEP_SCENARIO" == 1850 && "$OCN_GRID" == tnx2v1) then
    set NDEPFNAME = ndep_1850_CMIP6_tnx2v1_20180321.nc
  else if( "$BLOM_NDEP_SCENARIO" == 1850 && "$OCN_GRID" == tnx1v4) then
    set NDEPFNAME = ndep_1850_CMIP6_tnx1v4_20171106.nc
  else if( "$BLOM_NDEP_SCENARIO" == 1850 && "$OCN_GRID" == tnx0.25v4) then
    set NDEPFNAME = ndep_1850_CMIP6_tnx0.25v4_20190912.nc
  else if( "$BLOM_NDEP_SCENARIO" == 1850 && "$OCN_GRID" == tnx0.125v4) then
    set NDEPFNAME = ndep_1850_CMIP6_tnx0.125v4_20221013.nc
  else if( "$BLOM_NDEP_SCENARIO" == 2000 && "$OCN_GRID" == tnx2v1) then
    set NDEPFNAME = ndep_2000_CMIP6_tnx2v1_20200826.nc
  else if( "$BLOM_NDEP_SCENARIO" == 2000 && "$OCN_GRID" == tnx1v4) then
    set NDEPFNAME = ndep_2000_CMIP6_tnx1v4_20200826.nc
  else if( "$BLOM_NDEP_SCENARIO" == 2000 && "$OCN_GRID" == tnx0.25v4) then
    set NDEPFNAME = ndep_2000_CMIP6_tnx0.25v4_20200826.nc
  else if( "$BLOM_NDEP_SCENARIO" == hist && "$OCN_GRID" == tnx2v1) then
    set NDEPFNAME = ndep_185001-201412_tnx2v1_20190702.nc
  else if( "$BLOM_NDEP_SCENARIO" == hist && "$OCN_GRID" == tnx1v4) then
    set NDEPFNAME = ndep_185001-201412_tnx1v4_20180613.nc
  else if( "$BLOM_NDEP_SCENARIO" == hist && "$OCN_GRID" == tnx0.25v4) then
    set NDEPFNAME = ndep_185001-201412_tnx0.25v4_20190705.nc
  else if( `echo $BLOM_NDEP_SCENARIO | cut -c1-3` == ssp && "$OCN_GRID" == tnx1v4) then
    set NDEPFNAME = ndep_201501-210012-${BLOM_NDEP_SCENARIO}_tnx1v4_20191112.nc
  else if( "$BLOM_NDEP_SCENARIO" == UNSET ) then
    set DO_NDEP   = .false.
    set NDEPFNAME = "''"
  endif
else
  set DO_NDEP   = .false.
  set NDEPFNAME = "''"
endif
if ("$HAMOCC_SEDSPINUP" == TRUE) then
  set DO_SEDSPINUP = .true.
  set SEDSPIN_YR_S = $HAMOCC_SEDSPINUP_YR_START
  set SEDSPIN_YR_E = $HAMOCC_SEDSPINUP_YR_END
  set SEDSPIN_NCYC = $HAMOCC_SEDSPINUP_NCYCLE
else
  set DO_SEDSPINUP = .false.
  set SEDSPIN_YR_S = -1
  set SEDSPIN_YR_E = -1
  set SEDSPIN_NCYC = -1
endif
# VSLS is currently only available for the tnx1v4 grid, since a climatlogy file for 
# short wave radiation is needed. 
if ("$HAMOCC_VSLS" == TRUE && "$OCN_GRID" != tnx1v4) then
  echo "$0 ERROR: HAMOCC_VSLS == TRUE not possible with this grid resolution (no swa-climatology available) "
  exit -1
endif
# For the following options, there are currently no switches in Case-XML files.
# These options can be activated by expert users via user namelist.
set DO_OALK = .false.
set BGCOAFX_OALKSCEN = "''"
set BGCOAFX_OALKFILE = "''"
set BGCOAFX_ADDALK    = 0.135
set BGCOAFX_CDRMIP_LATMAX = 70.0
set BGCOAFX_CDRMIP_LATMIN = -60.0
set BGCOAFX_RAMP_START    = 2025
set BGCOAFX_RAMP_END      = 2035
set WITH_DMSPH = .false.
set PI_PH_FILE = "''"
set L_3DVARSEDPOR = .false.
set SEDPORFILE = "''"


#------------------------------
# set DIAPHY defaults 
#------------------------------
set GLB_FNAMETAG = "'hd','hm','hy'"  
set GLB_AVEPERIO =  '1,  30, 365'
if ("$TEST" == TRUE) then
   set GLB_FILEFREQ =  '1,  30, 365'
else
   set GLB_FILEFREQ = '30,  30, 365'
endif
set GLB_COMPFLAG =  '0,   0,   0'
if ("$PIO_NETCDF_FORMAT_OCN" == 64bit_offset) then
  set GLB_NCFORMAT =  '1,   1,   1'
else
  set GLB_NCFORMAT =  '0,   0,   0'
endif
set H2D_ABSWND   =  '0,   4,   0'

set H2D_ALB      =  '0,   0,   0'

set H2D_BTMSTR   =  '0,   4,   0'
set H2D_BRNFLX   =  '0,   4,   0'
set H2D_BRNPD    =  '0,   4,   0'

set H2D_DFL      =  '0,   0,   0'

set H2D_EVA      =  '0,   4,   0'
set H2D_FICE     =  '0,   4,   0'
set H2D_FMLTFZ   =  '0,   4,   0'

set H2D_HICE     =  '0,   0,   0'

set H2D_HMLTFZ   =  '0,   4,   0'

set H2D_HSNW     =  '0,   0,   0'
set H2D_IAGE     =  '0,   0,   0'

set H2D_IDKEDT   =  '0,   4,   0'
set H2D_LAMULT   =  '0,   4,   0'
set H2D_LASL     =  '0,   4,   0'
set H2D_LIP      =  '0,   4,   0'

set H2D_MAXMLD   =  '4,   4,   0'

set H2D_MLD      =  '0,   4,   0'

set H2D_MLTS     =  '4,   4,   0'

set H2D_MLTSMN   =  '0,   4,   0'
set H2D_MLTSMX   =  '0,   4,   0'
set H2D_MLTSSQ   =  '0,   4,   0'
set H2D_MTKEUS   =  '0,   4,   0'
set H2D_MTKENI   =  '0,   4,   0'
set H2D_MTKEBF   =  '0,   4,   0'
set H2D_MTKERS   =  '0,   4,   0'
set H2D_MTKEPE   =  '0,   4,   0'
set H2D_MTKEKE   =  '0,   4,   0'
set H2D_MTY      =  '0,   4,   0'
set H2D_NSF      =  '0,   4,   0'
set H2D_PBOT     =  '0,   4,   0'
set H2D_PSRF     =  '0,   4,   0'
set H2D_RFIFLX   =  '0,   4,   0'
set H2D_RNFFLX   =  '0,   4,   0'
set H2D_SALFLX   =  '0,   4,   0'
set H2D_SALRLX   =  '0,   4,   0'
set H2D_SBOT     =  '0,   4,   0'

set H2D_SEALV    =  '4,   4,   0'

set H2D_SLVSQ    =  '0,   4,   0'
set H2D_SFL      =  '0,   4,   0'
set H2D_SOP      =  '0,   4,   0'
set H2D_SIGMX    =  '0,   4,   0'

set H2D_SSS      =  '4,   4,   0'
set H2D_SSSSQ    =  '4,   4,   0'
set H2D_SST      =  '4,   4,   0'
set H2D_SSTSQ    =  '4,   4,   0'

set H2D_SURFLX   =  '0,   4,   0'
set H2D_SURRLX   =  '0,   4,   0'
set H2D_SWA      =  '0,   4,   0'

set H2D_T20D     =  '4,   4,   0'

set H2D_TAUX     =  '0,   4,   0'
set H2D_TAUY     =  '0,   4,   0'
set H2D_TBOT     =  '0,   4,   0'

set H2D_TICE     =  '0,   0,   0'
set H2D_TSRF     =  '0,   0,   0'

set H2D_UB       =  '0,   4,   0'

set H2D_UICE     =  '0,   0,   0'

set H2D_USTAR    =  '0,   4,   0'
set H2D_USTAR3   =  '0,   4,   0'

set H2D_USTOKES  =  '0,   0,   0'

set H2D_VB       =  '0,   4,   0'

set H2D_VICE     =  '0,   0,   0'
set H2D_VSTOKES  =  '0,   0,   0'

set H2D_ZTX      =  '0,   4,   0'
set LYR_BFSQ     =  '0,   4,   0'
set LYR_DIFDIA   =  '0,   4,   0'
set LYR_DIFVMO   =  '0,   4,   0'
set LYR_DIFVHO   =  '0,   4,   0'
set LYR_DIFVSO   =  '0,   4,   0'
set LYR_DIFINT   =  '0,   4,   0'
set LYR_DIFISO   =  '0,   4,   0'
set LYR_DP       =  '0,   4,   0'
set LYR_DZ       =  '0,   4,   0'
set LYR_SALN     =  '0,   4,   0'
set LYR_TEMP     =  '0,   4,   0'

set LYR_TRC      =  '0,   0,   0'

set LYR_UFLX     =  '0,   4,   0'
set LYR_UTFLX    =  '0,   4,   0'
set LYR_USFLX    =  '0,   4,   0'

set LYR_UMFLTD   =  '0,   0,   4'
set LYR_UMFLSM   =  '0,   0,   4'
set LYR_UTFLTD   =  '0,   0,   4'
set LYR_UTFLSM   =  '0,   0,   4'
set LYR_UTFLLD   =  '0,   0,   4'
set LYR_USFLTD   =  '0,   0,   4'
set LYR_USFLSM   =  '0,   0,   4'
set LYR_USFLLD   =  '0,   0,   4'

set LYR_UVEL     =  '0,   4,   0'
set LYR_VFLX     =  '0,   4,   0'
set LYR_VTFLX    =  '0,   4,   0'
set LYR_VSFLX    =  '0,   4,   0'

set LYR_VMFLTD   =  '0,   0,   4'
set LYR_VMFLSM   =  '0,   0,   4'
set LYR_VTFLTD   =  '0,   0,   4'
set LYR_VTFLSM   =  '0,   0,   4'
set LYR_VTFLLD   =  '0,   0,   4'
set LYR_VSFLTD   =  '0,   0,   4'
set LYR_VSFLSM   =  '0,   0,   4'
set LYR_VSFLLD   =  '0,   0,   4'

set LYR_VVEL     =  '0,   4,   0'
set LYR_WFLX     =  '0,   4,   0'
set LYR_WFLX2    =  '0,   4,   0'
set LYR_PV       =  '0,   4,   0'
set LYR_TKE      =  '0,   4,   0'
set LYR_GLS_PSI  =  '0,   4,   0'
set LYR_IDLAGE   =  '0,   4,   0'
set LVL_BFSQ     =  '0,   4,   0'
set LVL_DIFDIA   =  '0,   4,   0'
set LVL_DIFVMO   =  '0,   4,   0'
set LVL_DIFVHO   =  '0,   4,   0'
set LVL_DIFVSO   =  '0,   4,   0'
set LVL_DIFINT   =  '0,   4,   0'
set LVL_DIFISO   =  '0,   4,   0'
set LVL_DZ       =  '0,   4,   0'
set LVL_SALN     =  '0,   4,   0'
set LVL_TEMP     =  '0,   4,   0'

set LVL_TRC      =  '0,   0,   0'

set LVL_UFLX     =  '0,   4,   0'
set LVL_UTFLX    =  '0,   4,   0'
set LVL_USFLX    =  '0,   4,   0'

set LVL_UMFLTD   =  '0,   0,   4'
set LVL_UMFLSM   =  '0,   0,   4'
set LVL_UTFLTD   =  '0,   0,   4'
set LVL_UTFLSM   =  '0,   0,   4'
set LVL_UTFLLD   =  '0,   0,   4'
set LVL_USFLTD   =  '0,   0,   4'
set LVL_USFLSM   =  '0,   0,   4'
set LVL_USFLLD   =  '0,   0,   4'

set LVL_UVEL     =  '0,   4,   0'
set LVL_VFLX     =  '0,   4,   0'
set LVL_VTFLX    =  '0,   4,   0'
set LVL_VSFLX    =  '0,   4,   0'

set LVL_VMFLTD   =  '0,   0,   4'
set LVL_VMFLSM   =  '0,   0,   4'
set LVL_VTFLTD   =  '0,   0,   4'
set LVL_VTFLSM   =  '0,   0,   4'
set LVL_VTFLLD   =  '0,   0,   4'
set LVL_VSFLTD   =  '0,   0,   4'
set LVL_VSFLSM   =  '0,   0,   4'
set LVL_VSFLLD   =  '0,   0,   4'

set LVL_VVEL     =  '0,   4,   0'
set LVL_WFLX     =  '0,   4,   0'
set LVL_WFLX2    =  '0,   4,   0'
set LVL_PV       =  '0,   4,   0'
set LVL_TKE      =  '0,   4,   0'
set LVL_GLS_PSI  =  '0,   4,   0'
set LVL_IDLAGE   =  '0,   4,   0'
set MSC_MMFLXL   =  '0,   4,   0'
set MSC_MMFLXD   =  '0,   4,   0'
set MSC_MMFTDL   =  '0,   4,   0'
set MSC_MMFSML   =  '0,   4,   0'
set MSC_MMFTDD   =  '0,   4,   0'
set MSC_MMFSMD   =  '0,   4,   0'
set MSC_MHFLX    =  '0,   4,   0'
set MSC_MHFTD    =  '0,   4,   0'
set MSC_MHFSM    =  '0,   4,   0'
set MSC_MHFLD    =  '0,   4,   0'
set MSC_MSFLX    =  '0,   4,   0'
set MSC_MSFTD    =  '0,   4,   0'
set MSC_MSFSM    =  '0,   4,   0'
set MSC_MSFLD    =  '0,   4,   0'
set MSC_VOLTR    =  '0,   4,   0'
set MSC_MASSGS   =  '0,   4,   0'
set MSC_VOLGS    =  '0,   4,   0'
set MSC_SALNGA   =  '0,   4,   0'
set MSC_TEMPGA   =  '0,   4,   0'
set MSC_SSSGA    =  '0,   4,   0'
set MSC_SSTGA    =  '0,   4,   0'

#------------------------------
# set DIABGC defaults
#------------------------------
set BGC_FNAMETAG  = "'hbgcd','hbgcm','hbgcy'"
set BGC_AVEPERIO  = '1,30,365'
set BGC_FILEFREQ  = '30,30,365'
if ("$TEST" == TRUE) then
   set BGC_FILEFREQ  = ' 1,30,365'
else
   set BGC_FILEFREQ  = '30,30,365'
endif
set BGC_COMPFLAG  = '0, 0, 0'
if ("$PIO_NETCDF_FORMAT_OCN" == 64bit_offset) then
  set BGC_NCFORMAT  = '1, 1, 1'
else
  set BGC_NCFORMAT  = '0, 0, 0'
endif
set BGC_INVENTORY = '0, 1, 0'
set SRF_PHOSPH    = '0, 2, 2'
set SRF_OXYGEN    = '0, 2, 2'    
set SRF_IRON      = '0, 2, 2'   
set SRF_ANO3      = '0, 2, 2'
set SRF_ALKALI    = '4, 2, 2'
set SRF_SILICA    = '0, 2, 2' 
set SRF_DIC       = '4, 2, 2' 
set SRF_PHYTO     = '4, 2, 2' 
set SRF_PH        = '0, 2, 2' 
set SRF_EXPORT    = '0, 2, 2' 
set SRF_EXPOSI    = '0, 2, 2' 
set SRF_EXPOCA    = '0, 2, 2' 
set SRF_KWCO2     = '0, 2, 2' 
set SRF_KWCO2KHM  = '0, 2, 2' 
set SRF_CO2KH     = '0, 2, 2' 
set SRF_CO2KHM    = '0, 2, 2' 
set SRF_PCO2      = '0, 2, 2' 
set SRF_PCO2M     = '0, 2, 2' 
set SRF_CO2FXD    = '4, 2, 2' 
set SRF_CO2FXU    = '4, 2, 2' 
set SRF_OXFLUX    = '0, 2, 2' 
set SRF_NIFLUX    = '0, 2, 2' 
set SRF_N2OFX     = '0, 0, 2' 
set SRF_DMSFLUX   = '0, 2, 2' 
set SRF_DMS       = '0, 2, 2' 
set SRF_DMSPROD   = '0, 2, 2' 
set SRF_DMS_BAC   = '0, 2, 2' 
set SRF_DMS_UV    = '0, 2, 2' 
set SRF_ATMCO2    = '0, 2, 2' 
set SRF_ATMO2     = '0, 2, 2' 
set SRF_ATMN2     = '0, 2, 2' 
set SRF_NATDIC    = '0, 2, 2'
set SRF_NATALKALI = '0, 2, 2'
set SRF_NATPH     = '0, 2, 2'
set SRF_NATPCO2   = '0, 2, 2'
set SRF_NATCO2FX  = '0, 2, 2'
set SRF_CO213FXD  = '0, 2, 2' 
set SRF_CO213FXU  = '0, 2, 2' 
set SRF_CO214FXD  = '0, 2, 2' 
set SRF_CO214FXU  = '0, 2, 2' 
set SRF_CFC11     = '0, 2, 2' 
set SRF_CFC12     = '0, 2, 2' 
set SRF_SF6       = '0, 2, 2' 
set SRF_BROMO     = '0, 2, 2'
set SRF_BROMOFX   = '0, 2, 2'
set INT_BROMOPRO  = '0, 2, 2'
set INT_BROMOUV   = '0, 2, 2'
set INT_PHOSY     = '4, 2, 2' 
set INT_NFIX      = '0, 2, 2' 
set INT_DNIT      = '0, 2, 2' 
if ("$BLOM_N_DEPOSITION" == TRUE) then
set FLX_NDEP      = '0, 2, 2'
else
set FLX_NDEP      = '0, 0, 0'
endif
set FLX_OALK      = '0, 0, 0'
set FLX_CAR0100   = '0, 2, 2'
set FLX_CAR0500   = '0, 2, 2'
set FLX_CAR1000   = '0, 2, 2'
set FLX_CAR2000   = '0, 2, 2'
set FLX_CAR4000   = '0, 2, 2'
set FLX_CAR_BOT   = '0, 2, 2'
set FLX_BSI0100   = '0, 2, 2'
set FLX_BSI0500   = '0, 2, 2'
set FLX_BSI1000   = '0, 2, 2'
set FLX_BSI2000   = '0, 2, 2'
set FLX_BSI4000   = '0, 2, 2'
set FLX_BSI_BOT   = '0, 2, 2'
set FLX_CAL0100   = '0, 2, 2'
set FLX_CAL0500   = '0, 2, 2'
set FLX_CAL1000   = '0, 2, 2'
set FLX_CAL2000   = '0, 2, 2'
set FLX_CAL4000   = '0, 2, 2'
set FLX_CAL_BOT   = '0, 2, 2'
set LYR_PHYTO     = '0, 0, 2' 
set LYR_GRAZER    = '0, 0, 2' 
set LYR_DOC       = '0, 0, 2' 
set LYR_PHOSY     = '0, 0, 2' 
set LYR_PHOSPH    = '0, 0, 2' 
set LYR_OXYGEN    = '0, 0, 4' 
set LYR_IRON      = '0, 0, 2'
set LYR_ANO3      = '0, 0, 2'
set LYR_ALKALI    = '0, 0, 2'
set LYR_SILICA    = '0, 0, 2'
set LYR_DIC       = '0, 0, 2'
set LYR_POC       = '0, 0, 2'
set LYR_CALC      = '0, 0, 2'
set LYR_OPAL      = '0, 0, 2'
set LYR_CO3       = '0, 0, 2'
set LYR_N2O       = '0, 0, 0'
set LYR_PH        = '0, 0, 2'
set LYR_OMEGAC    = '0, 0, 2'
set LYR_OMEGAA    = '0, 0, 2'
set LYR_PREFO2    = '0, 0, 4'
set LYR_O2SAT     = '0, 0, 4'
set LYR_PREFPO4   = '0, 0, 2'
set LYR_PREFALK   = '0, 0, 2'
set LYR_PREFDIC   = '0, 0, 2'
set LYR_DICSAT    = '0, 0, 2'
set LYR_NATDIC    = '0, 0, 2'
set LYR_NATALKALI = '0, 0, 2'
set LYR_NATCO3    = '0, 0, 2'
set LYR_NATCALC   = '0, 0, 2'
set LYR_NATPH     = '0, 0, 2'
set LYR_NATOMEGAC = '0, 0, 2'
set LYR_NATOMEGAA = '0, 0, 2'
set LYR_DIC13     = '0, 0, 2'
set LYR_DIC14     = '0, 0, 2'
set LYR_D13C      = '0, 0, 2'
set LYR_D14C      = '0, 0, 2'
set LYR_BIGD14C   = '0, 0, 2'
set LYR_POC13     = '0, 0, 2'
set LYR_DOC13     = '0, 0, 2'
set LYR_CALC13    = '0, 0, 2'
set LYR_PHYTO13   = '0, 0, 2'
set LYR_GRAZER13  = '0, 0, 2'
set LYR_CFC11     = '0, 0, 2'
set LYR_CFC12     = '0, 0, 2'
set LYR_SF6       = '0, 0, 2'
set LYR_NOS       = '0, 0, 2'
set LYR_WPHY      = '0, 0, 2'
set LYR_WNOS      = '0, 0, 2'
set LYR_EPS       = '0, 0, 0'
set LYR_ASIZE     = '0, 0, 0'
set LYR_BROMO     = '0, 0, 2'
set BGC_DP        = '0, 2, 2'
set LVL_PHYTO     = '0, 2, 2'
set LVL_GRAZER    = '0, 2, 2'
set LVL_DOC       = '0, 2, 2'
set LVL_PHOSY     = '0, 2, 2'
set LVL_PHOSPH    = '0, 2, 2'
set LVL_OXYGEN    = '0, 4, 4'
set LVL_IRON      = '0, 2, 2'
set LVL_ANO3      = '0, 2, 2'
set LVL_ALKALI    = '0, 2, 2'
set LVL_SILICA    = '0, 2, 2'
set LVL_DIC       = '0, 2, 2'
set LVL_POC       = '0, 2, 2'
set LVL_CALC      = '0, 2, 2'
set LVL_OPAL      = '0, 2, 2'
set LVL_CO3       = '0, 2, 2'
set LVL_N2O       = '0, 0, 2'
set LVL_PH        = '0, 2, 2'
set LVL_OMEGAC    = '0, 2, 2'
set LVL_OMEGAA    = '0, 2, 2'
set LVL_PREFO2    = '0, 4, 4'
set LVL_O2SAT     = '0, 4, 4'
set LVL_PREFPO4   = '0, 2, 2'
set LVL_PREFALK   = '0, 2, 2'
set LVL_PREFDIC   = '0, 2, 2'
set LVL_DICSAT    = '0, 2, 2'
set LVL_NATDIC    = '0, 2, 2'
set LVL_NATALKALI = '0, 2, 2'
set LVL_NATCO3    = '0, 2, 2'
set LVL_NATCALC   = '0, 2, 2'
set LVL_NATPH     = '0, 2, 2'
set LVL_NATOMEGAC = '0, 2, 2'
set LVL_NATOMEGAA = '0, 2, 2'
set LVL_DIC13     = '0, 2, 2'
set LVL_DIC14     = '0, 2, 2'
set LVL_D13C      = '0, 2, 2'
set LVL_POC13     = '0, 2, 2'
set LVL_DOC13     = '0, 2, 2'
set LVL_CALC13    = '0, 2, 2'
set LVL_PHYTO13   = '0, 2, 2'
set LVL_GRAZER13  = '0, 2, 2'
set LVL_CFC11     = '0, 2, 2'
set LVL_CFC12     = '0, 2, 2'
set LVL_SF6       = '0, 2, 2'
set LVL_NOS       = '0, 2, 2'
set LVL_WPHY      = '0, 2, 2'
set LVL_WNOS      = '0, 2, 2'
set LVL_EPS       = '0, 0, 0'
set LVL_ASIZE     = '0, 0, 0'
set LVL_BROMO     = '0, 2, 2'
set FLX_SEDIFFIC  = '0, 0, 2'
set FLX_SEDIFFAL  = '0, 0, 2'
set FLX_SEDIFFPH  = '0, 0, 2'
set FLX_SEDIFFOX  = '0, 0, 2'
set FLX_SEDIFFN2  = '0, 0, 2'
set FLX_SEDIFFNO3 = '0, 0, 2'
set FLX_SEDIFFSI  = '0, 0, 2'
set SDM_POWAIC    = '0, 0, 2'
set SDM_POWAAL    = '0, 0, 2'
set SDM_POWAPH    = '0, 0, 2'
set SDM_POWAOX    = '0, 0, 2'
set SDM_POWN2     = '0, 0, 2'
set SDM_POWNO3    = '0, 0, 2'
set SDM_POWASI    = '0, 0, 2'
set SDM_SSSO12    = '0, 0, 2'
set SDM_SSSSIL    = '0, 0, 2'
set SDM_SSSC12    = '0, 0, 2'
set SDM_SSSTER    = '0, 0, 2'
set BUR_SSSO12    = '0, 0, 2'
set BUR_SSSSIL    = '0, 0, 2'
set BUR_SSSC12    = '0, 0, 2'
set BUR_SSSTER    = '0, 0, 2'

# if partial coupling, enable SSS relaxation
if ("$BLOM_COUPLING"  =~ *partial*) then
  if ("$BLOM_VCOORD" == isopyc_bulkml) then
    set SRXDAY = 6.
  else
    set SRXDAY = 60.
    set SRXDPT = 10.
  endif
  set SPRFAC = .true.
  set SRXBAL = .true.
endif

# set grid dependent parameters
if ("$OCN_GRID" == gx1v5 || "$OCN_GRID" == gx1v6) then
  set BACLIN = 1800.
  set BATROP = 36.
else if ("$OCN_GRID" == gx3v7) then
  set BACLIN = 3600.
  set BATROP = 72.
else if ("$OCN_GRID" == tnx2v1 ) then
  set BACLIN = 4800.
  set BATROP = 96.
  set EGC    = 0.5
  if ("$BLOM_UNIT" == cgs) then
    set EGMXDF = 1000.e4
  else
    set EGMXDF = 1000.
  endif
  set CWMTAG = "'Gibraltar','Gibraltar'"
  set CWMEDG = "        'u',        'u'"
  set CWMI   = "         53,         54"
  set CWMJ   = "        137,        137"
  set CWMWTH = "      30.e3,      30.e3"
else if ("$OCN_GRID" ==  tnx1.5v1 ) then
  set BACLIN = 4800.
  set BATROP = 96.
  set EGC    = 0.5
  if ("$BLOM_UNIT" == cgs) then
    set EGMXDF = 1000.e4
  else
    set EGMXDF = 1000.
  endif
else if ("$OCN_GRID" == tnx1v1 || "$OCN_GRID" == tnx1v3 || "$OCN_GRID" == tnx1v4) then
  if ("$OCN_NCPL" == 24) then
    set BACLIN = 3600.
    set BATROP = 60.
    set CWBDTS = .75e-4
    set NIWGF  = .4
    set SMTFRC = .false.
    if ("$BLOM_VCOORD" == isopyc_bulkml) then
      set CE     = .5
    endif
  else
    set BACLIN = 3200.
    set BATROP = 64.
  endif
  set CWMTAG = "'Gibraltar','Gibraltar'"
  set CWMEDG = "        'u',        'u'"
  set CWMI   = "        105,        106"
  set CWMJ   = "        273,        273"
  set CWMWTH = "      30.e3,      30.e3"
else if ("$OCN_GRID" == tnx0.25v1 || "$OCN_GRID" == tnx0.25v3 || "$OCN_GRID" == tnx0.25v4) then
  set BACLIN = 900.
  set BATROP = 15.
  if ("$BLOM_UNIT" == cgs) then
    set MDV2HI = .15
    set MDV2LO = .15
    set MDV4HI = 0.
    set MDV4LO = 0.
    set MDC2HI = 300.e4
    set MDC2LO = 300.e4
  else
    set MDV2HI = .0015
    set MDV2LO = .0015
    set MDV4HI = 0.
    set MDV4LO = 0.
    set MDC2HI = 300.
    set MDC2LO = 300.
  endif
  set VSC2HI = .15
  set VSC2LO = .15
  set VSC4HI = 0.0625
  set VSC4LO = 0.0625
  set CWBDTS = 0.75e-4
  set CWBDLS = 25.
  set EDWMTH = "'step'"
  set EGC    = 0.85
  if ("$BLOM_UNIT" == cgs) then
    set EGMXDF = 1500.e4
  else
    set EGMXDF = 1500.
  endif
  if ("$BLOM_VCOORD" == isopyc_bulkml) then
    set CE     = 1.0
  endif
else if ("$OCN_GRID" == tnx0.125v4) then
  set BACLIN = 300.
  set BATROP = 6.
  set EGMNDF = 0.
  set EGMXDF = 0.
  set EDWMTH = "'step'"
  set CWBDTS = .75e-4
  set CWBDLS = 25
  if ("$BLOM_UNIT" == cgs) then
    set MDV2HI = .1
    set MDV2LO = .1
    set MDV4HI = 0.
    set MDV4LO = 0.
    set MDC2HI = 300.e4
    set MDC2LO = 100.e4
  else
    set MDV2HI = .001
    set MDV2LO = .001
    set MDV4HI = 0.
    set MDV4LO = 0.
    set MDC2HI = 300.
    set MDC2LO = 100.
  endif
  set VSC2HI = 0.
  set VSC2LO = 0.
  set VSC4HI = .06
  set VSC4LO = .06
  set LTEDTP = "'layer'"
else
  echo "OCN_GRID is $OCN_GRID \n"    
  echo "$0 ERROR: Cannot deal with GRID equal to $OCN_GRID "
  exit -1
endif

# set grid independent input files (iHAMOCC initial conditions)
set INIDIC = "'$DIN_LOC_ROOT/ocn/blom/inicon/glodapv2_Ct_preind_OMIPinit_20171107.nc'"
set INIALK = "'$DIN_LOC_ROOT/ocn/blom/inicon/glodapv2_At_OMIPinit_20171107.nc'"
set INIPO4 = "'$DIN_LOC_ROOT/ocn/blom/inicon/woa13_phosphate_OMIPinit_20171107.nc'"
set INIOXY = "'$DIN_LOC_ROOT/ocn/blom/inicon/woa13_oxygen_OMIPinit_20171107.nc'"
set ININO3 = "'$DIN_LOC_ROOT/ocn/blom/inicon/woa13_nitrate_OMIPinit_20171107.nc'"
set INISIL = "'$DIN_LOC_ROOT/ocn/blom/inicon/woa13_silicate_OMIPinit_20171107.nc'"
if ("$HAMOCC_CISO" == TRUE) then
set INID13C = "'$DIN_LOC_ROOT/ocn/blom/inicon/d13C_permil_20180609.nc'"
set INID14C = "'$DIN_LOC_ROOT/ocn/blom/inicon/d14C_permil_20180609.nc'"
else
set INID13C = "''"
set INID14C = "''"
endif

# set grid dependent input files
if      ("$OCN_GRID" == tnx2v1) then
  set GRFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/grid_tnx2v1_20130206.nc'"
  set ICFILE = "'$DIN_LOC_ROOT/ocn/blom/inicon/inicon_tnx2v1_20130419.nc'"
  set TDFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/tidal_dissipation_tnx2v1_20130419.nc'"
  set MER_ORFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/ocean_regions_tnx2v1_20190826.nc'"
  set MER_MIFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/mertra_index_tnx2v1_20190826.dat'"
  set SEC_SIFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/section_index_tnx2v1_20190826.dat'"
  set SCFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/sss_clim_core_tnx2v1_20130927.nc'"
  set FEDEPFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/dustdep_mhw2006_tnx2v1_20130506.nc'"
  set SWACLIMFILE = "''"
  set SEDPORFILE = "''"
  if ("$BLOM_RIVER_NUTRIENTS" == TRUE) then
    set RIVINFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/river_nutrients_GNEWS2000_tnx2v1_20170915.nc'"
  else
    set RIVINFILE = "''"
  endif
  if ("$BLOM_N_DEPOSITION" == TRUE) then
    set NDEPFILE  = "'$DIN_LOC_ROOT/ocn/blom/bndcon/$NDEPFNAME'"
  else
    set NDEPFILE  = "''"
  endif
else if ("$OCN_GRID" == tnx1v4) then
  set GRFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/grid_tnx1v4_20170622.nc'"
  set ICFILE = "'$DIN_LOC_ROOT/ocn/blom/inicon/inicon_tnx1v4_20170622.nc'"
  set TDFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/tidal_dissipation_tnx1v4_20170605.nc'"
  set MER_ORFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/ocean_regions_tnx1v4_20190729.nc'"
  set MER_MIFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/mertra_index_tnx1v4_20190615.dat'"
  set SEC_SIFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/section_index_tnx1v4_20190611.dat'"
  set CCFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/chlorophyll_concentration_tnx1v4_20170608.nc'"
  set SCFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/sss_clim_core_tnx1v4_20170604.nc'"
  set FEDEPFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/dustdep_mhw2006_tnx1v4_20171107.nc'"
  set SEDPORFILE = "''"
  if ("$HAMOCC_VSLS" == TRUE) then
    set SWACLIMFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/Annual_clim_swa_tnx1v4_20210415.nc'"
  else
    set SWACLIMFILE = "''"
  endif
  if ("$BLOM_RIVER_NUTRIENTS" == TRUE) then
    set RIVINFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/river_nutrients_GNEWS2000_tnx1v4_20170820.nc'"
  else
    set RIVINFILE = "''"
  endif
  if ("$BLOM_N_DEPOSITION" == TRUE) then
    set NDEPFILE  = "'$DIN_LOC_ROOT/ocn/blom/bndcon/$NDEPFNAME'"
  else
    set NDEPFILE  = "''"
  endif
else if ("$OCN_GRID" == tnx0.25v4) then
  set GRFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/grid_tnx0.25v4_20170622.nc'"
  set ICFILE = "'$DIN_LOC_ROOT/ocn/blom/inicon/inicon_tnx0.25v4_20170623.nc'"
  set TDFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/tidal_dissipation_tnx0.25v4_20170626.nc'"
  set MER_ORFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/ocean_regions_tnx0.25v4_20190612.nc'"
  set MER_MIFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/mertra_index_tnx0.25v4_20190701.dat'"
  set SEC_SIFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/section_index_tnx0.25v4_20190612.dat'"
  set CCFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/chlorophyll_concentration_tnx0.25v4_20170623.nc'"
  set SCFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/sss_clim_core_tnx0.25v4_20170623.nc'"
  set FEDEPFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/dustdep_mhw2006_tnx0.25v4_20181004.nc'"
  set SWACLIMFILE = "''"
  set SEDPORFILE = "''"
  if ("$BLOM_RIVER_NUTRIENTS" == TRUE) then
    set RIVINFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/river_nutrients_GNEWS2000_tnx0.25v4_20170821.nc'"
  else
    set RIVINFILE = "''"
  endif
  if ("$BLOM_N_DEPOSITION" == TRUE) then
    set NDEPFILE  = "'$DIN_LOC_ROOT/ocn/blom/bndcon/$NDEPFNAME'"
  else
    set NDEPFILE  = "''"
  endif
else if ("$OCN_GRID" == tnx0.125v4) then
  set GRFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/grid_tnx0.125v4_20221013.nc'"
  set ICFILE = "'$DIN_LOC_ROOT/ocn/blom/inicon/inicon_tnx0.125v4_20230318.nc'"
  set TDFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/tidal_dissipation_tnx0.125v4_20221013.nc'"
  set MER_ORFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/ocean_regions_tnx0.125v4_20221013.nc'"
  set MER_MIFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/mertra_index_tnx0.125v4_20221013.dat'"
  set SEC_SIFILE = "'$DIN_LOC_ROOT/ocn/blom/grid/section_index_tnx0.125v4_20221013.dat'"
  set CCFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/chlorophyll_concentration_tnx0.125v4_20221013.nc'"
  set SCFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/sss_clim_core_tnx0.125v4_20221013.nc'"
  set FEDEPFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/dustdep_mhw2006_tnx0.125v4_20221013.nc'"
  set SWACLIMFILE = "''"
  set SEDPORFILE = "''"
  if ("$BLOM_RIVER_NUTRIENTS" == TRUE) then
    set RIVINFILE = "'$DIN_LOC_ROOT/ocn/blom/bndcon/river_nutrients_GNEWS2000_tnx0.125v4_20221013.nc'"
  else
    set RIVINFILE = "''"
  endif
  if ("$BLOM_N_DEPOSITION" == TRUE) then
    set NDEPFILE  = "'$DIN_LOC_ROOT/ocn/blom/bndcon/$NDEPFNAME'"
  else
    set NDEPFILE  = "''"
  endif
else
  echo "$0 ERROR: Cannot deal with GRID = $OCN_GRID "
  exit -1
endif


#------------------------------------------------------------------------------
# Create resolved namelist
#------------------------------------------------------------------------------
foreach mem ("`seq $NINST_OCN`")
  if ( ${NINST_OCN} == '1' ) then
    set inststr = ''
  else
    set inststr = ("`printf '_%4.4d' $mem`")
  endif

  # modify namelist variables as specified in user_nl_blom
  foreach line ("`grep = $CASEROOT/user_nl_blom$inststr`")
    if (`echo "$line" | tr -d ' ' | cut -c -1` != '#') then
    set var = `echo "$line" | sed 's/=.*//' | tr '[a-z]' '[A-Z]'`
    set val = `echo "$line" | sed 's/.*=//'`
    eval 'set $var = "$val"'
    endif
  end

cp ocn_in.readme $RUNDIR/.

cat >! $RUNDIR/ocn_in$inststr << EOF
&LIMITS
  NDAY1    = $NDAY1
  NDAY2    = $NDAY2
  IDATE    = $IDATE
  IDATE0   = $IDATE0
  RUNID    = $RUNID
  EXPCNF   = $EXPCNF
  RUNTYP   = $RUNTYP
  GRFILE   = $GRFILE
  ICFILE   = $ICFILE
  PREF     = $PREF
  BACLIN   = $BACLIN
  BATROP   = $BATROP
  MDV2HI   = $MDV2HI
  MDV2LO   = $MDV2LO
  MDV4HI   = $MDV4HI
  MDV4LO   = $MDV4LO
  MDC2HI   = $MDC2HI
  MDC2LO   = $MDC2LO
  VSC2HI   = $VSC2HI
  VSC2LO   = $VSC2LO
  VSC4HI   = $VSC4HI
  VSC4LO   = $VSC4LO
  CBAR     = $CBAR
  CB       = $CB
  CWBDTS   = $CWBDTS
  CWBDLS   = $CWBDLS
  MOMMTH   = $MOMMTH
  BMCMTH   = $BMCMTH
  RMPMTH   = $RMPMTH
  MLRTTP   = $MLRTTP
  RM0      = $RM0
  RM5      = $RM5
  CE       = $CE
  TDFILE   = $TDFILE
  NIWGF    = $NIWGF
  NIWBF    = $NIWBF
  NIWLF    = $NIWLF
  SWAMTH   = $SWAMTH
  JWTYPE   = $JWTYPE
  CHLOPT   = $CHLOPT
  CCFILE   = $CCFILE
  TRXDAY   = $TRXDAY
  SRXDAY   = $SRXDAY
  TRXDPT   = $TRXDPT
  SRXDPT   = $SRXDPT
  TRXLIM   = $TRXLIM
  SRXLIM   = $SRXLIM
  APTFLX   = $APTFLX
  APSFLX   = $APSFLX
  DITFLX   = $DITFLX
  DISFLX   = $DISFLX
  SRXBAL   = $SRXBAL
  SCFILE   = $SCFILE
  WAVSRC   = $WAVSRC
  SMTFRC   = $SMTFRC
  SPRFAC   = $SPRFAC
  ATM_PATH = $ATM_PATH
  ITEST    = $ITEST
  JTEST    = $JTEST
  CNSVDI   = $CNSVDI
  CSDIAG   = $CSDIAG
  RSTFRQ   = $RSTFRQ
  RSTFMT   = $RSTFMT
  RSTCMP   = $RSTCMP
  IOTYPE   = $IOTYPE
/
EOF

if ("$BLOM_VCOORD" == cntiso_hybrid) then
cat >>! $RUNDIR/ocn_in$inststr << EOF

&VCOORD
  VCOORD_TYPE            = $VCOORD_TYPE
  RECONSTRUCTION_METHOD  = $RECONSTRUCTION_METHOD
  DENSITY_LIMITING       = $DENSITY_LIMITING
  TRACER_LIMITING        = $TRACER_LIMITING
  VELOCITY_LIMITING      = $VELOCITY_LIMITING
  DENSITY_PC_UPPER_BNDR  = $DENSITY_PC_UPPER_BNDR
  DENSITY_PC_LOWER_BNDR  = $DENSITY_PC_LOWER_BNDR
  TRACER_PC_UPPER_BNDR   = $TRACER_PC_UPPER_BNDR
  TRACER_PC_LOWER_BNDR   = $TRACER_PC_LOWER_BNDR
  VELOCITY_PC_UPPER_BNDR = $VELOCITY_PC_UPPER_BNDR
  VELOCITY_PC_LOWER_BNDR = $VELOCITY_PC_LOWER_BNDR
  DPMIN_SURFACE          = $DPMIN_SURFACE
  DPMIN_INFLATION_FACTOR = $DPMIN_INFLATION_FACTOR
  DPMIN_INTERIOR         = $DPMIN_INTERIOR
  DKTZU                  = $DKTZU
  DKTZL                  = $DKTZL
/
EOF
endif

cat >>! $RUNDIR/ocn_in$inststr << EOF
 
&DIFFUSION
  EITMTH   = $EITMTH
  EDRITP   = $EDRITP
  EDWMTH   = $EDWMTH
  EDDF2D   = $EDDF2D
  EDSPRS   = $EDSPRS
  EGC      = $EGC
  EGGAM    = $EGGAM
  EGLSMN   = $EGLSMN
  EGMNDF   = $EGMNDF
  EGMXDF   = $EGMXDF
  EGIDFQ   = $EGIDFQ
  TBFILE   = $TBFILE
  RHISCF   = $RHISCF
  EDANIS   = $EDANIS
  REDI3D   = $REDI3D
  RHSCTP   = $RHSCTP
  RI0      = $RI0
  BDMTYP   = $BDMTYP
  BDMC1    = $BDMC1
  BDMC2    = $BDMC2
  BDMLDP   = $BDMLDP
  TKEPF    = $TKEPF
  SMOBLD   = $SMOBLD
  LNGMTP   = $LNGMTP
  LTEDTP   = $LTEDTP
/
EOF

if ($?CWMTAG) then
cat >>! $RUNDIR/ocn_in$inststr << EOF
 
&CWMOD
  CWMTAG = $CWMTAG
  CWMEDG = $CWMEDG
  CWMI   = $CWMI
  CWMJ   = $CWMJ
  CWMWTH = $CWMWTH
/
EOF
endif

cat >>! $RUNDIR/ocn_in$inststr << EOF

&MERDIA
  MER_ORFILE = $MER_ORFILE
  MER_MIFILE = $MER_MIFILE
  MER_REGNAM = 'atlantic_arctic_ocean', 'atlantic_arctic_extended_ocean', 'indian_pacific_ocean', 'global_ocean'
  MER_REGFLG(1,:) = 2, 4
  MER_REGFLG(2,:) = 2, 4, 6, 7, 8, 9
  MER_REGFLG(3,:) = 3, 5 
  MER_REGFLG(4,:) = 0
  MER_MINLAT = -34., -34., -34., -90.
  MER_MAXLAT =  90.,  90.,  90.,  90.
/

&SECDIA
  SEC_SIFILE = $SEC_SIFILE
/

&DIAPHY
  GLB_FNAMETAG = $GLB_FNAMETAG
  GLB_AVEPERIO = $GLB_AVEPERIO
  GLB_FILEFREQ = $GLB_FILEFREQ
  GLB_COMPFLAG = $GLB_COMPFLAG
  GLB_NCFORMAT = $GLB_NCFORMAT
  H2D_ABSWND   = $H2D_ABSWND
  H2D_ALB      = $H2D_ALB
  H2D_BTMSTR   = $H2D_BTMSTR
  H2D_BRNFLX   = $H2D_BRNFLX
  H2D_BRNPD    = $H2D_BRNPD
  H2D_DFL      = $H2D_DFL
  H2D_EVA      = $H2D_EVA
  H2D_FICE     = $H2D_FICE
  H2D_FMLTFZ   = $H2D_FMLTFZ
  H2D_HICE     = $H2D_HICE
  H2D_HMLTFZ   = $H2D_HMLTFZ
  H2D_HSNW     = $H2D_HSNW
  H2D_IAGE     = $H2D_IAGE
  H2D_IDKEDT   = $H2D_IDKEDT
  H2D_LAMULT   = $H2D_LAMULT
  H2D_LASL     = $H2D_LASL
  H2D_LIP      = $H2D_LIP
  H2D_MAXMLD   = $H2D_MAXMLD
  H2D_MLD      = $H2D_MLD
  H2D_MLTS     = $H2D_MLTS
  H2D_MLTSMN   = $H2D_MLTSMN
  H2D_MLTSMX   = $H2D_MLTSMX
  H2D_MLTSSQ   = $H2D_MLTSSQ
  H2D_MTKEUS   = $H2D_MTKEUS
  H2D_MTKENI   = $H2D_MTKENI
  H2D_MTKEBF   = $H2D_MTKEBF
  H2D_MTKERS   = $H2D_MTKERS
  H2D_MTKEPE   = $H2D_MTKEPE
  H2D_MTKEKE   = $H2D_MTKEKE
  H2D_MTY      = $H2D_MTY
  H2D_NSF      = $H2D_NSF
  H2D_PBOT     = $H2D_PBOT
  H2D_PSRF     = $H2D_PSRF
  H2D_RFIFLX   = $H2D_RFIFLX
  H2D_RNFFLX   = $H2D_RNFFLX
  H2D_SALFLX   = $H2D_SALFLX
  H2D_SALRLX   = $H2D_SALRLX
  H2D_SBOT     = $H2D_SBOT
  H2D_SEALV    = $H2D_SEALV
  H2D_SLVSQ    = $H2D_SLVSQ
  H2D_SFL      = $H2D_SFL
  H2D_SOP      = $H2D_SOP
  H2D_SIGMX    = $H2D_SIGMX
  H2D_SSS      = $H2D_SSS
  H2D_SSSSQ    = $H2D_SSSSQ
  H2D_SST      = $H2D_SST
  H2D_SSTSQ    = $H2D_SSTSQ
  H2D_SURFLX   = $H2D_SURFLX
  H2D_SURRLX   = $H2D_SURRLX
  H2D_SWA      = $H2D_SWA
  H2D_T20D     = $H2D_T20D
  H2D_TAUX     = $H2D_TAUX
  H2D_TAUY     = $H2D_TAUY
  H2D_TBOT     = $H2D_TBOT
  H2D_TICE     = $H2D_TICE
  H2D_TSRF     = $H2D_TSRF
  H2D_UB       = $H2D_UB
  H2D_UICE     = $H2D_UICE
  H2D_USTAR    = $H2D_USTAR
  H2D_USTAR3   = $H2D_USTAR3
  H2D_USTOKES  = $H2D_USTOKES
  H2D_VB       = $H2D_VB
  H2D_VICE     = $H2D_VICE
  H2D_VSTOKES  = $H2D_VSTOKES
  H2D_ZTX      = $H2D_ZTX
  LYR_BFSQ     = $LYR_BFSQ
  LYR_DIFDIA   = $LYR_DIFDIA
  LYR_DIFVMO   = $LYR_DIFVMO
  LYR_DIFVHO   = $LYR_DIFVHO
  LYR_DIFVSO   = $LYR_DIFVSO
  LYR_DIFINT   = $LYR_DIFINT
  LYR_DIFISO   = $LYR_DIFISO
  LYR_DP       = $LYR_DP
  LYR_DZ       = $LYR_DZ
  LYR_SALN     = $LYR_SALN
  LYR_TEMP     = $LYR_TEMP
  LYR_TRC      = $LYR_TRC
  LYR_UFLX     = $LYR_UFLX
  LYR_UTFLX    = $LYR_UTFLX
  LYR_USFLX    = $LYR_USFLX
  LYR_UMFLTD   = $LYR_UMFLTD
  LYR_UMFLSM   = $LYR_UMFLSM
  LYR_UTFLTD   = $LYR_UTFLTD
  LYR_UTFLSM   = $LYR_UTFLSM
  LYR_UTFLLD   = $LYR_UTFLLD
  LYR_USFLTD   = $LYR_USFLTD
  LYR_USFLSM   = $LYR_USFLSM
  LYR_USFLLD   = $LYR_USFLLD
  LYR_UVEL     = $LYR_UVEL
  LYR_VFLX     = $LYR_VFLX
  LYR_VTFLX    = $LYR_VTFLX
  LYR_VSFLX    = $LYR_VSFLX
  LYR_VMFLTD   = $LYR_VMFLTD
  LYR_VMFLSM   = $LYR_VMFLSM
  LYR_VTFLTD   = $LYR_VTFLTD
  LYR_VTFLSM   = $LYR_VTFLSM
  LYR_VTFLLD   = $LYR_VTFLLD
  LYR_VSFLTD   = $LYR_VSFLTD
  LYR_VSFLSM   = $LYR_VSFLSM
  LYR_VSFLLD   = $LYR_VSFLLD
  LYR_VVEL     = $LYR_VVEL
  LYR_WFLX     = $LYR_WFLX
  LYR_WFLX2    = $LYR_WFLX2
  LYR_PV       = $LYR_PV
  LYR_TKE      = $LYR_TKE
  LYR_GLS_PSI  = $LYR_GLS_PSI
  LYR_IDLAGE   = $LYR_IDLAGE
  LVL_BFSQ     = $LVL_BFSQ
  LVL_DIFDIA   = $LVL_DIFDIA
  LVL_DIFVMO   = $LVL_DIFVMO
  LVL_DIFVHO   = $LVL_DIFVHO
  LVL_DIFVSO   = $LVL_DIFVSO
  LVL_DIFINT   = $LVL_DIFINT
  LVL_DIFISO   = $LVL_DIFISO
  LVL_DZ       = $LVL_DZ
  LVL_SALN     = $LVL_SALN
  LVL_TEMP     = $LVL_TEMP
  LVL_TRC      = $LVL_TRC
  LVL_UFLX     = $LVL_UFLX
  LVL_UTFLX    = $LVL_UTFLX
  LVL_USFLX    = $LVL_USFLX
  LVL_UMFLTD   = $LVL_UMFLTD
  LVL_UMFLSM   = $LVL_UMFLSM
  LVL_UTFLTD   = $LVL_UTFLTD
  LVL_UTFLSM   = $LVL_UTFLSM
  LVL_UTFLLD   = $LVL_UTFLLD
  LVL_USFLTD   = $LVL_USFLTD
  LVL_USFLSM   = $LVL_USFLSM
  LVL_USFLLD   = $LVL_USFLLD
  LVL_UVEL     = $LVL_UVEL
  LVL_VFLX     = $LVL_VFLX
  LVL_VTFLX    = $LVL_VTFLX
  LVL_VSFLX    = $LVL_VSFLX
  LVL_VMFLTD   = $LVL_VMFLTD
  LVL_VMFLSM   = $LVL_VMFLSM
  LVL_VTFLTD   = $LVL_VTFLTD
  LVL_VTFLSM   = $LVL_VTFLSM
  LVL_VTFLLD   = $LVL_VTFLLD
  LVL_VSFLTD   = $LVL_VSFLTD
  LVL_VSFLSM   = $LVL_VSFLSM
  LVL_VSFLLD   = $LVL_VSFLLD
  LVL_VVEL     = $LVL_VVEL
  LVL_WFLX     = $LVL_WFLX
  LVL_WFLX2    = $LVL_WFLX2
  LVL_PV       = $LVL_PV
  LVL_TKE      = $LVL_TKE
  LVL_GLS_PSI  = $LVL_GLS_PSI
  LVL_IDLAGE   = $LVL_IDLAGE
  MSC_MMFLXL   = $MSC_MMFLXL
  MSC_MMFLXD   = $MSC_MMFLXD
  MSC_MMFTDL   = $MSC_MMFTDL
  MSC_MMFSML   = $MSC_MMFSML
  MSC_MMFTDD   = $MSC_MMFTDD
  MSC_MMFSMD   = $MSC_MMFSMD
  MSC_MHFLX    = $MSC_MHFLX
  MSC_MHFTD    = $MSC_MHFTD
  MSC_MHFSM    = $MSC_MHFSM
  MSC_MHFLD    = $MSC_MHFLD
  MSC_MSFLX    = $MSC_MSFLX
  MSC_MSFTD    = $MSC_MSFTD
  MSC_MSFSM    = $MSC_MSFSM
  MSC_MSFLD    = $MSC_MSFLD
  MSC_VOLTR    = $MSC_VOLTR
  MSC_MASSGS   = $MSC_MASSGS
  MSC_VOLGS    = $MSC_VOLGS
  MSC_SALNGA   = $MSC_SALNGA
  MSC_TEMPGA   = $MSC_TEMPGA
  MSC_SSSGA    = $MSC_SSSGA
  MSC_SSTGA    = $MSC_SSTGA
/
EOF

if ("$ecosys" == TRUE) then
cat >>! $RUNDIR/ocn_in$inststr << EOF

&BGCNML
  ATM_CO2      = $CCSM_CO2_PPMV
  FEDEPFILE    = $FEDEPFILE
  SWACLIMFILE  = $SWACLIMFILE
  DO_RIVINPT   = $DO_RIVINPT
  RIVINFILE    = $RIVINFILE 
  DO_NDEP      = $DO_NDEP
  NDEPFILE     = $NDEPFILE
  DO_OALK      = $DO_OALK
  DO_SEDSPINUP = $DO_SEDSPINUP
  SEDSPIN_YR_S = $SEDSPIN_YR_S
  SEDSPIN_YR_E = $SEDSPIN_YR_E
  SEDSPIN_NCYC = $SEDSPIN_NCYC
  INIDIC       = $INIDIC
  INIALK       = $INIALK
  INIPO4       = $INIPO4
  INIOXY       = $INIOXY
  ININO3       = $ININO3
  INISIL       = $INISIL
  INID13C      = $INID13C
  INID14C      = $INID14C
  WITH_DMSPH   = $WITH_DMSPH
  PI_PH_FILE   = $PI_PH_FILE
  L_3DVARSEDPOR = $L_3DVARSEDPOR
  SEDPORFILE   = $SEDPORFILE
/

&BGCOAFX
  OALKSCEN      = $BGCOAFX_OALKSCEN
  OALKFILE      = $BGCOAFX_OALKFILE
  ADDALK        = $BGCOAFX_ADDALK
  CDRMIP_LATMAX = $BGCOAFX_CDRMIP_LATMAX
  CDRMIP_LATMIN = $BGCOAFX_CDRMIP_LATMIN
  RAMP_START    = $BGCOAFX_RAMP_START
  RAMP_END      = $BGCOAFX_RAMP_END
/

&DIABGC
  GLB_FNAMETAG  = $BGC_FNAMETAG
  GLB_AVEPERIO  = $BGC_AVEPERIO
  GLB_FILEFREQ  = $BGC_FILEFREQ
  GLB_COMPFLAG  = $BGC_COMPFLAG
  GLB_NCFORMAT  = $BGC_NCFORMAT
  GLB_INVENTORY = $BGC_INVENTORY
  SRF_PHOSPH    = $SRF_PHOSPH
  SRF_OXYGEN    = $SRF_OXYGEN
  SRF_IRON      = $SRF_IRON
  SRF_ANO3      = $SRF_ANO3
  SRF_ALKALI    = $SRF_ALKALI
  SRF_SILICA    = $SRF_SILICA
  SRF_DIC       = $SRF_DIC
  SRF_PHYTO     = $SRF_PHYTO
  SRF_PH        = $SRF_PH
  SRF_EXPORT    = $SRF_EXPORT
  SRF_EXPOSI    = $SRF_EXPOSI
  SRF_EXPOCA    = $SRF_EXPOCA
  SRF_KWCO2     = $SRF_KWCO2
  SRF_KWCO2KHM  = $SRF_KWCO2KHM
  SRF_CO2KH     = $SRF_CO2KH
  SRF_CO2KHM    = $SRF_CO2KHM
  SRF_PCO2      = $SRF_PCO2
  SRF_PCO2M     = $SRF_PCO2M
  SRF_CO2FXD    = $SRF_CO2FXD
  SRF_CO2FXU    = $SRF_CO2FXU
  SRF_OXFLUX    = $SRF_OXFLUX
  SRF_NIFLUX    = $SRF_NIFLUX
  SRF_N2OFX     = $SRF_N2OFX
  SRF_DMSFLUX   = $SRF_DMSFLUX
  SRF_DMS       = $SRF_DMS
  SRF_DMSPROD   = $SRF_DMSPROD
  SRF_DMS_BAC   = $SRF_DMS_BAC
  SRF_DMS_UV    = $SRF_DMS_UV
  SRF_ATMCO2    = $SRF_ATMCO2
  SRF_ATMO2     = $SRF_ATMO2
  SRF_ATMN2     = $SRF_ATMN2
  SRF_NATDIC    = $SRF_NATDIC
  SRF_NATALKALI = $SRF_NATALKALI
  SRF_NATPH     = $SRF_NATPH
  SRF_NATPCO2   = $SRF_NATPCO2
  SRF_NATCO2FX  = $SRF_NATCO2FX
  SRF_CO213FXD  = $SRF_CO213FXD
  SRF_CO213FXU  = $SRF_CO213FXU
  SRF_CO214FXD  = $SRF_CO214FXD
  SRF_CO214FXU  = $SRF_CO214FXU
  SRF_CFC11     = $SRF_CFC11
  SRF_CFC12     = $SRF_CFC12
  SRF_SF6       = $SRF_SF6
  SRF_BROMO     = $SRF_BROMO
  SRF_BROMOFX   = $SRF_BROMOFX
  INT_BROMOPRO  = $INT_BROMOPRO
  INT_BROMOUV   = $INT_BROMOUV
  INT_PHOSY     = $INT_PHOSY
  INT_NFIX      = $INT_NFIX
  INT_DNIT      = $INT_DNIT
  FLX_NDEP      = $FLX_NDEP
  FLX_OALK      = $FLX_OALK
  FLX_CAR0100   = $FLX_CAR0100
  FLX_CAR0500   = $FLX_CAR0500
  FLX_CAR1000   = $FLX_CAR1000
  FLX_CAR2000   = $FLX_CAR2000
  FLX_CAR4000   = $FLX_CAR4000
  FLX_CAR_BOT   = $FLX_CAR_BOT
  FLX_BSI0100   = $FLX_BSI0100
  FLX_BSI0500   = $FLX_BSI0500
  FLX_BSI1000   = $FLX_BSI1000
  FLX_BSI2000   = $FLX_BSI2000
  FLX_BSI4000   = $FLX_BSI4000
  FLX_BSI_BOT   = $FLX_BSI_BOT
  FLX_CAL0100   = $FLX_CAL0100
  FLX_CAL0500   = $FLX_CAL0500
  FLX_CAL1000   = $FLX_CAL1000
  FLX_CAL2000   = $FLX_CAL2000
  FLX_CAL4000   = $FLX_CAL4000
  FLX_CAL_BOT   = $FLX_CAL_BOT
  LYR_PHYTO     = $LYR_PHYTO
  LYR_GRAZER    = $LYR_GRAZER
  LYR_DOC       = $LYR_DOC
  LYR_PHOSY     = $LYR_PHOSY
  LYR_PHOSPH    = $LYR_PHOSPH
  LYR_OXYGEN    = $LYR_OXYGEN
  LYR_IRON      = $LYR_IRON
  LYR_ANO3      = $LYR_ANO3
  LYR_ALKALI    = $LYR_ALKALI
  LYR_SILICA    = $LYR_SILICA
  LYR_DIC       = $LYR_DIC
  LYR_POC       = $LYR_POC
  LYR_CALC      = $LYR_CALC
  LYR_OPAL      = $LYR_OPAL
  LYR_CO3       = $LYR_CO3
  LYR_N2O       = $LYR_N2O
  LYR_PH        = $LYR_PH
  LYR_OMEGAC    = $LYR_OMEGAC
  LYR_OMEGAA    = $LYR_OMEGAA
  LYR_PREFO2    = $LYR_PREFO2
  LYR_O2SAT     = $LYR_O2SAT
  LYR_PREFPO4   = $LYR_PREFPO4
  LYR_PREFALK   = $LYR_PREFALK
  LYR_PREFDIC   = $LYR_PREFDIC
  LYR_DICSAT    = $LYR_DICSAT
  LYR_NATDIC    = $LYR_NATDIC
  LYR_NATALKALI = $LYR_NATALKALI
  LYR_NATCO3    = $LYR_NATCO3
  LYR_NATCALC   = $LYR_NATCALC
  LYR_NATPH     = $LYR_NATPH
  LYR_NATOMEGAC = $LYR_NATOMEGAC
  LYR_NATOMEGAA = $LYR_NATOMEGAA
  LYR_DIC13     = $LYR_DIC13
  LYR_DIC14     = $LYR_DIC14
  LYR_D13C      = $LYR_D13C
  LYR_D14C      = $LYR_D14C
  LYR_BIGD14C   = $LYR_BIGD14C
  LYR_POC13     = $LYR_POC13
  LYR_DOC13     = $LYR_DOC13
  LYR_CALC13    = $LYR_CALC13
  LYR_PHYTO13   = $LYR_PHYTO13
  LYR_GRAZER13  = $LYR_GRAZER13
  LYR_CFC11     = $LYR_CFC11
  LYR_CFC12     = $LYR_CFC12
  LYR_SF6       = $LYR_SF6
  LYR_NOS       = $LYR_NOS
  LYR_WPHY      = $LYR_WPHY
  LYR_WNOS      = $LYR_WNOS
  LYR_EPS       = $LYR_EPS
  LYR_ASIZE     = $LYR_ASIZE
  LYR_DP        = $BGC_DP
  LYR_BROMO     = $LYR_BROMO
  LVL_PHYTO     = $LVL_PHYTO
  LVL_GRAZER    = $LVL_GRAZER
  LVL_DOC       = $LVL_DOC
  LVL_PHOSY     = $LVL_PHOSY
  LVL_PHOSPH    = $LVL_PHOSPH
  LVL_OXYGEN    = $LVL_OXYGEN
  LVL_IRON      = $LVL_IRON
  LVL_ANO3      = $LVL_ANO3
  LVL_ALKALI    = $LVL_ALKALI
  LVL_SILICA    = $LVL_SILICA
  LVL_DIC       = $LVL_DIC
  LVL_POC       = $LVL_POC
  LVL_CALC      = $LVL_CALC
  LVL_OPAL      = $LVL_OPAL
  LVL_CO3       = $LVL_CO3
  LVL_N2O       = $LVL_N2O
  LVL_PH        = $LVL_PH
  LVL_OMEGAC    = $LVL_OMEGAC
  LVL_OMEGAA    = $LVL_OMEGAA
  LVL_PREFO2    = $LVL_PREFO2
  LVL_O2SAT     = $LVL_O2SAT
  LVL_PREFPO4   = $LVL_PREFPO4
  LVL_PREFALK   = $LVL_PREFALK
  LVL_PREFDIC   = $LVL_PREFDIC
  LVL_DICSAT    = $LVL_DICSAT
  LVL_NATDIC    = $LVL_NATDIC
  LVL_NATALKALI = $LVL_NATALKALI
  LVL_NATCO3    = $LVL_NATCO3
  LVL_NATCALC   = $LVL_NATCALC
  LVL_NATPH     = $LVL_NATPH
  LVL_NATOMEGAC = $LVL_NATOMEGAC
  LVL_NATOMEGAA = $LVL_NATOMEGAA
  LVL_DIC13     = $LVL_DIC13
  LVL_DIC14     = $LVL_DIC14
  LVL_D13C      = $LVL_D13C
  LVL_POC13     = $LVL_POC13
  LVL_DOC13     = $LVL_DOC13
  LVL_CALC13    = $LVL_CALC13
  LVL_PHYTO13   = $LVL_PHYTO13
  LVL_GRAZER13  = $LVL_GRAZER13
  LVL_CFC11     = $LVL_CFC11
  LVL_CFC12     = $LVL_CFC12
  LVL_SF6       = $LVL_SF6
  LVL_NOS       = $LVL_NOS
  LVL_WPHY      = $LVL_WPHY
  LVL_WNOS      = $LVL_WNOS
  LVL_EPS       = $LVL_EPS
  LVL_ASIZE     = $LVL_ASIZE
  LVL_BROMO     = $LVL_BROMO
  FLX_SEDIFFIC  = $FLX_SEDIFFIC
  FLX_SEDIFFAL  = $FLX_SEDIFFAL
  FLX_SEDIFFPH  = $FLX_SEDIFFPH
  FLX_SEDIFFOX  = $FLX_SEDIFFOX
  FLX_SEDIFFN2  = $FLX_SEDIFFN2
  FLX_SEDIFFNO3 = $FLX_SEDIFFNO3
  FLX_SEDIFFSI  = $FLX_SEDIFFSI
  SDM_POWAIC    = $SDM_POWAIC
  SDM_POWAAL    = $SDM_POWAAL
  SDM_POWAPH    = $SDM_POWAPH
  SDM_POWAOX    = $SDM_POWAOX
  SDM_POWN2     = $SDM_POWN2
  SDM_POWNO3    = $SDM_POWNO3
  SDM_POWASI    = $SDM_POWASI
  SDM_SSSO12    = $SDM_SSSO12
  SDM_SSSSIL    = $SDM_SSSSIL
  SDM_SSSC12    = $SDM_SSSC12
  SDM_SSSTER    = $SDM_SSSTER
  BUR_SSSO12    = $BUR_SSSO12
  BUR_SSSSIL    = $BUR_SSSSIL
  BUR_SSSC12    = $BUR_SSSC12
  BUR_SSSTER    = $BUR_SSSTER
/
EOF
endif

end ## foreach mem ("`seq $NINST_OCN`")

#------------------------------------------------------------------------------
# Generate blom.input_data_list
#------------------------------------------------------------------------------

cat > $CASEBUILD/blom.input_data_list << EOF
grid_file = `echo $GRFILE | tr -d '"' | tr -d "'"`
meridional_transport_index_file = `echo $MER_MIFILE | tr -d '"' | tr -d "'"`
meridional_transport_basin_file = `echo $MER_ORFILE | tr -d '"' | tr -d "'"`
section_index_file = `echo $SEC_SIFILE | tr -d '"' | tr -d "'"`
tidal_dissipation_file = `echo $TDFILE | tr -d '"' | tr -d "'"`
EOF
if ($SWAMTH == "'chlorophyll'") then
cat >> $CASEBUILD/blom.input_data_list << EOF
chlorophyll_concentration_file = `echo $CCFILE | tr -d '"' | tr -d "'"`
EOF
endif
if ($SRXDAY != "0.") then
cat >> $CASEBUILD/blom.input_data_list << EOF
sss_climatology_file = `echo $SCFILE | tr -d '"' | tr -d "'"`
EOF
endif

# iHAMOCC boundary conditions
if ($ecosys == TRUE) then
cat >> $CASEBUILD/blom.input_data_list << EOF
dust_file = `echo $FEDEPFILE | tr -d '"' | tr -d "'"`
EOF
  if ($BLOM_RIVER_NUTRIENTS == TRUE) then
cat >> $CASEBUILD/blom.input_data_list << EOF
river_file = `echo $RIVINFILE | tr -d '"' | tr -d "'"`
EOF
  endif
  if ($BLOM_N_DEPOSITION == TRUE) then
cat >> $CASEBUILD/blom.input_data_list << EOF
n_deposition_file = `echo $NDEPFILE | tr -d '"' | tr -d "'"`
EOF
  endif
  if ($BGCOAFX_OALKFILE != "''") then
cat >> $CASEBUILD/blom.input_data_list << EOF
oafx_file = `echo $BGCOAFX_OALKFILE | tr -d '"' | tr -d "'"`
EOF
  endif
  if ($HAMOCC_VSLS == TRUE) then
cat >> $CASEBUILD/blom.input_data_list << EOF
swa_clim_file = `echo $SWACLIMFILE | tr -d '"' | tr -d "'"`
EOF
  endif
  if ($L_3DVARSEDPOR == TRUE) then
cat >> $CASEBUILD/blom.input_data_list << EOF
sed_porosity_file = `echo $SEDPORFILE | tr -d '"' | tr -d "'"`
EOF
  endif
endif

# BLOM initial conditions
cat >> $CASEBUILD/blom.input_data_list << EOF
inicon_file = `echo $ICFILE | tr -d '"' | tr -d "'"`
EOF


# iHAMOCC initial conditions
if ($ecosys == TRUE) then
cat >> $CASEBUILD/blom.input_data_list << EOF
inidic_file = `echo $INIDIC | tr -d '"' | tr -d "'"`
inialk_file = `echo $INIALK | tr -d '"' | tr -d "'"`
inipo4_file = `echo $INIPO4 | tr -d '"' | tr -d "'"`
inioxy_file = `echo $INIOXY | tr -d '"' | tr -d "'"`
inino3_file = `echo $ININO3 | tr -d '"' | tr -d "'"`
inisil_file = `echo $INISIL | tr -d '"' | tr -d "'"`
EOF
  if ($HAMOCC_CISO == TRUE) then
cat >> $CASEBUILD/blom.input_data_list << EOF
inic13_file = `echo $INID13C | tr -d '"' | tr -d "'"`
inic14_file = `echo $INID14C | tr -d '"' | tr -d "'"`
EOF
  endif
  if ($RUN_TYPE == startup) then
    if ($ICFILE =~ *.blom.r.*) then
cat >> $CASEBUILD/blom.input_data_list << EOF
inicon_bgc_file = `echo $ICFILE | sed 's/.blom.r./.blom.rbgc./' | tr -d '"' | tr -d "'"`
EOF
    else if ($ICFILE =~ *.micom.r.*) then
cat >> $CASEBUILD/blom.input_data_list << EOF
inicon_bgc_file = `echo $ICFILE | sed 's/.micom.r./.micom.rbgc./' | tr -d '"' | tr -d "'"`
EOF
    endif
  endif
endif

