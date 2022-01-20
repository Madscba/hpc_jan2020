# Set the output to a png file
set terminal png size 1280,720

set xtics 2,2,24
set xlabel "Threads N (1)"
set ylabel "MLups (1/s)"
set pointsize 2.5
set grid

set output 'perf_numa.png'
set title 'Performance of NUMA Jacobian at different Ndim (start_T=16)'
p "perf_numa_64.dat" u 4:2 t "64" w lp, \
 "perf_numa_128.dat" u 4:2 t "128" w lp, \
 "perf_numa_256.dat" u 4:2 t "256" w lp, \