# Set the output to a png file
set terminal png size 1280,720

set logscale y
set xlabel "Iterations (1)"
set ylabel "Distance from solution"
set pointsize 2.5
set grid

set output 'converge_a.png'
set title 'Convergence towards analytical solution for different algorithms (N=100,Start_T=1)'
p "converge_a_gs.dat" u 1:3 t "Gauss-Seidel" w lp, \
 "converge_a_j.dat" u 1:3 t "Jacobian" w lp, \