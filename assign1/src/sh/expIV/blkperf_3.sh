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
DPATH=$"data/expIV/ex_blockperf"
BLOCKSIZE="103"
PERM="blk"
LOGEXT=$CC.dat


#export MFLOPS_MAX_IT=100
export MATMULT_COMPARE=0
JID=${LSB_JOBID}
EXPOUT="$LSB_JOBNAME.${JID}.er"
HWCOUNT="-h dch,on,dcm,on,l2h,on,l2m,on"


lscpu
cd "$RPATH/$SRCPATH"
NPARTS=(9 12 18 25 36 51 73 103 146 206 292 413 584 826 1168 1652 2336)
/bin/rm -f "$RPATH/$DPATH/blk3_perf_1$LOGEXT"
for i in $(seq 1 17)
do
	echo ./$EXECUTABLE blk ${NPARTS[i]} $BLOCKSIZE
		#collect -o $EXPOUT $HWCOUNT ./$EXECUTABLE $perm $mdim $mdim $mdim | grep -v CPU >> $RPATH/$DPATH/ratio_1_$perm.$LOGEXT
	./$EXECUTABLE blk ${NPARTS[i]} ${NPARTS[i]} ${NPARTS[i]} $BLOCKSIZE | grep -v CPU >> $RPATH/$DPATH/blk3_perf_1$LOGEXT
done
NPARTS=(3 4 6 9 12 18 25 36 51 73 103 146 206 292 413 584 826)
/bin/rm -f "$RPATH/$DPATH/blk3_perf_2$LOGEXT"
for i in $(seq 1 17)
do
	echo ./$EXECUTABLE blk ${NPARTS[i]} $BLOCKSIZE
		#collect -o $EXPOUT $HWCOUNT ./$EXECUTABLE $perm $mdim $mdim $mdim | grep -v CPU >> $RPATH/$DPATH/ratio_1_$perm.$LOGEXT
	./$EXECUTABLE blk $((${NPARTS[i]}*4)) $((${NPARTS[i]}*4)) ${NPARTS[i]} $BLOCKSIZE | grep -v CPU >> $RPATH/$DPATH/blk3_perf_2$LOGEXT
done
NPARTS=(5 7 10 14 21 29 42 59 84 119 168 238 337 477 674 954 1349)
/bin/rm -f "$RPATH/$DPATH/blk3_perf_3$LOGEXT"
for i in $(seq 1 17)
do
	echo ./$EXECUTABLE blk ${NPARTS[i]} $BLOCKSIZE
		#collect -o $EXPOUT $HWCOUNT ./$EXECUTABLE $perm $mdim $mdim $mdim | grep -v CPU >> $RPATH/$DPATH/ratio_1_$perm.$LOGEXT
	./$EXECUTABLE blk ${NPARTS[i]} ${NPARTS[i]} $((${NPARTS[i]}*4)) $BLOCKSIZE | grep -v CPU >> $RPATH/$DPATH/blk3_per_3$LOGEXT
done


exit 0

