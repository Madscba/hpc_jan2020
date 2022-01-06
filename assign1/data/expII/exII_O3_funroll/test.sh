#!/bin/sh 

# Experiment II - ratio 3

PERM="mnk"
NPARTS="9 18 36 73 147 295 591 1182"

lscpu




for mdim in $NPARTS
do
	echo  $mdim $(($mdim*2))
done


exit 0

