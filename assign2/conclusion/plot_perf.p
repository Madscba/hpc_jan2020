# Set the output to a png file
set terminal png size 1280,720

set xtics 2,2,24
set xlabel "Threads N (1)"
set ylabel "MLups (1/s)"
set pointsize 2.5
set grid

set output 'perf.png'
set title 'Performance of iterations of Jacobian (Ndim=256, start_T=16)'
p "naive.dat" u 4:2 t "Naive" w lp, \
 "advanced.dat" u 4:2 t "Advanced" w lp, \
 "numa.dat" u 4:2 t "NUMA" w lp, \
  "settings.dat" u 4:2 t "NUMA-best settings" w lp , \