# Set the output to a png file
set terminal png size 1280,720
set logscale x
set xtics 4,2,128
set xlabel "Ndim (1)"
set ylabel "MLups (1/s)"
set pointsize 2.5
set grid

set output 'perf_warp.png'
set title 'Performance of iterations of Jacobian (start_T=16)'
p "gpu_base.dat" u 1:2 t "Baseline" w lp,\
 "gpu_warp.dat" u 1:2 t "Warp" w lp, \