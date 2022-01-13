# Set the output to a png file
set terminal png size 640,360

set logscale y
set xlabel "Iterations (1)"
set ylabel "Change of u"
set pointsize 2.5
set grid

set output 'converg.png'
set title 'Convergence speed of different algorithms'
p "converge_gs.dat" u 1:2 t "Gauss-Seidel" w lp, \
 "converge_j.dat" u 1:2 t "Jacobian" w lp, \