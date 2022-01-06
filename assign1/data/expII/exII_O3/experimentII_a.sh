#!/bin/sh

# Experiment II a - SQR
CC=${1-"gcc"}
LOGEXT=$CC.dat
RPATH=$"/zhome/87/9/127623/Desktop/02461_hpc/assignments/hpc_jan2020/assign1/"
DPATH=$"data/expII/"
SHPATH=$"src/sh/expII/"

echo Experiment II a

cd "$RPATH/$DPATH"
/bin/rm -f *.$LOGEXT


cd "$RPATH/$SHPATH"

bsub < matrix_ratio_1.sh
bsub < matrix_ratio_2.sh
bsub < matrix_ratio_3.sh


exit 0

