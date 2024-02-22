.model small 
.data

ARRAY DB 45, 0, 28, 76, 45, 0, 0, 14, 32, 27, 14, 39, 0, 68, 15, 23, 0, 14, 42, 27 

CONTROLLED_ADDER EQU 1
CONTROLLER_ADDER EQU 1
STOPPER EQU 20
DUPLICATE_ZERO EQU 0

.stack           
.code
.STARTUP 
                                                                                 
MOV SI, OFFSET ARRAY                                                                                
MOV DI, OFFSET ARRAY       ;Getting Location of Array to Operate
MOV AX, CONTROLLER_ADDER
MOV BX, CONTROLLED_ADDER   ;Loop statement(like "i" in C Language)

LOOP1:                 
MOV CH, BYTE PTR DS:[DI]   ;Looping in 2 arrays
MOV CL, BYTE PTR DS:[SI]   ;CH Loops in every 20 loops of CL
CMP CH, CL                 ;Reason of it CL checks every element according to CH
JE DUPLICATE_ZERO_CHECKER  ;whether it is duplicate or not
LOOP1_CONTINUE:
ADD SI, BX
CMP SI,STOPPER
JE LOOP2
LOOP LOOP1

LOOP2:
ADD DI, AX
MOV SI, OFFSET ARRAY
CMP DI, STOPPER
JE CONTINUE1
JNE LOOP1 

DUPLICATE_ZERO_CHECKER:
CMP SI, DI
JA DUPLICATE_ZERO_CONVERTER;If our CH index smaller than CL index
JBE LOOP1_CONTINUE         ;It is the first occurance so it is not going to be zero
                           ;If not it is going to be zero
DUPLICATE_ZERO_CONVERTER:
MOV ARRAY[SI], DUPLICATE_ZERO
JMP LOOP1_CONTINUE       
        
CONTINUE1:                 ;At this point array is clarified from duplicates   
MOV AX, CONTROLLER_ADDER
MOV SI, OFFSET ARRAY
MOV CX, 0
MOV BX, CONTROLLED_ADDER 
                 
STACKINGLOOP1:
MOV CL, BYTE PTR DS:[SI]   ;Putting all remaining varibles in stack besides zeros
ADD SI,AX                  ;Holding the number of zeros to utizlize array's order next time
CMP SI,STOPPER
JE UN_STACK
CMP CL, 0
JE ZERO_COUNTING
JNE STACKING1
LOOP STACKINGLOOP1

ZERO_COUNTING:
ADD BX, AX
JMP STACKINGLOOP1

STACKING1:
PUSH CX
JMP STACKINGLOOP1

UN_STACK:            
MOV DX, STOPPER
SUB DX, BX
MOV SI, DX
SUB SI, AX
              
UN_STACKING:
POP CX                     ;Unstacking and putting elements in correct order.
MOV BYTE PTR DS:[SI], CL   ;Since the stack is LIFO we are going to get the last element before zeros.
SUB SI, AX                 ;So with this algorithm last element is placed next to first zero.
CMP SI, 0                  ;After this we are zero padding the rest of the array.
JE PRE_ZERO_PADDING
LOOP UN_STACKING

PRE_ZERO_PADDING:
MOV DX, STOPPER
SUB DX, BX
MOV SI, DX

ZERO_PADDING:                  
MOV BYTE PTR DS:[SI], 0
ADD SI,AX
CMP SI,STOPPER
JE FINAL 
LOOP ZERO_PADDING
                 
FINAL:                 
                 
.EXIT 
END                                                                                                                                                                       