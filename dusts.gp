# Set the input data format
set datafile separator ","

# Define the bin width (e.g., 144 blocks per bin is a day)
binwidth = 1
bin(x, width) = width * floor(x / width) + width / 2.0

# Graph Styling
set logscale y
set yrange [1:*]
set xrange [1:*]
set style fill solid 1 noborder
set boxwidth binwidth
set grid y
set xlabel "Block Height"
set ylabel "Number of Transactions"
set title "Dust (< 1000 sats) outputs sent to victim addresses (> 0.5 BTC)"
set key top left
set size ratio 0.5

# --- VERTICAL ANNOTATIONS (HALVINGS) ---
# Line Color and Style
set style line 100 lc rgb "#808080" lw 1.5 dt 2

# 2012 Halving
set arrow from 210000, graph 0 to 210000, graph 1 nohead ls 100
set label "Epoch 2 (2012)" at 210000, graph 1.02 center font ",9"

# 2016 Halving
set arrow from 420000, graph 0 to 420000, graph 1 nohead ls 100
set label "Epoch 3 (2016)" at 420000, graph 1.02 center font ",9"

# 2020 Halving
set arrow from 630000, graph 0 to 630000, graph 1 nohead ls 100
set label "Epoch 4 (2020)" at 630000, graph 1.02 center font ",9"

# 2024 Halving
set arrow from 840000, graph 0 to 840000, graph 1 nohead ls 100
set label "Epoch 5 (2024)" at 840000, graph 1.02 center font ",9"
# ---------------------------------------

# Plotting the data
# Column 5 is 'height', Column 7 is 'type'
# Create cumulative plots for each script type
plot 'dusts.csv' using (bin($5, binwidth)):(strcol(7) eq "P2SH" ? 1 : 0) smooth cumulative with lines lw 2 lc rgb "red" title "P2SH", \
     'dusts.csv' using (bin($5, binwidth)):(strcol(7) eq "P2PKH" ? 1 : 0) smooth cumulative with lines lw 2 lc rgb "blue" title "P2PKH", \
     'dusts.csv' using (bin($5, binwidth)):(strcol(7) eq "P2WPKH" ? 1 : 0) smooth cumulative with lines lw 2 lc rgb "green" title "P2WPKH", \
     'dusts.csv' using (bin($5, binwidth)):(strcol(7) eq "P2WSH" ? 1 : 0) smooth cumulative with lines lw 2 lc rgb "orange" title "P2WSH", \
     'dusts.csv' using (bin($5, binwidth)):(strcol(7) eq "P2TR" ? 1 : 0) smooth cumulative with lines lw 2 lc rgb "purple" title "P2TR"