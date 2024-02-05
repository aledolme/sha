remove_design -all

define_design_lib WORK -path ./work


set search_path [list $search_path . ../includes ../src /software/synopsys/syn_current/libraries/syn /software/dk/umc65/Core-lib_LL_Multi-Voltage_Reg.Vt/synopsys ]
set link_library [list "*" "uk65lscllmvbbr_120c25_tc.db" "dw_foundation.sldb" ]
set target_library [list "uk65lscllmvbbr_120c25_tc.db" ]
set synthetic_library [list "dw_foundation.sldb" ]

source analyze.tcl

elaborate sha3 -library work
link
create_clock -name "CLK" -period 0 [ get_ports clk ]

write -f ddc -hierarchy -output results/precompiled.ddc

report_clocks > results/clocks.rpt

compile_ultra -no_autoungroup -no_boundary_optimization -timing -gate_clock

write -f ddc -hierarchy -output ${REPORT_DIR}/compiled.ddc

change_names -rules verilog -hier

write -format verilog -hier -o netlist.v

report_timing -nosplit > ${REPORT_DIR}/timing.rpt
report_area -hier -nosplit > ${REPORT_DIR}/area.rpt
report_resources -hierarchy > ${REPORT_DIR}/resources.rpt
report_power > ${REPORT_DIR}/power.rpt

