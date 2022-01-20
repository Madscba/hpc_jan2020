#!/bin/sh 

# GPU1 solution - varying size

#BSUB -J matmult_gpu1
#BSUB -q hpcintrogpu 
#BSUB -n 1 
#BSUB -R "span[hosts=1]"  
#BSUB -gpu "num=1:mode=exclusive_process"  
#BSUB -W 20 
#BSUB -R "rusage[mem=4024MB]"
#BSUB -N 
#BSUB -o O_gpu_nat_%J.out 
#BSUB -e E_gpu_nat_%J.err 

module load cuda/11.5.1 
#CC=${1-"gcc"}
EXECUTABLE=matmult_f.nvcc
NPARTS="103 146 206 292 413 584 826 1168 1652 2336 3304 4672 6602 9344"
LOGEXT=$CC.dat
lscpu
nvidia-smi


#export MFLOPS_MAX_IT=100
export MATMULT_COMPARE=0

cd ".."

/bin/rm -f "./performance/gpu1$LOGEXT"
for mdim in $NPARTS
do
    echo ../$EXECUTABLE $mdim
        #collect -o $EXPOUT $HWCOUNT ./$EXECUTABLE $perm $mdim $mdim $mdim | grep -v CPU >> $RPATH/$DPATH/ratio_1_$perm.$LOGEXT
    ./$EXECUTABLE gpu1 $mdim $mdim $mdim | grep -v CPU >> ./performance/gpu1$LOGEXT
done

exit 0




