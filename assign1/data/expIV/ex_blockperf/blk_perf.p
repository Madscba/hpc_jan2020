# Set the output to a png file
set terminal png size 1920,1080

set logscale x; set xtics 64, 4, 262144
set xlabel "Memory footprint (Kbyte)"
set ylabel "Performance (Mflop/s)"
set arrow from 32, graph 0 to 32, graph 1 nohead
set arrow from 256, graph 0 to 256, graph 1 nohead
set arrow from 30720, graph 0 to 30720, graph 1 nohead
set pointsize 2.5
set grid

set output 'blockperf.png'
set title 'Performance plot of blocking version (Block size 7)'
p "blk_perf.dat" u 1:2 notitle w lp

