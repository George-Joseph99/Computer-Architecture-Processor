vsim -gui work.processor
mem load -filltype value -filldata 10 -fillradix hexadecimal /processor/MEM/dataMemory(0)
mem load -filltype value -filldata 10000000 -fillradix hexadecimal /processor/MEM/dataMemory(1792)
mem load -filltype value -filldata E0000300 -fillradix hexadecimal /processor/MEM/dataMemory(1793)
mem load -filltype value -filldata 26C00000 -fillradix hexadecimal /processor/MEM/dataMemory(1794)
mem load -filltype value -filldata 0 -fillradix hexadecimal /processor/MEM/dataMemory(1795)
mem load -filltype value -filldata 0 -fillradix hexadecimal /processor/MEM/dataMemory(1796)
mem load -filltype value -filldata 56780000 -fillradix hexadecimal /processor/MEM/dataMemory(768)
mem load -filltype value -filldata 51280000 -fillradix hexadecimal /processor/MEM/dataMemory(769)
mem load -filltype value -filldata E8000000 -fillradix hexadecimal /processor/MEM/dataMemory(770)
mem load -filltype value -filldata 10000000 -fillradix hexadecimal /processor/MEM/dataMemory(771)
add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/rst \
sim:/processor/Processor_INPORT \
sim:/processor/Processor_OUTPORT
add wave -position insertpoint  \
sim:/processor/StackPointer 
add wave -position insertpoint  \
sim:/processor/PC_OUT 
add wave -position insertpoint  \
sim:/processor/CF_Reg \
sim:/processor/NF_Reg \
sim:/processor/ZF_Reg 
add wave -position insertpoint  \
sim:/processor/regfile/s0 \
sim:/processor/regfile/s1 \
sim:/processor/regfile/s2 \
sim:/processor/regfile/s3 \
sim:/processor/regfile/s4 \
sim:/processor/regfile/s5 \
sim:/processor/regfile/s6 \
sim:/processor/regfile/s7 
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/rst 1 0
run
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /processor/PC_Add
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 0  Instance: /processor/MEM
# ** Warning: NUMERIC_STD.TO_INTEGER: metavalue detected, returning 0
#    Time: 0 ps  Iteration: 1  Instance: /processor/MEM
force -freeze sim:/processor/PC_out 16#700 0
force -freeze sim:/processor/rst 0 0
run
noforce sim:/processor/PC_out
run
force -freeze sim:/processor/PC_out 16#300 0
run
run
noforce sim:/processor/PC_out
run
run
run
force -freeze sim:/processor/PC_out 16#702 0

