vsim -gui work.fetchdecode
# vsim -gui work.fetchdecode 
# Start time: 12:29:09 on May 26,2022
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading work.fetchdecode(arch_fetchdecode)
# Loading work.myndff(arch)
add wave -position insertpoint sim:/fetchdecode/*
force -freeze sim:/fetchdecode/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/fetchdecode/stall 0 0
force -freeze sim:/fetchdecode/flush 0 0
force -freeze sim:/fetchdecode/PC_Added_in 16#FFFFFFF 0
force -freeze sim:/fetchdecode/instruction_in 16#11111111 0
force -freeze sim:/fetchdecode/inport_in 16#12345678 0
run
run
force -freeze sim:/fetchdecode/flush 1 0
run
force -freeze sim:/fetchdecode/flush 0 0
force -freeze sim:/fetchdecode/PC_Added_in 16#F0F0F0F0 0
force -freeze sim:/fetchdecode/instruction_in 16#FFFFFFFF 0
force -freeze sim:/fetchdecode/stall 1 0
run
force -freeze sim:/fetchdecode/stall 0 0
run
run