
#PURPOSE: 	Program to test the square function

#INPUT:  	none

#OUTPUT: 	Correct answer or Wrong answer		
.include "linux.s"
.section .data
	num: .int 5
	correct_msg: .ascii "correct answer\n"
	correct_msg_len = . -correct_msg
	wrong_msg: .ascii "wrong answer\n"
	wrong_msg_len = . -wrong_msg

.section .text
	.globl _start

_start:

	pushl $num
	call square
	addl $4, %esp
	
	test_square_result:
	movl %eax, %ebx
	movl $num, %eax
	imull %eax, %eax
	cmpl %ebx, %eax
	jne else

	pushl $correct_msg
	pushl $correct_msg_len
	call print
	jmp end_if

	else:
	pushl $wrong_msg
	pushl $wrong_msg_len
	call print
	
	end_if:

	addl $8, %esp

	xor %ebx, %ebx
	movl $SYS_EXIT, %eax
	int $LINUX_SYSCALL_INT

.type print,@function
print:
	pushl %ebp
	movl %esp, %ebp

	movl $SYS_WRITE, %eax
	movl $STDOUT, %ebx
	movl 12(%ebp), %ecx
	movl 8(%ebp), %edx
	int $LINUX_SYSCALL_INT

	movl %ebp, %esp
	popl %ebp
	ret

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
