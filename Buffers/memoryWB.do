vsim -gui work.memorywb
# vsim -gui work.memorywb 
# Start time: 20:38:21 on May 26,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.memorywb(arch_memorywb)
# Loading work.myndff(arch)
add wave -position insertpoint sim:/memorywb/*
force -freeze sim:/memorywb/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/memorywb/flush 0 0
force -freeze sim:/memorywb/stall 0 0
force -freeze sim:/memorywb/MemoryData_in 16#FFFF 0
force -freeze sim:/memorywb/ALU_Result_in 16#0F0F0F0F 0
force -freeze sim:/memorywb/WBAddress_in 110 0
force -freeze sim:/memorywb/WBValue_ALU_OR_Memory_in 1 0
run
run
force -freeze sim:/memorywb/flush 1 0
run
force -freeze sim:/memorywb/flush 0 0
force -freeze sim:/memorywb/stall 1 0
run
run
force -freeze sim:/memorywb/stall 0 0
run
run