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

set output 'expIV/ex_blockperf/performance_1.png'
set title 'Performance plot of versions (Ratio 1)'
p "expIV/ex_blockperf/blk_perf_1.dat" u 1:2 t "Double blocking" w lp, \
 "expIV/ex_blockperf/blk3_perf_1.dat" u 1:2 t "Triple blocking" w lp, \
 "expII/exII_Ofast_funroll/ratio_1_mkn..dat" u 1:2 t "Native" w lp, \
 "expII/exII_Ofast_funroll_lib/ratio_1_lib..dat" u 1:2 t "Library" w lp


set output 'expIV/ex_blockperf/performance_2.png'
set title 'Performance plot of versions (Ratio 2)'
p "expIV/ex_blockperf/blk_perf_2.dat" u 1:2 t "Double blocking" w lp, \
 "expIV/ex_blockperf/blk3_perf_2.dat" u 1:2 t "Triple blocking" w lp, \
 "expII/exII_Ofast_funroll/ratio_2_mkn..dat" u 1:2 t "Native" w lp, \
 "expII/exII_Ofast_funroll_lib/ratio_2_lib..dat" u 1:2 t "Library" w lp

 set output 'expIV/ex_blockperf/performance_3.png'
set title 'Performance plot of versions (Ratio 3)'
p "expIV/ex_blockperf/blk_perf_3.dat" u 1:2 t "Double blocking" w lp, \
 "expIV/ex_blockperf/blk3_perf_3.dat" u 1:2 t "Triple blocking" w lp, \
 "expII/exII_Ofast_funroll/ratio_3_mkn..dat" u 1:2 t "Native" w lp, \
 "expII/exII_Ofast_funroll_lib/ratio_3_lib..dat" u 1:2 t "Library" w lp


