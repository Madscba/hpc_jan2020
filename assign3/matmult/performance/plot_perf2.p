# Set the output to a png file
set terminal png size 1280,720

set logscale x; set xtics 0.15,4,1573
set xlabel "Memory footprint (mbytes)"
set ylabel "Gflops (1/s)"
set pointsize 2.5
set grid

set output 'perf2.png'
set title 'Performance'
p "c_cpu_1.dat" u 1:2 t "CPU DGEMM 1 thread" w lp,\
 "c_cpu_16.dat" u 1:2 t "CPU DGEMM 16 threads" w lp, \
 "c_gpu1.dat" u 1:2 t "GPU 1" w lp, \
 "c_gpu2.dat" u 1:2 t "GPU 2" w lp, \
 "c_gpu3.dat" u 1:2 t "GPU 3" w lp, \
 "c_gpu4.dat" u 1:2 t "GPU 4" w lp, \