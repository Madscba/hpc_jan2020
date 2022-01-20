#!/bin/sh 

# Multiple GPU solution - varying size

#BSUB -J poisson_ref_2gpu 
#BSUB -q hpcintrogpu 
#BSUB -n 2
#BSUB -R "span[hosts=1]"  
#BSUB -gpu "num=2:mode=exclusive_process"  
#BSUB -W 20 
#BSUB -R "rusage[mem=1024MB]"
#BSUB -N 
#BSUB -o O_2gpu_%J.out 
#BSUB -e E_2gpu_%J.err  

export TMPDIR=$__LSF_JOB_TMPDIR__ 
module load cuda/11.5.1 
 
export MFLOPS_MAX_IT=1 

LOGEXT=$CC.dat
NDIMS="16 32 64 128 256 512"
EXECUTABLE_J="poisson_gpu"
lscpu

for NDIM in $NDIMS
do
	echo $EXECUTABLE_J $NDIM 1000 1 1
	./$EXECUTABLE_J $NDIM 1000 1 1 | grep -v CPU >> ./gpu_$NDIM$LOGEXT

done


exit 0

