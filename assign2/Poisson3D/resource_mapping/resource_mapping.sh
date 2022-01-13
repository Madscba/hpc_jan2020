#!/bin/sh 

# Experiment II - ratio 1

#BSUB -q hpcintro
#BSUB -J mat_rat_1
#BSUB -n 32
#BSUB -R "rusage[mem=1024MB]"
#BSUB -R "select[model=XeonE5_2650v4]"
#BSUB -R "span[hosts=1] affinity[socket(1)]"
#BSUB -M 4GB
#BSUB -W 1
###BSUB -B 
#BSUB -N 
#BSUB -o O_ratio_1_%J.out 
#BSUB -e E_ratio_1_%J.err 

echo lscpu
