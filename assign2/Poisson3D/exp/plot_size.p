# Set the output to a png file
set terminal png size 1280,720

set logscale y
set xlabel "Iterations (1)"
set ylabel "Change of u"
set pointsize 2.5
set grid

set output 'size.png'
set title 'Convergence speed of different start_T (N=100)'
p "size_0.dat" u 1:2 t "0" w lp, \
 "size_2.dat" u 1:2 t "2" w lp, \
 "size_4.dat" u 1:2 t "4" w lp, \
 "size_6.dat" u 1:2 t "6" w lp, \
 "size_8.dat" u 1:2 t "8" w lp, \
 "size_10.dat" u 1:2 t "10" w lp, \
 "size_12.dat" u 1:2 t "12" w lp, \
 "size_14.dat" u 1:2 t "14" w lp, \
 "size_16.dat" u 1:2 t "16" w lp, \
 "size_18.dat" u 1:2 t "18" w lp, \
 "size_20.dat" u 1:2 t "20" w lp, \
 "size_22.dat" u 1:2 t "22" w lp
