#PURPOSE: 	This routine amis to loop over the records and read each record

#INPUT:  	file input descriptor and file output descriptor

#OUTPUT:   none
.include "linux.s"
.include "record-def.s"

.section .data

    file_name:
        .ascii "test.dat\0"

    .equ ST_INPUT_DESCRIPTOR, -4
    .equ ST_OUTPUT_DESCRIPTOR, -8

.section .bss
    .lcomm record_buffer, RECORD_SIZE

.section .text
.global _start

_start:
    
    movl %esp, %ebp
    subl $8, %esp

    movl $SYS_OPEN, %eax
    movl $file_name, %ebx
    movl $0, %ecx                   #open read-only
    movl $0666, %edx
    int $LINUX_SYSCALL_INT

    store_FD_IN:
        movl %eax, ST_INPUT_DESCRIPTOR(%ebp)

    store_FD_OUT:
        movl $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)

    record_read_loop:
        pushl ST_INPUT_DESCRIPTOR(%ebp)
        pushl $record_buffer
        call read_record
        addl $8, %esp

        cmpl $RECORD_SIZE, %eax                         #if the return value not the same record size, then it's end or an error
        jne finihsed_reading

        pushl $RECORD_FIRSTNAME + record_buffer
        call count_chars
        addl $4, %esp

        movl %eax, %edx
        movl $SYS_WRITE, %eax
        movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
        movl $RECORD_FIRSTNAME + record_buffer, %ecx
        int $LINUX_SYSCALL_INT

        pushl ST_OUTPUT_DESCRIPTOR(%ebp)
        call write_newline
        addl $4, %esp

        jmp record_read_loop

    finihsed_reading:    
        movl $SYS_EXIT, %eax
        movl $0, %ebx
        int $LINUX_SYSCALL_INT
