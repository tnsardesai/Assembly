/******************************************************************************
* @file p2_tns4616.s
* @computing number of integer partitions for a positive integer
*  n with parts up to m
* @author Tanmay Sardesai, 1001094616
******************************************************************************/
 
    .global main
    .func main

main:
	BL _prompt
	BL _scanf
	MOV R4,R0
	BL _prompt
	BL _scanf
	MOV R5,R0
	MOV R1,R4
	MOV R2,R5
	MOV R7,#0
	MOV R0,#0
	BL _count_partition
	ADD R0,R0,R7
	MOV R1,R0
	MOV R2,R4
	MOV R3,R5
	BL _print_val
	B main

_print_val:
	PUSH {LR}	          	@ store LR since printf call overwrites
    LDR R0,=result_str  	@ string at label resultstr:    
	BL printf           	@ call printf, where R1 is the print argument
    POP {LR}
	MOV PC, LR	          	@ return

_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #17             @ print string length
    LDR R1, =prompt_str    @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_scanf:
    PUSH {LR}              @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer	
	POP {LR}    
	MOV PC, LR              @ return 

_count_partition:
	PUSH {LR}
	CMP R1,#0
	MOVEQ R0,#1
	POPEQ {PC}

	MOVLT R0,#0
	POPLT {PC}

	CMP R2,#0
	MOVEQ R0,#0
	POPEQ {PC}

	PUSH {R1}
	PUSH {R2}
	SUB R1,R1,R2
	BL _count_partition
	ADD R7,R7,R0
	POP {R2}
	POP {R1}
	SUB R2,R2,#1
	BL _count_partition
	POP {PC}


	
	


.data
prompt_str:     .ascii      "Enter a number : "
format_str:		.asciz		"%d"
result_str:		.asciz 		"There are %d partitions of %d using integers up to %d\n"
