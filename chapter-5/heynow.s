#PURPOSE: 	Program to create a new file and write msg to it

#INPUT:  	filename

#OUTPUT:   none
.section .data
	msg: .ascii "Hey diddle diddle!\n"
	msg_len=.-msg

	#system calls numbers
	.equ SYS_OPEN, 5
	.equ SYS_WRITE, 4
	.equ SYS_CLOSE, 6
	.equ SYS_EXIT, 1

	.equ O_CREAT_WRONLY_TRUNC, 03101

	.equ LINUX_SYSCALL_INT, 0x80

	.equ NUMBER_ARGS, 1

.section .text
	.equ ST_SIZE_RESERVE, 4
	.equ ST_FD_OUT, -4
	.equ ST_ARGC, 0
	.equ ST_ARGV_0, 4							#program name
	.equ ST_ARGV_1, 8							#outfile file name

.global _start

_start:
	movl %esp, %ebp
	subl $ST_SIZE_RESERVE, %esp

	open_file:
	open_fd_out:
		movl $SYS_OPEN, %eax					#set open sys call
		movl ST_ARGV_1(%ebp), %ebx				#get filename from ARGs
		movl $O_CREAT_WRONLY_TRUNC, %ecx		#set flags
		movl $0666, %edx						#file mode
		int $LINUX_SYSCALL_INT

	store_fd_out:
		movl %eax, ST_FD_OUT(%ebp)

	write_to_file:
		movl $SYS_WRITE, %eax	
		movl ST_FD_OUT(%ebp), %ebx				#output file descriptor 
		movl $msg, %ecx							#buffer location
		movl $msg_len, %edx
		int $LINUX_SYSCALL_INT

	end_program:
		movl $SYS_CLOSE, %eax
		movl ST_FD_OUT(%ebp), %ebx
		int $LINUX_SYSCALL_INT

		movl $SYS_EXIT, %eax
		movl $0, %ebx
		int $LINUX_SYSCALL_INT
