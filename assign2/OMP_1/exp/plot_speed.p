# Set the output to a png file
set terminal png size 1280,720
set xtics 2,2,24
set yrange [0:4]
set xlabel "Threads N (1)"
set ylabel "Speed-up S(N)"
set pointsize 2.5
set grid

set output 'speed.png'
set title 'Speed-up for different algorithms(N = 256, Start_T = 16)'
p 1/(0.6074696744/x + 1-0.6074696744) t "Potential Gauss-Seidel (f = 0.61)" lc 1, \
  "perf_gs.dat" u 4:5 t "Gauss-Seidel" w lp lc 1, \
 1/(0.4831/x + 1-0.4831) t "Potential Jacobi (f = 0.48)" lc 2, \
 "perf_j.dat" u 4:5 t "Jacobian" w lp lc 2, \
 x t "f = 1"