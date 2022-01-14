#!/bin/sh 

# Experiment Block size

#BSUB -q hpc
#BSUB -J mlups_omp1_ndim
#BSUB -n 24
#BSUB -R "rusage[mem=1024MB]"
#BSUB -R "select[model=XeonE5_2650v4]"
#BSUB -R "span[hosts=1]"
#BSUB -M 4GB
#BSUB -W 120
###BSUB -B 
#BSUB -N 
#BSUB -o O_ratio_1_%J.out 
#BSUB -e E_ratio_1_%J.err 

#CC=${1-"gcc"}
NDIMS="64 128 256 512"
START_T=16
EXECUTABLE_J="../poisson_j"
THREADS="1 2 4 6 8 10 12 14 16 18 20 22 24"
lscpu
LOGEXT=$CC.dat
export OMP_DISPLAY_ENV=verbose
export OMP_DISPLAY_AFFINITY=TRUE
export OMP_PROC_PLACES=24

for NDIM in $NDIMS
do
/bin/rm -f "./perf_j_$NDIM$LOGEXT"
for n in $THREADS
do
	
	export OMP_PROC_BIND=spread
	export OMP_NUM_THREADS=$n
	echo $EXECUTABLE_J  $NDIM 3000 0.0 $START_T 0 1 $n
	$EXECUTABLE_J $NDIM 3000 0.0 $START_T 0 1  | grep -v CPU >> ./spread_j_$NDIM$LOGEXT

	export OMP_PROC_BIND=close
	export OMP_NUM_THREADS=$n
	echo $EXECUTABLE_J  $NDIM 3000 0.0 $START_T 0 1 $n
	$EXECUTABLE_J $NDIM 3000 0.0 $START_T 0 1  | grep -v CPU >> ./close_j_$NDIM$LOGEXT

done
done

exit 0

