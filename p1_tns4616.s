/******************************************************************************
* @file p1_tns4616.s
* @make a simple calculator that has +,-,*,M
*
* @author Tanmay Sardesai, 1001094616
******************************************************************************/
 
    .global main
    .func main
   
main:
    	BL  _prompt1            @ branch to prompt1 procedure with return
    	BL  _scanf              @ branch to scanf procedure with return
	MOV R4, R0				@ move return value R0 to argument register R4
	MOV R1, R0              @ move return value R0 to argument register R1
	BL	_printf				@ print the value entered by the user
	BL	_prompt2			@ branch to prompt2 procedure with return
	BL  _getchar            @ branch to scanf procedure with return
	MOV R5, R0				@ move return value R0 to argument register R5	
	BL  _prompt1            @ branch to prompt1 procedure with return
    	BL  _scanf              @ branch to scanf procedure with return
	MOV R6, R0				@ move return value R0 to argument register R6    
	MOV R1, R0              @ move return value R0 to argument register R3
	BL	_printf	
	MOV	R1,R4				@ move return value R0 to argument register R1
	MOV R2,R5				@ move return value R0 to argument register R1
	MOV R3,R6    			@ move return value R0 to argument register R1
	BL  _compare            @ check the scanf input
	MOV R1,R0				@ move result to input register R1 from register R0
	BL	_print_val			@ print value stored in R1    
	B   main                @ branch back to start of main for infinite loop

_print_val:
	MOV R7, LR          	@ store LR since printf call overwrites
    	LDR R0,=result_str  	@ string at label resultstr:    
	BL printf           	@ call printf, where R1 is the print argument
    	MOV LR, R7         		@ restore LR from R4
    	MOV PC, LR          	@ return
   
_scanf:
    	MOV R7, LR              @ store LR since scanf call overwrites
    	SUB SP, SP, #4          @ make room on stack
    	LDR R0, =format_str     @ R0 contains address of format string
    	MOV R1, SP              @ move SP to R1 to store entry on stack
    	BL scanf                @ call scanf
    	LDR R0, [SP]            @ load value at SP into R0
    	ADD SP, SP, #4          @ restore the stack pointer
    	MOV PC, R7              @ return 

_printf:
    	MOV R7, LR              @ store LR since printf call overwrites
    	LDR R0, =printf_str     @ R0 contains formatted string address
    	MOV R1, R1              @ R1 contains printf argument (redundant line)
    	BL printf               @ call printf
    	MOV PC, R7              @ return

_prompt1:
    	MOV R7, #4              @ write syscall, 4
    	MOV R0, #1              @ output stream to monitor, 1
    	MOV R2, #17             @ print string length
    	LDR R1, =prompt1_str    @ string at label prompt_str:
    	SWI 0                   @ execute syscall
    	MOV PC, LR              @ return

_prompt2:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #33             @ print string length
    LDR R1, =prompt2_str    @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return
   
_getchar:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return
 
_compare:
	MOV R7,LR
    	CMP R2, #'+'            @ compare against the constant char '+'
	BLEQ _add				@ branch if equal to add with return
	CMP R2, #'-'            @ compare against the constant char '-'
	BLEQ _sub				@ branch if equal to add with return
	CMP R2, #'*'            @ compare against the constant char '*'
	BLEQ _mul				@ branch if equal to add with return    
    	CMP R2, #'M'			@ compare against the constant char 'M'
	BLEQ	_max				@ branch if equal to add with return
	MOV PC, R7				@ return

_add:
	MOV R0,R1				@ copy input register R1 to output R0
	ADD R0,R3				@ add input register R3 to register R0
	MOV PC,LR				@ return

_sub:
	MOV R0,R1				@ copy input register R1 to output R0
	SUB R0,R3				@ sub input register R3 from register R0 
	MOV PC,LR				@ return

_mul:
	MOV R0,R1				@ copy input register R1 to output R0
	MUL R0,R3				@ multiply input register R3 to register R0
	MOV PC,LR				@ return
		
_max:
	CMP R1,R3				@ compare value in register R1, R3
	MOVLE R1,R3				@ move register R3 to R1 is R1 is lesser than or equal to R3
	MOV R0,R1				@ move from register R1 to output register R0	
	MOV PC,LR				@ return

.data
printf_str:     .asciz      "The number entered was: %d\n"
format_str:		.asciz		"%d"
read_char:      .ascii      " "
prompt1_str:    .ascii      "Enter a number : "
prompt2_str:	.ascii		"Enter a operation from +,-,*,M : "
result_str:		.asciz 		"Result = %d\n"
