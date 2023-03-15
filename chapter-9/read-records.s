#PURPOSE: 	This routine amis to loop over the records and read each record

#INPUT:  	file input descriptor and file output descriptor

#OUTPUT:   none
.include "linux.s"
.include "record-def.s"

.section .data

    file_name:
        .ascii "test.dat\0"

    record_buffer_ptr:
        .long 0

    .equ ST_INPUT_DESCRIPTOR, -4
    .equ ST_OUTPUT_DESCRIPTOR, -8


.section .text
.global _start

_start:
    
    movl %esp, %ebp
    subl $8, %esp

    // call allocate_init

    pushl $RECORD_SIZE
    call allocate
    movl %eax, record_buffer_ptr

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
        pushl record_buffer_ptr
        call read_record
        addl $8, %esp

        cmpl $RECORD_SIZE, %eax                         #if the return value not the same record size, then it's end or an error
        jne finihsed_reading

        movl record_buffer_ptr, %eax
        addl $RECORD_FIRSTNAME, %eax
        pushl %eax
        call count_chars
        addl $4, %esp

        movl %eax, %edx
        movl $SYS_WRITE, %eax
        movl ST_OUTPUT_DESCRIPTOR(%ebp), %ebx
        movl record_buffer_ptr, %ecx
        addl $RECORD_FIRSTNAME, %ecx
        int $LINUX_SYSCALL_INT

        pushl ST_OUTPUT_DESCRIPTOR(%ebp)
        call write_newline
        addl $4, %esp

        jmp record_read_loop

    finihsed_reading:
        pushl record_buffer_ptr
        call deallocate

        movl $SYS_EXIT, %eax
        xor %ebx, %ebx
        int $LINUX_SYSCALL_INT
