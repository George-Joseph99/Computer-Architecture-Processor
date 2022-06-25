vsim -gui work.processor
mem load -filltype value -filldata A0 -fillradix hexadecimal /processor/MEM/dataMemory(0)
mem load -filltype value -filldata 100 -fillradix hexadecimal /processor/MEM/dataMemory(1)
mem load -filltype value -filldata 200 -fillradix hexadecimal /processor/MEM/dataMemory(2)
mem load -filltype value -filldata 250 -fillradix hexadecimal /processor/MEM/dataMemory(3)
mem load -filltype value -filldata 10000000 -fillradix hexadecimal /processor/MEM/dataMemory(160)
mem load -filltype value -filldata 0 -fillradix hexadecimal /processor/MEM/dataMemory(161)
mem load -filltype value -filldata 19200000 -fillradix hexadecimal /processor/MEM/dataMemory(162)
mem load -filltype value -filldata 21200000 -fillradix hexadecimal /processor/MEM/dataMemory(163)
mem load -filltype value -filldata 31200000 -fillradix hexadecimal /processor/MEM/dataMemory(164)
mem load -filltype value -filldata 32400000 -fillradix hexadecimal /processor/MEM/dataMemory(165)
mem load -filltype value -filldata 1A400000 -fillradix hexadecimal /processor/MEM/dataMemory(166)
mem load -filltype value -filldata 21200000 -fillradix hexadecimal /processor/MEM/dataMemory(167)
mem load -filltype value -filldata 29200000 -fillradix hexadecimal /processor/MEM/dataMemory(168)
mem load -filltype value -filldata 2A400000 -fillradix hexadecimal /processor/MEM/dataMemory(169)
mem load -filltype value -filldata 8000000 -fillradix hexadecimal /processor/MEM/dataMemory(170)
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
