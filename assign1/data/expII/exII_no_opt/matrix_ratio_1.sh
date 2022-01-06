#!/bin/sh 

# Experiment II - ratio 1

#BSUB -q hpcintro
#BSUB -J mat_rat_1
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

#CC=${1-"gcc"}
EXECUTABLE=matmult_c.gcc
SRCPATH="src/"
RPATH=$"/zhome/87/9/127623/Desktop/02461_hpc/assignments/hpc_jan2020/assign1/"
DPATH=$"data/expII/"
NPARTS="9 12 18 25 36 51 73 103 146 206 292 413 584 826 1168 1652 2336"
PERM="mnk mkn nmk nkm kmn knm"
LOGEXT=$CC.dat


#export MFLOPS_MAX_IT=100
export MATMULT_COMPARE=0
JID=${LSB_JOBID}
EXPOUT="$LSB_JOBNAME.${JID}.er"
HWCOUNT="-h dch,on,dcm,on,l2h,on,l2m,on"


lscpu
cd "$RPATH/$SRCPATH"


for perm in $PERM
do
	for mdim in $NPARTS
	do
		echo ./$EXECUTABLE $perm $mdim
    		#collect -o $EXPOUT $HWCOUNT ./$EXECUTABLE $perm $mdim $mdim $mdim | grep -v CPU >> $RPATH/$DPATH/ratio_1_$perm.$LOGEXT
		./$EXECUTABLE $perm $mdim $mdim $mdim | grep -v CPU >> $RPATH/$DPATH/ratio_1_$perm.$LOGEXT
	done
done

exit 0

