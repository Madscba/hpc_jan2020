#!/bin/sh 

# Experiment Block size

#BSUB -q hpc
#BSUB -J mlups_omp1
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

#CC=${1-"gcc"}
NDIM=256
START_T=16
EXECUTABLE_J="../poisson_j"
EXECUTABLE_GS="../poisson_gs"
THREADS="1 2 4 6 8 10 12 14 16 18 20 22 24"
lscpu
LOGEXT=$CC.dat
export OMP_DISPLAY_ENV=verbose
export OMP_DISPLAY_AFFINITY=TRUE
export OMP_PROC_PLACES=24
export OMP_PROC_BIND=spread #close
/bin/rm -f "./perf_j$LOGEXT"
/bin/rm -f "./perf_gs$LOGEXT"


for n in $THREADS
do
	
	export OMP_NUM_THREADS=$n
	echo $EXECUTABLE_J  $NDIM 3000 0.0 $START_T 0 1
	$EXECUTABLE_J $NDIM 3000 0.0 $START_T 0 1  | grep -v CPU >> ./perf_j$LOGEXT

	export OMP_NUM_THREADS=$n
	echo $EXECUTABLE_GS  $NDIM 3000 0.0 $START_T 0 1
	$EXECUTABLE_GS $NDIM 3000 0.0 $START_T 0 1  | grep -v CPU >> ./perf_gs$LOGEXT
done

exit 0

