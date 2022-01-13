#!/bin/sh 

# Experiment II - ratio 1

#BSUB -q hpcintro
#BSUB -J converge
#BSUB -n 1
#BSUB -R "rusage[mem=1024MB]"
#BSUB -R "select[model=XeonE5_2650v4]"
#BSUB -R "span[hosts=1] affinity[socket(1)]"
#BSUB -M 4GB
#BSUB -W 60
###BSUB -B 
#BSUB -N 
#BSUB -o O_ratio_1_%J.out 
#BSUB -e E_ratio_1_%J.err 

#CC=${1-"gcc"}
LOGEXT=$CC.dat



lscpu
/bin/rm -f "converge_j$LOGEXT"
echo N-Analytical J
../poisson_j 100 10000 0.0 16 0 | grep -v CPU >> ./converge_j$LOGEXT
/bin/rm -f "converge_gs$LOGEXT"
echo N-Analytical GS
../poisson_gs 100 10000 0.0 16 0 | grep -v CPU >> ./converge_gs$LOGEXT

exit 0

