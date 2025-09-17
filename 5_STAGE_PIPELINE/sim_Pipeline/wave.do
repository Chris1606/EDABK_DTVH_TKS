onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_RISCV_Pipeline/DUT/AddrA
add wave -noupdate /test_RISCV_Pipeline/DUT/AddrB
add wave -noupdate /test_RISCV_Pipeline/DUT/clk
add wave -noupdate /test_RISCV_Pipeline/DUT/Stall
add wave -noupdate /test_RISCV_Pipeline/DUT/RegWen_D
add wave -noupdate /test_RISCV_Pipeline/DUT/RegWen_E
add wave -noupdate /test_RISCV_Pipeline/DUT/RegWen_E1
add wave -noupdate /test_RISCV_Pipeline/DUT/RegWen_M
add wave -noupdate /test_RISCV_Pipeline/DUT/RegWen_W
add wave -noupdate /test_RISCV_Pipeline/DUT/AddrA_E
add wave -noupdate /test_RISCV_Pipeline/DUT/AddrD_M
add wave -noupdate /test_RISCV_Pipeline/DUT/AddrD_W
add wave -noupdate /test_RISCV_Pipeline/DUT/control_temp_srcA_unit
add wave -noupdate /test_RISCV_Pipeline/DUT/temp_srcA
add wave -noupdate /test_RISCV_Pipeline/DUT/dataA_E
add wave -noupdate /test_RISCV_Pipeline/DUT/ALU_res_M
add wave -noupdate /test_RISCV_Pipeline/DUT/WritebackData_result_W
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {31 ns} {57 ns}
