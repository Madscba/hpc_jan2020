#!/bin/sh 

# Experiment Block performance

#BSUB -q hpcintro
#BSUB -J mat_blk
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

module load studio
ls
#CC=${1-"gcc"}
EXECUTABLE=matmult_c.gcc
SRCPATH="src/"
RPATH=$"/zhome/fa/5/127129/hpc_jan2022/assign1"
DPATH=$"data/expII/ex_blockperf"
NPARTS="9 12 18 25 36 51 73 103 146 206 292 413 584 826 1168 1652 2336"
BLOCKSIZE="7"
PERM="blk"
LOGEXT=$CC.dat


#export MFLOPS_MAX_IT=100
export MATMULT_COMPARE=0
JID=${LSB_JOBID}
EXPOUT="$LSB_JOBNAME.${JID}.er"
HWCOUNT="-h dch,on,dcm,on,l2h,on,l2m,on"


lscpu
cd "$RPATH/$SRCPATH"


for mdim in $NPARTS
do
	echo ./$EXECUTABLE blk $mdim $BLOCKSIZE
		#collect -o $EXPOUT $HWCOUNT ./$EXECUTABLE $perm $mdim $mdim $mdim | grep -v CPU >> $RPATH/$DPATH/ratio_1_$perm.$LOGEXT
	./$EXECUTABLE blk $mdim $mdim $mdim $BLOCKSIZE | grep -v CPU >> $RPATH/$DPATH/blk_perf$LOGEXT
done

exit 0

