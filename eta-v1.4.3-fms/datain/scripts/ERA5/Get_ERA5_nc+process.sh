#!/bin/bash 
#
# Get_ERA5_nc+process.sh yyyymmddhh nhour
# yyyymmddhh : initial date to start to get data
#       nhour: number of hours of data download 
#              frequency 6/6h

# Check input parameter 
if (($#<2)) ; then
  echo "      Get_ERA5_nc+process.sh yyyymmddhh nhour"
  echo "      yyyymmddhh : initial date to start to get data"
  echo "      nhour: number of hours of data download"
  echo "      frequency 6/6h"
  exit 1
fi

export Run_Date=${1}
export nhours=${2}
yyyyi=${Run_Date:0:4} 
mmi=${Run_Date:4:2}
ddi=${Run_Date:6:2} 
hhi=${Run_Date:10:2}

# VARIAVEIS
Dir_scr=/home/nicole/workdir/Versions/eta-v1.4.3-fms/datain/scripts/ERA5
Dir_home=`dirname ${Dir_scr}`
Dir_datain=`dirname ${Dir_home}`
ModelDrive=`basename ${Dir_scr}`
Dir_wrk=${Dir_datain}/atmos/${ModelDrive}/${Run_Date}
Dir_ETAwrk=${Dir_datain}/atmos/ETAwrk/${ModelDrive}/${Run_Date}
Dir_ETAwrk_SST=${Dir_datain}/atmos/ETAwrk/${ModelDrive}/${Run_Date}
Dir_util=${Dir_datain}/util
InitBC=6
FInitBC=${ModelDrive}

LastArq="False"
tval=000000
tvalF=`printf "%06d" "${tval}"`
nhours=`printf "%06d" "${nhours}"`


rm -f ${Dir_scr}/Submit_deco.list

# PbsSlurm
cat <<EOF> ${Dir_scr}/Submit_deco.list
#!/bin/bash -x
#SBATCH -n 1
#SBATCH --time=30:50:00
#SBATCH -p triton16
#SBATCH -V
#SBATCH -J ERA52Eta
#SBATCH --output=ERA5_ETAwrk.out
######################

EOF


while [ "${LastArq}" != "True" ] ; do
Dir_wrk=${Dir_datain}/atmos/${ModelDrive}/${Run_Date}
Dir_ETAwrk=${Dir_datain}/atmos/ETAwrk/${ModelDrive}/${Run_Date}
Dir_ETAwrk_SST=${Dir_datain}/sst/ETAwrk/${ModelDrive}/${Run_Date}
if [ ! -d ${Dir_wrk} ] ; then
  mkdir -p  ${Dir_wrk}
fi
if [ ! -d ${Dir_ETAwrk} ] ; then
  mkdir -p  ${Dir_ETAwrk}
fi
if [ ! -d ${Dir_ETAwrk_SST} ] ; then
  mkdir -p  ${Dir_ETAwrk_SST}
fi
cd ${Dir_wrk}
python3 ${Dir_scr}/get_ERA5_nc.py ${Run_Date:0:4} ${Run_Date:4:2} ${Run_Date:6:2} ${Run_Date:8:2} 
cat <<EOF> ${Dir_wrk}/Submit_deco${Run_Date}
#!/bin/bash -x

cd ${Dir_wrk}
cdo -f grb -copy ${Dir_wrk}/ERA5_Pressure_${Run_Date}.nc ${Dir_wrk}/ERA5_Pressure_${Run_Date}.grib
cdo -f grb -copy ${Dir_wrk}/ERA5_Surface_${Run_Date}.nc ${Dir_wrk}/ERA5_Surface_${Run_Date}.grib
cdo -f grb -copy ${Dir_wrk}/ERA5_SST_${Run_Date}.nc ${Dir_ETAwrk_SST}/ERA5_SST_${Run_Date}.grib
${Dir_scr}/deco_ERA5_SST.sh ${Run_Date}
${Dir_scr}/deco_ERA5.sh ${Run_Date}
EOF
  chmod 755 ${Dir_wrk}/Submit_deco${Run_Date}
  echo "${Dir_wrk}/Submit_deco${Run_Date}" >> ${Dir_scr}/Submit_deco.list
  if [ "${tvalF}" == "${nhours}" ] ; then
    GlobalOK="True"
    break
  fi
  let tval=${tval}+${InitBC}
  tvalF=`printf "%06d" "${tval}"`
  Run_Date=`date -d "${yyyyi}-${mmi}-${ddi} ${hhi} +${tval} hour" "+%Y%m%d%H"`
done

# QueueCmd
sbatch ${Dir_scr}/Submit_deco.list

exit
