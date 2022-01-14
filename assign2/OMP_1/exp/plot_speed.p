# Set the output to a png file
set terminal png size 1280,720
set xtics 2,2,24
set xlabel "Threads N (1)"
set ylabel "Speed-up S(N)"
set pointsize 2.5
set grid

set output 'speed.png'
set title 'Speed-up for different algorithms(N = 256, Start_T = 16)'
set arrow from 0,0 to 6,6 nohead
p "perf_gs.dat" u 4:5 t "Gauss-Seidel" w lp, \
 "perf_j.dat" u 4:5 t "Jacobian" w lp