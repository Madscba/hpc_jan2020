# Set the output to a png file
set terminal png size 1280,720

set logscale y
set xlabel "Dimension N (1)"
set ylabel "MLups (1/s)"
set pointsize 2.5
set grid

set output 'perf.png'
set title 'Performance scaling of different algorithms'
p "perf_gs.dat" u 1:2 t "Gauss-Seidel" w lp, \
 "perf_j.dat" u 1:2 t "Jacobian" w lp, \