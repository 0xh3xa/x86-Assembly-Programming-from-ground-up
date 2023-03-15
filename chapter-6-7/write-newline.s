#PURPOSE: 	This routine amis to write new line to the STD

#INPUT:  	file descriptor

#OUTPUT:   none
.include "linux.s"

.section .data
    new_line:
        .ascii "\n"

    .equ ST_FILE_DESCRIPTOR, 8

.section .text
.global write_newline

.type write_newline, @function

write_newline:
    pushl %ebp
    movl %esp, %ebp

    movl $SYS_WRITE, %eax
    movl ST_FILE_DESCRIPTOR(%ebp), %ebx
    movl $new_line, %ecx
    movl $1, %edx
    int $LINUX_SYSCALL_INT

    movl %ebp, %esp
    pop %ebp
    ret
