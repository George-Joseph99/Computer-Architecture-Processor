# all numbers in hex format
# we always start by reset signal
# this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines



#check on load use
.ORG 700
SETC      #C-->1
Call 300  #SP=FFFFFFFE, M[FFFFFFFF]=next PC
INC R6	  #R6=401, this statement shouldn't be executed till call returns, C--> 0, N-->0,Z-->0
NOP
NOP


.ORG 300
ADD R6,R3,R6 #R6=400
ADD R1,R1,R2 #R1=80, C->0,N=0, Z=0
RET
SETC           
