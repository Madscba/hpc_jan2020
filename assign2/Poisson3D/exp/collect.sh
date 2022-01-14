#!/bin/sh 

# Experiment Block size

#BSUB -q hpc
#BSUB -J collect_omp1
#BSUB -n 24
#BSUB -R "rusage[mem=1024MB]"
#BSUB -R "select[model=XeonE5_2650v4]"
#BSUB -R "span[hosts=1]"
#BSUB -M 4GB
#BSUB -W 60
###BSUB -B 
#BSUB -N 
#BSUB -o O_ratio_1_%J.out 
#BSUB -e E_ratio_1_%J.err 
module load studio
#CC=${1-"gcc"}
NDIM=256
START_T=16
EXECUTABLE_J="../poisson_j"
lscpu
LOGEXT=$CC.dat

JID=${LSB_JOBID}
EXPOUT="$LSB_JOBNAME.${JID}.er"
HWCOUNT="-h dch,on,dcm,on,l2h,on,l2m,on"
collect -o $EXPOUT $HWCOUNT ./$EXECUTABLE_J $NDIM 1000 0.0 $START_T 0 1 | grep -v CPU >> ./dummy$LOGEXT



exit 0

