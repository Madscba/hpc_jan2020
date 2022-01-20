# Set the output to a png file
set terminal png size 1280,720

set logscale x; set xtics 150,2,1572864
set xlabel "Memory footprint (Kbyte)"
set ylabel "Mflops (1/s)"
set pointsize 2.5
set grid

set output 'perf1.png'
set title 'Performance'
p "cpu_1.dat" u 1:2 t "CPU 1 DGEMM thread" w lp,\
 "cpu_16.dat" u 1:2 t "CPU 16 DGEMM threads" w lp, \
 "gpu1.dat" u 1:2 t "GPU 1" w lp, \
 "gpu2.dat" u 1:2 t "GPU 2" w lp, \