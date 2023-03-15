
#PURPOSE: 	Program to find factorial value using recursion

#INPUT:  	none

#OUTPUT: 				

#VARIABLES:		The registers have the following uses:
#					%ebx - Number to multiplay with eax
#					%eax - Current recursion series
.code32
.section .data

.section .text
	.globl _start

_start:
	pushl $5
	call factorial
	addl $4, %esp

	movl %eax, %ebx
	movl $1, %eax
	int $0x80

.type factorial,@function
factorial:
	pushl %ebp
	movl %esp, %ebp

	movl 8(%ebp), %eax

	cmpl $1, %eax
	je end_factorial

	decl %eax
	pushl %eax
	call factorial

	movl 8(%ebp), %ebx
	imull %ebx, %eax

	end_factorial:
		movl %ebp, %esp
		popl %ebp
		ret
