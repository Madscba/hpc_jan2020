#!/bin/sh 

# gpu3 solution - varying size

#BSUB -J matmult_gpu3
#BSUB -q hpcintrogpu 
#BSUB -n 16 
#BSUB -R "span[hosts=1]"  
#BSUB -gpu "num=1:mode=exclusive_process"  
#BSUB -W 60 
#BSUB -R "rusage[mem=4024MB]"
#BSUB -N 
#BSUB -o O_gpu_nat_%J.out 
#BSUB -e E_gpu_nat_%J.err 

module load cuda/11.5.1 
#CC=${1-"gcc"}
EXECUTABLE=matmult_f.nvcc
NPARTS="80 128 160 256 320 512 640 1024 1280 2048 2560 4096 5120 8192"
LOGEXT=$CC.dat
lscpu
nvidia-smi


#export MFLOPS_MAX_IT=100
export MATMULT_COMPARE=0

cd ".."

/bin/rm -f "./performance/gpu3$LOGEXT"
for mdim in $NPARTS
do
    echo ../$EXECUTABLE $mdim
        #collect -o $EXPOUT $HWCOUNT ./$EXECUTABLE $perm $mdim $mdim $mdim | grep -v CPU >> $RPATH/$DPATH/ratio_1_$perm.$LOGEXT
    ./$EXECUTABLE gpu3 $mdim $mdim $mdim | grep -v CPU >> ./performance/gpu3$LOGEXT
done

exit 0




