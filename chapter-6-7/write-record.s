#PURPOSE: 	This routine amis to write a record to a file descriptor

#INPUT:  	buffer and file descriptor

#OUTPUT:   none
.include "linux.s"
.include "record-def.s"

.equ ST_WRITE_BUFFER, 8
.equ ST_FILE_DESCRIPTOR, 12

.section .text
.global write_record

.type write_record, @function
write_record:
    pushl %ebp
    movl %esp, %ebp
    
    pushl %ebx

    movl $SYS_WRITE, %eax
    movl ST_FILE_DESCRIPTOR(%ebp), %ebx
    movl ST_WRITE_BUFFER(%ebp), %ecx
    movl $RECORD_SIZE, %edx
    int $LINUX_SYSCALL_INT

    popl %ebx
    
    movl %ebp, %esp
    popl %ebp
    ret

