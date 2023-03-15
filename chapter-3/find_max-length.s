#PURPOSE: 	Program to find the maximum number of a set of data items

#INPUT:  	none

#OUTPUT: 				

#VARIABLES:		The registers have the following uses:
#					%edi - Holds the index of the data item being examined	
#					%ebx - Largest data item found
#					%eax - Current data item
#
#			The following memory locations are used:
#					data_items - contains the item data.  the length is used to terminate the data
.section .data
	numbers:
		.long 4,2,5,7,1,3
	numbers_size = . -numbers				#6 elements * 4 size = 24
	numbers_len = (. -numbers) / 4			#24 / 4 size = 6

.section .text
	.globl _start

_start:
		movl $0, %edi
		movl numbers(,%edi,4), %eax

		movl %eax, %ebx

		start_loop:
			incl %edi
			cmpl $numbers_len, %edi
			je loop_exit
			
			movl numbers(,%edi,4), %eax

			cmpl %ebx, %eax
			jle start_loop

			movl %eax, %ebx
			jmp start_loop

		loop_exit:
			movl $1, %eax
			int $0x80
