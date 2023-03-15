#PURPOSE: 	This routine amis to write records to file

#INPUT:  	none

#OUTPUT:   none
.include "linux.s"
.include "record-def.s"

.section .data
    
    record1:
        .ascii "Fredrick\0"
        .rept 31
        .byte 0
        .endr

        .ascii "Bartlett\0"
        .rept 31
        .byte 0
        .endr

        .ascii "4242 S Prairie\nTulsa, OK 55555\0"
        .rept 209
        .byte 0
        .endr

        .long 45

    record2:
        .ascii "Fredrick2\0"
        .rept 31
        .byte 0
        .endr

        .ascii "Bartlett2\0"
        .rept 31
        .byte 0
        .endr

        .ascii "4242 S Prairie\nTulsa, OK 55555\0"
        .rept 209
        .byte 0
        .endr

        .long 45

    file_name:
        .ascii "test.dat\0"

    .equ ST_FILE_DESCRIPTOR, -4

.section .text
.global _start

_start:
    movl %esp, %ebp
    subl $4, %esp               #Space to hold the file descriptor
    
    open_file:
        movl $SYS_OPEN, %eax
        movl $file_name, %ebx
        movl $0101, %ecx        #Create if it doesn't exist, and open for writing
        movl $0666, %edx
        int $LINUX_SYSCALL_INT

    store_fd:
        movl %eax, ST_FILE_DESCRIPTOR(%ebp)

    write_to_file:
        pushl ST_FILE_DESCRIPTOR(%ebp)
        pushl $record1
        call write_record
        addl $8, %esp

        pushl ST_FILE_DESCRIPTOR(%ebp)
        pushl $record2
        call write_record
        addl $8, %esp
        
    close_file_descriptor:
       movl $SYS_CLOSE, %eax
       movl ST_FILE_DESCRIPTOR(%ebp), %ebx 
       int $LINUX_SYSCALL_INT

    end_program:
        movl $SYS_EXIT, %eax
        movl $0, %ebx
        int $LINUX_SYSCALL_INT
