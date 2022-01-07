# Set the output to a png file
set terminal png size 640,360
# The file we'll write to
set output 'blksize.png'
# The graphic title
set title 'Performance of block sizes with (n,k,m = 103)'
# Set axis labels
set xlabel "Block Size (1)"
set ylabel "Performance (Mflop/s)"
p 'blk.dat' u 5:2 w lp notitle