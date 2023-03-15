#PURPOSE: 	 Program to convert an input file to an output file with all letters 
#			 converted to uppercase
#Processing: 	1) Open the input file
#	     		2) Open the output file
#	    		3) While we're not at the end of the input file
#					a) read part of file into our memory buffer
#					b) go through each byte of memory
#					,if the byte is lowercase letter
#					,convert it to uppercase
#					c) write the memory buffer to output file
.section .data
	#system calls numbers
	.equ SYS_OPEN, 5
	.equ SYS_WRITE, 4
	.equ SYS_READ, 3
	.equ SYS_CLOSE, 6
	.equ SYS_EXIT, 1

	#options for open
	.equ O_RDONLY, 0
	.equ O_CREAT_WRONLY_TRUNC, 03101

	#standard file descriptors
	.equ STDIN, 0
	.equ STDOUT, 1
	.equ STDERR, 2

	#system call interrupt
	.equ LINUX_SYSCALL_INT, 0x80

	#This is the return value of read
	#which means hit the end of the file
	.equ END_OF_FILE, 0
	.equ NUMBER_ARGS, 2


.section .bss
	.equ BUFFER_SIZE, 500
	.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text
	#Stack positions
	.equ ST_SIZE_RESERVE, 8
	.equ ST_FD_IN, -4
	.equ ST_FD_OUT, -8
	.equ ST_ARGC, 0
	.equ ST_ARGV_0, 4					#program name
	.equ ST_ARGV_1, 8					#input file name
	.equ ST_ARGV_2, 12					#output file name

.globl _start

_start:
	movl %esp, %ebp
	subl $ST_SIZE_RESERVE, %esp			#2 words

	open_files:
	open_fd_in:
		movl $SYS_OPEN, %eax			#set open sys call
		movl ST_ARGV_1(%ebp), %ebx		#get filename from ARGs
		movl $O_RDONLY, %ecx			#set flags
		movl $0666, %edx				#file mode
		int $LINUX_SYSCALL_INT

	store_fd_in:
		movl %eax, ST_FD_IN(%ebp)

	open_fd_out:
		movl $SYS_OPEN, %eax
		movl ST_ARGV_2(%ebp), %ebx
		movl $O_CREAT_WRONLY_TRUNC, %ecx
		movl $0666, %edx
		int $LINUX_SYSCALL_INT

	store_fd_out:
		movl %eax, ST_FD_OUT(%ebp)

	read_loop_begin:
		movl $SYS_READ, %eax
		movl ST_FD_IN(%ebp), %ebx		#get the input file descriptor
		movl $BUFFER_DATA, %ecx			#the location to read into
		movl $BUFFER_SIZE, %edx			#size of the buffer
		
		int $LINUX_SYSCALL_INT

		cmpl $END_OF_FILE, %eax			#exit condition when hit end of the file
		jle end_loop

		continue_read_loop:
			pushl $BUFFER_DATA
			pushl %eax
			call convert_to_upper
			pop %eax
			addl $4, %esp

			movl %eax, %edx				#buffer size
			movl $SYS_WRITE, %eax	
			movl ST_FD_OUT(%ebp), %ebx	#output file descriptor 
			movl $BUFFER_DATA, %ecx		#buffer location
			int $LINUX_SYSCALL_INT

			jmp read_loop_begin

		end_loop:
			movl $SYS_CLOSE, %eax
			movl ST_FD_OUT(%ebp), %ebx
			int $LINUX_SYSCALL_INT

			movl $SYS_CLOSE, %eax
			movl ST_FD_IN(%ebp), %ebx
			int $LINUX_SYSCALL_INT

			movl $SYS_EXIT, %eax
			movl $0, %ebx
			int $LINUX_SYSCALL_INT


.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z,'z'
.equ UPPER_CONVERSION, 'A' - 'a'

.equ ST_BUFFER_LEN, 8
.equ ST_BUFFER, 12

convert_to_upper:
	pushl %ebp
	movl %esp, %ebp

	movl ST_BUFFER(%ebp), %eax
	movl ST_BUFFER_LEN(%ebp), %ebx
	movl $0, %edi
	cmpl $0, %ebx						#if a buffer with zero length was given to use just leav
	je end_convert_loop

	convert_loop:
		movb (%eax, %edi, 1), %cl
		cmpb $LOWERCASE_A, %cl
		jl next_byte
		cmpb $LOWERCASE_Z, %cl
		jg next_byte

		addb $UPPER_CONVERSION, %cl
		movb %cl, (%eax, %edi, 1)
		
		next_byte:
			incl %edi
			cmpl %edi, %ebx
			jne convert_loop

		end_convert_loop:
			movl %ebp, %esp
			popl %ebp
			ret
