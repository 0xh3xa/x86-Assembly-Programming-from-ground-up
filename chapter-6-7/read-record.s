#PURPOSE: This routine amis to read one record and save content in the buffer

#INPUT:   buffer and file descriptor

#OUTPUT:  none

.include "linux.s"
.include "record-def.s"

.section .data
    .equ ST_READ_BUFFER, 8
    .equ ST_FILE_DESCRIPTOR, 12

.section .text
.globl read_record

.type read_record, @function
read_record:
    pushl %ebp
    movl %esp, %ebp

    pushl %ebx

    movl $SYS_READ, %eax
    movl ST_FILE_DESCRIPTOR(%ebp), %ebx
    movl ST_READ_BUFFER(%ebp), %ecx
    movl $RECORD_SIZE, %edx
    int $LINUX_SYSCALL_INT

    popl %ebx
    
    movl %ebp, %esp
    pop %ebp
    ret
