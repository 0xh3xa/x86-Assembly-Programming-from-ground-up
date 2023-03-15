
#PURPOSE: 	Program to calculate the power result

#INPUT:  	none

#OUTPUT: 				

#VARIABLES:		The registers have the following uses:
#					%ecx - Holds the power number
#					%ebx - Holds the base number
#					%eax - Holds the value from local variable -4(%ebp) and multiple with %ebx
#					local variable -4(%ebp) - Holds the multiply value
#					-4(%ebx) = %ebx * %eax
.section .data

.section .text
	.globl _start

_start:
	pushl $2
	pushl $3
	call power
	addl $8, %esp

	movl %eax, %ebx
	movl $1, %eax
	int $0x80

.type power, @function
power:
	pushl %ebp
	movl %esp, %ebp
	subl $4, %esp

	movl 12(%ebp), %ebx
	movl 8(%ebp), %ecx

	movl $1, %eax

	cmpl $0, %ecx
	je power_return

	movl %ebx, -4(%ebp)

	power_loop_start:
		cmpl $1, %ecx
		je end_power

		decl %ecx

		movl -4(%ebp), %eax
		imull %ebx, %eax
		movl %eax, -4(%ebp)

		jmp power_loop_start

	end_power:
		movl -4(%ebp), %eax
		jmp power_return

	power_return:
		movl %ebp, %esp
		popl %ebp
		ret
