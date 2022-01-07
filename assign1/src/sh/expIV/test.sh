#!/bin/sh 
NPARTS=(9 12 18 25 36 51 73 103 146 206 292 413 584 826 1168 1652 2336)
for i in $(seq 1 17)
do
    echo ${NPARTS[i]}
done