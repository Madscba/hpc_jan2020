# Set the output to a png file
set terminal png size 1920,1080

set logscale x; set xtics 64, 4, 262144
set xlabel "Memory footprint (Kbyte)"
set ylabel "Performance (Mflop/s)"
perm = "kmn knm mkn mnk nkm nmk"
set arrow from 32, graph 0 to 32, graph 1 nohead
set arrow from 256, graph 0 to 256, graph 1 nohead
set arrow from 30720, graph 0 to 30720, graph 1 nohead
set pointsize 2.5
set grid

set output 'ratio1plot.png'
set title 'Performance plot of different permutations (Ratio 1)'
p for [per = 1:6] "ratio_1_".word(perm,per)."..dat" u 1:2 t "Permutation: ".word(perm,per) w lp


set output 'ratio2plot.png'
set title 'Performance plot of different permutations (Ratio 2)'
p for [per = 1:6] "ratio_2_".word(perm,per)."..dat" u 1:2 t "Permutation: ".word(perm,per) w lp

set output 'ratio3plot.png'
set title 'Performance plot of different permutations (Ratio 3)'
p for [per = 1:6] "ratio_3_".word(perm,per)."..dat" u 1:2 t "Permutation: ".word(perm,per) w lp