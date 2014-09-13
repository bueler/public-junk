#!/bin/bash

# uses NCO (http://nco.sourceforge.net/)

# files needed:
ln -s ../pism_Antarctica_5km.nc
# also: copy pism_dSL.nc from examples/std-greenland/

# nomass_30km.nc comes from examples/searise-antarctica/antspinCC.sh
FILE=start.nc
cp nomass_30km.nc start.nc

# setup at beginning so changes are significant
echo "  modify $FILE to multiply ice thickness by 1.15 ..."
ncrename -O -v thk,oldthk $FILE
# delete standard_name attribute from oldthk
ncatted -O -a standard_name,oldthk,d,, $FILE
ncap2 -O -s "thk=1.15*oldthk" $FILE $FILE
echo "  modify $FILE to multiply precipitation by 0.7 ..."
ncrename -O -v precipitation,oldprecipitation $FILE
ncap2 -O -s "precipitation=0.7*oldprecipitation" $FILE $FILE
echo "  ... done with preprocess"
echo ""

NN=6
DURATION=116000
OUT=runpippa.nc
echo "  running for $DURATION to generate final file $OUT ..."
echo ""

mpiexec -n $NN pismr -skip -skip_max 10 -i $FILE -sia_e 3.0 \
  -atmosphere given -atmosphere_given_file pism_Antarctica_5km.nc \
  -surface simple \
  -ocean pik,delta_SL -meltfactor_pik 5e-3 -ocean_delta_SL_file pism_dSL.nc \
  -ssa_method fd -ssa_e 0.6 -pik \
  -calving eigen_calving,thickness_calving -eigen_calving_K 2.0e18 -thickness_calving_threshold 200.0 \
  -stress_balance ssa+sia -hydrology null -pseudo_plastic -pseudo_plastic_q 0.25 \
  -till_effective_fraction_overburden 0.02 -tauc_slippery_grounding_lines \
  -topg_to_phi 15.0,40.0,-300.0,700.0 \
  -ys -$DURATION -ye 0 \
  -ts_file ts_$OUT -ts_times -$DURATION:1:0 \
  -extra_file extra_$OUT -extra_times -$DURATION:1000:0 \
  -bed_def lc \
  -extra_vars lat,lon,thk,usurf,velbase_mag,mask,diffusivity,tauc,bmelt,tillwat,temppabase,topg,dbdt \
  -o $OUT
