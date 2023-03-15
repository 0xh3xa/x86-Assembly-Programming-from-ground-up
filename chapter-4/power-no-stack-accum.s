
#PURPOSE: 	Program to calculate power result using stack, i.e 2^5

#INPUT:  	none

#OUTPUT: 				

#VARIABLES:		The registers have the following uses:
#					%ecx - Holds the power number
#					%ebx - Holds the base number and store power value
#					%eax - Holds the base number, used to multiply it with %ebx
#					%ebx = %ebx * %eax => %ebx = 2 * 2 = 4, %ebx = 4 * 2 = 8, ..., %ebx = 16 * 2 = 32
.section .data

.section .text
	.globl _start

_start:
	pushl $2
	pushl $5
	call power
	addl $8, %esp

	movl %eax, %ebx
	movl $1, %eax
	int $0x80

.type power, @function
power:
	pushl %ebp
	movl %esp, %ebp

	movl 12(%ebp), %ebx			#has 2, which is the base
	movl 8(%ebp), %ecx			#has 5, which is power, will be the counter

	cmp $0, %ecx
	je end_power

	movl %ebx, %eax

	power_loop_start:
		cmp $1, %ecx
		je end_power

		decl %ecx

		imull %ebx, %eax
		jmp power_loop_start

	end_power:
		movl %ebp, %esp
		popl %ebp
		ret
