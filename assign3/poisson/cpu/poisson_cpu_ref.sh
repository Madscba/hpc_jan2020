#!/bin/sh 

# Reference CPU solution - varying size

###				QUEUE?
#BSUB -q hpc
#BSUB -J poisson_ref_cpu
#BSUB -n 1
#BSUB -R "rusage[mem=1024MB]"
#BSUB -R "select[model=XeonE5_2650v4]"
#BSUB -R "span[hosts=1]"
#BSUB -M 4GB
#BSUB -W 40
###BSUB -B 
#BSUB -N 
#BSUB -o O_cpu_%J.out 
#BSUB -e E_cpu_%J.err 

#CC=${1-"gcc"}
NDIMS="4 8 16 32 64 128 256"
START_T=16
EXECUTABLE_J="./poisson_j"
THREADS="1"
lscpu
LOGEXT=$CC.dat
export OMP_DISPLAY_ENV=verbose
export OMP_DISPLAY_AFFINITY=TRUE
for NDIM in $NDIMS
do
	/bin/rm -f "./perf_j_$NDIM$LOGEXT"
	export OMP_NUM_THREADS=$(THREADS)
	echo $EXECUTABLE_J  $NDIM 3000 $START_T 0 1 $n
	$EXECUTABLE_J $NDIM 3000 $START_T 0 1  | grep -v CPU >> ./cpu_$NDIM$LOGEXT

done

exit 0

