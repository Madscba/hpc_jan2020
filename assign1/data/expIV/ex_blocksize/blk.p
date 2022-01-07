# Set the output to a png file
set terminal png size 640,360
# The file we'll write to
set output 'blksize.png'
# The graphic title
set title 'Performance of block sizes with 4Mbyte problem'
# Set axis labels
set xlabel "Block Size (1)"
set ylabel "Performance (Mflop/s)"
p 'blk_1.dat' u 6:2 w lp t "Ratio 1", \
'blk_2.dat' u 6:2 w lp t "Ratio 2", \
'blk_3.dat' u 6:2 w lp t "Ratio 3"
