# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Cmd: yosys -c ./gen_netlist.tcl

## SET variables HERE!!!
set work_dir "/mnt/c/Users/ngyen/Documents/Projects/rtl_projects/yosys/examples/test_sog"
set lr_synth_out_dir $env(LR_SYNTH_OUT_DIR) ;#"ibex_11_05_2025_18_08_31"
set top_module "ibex_top"
set lr_synth_cell_library_path $env(LR_SYNTH_CELL_LIBRARY_PATH) ;# "/mnt/c/Users/ngyen/Documents/Projects/rtl_projects/yosys/examples/test_sog/NangateOpenCellLibrary_typical.lib"
set lr_synth_netlist_out "/mnt/c/Users/ngyen/Documents/Projects/rtl_projects/yosys/examples/test_sog/ibex_top_netlist.v"

puts "work_dir: $work_dir"
puts "lr_synth_out_dir: $lr_synth_out_dir"
puts "top_module: $top_module"
puts "lr_synth_cell_library_path: $lr_synth_cell_library_path"
puts "lr_synth_netlist_out: $lr_synth_netlist_out"

# Execute synthesis
yosys "design -reset"

yosys "read_verilog -defer -sv $work_dir/rtl/prim_clock_gating.v $lr_synth_out_dir/generated/*.v"
#read_verilog -defer -sv ./design.sv
### Add more sv: read_verilog -sv ../example/verilog/TinyRocket/chipyard.TestHarness.TinyRocketConfig.top.sv

# elaborate design hierarchy
yosys "hierarchy -check -top $top_module"

# the high-level stuff
yosys "proc; opt;"
yosys "flatten; opt;"
yosys "fsm; opt;"
yosys "alumacc; share; opt;"
yosys "memory; opt"

# mapping to internal cell library
yosys "techmap; opt"
yosys "dfflibmap -liberty $lr_synth_cell_library_path"

# mapping logic to mycells.lib
yosys "abc -liberty $lr_synth_cell_library_path"

# cleanup
yosys "clean"

# Generate netlist
yosys "write_verilog $lr_synth_netlist_out"
