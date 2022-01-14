# Set the output to a png file
set terminal png size 1280,720

set logscale y
set xlabel "Iterations (1)"
set ylabel "Change of u"
set pointsize 2.5
set grid

set output 'converge.png'
set title 'Convergence speed of different algorithms (N=100,Start_T=16)'
p "converge_gs.dat" u 1:2 t "Gauss-Seidel" w lp, \
 "converge_j.dat" u 1:2 t "Jacobian" w lp, \