vsim -gui work.decodeexecute
# vsim -gui work.decodeexecute 
# Start time: 12:54:06 on May 26,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.decodeexecute(arch_decodeexecute)
# Loading work.myndff(arch)
add wave -position insertpoint sim:/decodeexecute/*
force -freeze sim:/decodeexecute/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/decodeexecute/flush 0 0
force -freeze sim:/decodeexecute/stall 0 0
force -freeze sim:/decodeexecute/PC_Added1_in 16#FFFF 0
force -freeze sim:/decodeexecute/inport_in 16#0000 0
force -freeze sim:/decodeexecute/ReadData1_in 16#1 0
force -freeze sim:/decodeexecute/ReadData2_in 16#2 0
force -freeze sim:/decodeexecute/ExtendedImmOrOffset_in 16#3 0
force -freeze sim:/decodeexecute/ALU_OP_in 1010 0
force -freeze sim:/decodeexecute/ReadData2_Or_Imm_in 01 0
force -freeze sim:/decodeexecute/WBAddress_in 111 0
force -freeze sim:/decodeexecute/RegWB_enable_in 1 0
force -freeze sim:/decodeexecute/Inport_Or_ALU_in 1 0
force -freeze sim:/decodeexecute/outport_DecEx_in 0 0
force -freeze sim:/decodeexecute/MemWriteEnable_in 1 0
force -freeze sim:/decodeexecute/SPEnable_in 0 0
force -freeze sim:/decodeexecute/SelectorSP_in 0 0
force -freeze sim:/decodeexecute/NewOrOldSP_in 0 0
force -freeze sim:/decodeexecute/SP_Or_ALU_Result_in 1 0
force -freeze sim:/decodeexecute/ReadData1_Or_PC_Added1_in 1 0
force -freeze sim:/decodeexecute/WBValue_ALU_OR_Memory_in 1 0
force -freeze sim:/decodeexecute/ReadData1_Or_ReadData2_in 11 0
force -freeze sim:/decodeexecute/Rsrc_in 010 0
force -freeze sim:/decodeexecute/MEM_Read_in 1 0
force -freeze sim:/decodeexecute/jump_signal_in 01 0
force -freeze sim:/decodeexecute/jump_enable_in 1 0
force -freeze sim:/decodeexecute/ret_signal_in 1 0
run
run
force -freeze sim:/decodeexecute/flush 1 0
run
force -freeze sim:/decodeexecute/flush 0 0
force -freeze sim:/decodeexecute/stall 1 0
run
run
force -freeze sim:/decodeexecute/stall 0 0
run
run
