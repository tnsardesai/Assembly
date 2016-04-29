/******************************************************************************
* @file p3_tns4616.s
* @populate a array and then sort it in increasing order.
*
* @author Tanmay Sardesai, 1001094616
******************************************************************************/
 
    .global main
    .func main

main:
	BL _scanf
	MOV R4, R0
    MOV R0, #0              @ initialze index variable
	BL _generate
	MOV R0, #0
	BL _sort_ascending
	@MOV R0, #0
	BL _print_array
	B _exit

_generate:
writeloop:
    CMP R0, #20             @ check to see if we are done iterating
    MOVEQ PC, LR            @ exit loop if done
    LDR R1, =array_a        @ get address of a
	LDR R3, =array_b
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
	PUSH {R0}
	ADD R0, R0, R4    
	STR R0, [R2]            @ write the address of a[i] to a[i]    
	POP {R0}
	LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R3, R2          @ R2 now has the element address
	PUSH {R0}
	ADD R0, R0, R4    
	STR R0, [R2]            @ write the address of a[i] to a[i]    
	POP {R0}	
	ADD R0, R0, #1          @ increment index
	LSL R2, R0, #2
	ADD R2, R1, R2
	PUSH {R0}
	ADD R0, R0, R4
	RSB R0, R0, #0
	STR R0,[R2]
	POP {R0}
	LSL R2, R0, #2
	ADD R2, R3, R2
	PUSH {R0}
	ADD R0, R0, R4
	RSB R0, R0, #0
	STR R0,[R2]
	POP {R0}
	ADD R0, R0, #1
    B   writeloop           @ branch to next loop iteration

_sort_ascending:
loop1:
	CMP R0, #19
	MOVEQ PC, LR
	LDR R3, =array_b
	LSL R2 , R0, #2
	ADD R2 , R2, R3
	LDR R2, [R2]
	PUSH {R2}
	ADD R1 ,R0 , #1	
loop2:
	CMP R1, #20
	BEQ done2
	LSL R8, R1, #2
	ADD R8, R8, R3
	LDR R8, [R8]
	CMP R8,R2
	MOVLT R2,R8
	MOVLT R11,R1
	ADD R1,R1,#1
	B loop2
done2:
	POP {R5}
	CMP R2,R5
	MOVNE R6,R2
	MOVNE R2,R5
	MOVNE R5,R6
	LSLNE R10,R0, #2
	ADDNE R10,R10,R3
	STRNE R5,[R10]
	LSLNE R9,R11,#2
	ADDNE R9,R9,R3
	STRNE R2,[R9]
	ADD R0,R0,#1
	B loop1
	
_print_array:
	MOV R0,#0
	PUSH {LR}
readloop:
    CMP R0, #20             @ check to see if we are done iterating
	POPEQ {PC}
    LDR R1, =array_a        @ get address of a
	LDR R3, =array_b
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
	PUSH {R3}
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf_a           @ branch to print procedure with return
	POP {R3}    
	POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
	LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R3, R2          @ R2 now has the element address
    LDR R3, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
	PUSH {R3}
    MOV R2, R3              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf_b           @ branch to print procedure with return
	POP {R3}    
	POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
   
	
_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
       
_printf_a:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_printf_b:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str1     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return


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
   
.data

.balign 4
array_a:        .skip       80
.balign 4
array_b:		.skip		80
printf_str:     .asciz      "array_a[%d] = %d, "
printf_str1:     .asciz      "array_b[%d] = %d\n"
exit_str:       .ascii      "Terminating program.\n"
format_str:		.asciz		"%d"
