vsim -gui work.executememory
# vsim -gui work.executememory 
# Start time: 14:21:17 on May 26,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.executememory(arch_executememory)
# Loading work.myndff(arch)
add wave -position insertpoint sim:/executememory/*
force -freeze sim:/executememory/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/executememory/flush 0 0
force -freeze sim:/executememory/stall 0 0
force -freeze sim:/executememory/PC_Added_in 16#FFFFFFFF 0
force -freeze sim:/executememory/ALU_Result_in 16#12345678 0
force -freeze sim:/executememory/ReadData1_in 16#0F0F0F0F 0
force -freeze sim:/executememory/WBAddress_in 111 0
force -freeze sim:/executememory/RegWB_enable_in 1 0
force -freeze sim:/executememory/MemWriteEnable_in 1 0
force -freeze sim:/executememory/SPEnable_in 1 0
force -freeze sim:/executememory/SelectorSP_in 0 0
force -freeze sim:/executememory/NewOrOldSP_in 0 0
force -freeze sim:/executememory/SP_Or_ALU_Result_in 0 0
force -freeze sim:/executememory/ReadData1_Or_PC_Added1_in 1 0
force -freeze sim:/executememory/WBValue_ALU_OR_Memory_in 0 0
force -freeze sim:/executememory/MEM_Read_in 1 0
force -freeze sim:/executememory/ret_signal_in 0 0
run
run
force -freeze sim:/executememory/PC_Added_in 16#11111111111111111 0
run
run
force -freeze sim:/executememory/flush 1 0
run
force -freeze sim:/executememory/stall 1 0
force -freeze sim:/executememory/flush 0 0
run
run
force -freeze sim:/executememory/stall 0 0
run
run