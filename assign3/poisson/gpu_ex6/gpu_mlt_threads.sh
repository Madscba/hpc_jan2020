#!/bin/sh 

# GPU solution with one threads per element in U - varying size

#BSUB -J poisson_ref_gpu_mlt 
#BSUB -q hpcintrogpu 
#BSUB -n 1 
#BSUB -R "span[hosts=1]"  
#BSUB -gpu "num=1:mode=exclusive_process"  
#BSUB -W 20 
#BSUB -R "rusage[mem=1024MB]"
#BSUB -N 
#BSUB -o O_gpu_nat_%J.out 
#BSUB -e E_gpu_nat_%J.err  
 
export TMPDIR=$__LSF_JOB_TMPDIR__ 
module load cuda/11.5.1 
 
export MFLOPS_MAX_IT=1 

LOGEXT=$CC.dat
NDIMS="256"
EXECUTABLE_J="poisson_gpu"
lscpu

for NDIM in $NDIMS
do
	echo $EXECUTABLE_J $NDIM 1000 1 1
	nv-nsight-cu-cli -o profile_$LSB_JOBID \
	--section ComputeWorkloadAnalysis \
	--section LaunchStats \
	--section MemoryWorkloadAnalysis \
	--section MemoryWorkloadAnalysis_Chart \
	--section MemoryWorkloadAnalysis_Tables \
	--section SpeedOfLight \
	--section SpeedOfLight_HierarchicalDoubleRooflineChart \
	--section SpeedOfLight_HierarchicalSingleRooflineChart \
	--target-processes all ./$EXECUTABLE_J $perm 10 1 1	

	##./$EXECUTABLE_J $NDIM 1000 1 1 | grep -v CPU >> ./gpu_$LOGEXT

done

exit 0

