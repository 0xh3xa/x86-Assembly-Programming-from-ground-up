.include "linux.s"

.section .data
    hello_world:
        .ascii "Hello World!\n"

    hello_world_end:
        .equ hello_world_len, hello_world_end - hello_world

.section .text
.globl _start

_start:
    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl $hello_world, %ecx
    movl $hello_world_len, %edx
    int $LINUX_SYSCALL_INT

    movl $0, %ebx
    movl $SYS_EXIT, %eax
    int $LINUX_SYSCALL_INT
