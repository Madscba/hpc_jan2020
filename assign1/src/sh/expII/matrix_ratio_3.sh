#!/bin/sh 

# Experiment II - ratio 3

#BSUB -q hpcintro
#BSUB -J mat_rat_3
#BSUB -n 1
#BSUB -R "rusage[mem=1024MB]"
#BSUB -R "select[model=XeonE5_2650v4]"
#BSUB -R "span[hosts=1] affinity[socket(1)]"
#BSUB -M 4GB
#BSUB -W 60
###BSUB -B 
#BSUB -N 
#BSUB -o O_ratio_3_%J.out 
#BSUB -e E_ratio_3_%J.err 

module load studio

#CC=${1-"gcc"}
EXECUTABLE=matmult_c.gcc
SRCPATH="src/"
RPATH=$"/zhome/87/9/127623/Desktop/02461_hpc/assignments/hpc_jan2020/assign1/"
DPATH=$"data/expII/"
NPARTS="5 7 10 14 21 29 42 59 84 119 168 238 337 477 674 954 1349"
EXECUTABLE=matmult_c.gcc
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
		echo ./matmult_c.${CC} $perm $mdim
    		#collect -o $EXPOUT $HWCOUNT ./$EXECUTABLE $perm $mdim $mdim $(($mdim*4)) | grep -v CPU >> $RPATH/$DPATH/ratio_3_$perm.$LOGEXT
		./$EXECUTABLE $perm $mdim $mdim $(($mdim*4)) | grep -v CPU >> $RPATH/$DPATH/ratio_3_$perm.$LOGEXT
	done
done

exit 0

