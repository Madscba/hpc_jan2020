# Set the output to a png file
set terminal png size 1280,720

set xtics 2,2,24
set xlabel "Threads N (1)"
set ylabel "MLups (1/s)"
set pointsize 2.5
set grid

set output 'perf.png'
set title 'Performance of advanced Jacobian at different Ndim (start_T=16)'
p "perf_64.dat" u 4:2 t "64" w lp, \
 "perf_128.dat" u 4:2 t "128" w lp, \
 "perf_256.dat" u 4:2 t "256" w lp, \