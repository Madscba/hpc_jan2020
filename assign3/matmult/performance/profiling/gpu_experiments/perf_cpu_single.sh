#!/bin/sh 

# Experiment III

#BSUB -q hpcintrogpu
#BSUB -J profiling_gpu
#BSUB -R "rusage[mem=1024MB]"
#BSUB -n 1 
#BSUB -R "span[hosts=1]"  
#BSUB -gpu "num=1:mode=exclusive_process" 
#BSUB -M 4GB
#BSUB -W 60
###BSUB -B 
#BSUB -N 
#BSUB -o O_ratio_1_%J.out 
#BSUB -e E_ratio_1_%J.err 


export TMPDIR=$__LSF_JOB_TMPDIR__ 
module load cuda/11.5.1 
lscpu
export MFLOPS_MAX_IT=1

##export OMP_DISPLAY_ENV=verbose
##export OMP_DISPLAY_AFFINITY=TRUE
export OMP_PLACES=cores
export OMP_PROC_BIND=spread #close
OMP_NUM_THREADS=1

#CC=${1-"gcc"}
EXECUTABLE=matmult_f.nvcc
SRCPATH="matmult/"
RPATH=$"/zhome/87/9/127623/Desktop/hpc_jan2022/assign3/"
DPATH=$"matmult/performance/profiling/"
PERM=$"lib"
##PERM=$"gpu1 gpu2 gpu3 gpu4 gpu5 gpu6 gpulib"
NPARTS="103 146 206 292 413 584 826 1168 1652 2336 3304 4672 6602 9344"
LOGEXT=$CC.dat


export MFLOPS_MAX_IT=1
export MATMULT_COMPARE=0
JID=${LSB_JOBID}
##EXPOUT="$LSB_JOBNAME.${JID}.er"
##HWCOUNT="-h dch,on,dcm,on,l2h,on,l2m,on"


lscpu
cd "$RPATH/$SRCPATH"


for perm in $PERM
do
	for mdim in $NPARTS
	do
		echo ./$EXECUTABLE $perm $mdim
    		##nv-nsight-cu-cli -o profile_$perm.$LSB_JOBID \
		##--section ComputeWorkloadAnalysis \
		##--section LaunchStats \
		##--section MemoryWorkloadAnalysis \
		##--section MemoryWorkloadAnalysis_Chart \
		##--section MemoryWorkloadAnalysis_Tables \
		##--section SpeedOfLight \
		##--section SpeedOfLight_HierarchicalDoubleRooflineChart \
		##--section SpeedOfLight_HierarchicalSingleRooflineChart \
		##./$EXECUTABLE $perm $mdim $mdim $mdim | grep -v CPU >> $RPATH/$DPATH/$mdim_$perm.$LOGEXT
		MKL_NUM_THREADS=1 numactl --cpunodebind=0 \
		./$EXECUTABLE $perm $mdim $mdim $mdim | grep -v CPU >> $RPATH/$DPATH/$mdim_$perm.$LOGEXT
	done
done

exit 0

