#!/bin/bash -x
#
# Verifica se foi passado algum parametro
if (($#<2)) ; then
echo "Use: "
fi
Run_Date=${1}
ifct=${2}

# VARIAVEIS
export Dir_scr=/home/nicole/workdir/Versions/eta-v1.4.3-fms/datain/scripts/BESMT062
export Dir_home=`dirname ${Dir_scr}` 
export Dir_datain=`dirname ${Dir_home}` 
export ModelDrive=`basename ${Dir_scr}`
export Dir_wrk=${Dir_datain}/atmos/${ModelDrive}/${Run_Date}
export Dir_ETAwrk=${Dir_datain}/atmos/ETAwrk/${ModelDrive}/${Run_Date}
export Dir_util=${Dir_datain}/util
export Dir_dprep_exe=${Dir_datain}/dprep/exe
export InitBC=6
export IntSST=24
export FInitBC=gposeta

FInitBC_Up=`echo ${FInitBC}|awk '{print toupper($1)}'`
cp ${Dir_scr}/InputModelInf.txt_${FInitBC} ${Dir_ETAwrk}/InputModelInf.txt

me=$(whoami)
echo "I am $me."

cd ${Dir_wrk}

dhr=`printf "%06d" "${ifct}"`
if [ "${dhr}" == "000000" ]  ; then
   datef=${Run_Date}
   ffct=icn
else
   datei=${Run_Date}
   datef=`${Dir_util}/caldate.3.0 ${Run_Date}   + ${InitBC}hr 'yyyymmddhh'`
   ffct=fct
fi
ifile=${Dir_wrk}/${FInitBC_Up}${Run_Date}${datef}E.${ffct}.TQ0062L042
ofile=${Dir_ETAwrk}/${ModelDrive}_${Run_Date}.${dhr}
echo '==================================================='
echo 'file in process '${ifile}
echo '==================================================='

echo ${Run_Date} > ${Dir_ETAwrk}/adate.txt
ln -s ${ifile} ${ofile}
${Dir_dprep_exe}/dg${FInitBC}.exe << endin
${ofile}
${Dir_ETAwrk}
endin
if [ -s ${ofile}.ETAwrk ]  ; then
  exit 0
else
${Dir_dprep_exe}/dg${FInitBC}.exe << endin
${ofile}
${Dir_ETAwrk}
endin
echo "${ofile}.ETAwrk" >> ${Dir_ETAwrk}/${ModelDrive}.ETAwrk.list
  if [ ! -s ${ofile}.ETAwrk ]  ; then
    echo "Verificar ${ifile}" >> ${Dir_ETAwrk}/${ModelDrive}.ETAwrk.list
    exit 1
  fi
fi
