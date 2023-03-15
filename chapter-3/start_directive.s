#PURPOSE: 	Program to show the error when no end syscall

#INPUT:  	none

#OUTPUT: 				
#
#			The error message when run the program (Segmentation fault)
.section .data

.section .text
	.globl _start

_start:

	movl $1, %eax
