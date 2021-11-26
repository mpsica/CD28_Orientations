#!/bin/bash

usage (){
echo "
  This script requires as input a trajectory file in .gro format
  containing only coords of CA atoms produced as usual
  with ''trjconv'' tool from GROMACS package

    Usage:
        $0 [opciones] [nombre de la trayectoria]

  After running, copy #CA= 224; Frames: 2446
"
}


[[ $# -lt 1 ]] && usage && exit


################################################
# Processing 
################################################

for PROT in $@
  do
  		PROT=$(echo ${PROT}|sed 's/\.gro//g')
      FILE=${PROT}.gro

  #		Copy CA coords
  		egrep -v [a-z] ${FILE} | grep CA | awk 'NF=6{print $4, $5, $6}' >  ${PROT}.dat

  #		Count frame number
  		FRAMES=$(egrep t= ${FILE} | wc -l)
  		NCA=$(egrep CA ${FILE} | wc -l)
  		echo "
      Filename = ${PROT}.dat
      Number of CA atoms = $((${NCA} / ${FRAMES}))
      Number of frames = ${FRAMES}"

      echo "
      Add this line to input_list in the R script
      \"${PROT}\" = c(${PROT}.dat, $((${NCA} / ${FRAMES})), ${FRAMES}, choose a #color)
      "

  done		


