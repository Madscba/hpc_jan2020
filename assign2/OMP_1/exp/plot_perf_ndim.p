# Set the output to a png file
set terminal png size 1280,720

set xtics 2,2,24
set xlabel "Threads N (1)"
set ylabel "MLups (1/s)"
set pointsize 2.5
set grid

set output 'perf_ndim.png'
set title 'Performance of Jacobian at different Ndim (start_T=16)'
p "perf_j_64.dat" u 4:2 t "64" w lp, \
 "perf_j_128.dat" u 4:2 t "128" w lp, \
 "perf_j_256.dat" u 4:2 t "256" w lp, \