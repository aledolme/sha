add wave -divider TB
add wave -position insertpoint sim:/sha3_384_tb/tb_clk
add wave -position insertpoint sim:/sha3_384_tb/tb_reset_n
add wave -position insertpoint sim:/sha3_384_tb/tb_mode
add wave -position insertpoint sim:/sha3_384_tb/tb_start
add wave -position insertpoint -radix hex sim:/sha3_384_tb/tb_sha3_in
add wave -position insertpoint -radix hex sim:/sha3_384_tb/tb_sha3_out
add wave -position insertpoint sim:/sha3_384_tb/tb_done

add wave -divider MODE
add wave -position insertpoint -color Turquoise sim:/sha3_384_tb/uut_sha3/sha3_ctrl
add wave -position insertpoint sim:/sha3_384_tb/uut_sha3/uut_input_pattern/selA
add wave -position insertpoint sim:/sha3_384_tb/uut_sha3/uut_input_pattern/selB
add wave -position insertpoint sim:/sha3_384_tb/uut_sha3/uut_input_pattern/selC

add wave -divider FSM
add wave -position insertpoint -radix unsigned -color MediumVioletRed sim:/sha3_384_tb/uut_sha3/sha3_ctrl_reg
add wave -position insertpoint -radix unsigned -color MediumVioletRed sim:/sha3_384_tb/uut_sha3/sha3_ctrl_new
add wave -position insertpoint -color MediumVioletRed sim:/sha3_384_tb/uut_sha3/sha3_ctrl_we
add wave -position insertpoint -radix unsigned -color CadetBlue sim:/sha3_384_tb/uut_sha3/round_number_reg
add wave -position insertpoint -radix unsigned -color CadetBlue sim:/sha3_384_tb/uut_sha3/round_number_new
add wave -position insertpoint -radix unsigned -color CadetBlue sim:/sha3_384_tb/uut_sha3/round_number_we

add wave -divider STATE-X
add wave -position insertpoint -radix hex -color Salmon sim:/sha3_384_tb/uut_sha3/state
add wave -position insertpoint -radix hex -color Coral sim:/sha3_384_tb/uut_sha3/state_reg
add wave -position insertpoint -radix hex -color Coral sim:/sha3_384_tb/uut_sha3/state_new
add wave -position insertpoint -radix hex -color Coral sim:/sha3_384_tb/uut_sha3/state_we

add wave -divider MULTI-PERMUTATION
add wave -position insertpoint -radix hex -color Turquoise sim:/sha3_384_tb/uut_sha3/sha3_in
add wave -position insertpoint -radix hex -color Turquoise sim:/sha3_384_tb/uut_sha3/input_keccak_mux
add wave -position insertpoint -radix hex -color Turquoise sim:/sha3_384_tb/uut_sha3/xored_value
add wave -position insertpoint -radix hex -color Turquoise sim:/sha3_384_tb/uut_sha3/xored_state
add wave -position insertpoint -radix unsigned sim:/sha3_384_tb/uut_sha3/permutation_number
add wave -position insertpoint -radix unsigned sim:/sha3_384_tb/uut_sha3/permutation_ref

add wave -divider KECCAK
add wave -position insertpoint -radix hex -color Orchid sim:/sha3_384_tb/uut_sha3/round_in
add wave -position insertpoint -radix hex -color Orchid sim:/sha3_384_tb/uut_sha3/round_constant_signal_out
add wave -position insertpoint -radix unsigned -color CadetBlue sim:/sha3_384_tb/uut_sha3/round_number_new
add wave -position insertpoint -radix hex -color Orchid sim:/sha3_384_tb/uut_sha3/round_out