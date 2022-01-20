#!/bin/sh 

# Naive GPU solution - varying size

#BSUB -J poisson_ref_gpu_nat 
#BSUB -q hpcintrogpu 
#BSUB -n 1 
#BSUB -R "span[hosts=1]"  
#BSUB -R "select[model=XeonGold6126]"
#BSUB -gpu "num=1:mode=exclusive_process"  
#BSUB -W 10 
#BSUB -R "rusage[mem=2048MB]"
#BSUB -N 
#BSUB -o O_gpu_nat_%J.out 
#BSUB -e E_gpu_nat_%J.err  
 
export TMPDIR=$__LSF_JOB_TMPDIR__ 
module load cuda/11.5.1 
 
export MFLOPS_MAX_IT=1 

LOGEXT=$CC.dat
NDIMS="4 8 16 32 64 128 256"
EXECUTABLE_J="poisson_gpu"
lscpu

for NDIM in $NDIMS
do
	echo $EXECUTABLE_J $NDIM 10000 1 1
	./$EXECUTABLE_J $NDIM 10000 1 1 | grep -v CPU >> ./gpu_$NDIM$LOGEXT

done

exit 0

