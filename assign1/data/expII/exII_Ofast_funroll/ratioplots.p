# Set the output to a png file
set terminal png size 1920,1080
# The file we'll write to
set output 'ratioplot.png'
# The graphic title
set title 'Data structure comparison: AoS vs SoA'
set logscale x; set xtics 64, 4, 262144
set xlabel "Memory footprint (Kbyte)"
set ylabel "Performance (Mflop/s)"
perm = "kmn knm mkn mnk nkm nmk"
titleprefix="dummy calc re-use total"
#plot the graphic
p for [per = 1:6] "ratio_3_".word(perm,per)."..dat" u 1:2  w lp
set grid
