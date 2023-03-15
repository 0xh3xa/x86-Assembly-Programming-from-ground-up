.include "linux.s"

.section .data
    like_msg:
        .ascii "dad likes dressy clothes\n"
    like_msg_end:
       .equ like_msg_len, like_msg_end - like_msg

    not_like_msg:
        .ascii "dad doesn't like dressy clothes\n"
    not_like_msg_end:
       .equ not_like_msg_len, not_like_msg_end - not_like_msg

.section .text
.globl _start

_start:

    movl $0b00000000000000000000000000001011, %ebx
    movl %ebx, %eax

    shrl $1, %eax
    andl $0b00000000000000000000000000000001, %eax

    cmpl $0b00000000000000000000000000000001, %eax
    je ye_he_likes_dressy_clothes

    jmp no_he_doesnt_like_dressy_clothers

    ye_he_likes_dressy_clothes:
        pushl $like_msg
        pushl $like_msg_len
        call my_print
        addl $8, %esp
        
        jmp end_program

    no_he_doesnt_like_dressy_clothers:
        pushl $not_like_msg
        pushl $not_like_msg_len
        call my_print
        addl $8, %esp

    end_program:
        xor %ebx, %ebx
        movl $SYS_EXIT, %eax
        int $LINUX_SYSCALL_INT

.type my_print, @function
.equ MSG, 12
.equ MSG_LEN, 8
my_print:
    pushl %ebp
    movl %esp, %ebp
    
    movl $SYS_WRITE, %eax
    movl $STDOUT, %ebx
    movl MSG(%ebp), %ecx
    movl MSG_LEN(%ebp), %edx
    int $LINUX_SYSCALL_INT

    movl %ebp, %esp
    popl %ebp
    ret
