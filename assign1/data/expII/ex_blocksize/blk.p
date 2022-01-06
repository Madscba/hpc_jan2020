# Set the output to a png file
set terminal png size 500,500
# The file we'll write to
set output 'blk_plot.png'
# The graphic title
set title 'Performance of block sizes with (n,k,m = 250)'
# Set axis labels
set xlabel "Block Size (1)"
set ylabel "Performance (Mflop/s)"
p 'blk.dat' u 5:2 w lp notitle