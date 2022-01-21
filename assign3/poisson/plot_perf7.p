# Set the output to a png file
set terminal png size 1280,720
set logscale x
set xtics 4,2,256
set xrange [4:256]
set xlabel "Ndim (1)"
set ylabel "MLups (1/s)"
set pointsize 2.5
set grid

set output 'perf_ex7.png'
set title 'Performance of Jacobi (start_T=16)'
p "./cpu/exp/assignment_3/multi_core/cpu_multi.dat" u 1:2 t "CPU" w lp, \
 "./gpu_ex6/gpu_part6_.dat" u 1:2 t "GPU1" w lp, \
 "./gpu_ex7/gpu_part7_.dat" u 1:2 t "GPU2" w lp, \