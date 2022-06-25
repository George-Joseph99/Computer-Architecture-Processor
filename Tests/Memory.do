vsim -gui work.processor
mem load -filltype value -filldata 300 -fillradix hexadecimal /processor/MEM/dataMemory(0)
mem load -filltype value -filldata 700 -fillradix hexadecimal /processor/MEM/dataMemory(1)
mem load -filltype value -filldata 200 -fillradix hexadecimal /processor/MEM/dataMemory(2)
mem load -filltype value -filldata 250 -fillradix hexadecimal /processor/MEM/dataMemory(3)
mem load -filltype value -filldata 100 -fillradix hexadecimal /processor/MEM/dataMemory(4)
mem load -filltype value -filldata 29200000 -fillradix hexadecimal /processor/MEM/dataMemory(256)
mem load -filltype value -filldata 8000000 -fillradix hexadecimal /processor/MEM/dataMemory(257)
mem load -filltype value -filldata 32400000 -fillradix hexadecimal /processor/MEM/dataMemory(768)
mem load -filltype value -filldata 33600000 -fillradix hexadecimal /processor/MEM/dataMemory(769)
mem load -filltype value -filldata 34800000 -fillradix hexadecimal /processor/MEM/dataMemory(770)
mem load -filltype value -filldata 91000005 -fillradix hexadecimal /processor/MEM/dataMemory(771)
mem load -filltype value -filldata 81200000 -fillradix hexadecimal /processor/MEM/dataMemory(772)
mem load -filltype value -filldata 82400000 -fillradix hexadecimal /processor/MEM/dataMemory(773)
mem load -filltype value -filldata 89200000 -fillradix hexadecimal /processor/MEM/dataMemory(774)
mem load -filltype value -filldata 8A400000 -fillradix hexadecimal /processor/MEM/dataMemory(775)
mem load -filltype value -filldata 35A00000 -fillradix hexadecimal /processor/MEM/dataMemory(776)
mem load -filltype value -filldata 9BA00201 -fillradix hexadecimal /processor/MEM/dataMemory(777)
mem load -filltype value -filldata 9CA00200 -fillradix hexadecimal /processor/MEM/dataMemory(778)
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
force -freeze sim:/processor/rst 0 0
force -freeze sim:/processor/Processor_INPORT 16#19 0
run
force -freeze sim:/processor/Processor_INPORT 16#FFFFFFFF 0
run
force -freeze sim:/processor/Processor_INPORT 16#FFFFF320 0
run