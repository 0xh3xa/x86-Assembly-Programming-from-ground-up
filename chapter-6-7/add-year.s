#PURPOSE: 	This routine amis to add year to the record

#INPUT:  	filename

#OUTPUT:   none
.include "linux.s"
.include "record-def.s"

.section .data
    input_file_name:
        .ascii "test.dat\0"
    
    output_file_name:
        .ascii "testout.dat\0"

    no_open_file_code:
        .ascii "0001: \0"
    
    no_open_file_msg:
        .ascii "Can't Open Input File\0"

.section .bss
    .lcomm record_buffer, RECORD_SIZE
    .equ ST_INPUT_DESCRIPTOR, -4
    .equ ST_OUTPUT_DESCRIPTOR, -8

.section .text
.globl _start

_start:
    movl %esp, %ebp
    subl $8, %esp

    movl $SYS_OPEN, %eax
    movl $input_file_name, %ebx
    movl $0, %ecx
    movl $0666, %edx
    int $LINUX_SYSCALL_INT

    store_FD_IN:
        movl %eax, ST_INPUT_DESCRIPTOR(%ebp)

    cmpl $0, %eax                                       # if eax is negative print error and exit
                                                        #otherwise greater then go to continue_progressing
    jl continue_progressing

    pushl $no_open_file_msg
    pushl $no_open_file_code
    call  error_exit

    continue_progressing:
        movl $SYS_OPEN, %eax
        movl $output_file_name, %ebx
        movl $0101, %ecx
        movl $0666, %edx
        int $LINUX_SYSCALL_INT

    store_FD_OUT:
        movl %eax, ST_OUTPUT_DESCRIPTOR(%ebp)

    loop_begin:
        pushl ST_INPUT_DESCRIPTOR(%ebp)
        pushl $record_buffer
        call read_record
        addl $8, %esp

        cmpl $RECORD_SIZE, %eax
        jne loop_end

        incl record_buffer + RECORD_AGE

        pushl ST_OUTPUT_DESCRIPTOR(%ebp)
        pushl $record_buffer
        call write_record
        addl $8, %esp

        jmp loop_begin

    loop_end:
        movl $SYS_EXIT, %eax
        movl $0, %ebx
        int $LINUX_SYSCALL_INT
