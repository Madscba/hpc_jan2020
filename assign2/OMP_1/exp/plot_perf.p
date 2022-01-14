# Set the output to a png file
set terminal png size 1280,720

set xtics 2,2,24
set yrange [80:300]
set xlabel "Threads N (1)"
set ylabel "MLups (1/s)"
set pointsize 2.5
set grid

set output 'perf.png'
set title 'Performance scaling of different algorithms'
p "perf_gs.dat" u 4:2 t "Gauss-Seidel" w lp, \
 "perf_j.dat" u 4:2 t "Jacobian" w lp, \