# Set the output to a png file
set terminal png size 1280,720
set logscale x
set xtics 2,2,36
set xlabel "Chunksize (1)"
set ylabel "MLups (1/s)"
set key right center
set pointsize 2.5
set grid

set output 'perf_settings.png'
set title 'Performance of different settings (Ndim=256, start_T=16)'
p "perf_18_dynamic_close.dat" u 5:2 t "18 threads / dynamic / close" w lp, \
 "perf_18_dynamic_spread.dat" u 5:2 t "18 threads / dynamic / spread" w lp, \
 "perf_18_static_close.dat" u 5:2 t "18 threads / static / close" w lp, \
 "perf_18_static_spread.dat" u 5:2 t "18 threads / static / spread" w lp, \
 "perf_24_dynamic_close.dat" u 5:2 t "24 threads / dynamic / close" w lp, \
 "perf_24_dynamic_spread.dat" u 5:2 t "24 threads / dynamic / spread" w lp, \
 "perf_24_static_close.dat" u 5:2 t "24 threads / static / close" w lp, \
 "perf_24_static_spread.dat" u 5:2 t "24 threads / static / spread" w lp