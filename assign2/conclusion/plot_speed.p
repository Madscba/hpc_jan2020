# Set the output to a png file
set terminal png size 1280,720
set xtics 2,2,24
set yrange [1:]
set xlabel "Threads N (1)"
set ylabel "Speed-up S(N)"
set pointsize 2.5
set grid

set output 'speed.png'
set title 'Speed-up for different itterations of Jacobi (Ndim=256, Start_T=16)'
p "naive.dat" u 4:5 t "Naive" w lp, \
 "advanced.dat" u 4:5 t "Advanced" w lp , \
 "numa.dat" u 4:5 t "NUMA" w lp , \
 "settings.dat" u 4:5 t "NUMA-best settings" w lp , \
 x t "f = 1"