
#PURPOSE: 	Program to calculate the square result

#INPUT:  	none

#OUTPUT: 				

#VARIABLES:		The registers have the following uses:
#					%ebx - Holds the number
#					%eax - Holds the number and result
.section .data

.section .text
	.globl _start

_start:
	pushl $4
	call square
	addl $4, %esp

	movl %eax, %ebx
	movl $1, %eax
	int $0x80

.type square,@function
square:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %eax
	movl 8(%ebp), %ebx
	
	imull %ebx, %eax

	movl %ebp, %esp
	popl %ebp
	ret
