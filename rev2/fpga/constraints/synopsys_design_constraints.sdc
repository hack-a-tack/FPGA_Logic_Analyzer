# iCE40UP5K Logic Analyzer, Rev2
# Synopsys Design Constraints
# Using frequency 52.8MHz to acccount for internal oscillator (48MHz) with tolerance of +- 10%

create_clock -name clk52 -period 18.939 [get_nets {E1.o_clk}]
