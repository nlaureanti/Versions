#!/bin/bash -x
#
# Verifica se foi passado algum parametro
export hh=${1}
if (($#<4)) ; then
  export Run_Date=`date "+%Y%m%d"`${hh}
else
  export Run_Date=${4}${hh}
fi
Fcti=${2}
Fctf=${3}
# VARIAVEIS
Dir_scr=/home/nicole/workdir/Versions/eta-v1.4.3-fms/datain/scripts/gfs2gr0.25
Dir_home=`dirname ${Dir_scr}`
Dir_datain=`dirname ${Dir_home}`
ModelDrive=`basename ${Dir_scr}`
Dir_wrk=${Dir_datain}/atmos/${ModelDrive}/${Run_Date}
Dir_ETAwrk=${Dir_datain}/atmos/ETAwrk/${ModelDrive}/${Run_Date}
Dir_util=${Dir_datain}/util
Fct=${2}
InitBC=6
FInitBC=${ModelDrive}

if [ ! -d ${Dir_wrk} ] ; then
  mkdir -p  ${Dir_wrk}
else
  rm -f ${Dir_wrk}/wget_pgrb2.list
fi
if [ ! -d ${Dir_ETAwrk} ] ; then                              
  mkdir -p ${Dir_ETAwrk}                                      
fi

${Dir_scr}/get_SST_noaa.ksh ${Run_Date:0:8}
${Dir_scr}/get_GFS_wgetParallel.ksh ${hh} ${Fcti} ${Fctf} ${Run_Date:0:8}
rm -f  ${Dir_ETAwrk}/Submit_deco.list

# PbsSlurm
cat <<EOF> ${Dir_ETAwrk}/Submit_deco.list
#!/bin/bash -x
#PBS -j oe
#PBS -l nodes=1:ncpus=1
#PBS -l walltime=04:50:00
#PBS -q pesq
#PBS -V
#PBS -N GFS2Eta
#PBS -o GFS_ETAwrk.out
######################

EOF


LastArq="False"
tval=${Fcti}
tvalF=`printf "%06d" "${tval}"`
FctEndF=`printf "%06d" "${Fctf}"`
yymmdd=`echo ${Run_Date} |cut -c3-8`
while [ "${LastArq}" != "True" ] ; do
cat <<EOF> ${Dir_ETAwrk}/Submit_deco${tvalF}
#!/bin/bash
cd ${Dir_ETAwrk}
${Dir_scr}/gfs2_deco.sh ${Run_Date} ${tval}
EOF
  chmod 755 ${Dir_ETAwrk}/Submit_deco${tvalF}
  if [[ -s ${Dir_ETAwrk}/gfs2_field_rec.txt ]] ; then
     echo "${Dir_ETAwrk}/Submit_deco${tvalF}" >> ${Dir_ETAwrk}/Submit_deco.list
  else
# LineDeco
    echo "${Dir_ETAwrk}/Submit_deco${tvalF}" >> ${Dir_ETAwrk}/Submit_deco.list
  fi
  if [ "${tvalF}" == "${FctEndF}" ] ; then
    GlobalOK="True"
    break
  fi
  let tval=${tval}+${InitBC}
  tvalF=`printf "%06d" "${tval}"`
done
# QueueCmd
qsub ${Dir_ETAwrk}/Submit_deco.list

exit
