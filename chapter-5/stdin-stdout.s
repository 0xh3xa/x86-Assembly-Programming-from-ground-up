#PURPOSE: 	Program to create a new file and write msg to that file

#INPUT:  	filename

#OUTPUT:   none
.section .data
    msg: .ascii "Insert an input:\n"
    msg_len =.-msg
    
    .equ MAX_CHAR, 30

	#system calls numbers
	.equ SYS_OPEN, 5
	.equ SYS_WRITE, 4
	.equ SYS_READ, 3
	.equ SYS_CLOSE, 6
	.equ SYS_EXIT, 1

    #standard file descriptors
	.equ STDIN, 0
	.equ STDOUT, 1
	.equ STDERR, 2

    .equ END_LINE, 0xa              #new-line \n
	.equ LINUX_SYSCALL_INT, 0x80

.text
.globl _start

_start:

    write_stdout:
        movl $SYS_WRITE, %eax
        movl $STDOUT, %ebx
        movl $msg, %ecx
        movl $msg_len, %edx
        int $LINUX_SYSCALL_INT

    read_stdin:
        movl $SYS_READ, %eax
        movl $STDIN, %ebx
        movl %esp, %ecx
        movl $MAX_CHAR, %edx
        int $LINUX_SYSCALL_INT

    movl $1, %ecx 		            #Counter

    #loop over the input str
    #to know how many chars entered
    #maybe less (Max Char<=30)
    movl %esp, %ebp
    input_str_loop:
        xor %ebx, %ebx              #reset to zero, same vals with xor gives zero
        movb (%esp), %bl            #move one byte char to bl
        incl %esp		            #Get next char to compare
        incl %ecx	 	            #Counter+=1
        cmpb $END_LINE, %bl	        #Compare with "\n" 
        jne input_str_loop		    #If not, continue 

    movl %ebp, %esp
    print_input_str_stdout:
        // subl %ecx, %esp		    #Start from the first input char
        movl $SYS_WRITE, %eax
        movl $STDOUT, %ebx
        movl %ecx, %edx         #Length of input str
        movl %esp, %ecx         #Location of the string from stack pointer
        int $LINUX_SYSCALL_INT
        
    exit_program:
        xor %ebx, %ebx          #reset ebx to zero
        movl $1, %eax
        int $LINUX_SYSCALL_INT
