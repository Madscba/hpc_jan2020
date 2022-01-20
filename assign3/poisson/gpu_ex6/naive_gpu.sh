#!/bin/sh 

# Naive GPU solution - varying size

#
#BSUB -q hpcintrogpu
#BSUB -J poisson_ref_gpu_nat
#BSUB -n 1
#BSUB -R "rusage[mem=1024MB]"
#BSUB -R "select[model=XeonE5_2650v4]"
#BSUB -R "span[hosts=1]"
##BSUB -gpu "num=1:mode=exclusive_process"
#BSUB -M 4GB
#BSUB -W 40
###BSUB -B 
#BSUB -N 
#BSUB -o O_gpu_nat_%J.out 
#BSUB -e E_gpu_nat_%J.err 

#CC=${1-"gcc"}
NDIMS="4 8 16 32 64 128 256"
START_T=16
EXECUTABLE_J="../poisson_gpu"
THREADS="1"
lscpu
LOGEXT=$CC.dat

for NDIM in $NDIMS
do
	/bin/rm -f "./perf_j_$NDIM$LOGEXT"
	export OMP_NUM_THREADS=$n
	echo $EXECUTABLE_J  $NDIM 3000 0.0 $START_T 0 1 $n
	$EXECUTABLE_J $NDIM 3000 0.0 $START_T 0 1  | grep -v CPU >> ./perf_numa_$NDIM$LOGEXT

done

exit 0

