#!/bin/sh 

# Experiment Block size

#BSUB -q hpcintro
#BSUB -J mat_blksize
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
EXECUTABLE="../poisson_j"
LOGEXT=$CC.dat



lscpu
ndim="100"
BLOCKSIZE="0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0"
for start in $BLOCKSIZE
do
	/bin/rm -f "./size_a_$start$LOGEXT"
	echo $EXECUTABLE  $start
	$EXECUTABLE $ndim 4000 0.0 $start 1 | grep -v CPU >> ./size_a_$start$LOGEXT
done

BLOCKSIZE="2 4 6 8 10 12 14 16 18 20 22"
for start in $BLOCKSIZE
do
	/bin/rm -f "./size_$start$LOGEXT"
	echo $EXECUTABLE  $start
	$EXECUTABLE $ndim 4000 0.0 $start 0 | grep -v CPU >> ./size_$start$LOGEXT
done

exit 0

