
#PURPOSE: 	Program to calculate power and sume result, i.e 2^5 + 3^3

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

	pushl %eax

	pushl $3
	pushl $3
	call power
	addl $8,%esp

	popl %ebx

	addl %eax, %ebx
	movl $1, %eax
	int $0x80

.type power, @function
power:
	pushl %ebp
	movl %esp, %ebp

	movl 12(%ebp), %ebx
	movl 8(%ebp), %ecx

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
