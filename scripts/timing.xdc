create_clock -name clk -period 1.9 [get_ports clk]

set_false_path -from [get_ports rst_n]
set_false_path -to [get_ports {led[*]}]
