#PURPOSE:  Program to take a file argument to read and print it to the screen (STD)

#INPUT:    file path

#OUTPUT:   print content to screen (STD)
.include "linux.s"

.section .bss
.equ BFFER_SIZE, 10
.lcomm BFFER, BFFER_SIZE

.section .text
.globl _start

.equ ST_FD_IN, -4
.equ ST_ARGC, 0                     #number of arguments
.equ ST_ARGV_0, 4                   #name of the program
.equ ST_ARGC_1, 8                   #file name

_start:
	movl %esp, %ebp

    movl $SYS_OPEN, %eax
    movl ST_ARGC_1(%ebp), %ebx
    movl $O_RDONLY, %ecx
    movl $PERM_NORMAL, %edx
    int $LINUX_SYSCALL_INT

    movl %eax, ST_FD_IN(%ebp)
    
    subl $4, %esp

    loop_start:
        movl $SYS_READ, %eax
        movl ST_FD_IN(%ebp), %ebx
        movl $BFFER, %ecx
        movl $BFFER_SIZE, %edx
        int $LINUX_SYSCALL_INT

        cmpl $END_OF_FILE, %eax
        jle loop_end

        movl %eax, %edx              #size of the actually buffer
        movl $SYS_WRITE, %eax
        movl $STDOUT, %ebx
        movl $BFFER, %ecx
        int $LINUX_SYSCALL_INT
        jmp loop_start

    loop_end:

        movl $SYS_CLOSE, %eax
        movl ST_FD_IN(%ebp), %ebx
        int $LINUX_SYSCALL_INT

        addl $4, %esp
        movl %ebp, %esp
        popl %ebp

        xor %ebx, %ebx
        movl $SYS_EXIT, %eax
        int $LINUX_SYSCALL_INT
