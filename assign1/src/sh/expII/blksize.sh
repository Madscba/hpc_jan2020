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

module load studio
ls
#CC=${1-"gcc"}
EXECUTABLE=matmult_c.gcc
SRCPATH="src/"
RPATH=$"/zhome/fa/5/127129/hpc_jan2022/assign1"
DPATH=$"data/expII/ex_blocksize"
mdim="103"
BLOCKSIZE="10 13 16 19 22 25 28 31 34 37 40 43 46 49 52 55"
PERM="blk"
LOGEXT=$CC.dat


#export MFLOPS_MAX_IT=100
export MATMULT_COMPARE=0
JID=${LSB_JOBID}
EXPOUT="$LSB_JOBNAME.${JID}.er"
HWCOUNT="-h dch,on,dcm,on,l2h,on,l2m,on"


lscpu
cd "$RPATH/$SRCPATH"


for bs in $BLOCKSIZE
do
	echo ./$EXECUTABLE blk $mdim $bs
		#collect -o $EXPOUT $HWCOUNT ./$EXECUTABLE $perm $mdim $mdim $mdim | grep -v CPU >> $RPATH/$DPATH/ratio_1_$perm.$LOGEXT
	./$EXECUTABLE blk $mdim $mdim $mdim $bs | grep -v CPU >> $RPATH/$DPATH/blk$LOGEXT
done

exit 0

