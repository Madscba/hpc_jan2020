# Set the output to a png file
set terminal png size 1280,720
set xtics 2,2,24
set yrange [0:4]
set xlabel "Threads N (1)"
set ylabel "Speed-up S(N)"
set pointsize 2.5
set grid

set output 'speed_ndim.png'
set title 'Speed-up for Jacobi at different sizes (Start_T=16)'
p 1/(0.4831/x + 1-0.4831) t "Potential (f = 0.48)", \
 "perf_j_64.dat" u 4:5 t "64" w lp, \
 "perf_j_128.dat" u 4:5 t "128" w lp , \
 "perf_j_256.dat" u 4:5 t "256" w lp , \
 x t "f = 1"