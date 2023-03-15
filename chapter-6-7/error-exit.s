#PURPOSE: 	This routine amis to write error code and error message the STD

#INPUT:  	error code, error msg
#OUTPUT:   print error code and error msg to the STD
.include "linux.s"

.equ ST_ERROR_CODE, 8
.equ ST_ERROR_MSG, 12

.global error_exit
.type error_exit, @function

error_exit:
    pushl %ebp
    movl %esp, %ebp

    movl ST_ERROR_CODE(%ebp), %ecx
    pushl %ecx
    call count_chars
    
    popl %ecx
    movl %eax, %edx
    movl $SYS_WRITE, %eax
    movl $STDERR, %ebx
    int $LINUX_SYSCALL_INT

    movl ST_ERROR_MSG(%ebp), %ecx
    pushl %ecx
    call count_chars

    popl %ecx
    movl %eax, %edx
    movl $SYS_WRITE, %eax
    movl $STDERR, %ebx
    int $LINUX_SYSCALL_INT

    pushl $STDERR
    call write_line

    movl $SYS_EXIT, %eax
    movl $1, %ebx
    int $LINUX_SYSCALL_INT
