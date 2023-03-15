#PURPOSE: 	Program to print a msg to STDOUT

#INPUT:  	filename

#OUTPUT:   none
.section .data
    msg: .ascii "hello world!\nhi man!\n"
    len = .-msg

.section .text
    .globl _start

_start:
    movl $4, %eax       #Write syscall
    movl $1, %ebx       #StdOut
    movl $msg, %ecx     #String data in ecx
    movl $len, %edx     #Length in edx
    int $0x80           #Syscall int

    movl $1, %eax
    int $0x80
