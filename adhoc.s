.include "linux.s"

.section .bss

.section .text
.globl _start

.equ ST_COUNTER, -4
.equ ST_ARGC, 0         # number of arguments
.equ ST_ARGV_0, 4       # name of the program
.equ ST_ARGC_1, 8       # file name

_start:
    movl %esp, %ebp

    subl $4, %esp
    
    movl ST_ARGC(%ebp), %ecx
    movl %ecx, ST_COUNTER(%ebp)

    
    xor %ebx, %ebx
    movl $SYS_EXIT, %eax
    int $LINUX_SYSCALL_INT
