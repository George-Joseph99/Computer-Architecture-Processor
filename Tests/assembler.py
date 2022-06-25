#do file initial



startSim = ['vsim -gui work.processor']
startingLines = [
    'add wave -position insertpoint  \\',
    'sim:/processor/clk \\',
    'sim:/processor/rst \\',
    'sim:/processor/Processor_INPORT \\',
    'sim:/processor/Processor_OUTPORT',
    'add wave -position insertpoint  \\',
    'sim:/processor/StackPointer ',
    'add wave -position insertpoint  \\',
    'sim:/processor/PC_OUT ',
    'add wave -position insertpoint  \\',
    'sim:/processor/CF_Reg \\',
    'sim:/processor/NF_Reg \\',
    'sim:/processor/ZF_Reg ',
    'add wave -position insertpoint  \\',
    'sim:/processor/regfile/s0 \\',
    'sim:/processor/regfile/s1 \\',
    'sim:/processor/regfile/s2 \\',
    'sim:/processor/regfile/s3 \\',
    'sim:/processor/regfile/s4 \\',
    'sim:/processor/regfile/s5 \\',
    'sim:/processor/regfile/s6 \\',
    'sim:/processor/regfile/s7 '
]

oneOperandOpCodes = {'NOP': '00000' , 'HLT':'00001' ,
 'SETC':'00010' ,'NOT':'00011','INC':'00100','OUT' : '00101' ,'IN':'00110'}

TwoOperandOpCodes = {'MOV':'01000' , 'SWAP':'01001' , 'ADD':'01010' ,
'SUB':'01011','AND':'01100' ,'IADD':'01101'}

MemoryOpCode = {'PUSH':'10000' , 'POP':'10001' , 'LDM':'10010','LDD':'10011','STD':'10100'}

BranchOpCode = {'JZ':'11000' , 'JN':'11001' ,'JC':'11010','JMP':'11011','CALL':'11100','RET':'11101'
                , 'INT':'11110', 'RTI':'11111'}

Registers={
    'R0': '000','R1': '001','R2': '010','R3': '011','R4': '100','R5': '101','R6': '110','R7': '111'
}

rootDir=''
filename = 'Branch'
Instructions = []
InstructionOrder = []
IndexNow = None
with open( rootDir + filename + '.asm' , 'r') as f:
    lines = f.readlines();

    for line in lines:

        removedSpaces = ' '.join(line.split()).upper()
        if(removedSpaces.startswith('#') or removedSpaces == ''):
            continue

        removeComments = removedSpaces[0: removedSpaces.find('#') -1] if(removedSpaces.find('#') != -1) else removedSpaces
        # group asm inst into a list
        asmInst = removeComments.split(' ')
        
        if(asmInst[0] == ".ORG"):
            IndexNow = int(asmInst[1] , 16)
            continue

        # 1 op 
        if(asmInst[0] in oneOperandOpCodes.keys()):

            binaryInst = oneOperandOpCodes[asmInst[0]]
            
            Rdst = ''
            # id inst is NOP HLT or SETC only intstuction no operands
            if(len(asmInst) == 1):
                Rdst = '000'
            else:
                Rdst = Registers[asmInst[1]]
            
            Instructions.append(binaryInst + Rdst + Rdst + '00000'+'0000000000000000')
        elif (asmInst[0] in TwoOperandOpCodes.keys()):

            binaryInst = TwoOperandOpCodes[asmInst[0]]

            Operands = asmInst[1].split(',')
            if(asmInst[0] != 'IADD'):
                Rdst = '000'
                Rsrc1 = '000'
                Rsrc2 = '000'

                if(len(Operands) == 2):
                    if(asmInst[0] == 'SWAP'):
                        Rsrc1 = Registers[Operands[0]]
                        Rdst = Registers[Operands[1]]
                        Instructions.append(binaryInst+'111'+Rdst+'00000'+  '0000000000000000')
                        InstructionOrder.append(IndexNow)
                        IndexNow+=1

                        Instructions.append(binaryInst+Rdst+Rsrc1+'00000'+  '0000000000000000')
                        InstructionOrder.append(IndexNow)

                        IndexNow+=1
                        Instructions.append(binaryInst+Rsrc1+'111'+'00000'+  '0000000000000000')
                    else:
                        print(asmInst[0])
                        print(Operands)
                        Rsrc1 = Registers[Operands[0]]
                        Rdst = Registers[Operands[1]]
                        Instructions.append(binaryInst+Rdst+Rsrc1+'00000'+  '0000000000000000')
                else:
                    Rdst = Registers[Operands[0]]
                    Rsrc1 = Registers[Operands[1]]
                    Rsrc2 = Registers[Operands[2]]
                    Instructions.append(binaryInst+Rdst+Rsrc1+Rsrc2+'00'+  '0000000000000000')

            else:
                Rdst = Registers[Operands[0]]
                Rsrc1 = Registers[Operands[1]]
                Imm = Operands[2]
                Instructions.append(binaryInst+Rdst+Rsrc1+'00000'+  bin(int('0x' + Imm, 16))[2:].zfill(16))

        elif(asmInst[0] in MemoryOpCode.keys()):
            binaryInst = MemoryOpCode[asmInst[0]]
            Operands = asmInst[1].split(',')
            if(len(Operands) == 1): # Push or Pop
                Rdst = Registers[Operands[0]]
                Instructions.append(binaryInst+Rdst+Rdst+'00000'+ '0000000000000000')
            else: # LDM LDD STD
                if(asmInst[0] == 'LDM'):
                    print(Operands)
                    Rdst = Registers[Operands[0]]
                    Imm = Operands[1]
                    Instructions.append(binaryInst+Rdst+'00000000'+   bin(int('0x' + Imm, 16))[2:].zfill(16))

                else: # offset(R1)

                    params = Operands[1]
                    params = params[:-1]
                    params = params.split('(')
                    if(asmInst[0] == 'LDD'):
                        Rdst = Registers[Operands[0]]
                        Rsrc1 = Registers[params[1]]
                        Offset = params[0]
                        Instructions.append(binaryInst+Rdst+Rsrc1+'00000'+  bin(int('0x' + Offset, 16))[2:].zfill(16))
                    else:
                        Rsrc1 = Registers[Operands[0]]
                        Rsrc2 = Registers[params[1]]
                        Offset = params[0]
                        Instructions.append(binaryInst+'000'+Rsrc1+Rsrc2+'00'+  bin(int('0x' + Offset, 16))[2:].zfill(16))
        elif (asmInst[0] in BranchOpCode.keys()):
            binaryInst = BranchOpCode[asmInst[0]]
            if(len(asmInst) == 1 ):
                Instructions.append(binaryInst+'00000000000'+ '0000000000000000')
            else:
                if(asmInst[0] == 'INT'):
                    index = asmInst[1]
                    Instructions.append(binaryInst+'00000000000'+  bin(int('0x' +index, 16))[2:].zfill(16))
                else: # jumps and call all use IMM
                    IMM = asmInst[1]
                    Instructions.append(binaryInst+'00000000000'+  bin(int('0x' +IMM, 16))[2:].zfill(16))
        else:
            # line after the ORG
            Instructions.append(bin(int('0x' +asmInst[0].lower(), 16))[2:].zfill(32))
        

        InstructionOrder.append(IndexNow)
        if( IndexNow != None):
            IndexNow+=1

# convert the instructions to Hexadecimal

HexaInsructs = [hex(int(i, 2)).upper()[2:] for i in Instructions]


with open( rootDir + filename + '.do' ,'w') as f:
    for line in startSim:
        f.write(line)
        f.write('\n')

    for(instruction , Order) in zip(HexaInsructs , InstructionOrder):
        f.write('mem load -filltype value -filldata {} -fillradix hexadecimal /processor/MEM/dataMemory({})'.format(instruction, Order))
        f.write('\n')

    for line in startingLines:
        f.write(line)
        f.write('\n')


                    



















            

