
#PURPOSE: 	Program to find max values using stack

#INPUT:  	none

#OUTPUT: 	Returns max value to the screen			

#VARIABLES:		The registers have the following uses:
#					%ecx - Counter variable used in loop
#					%ebx - Holds the max value
#					%eax - Pop value from the stack
.code32
.section .data

.section .text
	.globl _start

_start:
	pushl $3
	pushl $1
	pushl $-1
	pushl $16
	pushl $9
	pushl $2
	pushl $5
	pushl $10

	movl $6, %ecx

	popl %ebx

	start_loop:
		cmpl $0, %ecx
		je loop_exit
		decl %ecx

		popl %eax

		cmpl %ebx, %eax
		jle start_loop

		movl %eax, %ebx
		jmp start_loop

	loop_exit:
		movl $1, %eax
		int $0x80
