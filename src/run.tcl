set_fml_appmode FPV
set design morse_top

read_file -top $design -format sverilog -sva -vcs {-f flist.f}

# create clock
create_clock clk -period 10

# create reset
create_reset rst -sense low

check_fv

report_fv
