vsim -gui work.processor
mem load -filltype value -filldata FF -fillradix hexadecimal /processor/MEM/dataMemory(0)
mem load -filltype value -filldata 100 -fillradix hexadecimal /processor/MEM/dataMemory(1)
mem load -filltype value -filldata 200 -fillradix hexadecimal /processor/MEM/dataMemory(2)
mem load -filltype value -filldata 250 -fillradix hexadecimal /processor/MEM/dataMemory(3)
mem load -filltype value -filldata 31200000 -fillradix hexadecimal /processor/MEM/dataMemory(255)
mem load -filltype value -filldata 32400000 -fillradix hexadecimal /processor/MEM/dataMemory(256)
mem load -filltype value -filldata 33600000 -fillradix hexadecimal /processor/MEM/dataMemory(257)
mem load -filltype value -filldata 34800000 -fillradix hexadecimal /processor/MEM/dataMemory(258)
mem load -filltype value -filldata 45600000 -fillradix hexadecimal /processor/MEM/dataMemory(259)
mem load -filltype value -filldata 54300000 -fillradix hexadecimal /processor/MEM/dataMemory(260)
mem load -filltype value -filldata 5EB00000 -fillradix hexadecimal /processor/MEM/dataMemory(261)
mem load -filltype value -filldata 64F00000 -fillradix hexadecimal /processor/MEM/dataMemory(262)
mem load -filltype value -filldata 6A40FFFF -fillradix hexadecimal /processor/MEM/dataMemory(263)
mem load -filltype value -filldata 4F800000 -fillradix hexadecimal /processor/MEM/dataMemory(264)
mem load -filltype value -filldata 4C400000 -fillradix hexadecimal /processor/MEM/dataMemory(265)
mem load -filltype value -filldata 4AE00000 -fillradix hexadecimal /processor/MEM/dataMemory(266)
mem load -filltype value -filldata 52280000 -fillradix hexadecimal /processor/MEM/dataMemory(267)
mem load -filltype value -filldata 56880000 -fillradix hexadecimal /processor/MEM/dataMemory(268)
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
