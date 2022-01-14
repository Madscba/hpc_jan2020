#!/bin/sh 

# Experiment Block size

#BSUB -q hpc
#BSUB -J mlups_omp2_settings
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
NDIM=256
START_T=16
EXECUTABLE_J="../poisson_j"
THREADS="12 24"
lscpu
LOGEXT=$CC.dat
SCHEDS="dynamic static"
BINDS="spread close"
CHUNKS="1 2 5 10 25"
export OMP_DISPLAY_ENV=verbose
export OMP_DISPLAY_AFFINITY=TRUE

/bin/rm -f "./perf_j_$NDIM$LOGEXT"
for thread in $THREADS
do
	export OMP_NUM_THREADS=$thread
	for sched in $SCHEDS
	do
		for bind in $BINDS
		do
			export OMP_PROC_BIND=$bind
			for chunk in $CHUNKS
			do
				export OMP_SCHEDULE=$sched,$chunk
				echo $thread $sched $bind $chunk
				$EXECUTABLE_J $NDIM 3000 0.0 $START_T 0 1  | grep -v CPU >> ./perf_$thread"_"$sched"_"$bind$LOGEXT
			done
		done
	done
done

exit 0

