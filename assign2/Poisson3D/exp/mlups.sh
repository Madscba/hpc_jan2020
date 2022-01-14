#!/bin/sh 

# Experiment Block size

#BSUB -q hpc
#BSUB -J mlups_seq
#BSUB -n 1
#BSUB -R "rusage[mem=30000MB]"
#BSUB -R "select[model=XeonE5_2650v4]"
#BSUB -R "span[hosts=1] affinity[socket(1)]"
#BSUB -M 30GB
#BSUB -W 180
###BSUB -B 
#BSUB -N 
#BSUB -o O_ratio_1_%J.out 
#BSUB -e E_ratio_1_%J.err 

#CC=${1-"gcc"}
EXECUTABLE_J="../poisson_j"
EXECUTABLE_GS="../poisson_gs"
LOGEXT=$CC.dat



lscpu
ndim="8 16 32 64 128 256 512 1024"
START_T=16
/bin/rm -f "./perf_j$LOGEXT"
/bin/rm -f "./perf_gs$LOGEXT"
for n in $ndim
do
	echo $EXECUTABLE__J  $n 1000 0.0 $START_T 0 1
	$EXECUTABLE_J $n 1000 0.0 $START_T 0 1  | grep -v CPU >> ./perf_j$LOGEXT

	echo $EXECUTABLE__GS  $n 1000 0.0 $START_T 0 1
	$EXECUTABLE_GS $n 1000 0.0 $START_T 0 1  | grep -v CPU >> ./perf_gs$LOGEXT
done

exit 0

