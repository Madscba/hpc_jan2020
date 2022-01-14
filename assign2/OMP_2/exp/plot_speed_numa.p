# Set the output to a png file
set terminal png size 1280,720
set xtics 2,2,24
set yrange [1:]
set xlabel "Threads N (1)"
set ylabel "Speed-up S(N)"
set pointsize 2.5
set grid

set output 'speed_numa.png'
set title 'Speed-up for advanced Jacobi at different sizes (Start_T=16)'
p "perf_numa_64.dat" u 4:5 t "64" w lp, \
 "perf_numa_128.dat" u 4:5 t "128" w lp , \
 "perf_numa_256.dat" u 4:5 t "256" w lp , \
 x t "f = 1"