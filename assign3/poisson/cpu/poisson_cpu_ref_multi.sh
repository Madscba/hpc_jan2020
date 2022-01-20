#!/bin/sh 

# Reference CPU solution - varying size

###				QUEUE?
#BSUB -q hpc
#BSUB -J poisson_ref_cpu_multi
#BSUB -n 24
#BSUB -R "rusage[mem=1024MB]"
#BSUB -R "select[model=XeonGold6126]"
#BSUB -R "span[hosts=1]"
#BSUB -M 4GB
#BSUB -W 40
###BSUB -B 
#BSUB -N 
#BSUB -o O_cpu_%J.out 
#BSUB -e E_cpu_%J.err 

#CC=${1-"gcc"}
##NDIMS="4 8 16 32 64 128 256"
NDIMS="512 1024"
EXECUTABLE_J="poisson_j"
THREADS="12"
lscpu
LOGEXT=$CC.dat
module load cuda/11.5.1

cd /zhome/87/9/127623/Desktop/hpc_jan2022/assign3/poisson/cpu
export OMP_DISPLAY_ENV=verbose
export OMP_DISPLAY_AFFINITY=TRUE
export OMP_PLACES=cores
export OMP_PROC_BIND=spread #close

for NDIM in $NDIMS
do
	export OMP_NUM_THREADS=$THREADS
	echo $EXECUTABLE_J  $NDIM 1000
	$EXECUTABLE_J $NDIM 1000  | grep -v CPU >> ./cpu_multi$NDIM$LOGEXT

done

exit 0

